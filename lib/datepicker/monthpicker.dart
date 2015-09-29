/// <reference path="../../tsd.d.ts" />
import "package:angular2/angular2.dart"
    show Component, View, Host, OnInit, EventEmitter, DefaultValueAccessor, ElementRef, ViewContainerRef, NgIf, NgClass, FORM_DIRECTIVES, CORE_DIRECTIVES, Self, NgModel, Renderer;
import "datepicker-inner.dart" show DatePickerInner;
import "../ng2-bootstrap-config.dart" show Ng2BootstrapConfig;

const TEMPLATE_OPTIONS = { "bs4" : { "MONTH_BUTTON" : '''
        <button type="button" style="min-width:100%;" class="btn btn-default"
                [ng-class]="{\'btn-info\': dtz.selected, \'btn-link\': !dtz.selected && !datePicker.isActive(dtz), \'btn-info\': !dtz.selected && datePicker.isActive(dtz), disabled: dtz.disabled}"
                [disabled]="dtz.disabled"
                (click)="datePicker.select(dtz.date)" tabindex="-1"><span [ng-class]="{\'text-success\': dtz.current}">{{dtz.label}}</span></button>
    '''}, "bs3" : { "MONTH_BUTTON" : '''
        <button type="button" style="min-width:100%;" class="btn btn-default"
                [ng-class]="{\'btn-info\': dtz.selected, active: datePicker.isActive(dtz), disabled: dtz.disabled}"
                [disabled]="dtz.disabled"
                (click)="datePicker.select(dtz.date)" tabindex="-1"><span [ng-class]="{\'text-info\': dtz.current}">{{dtz.label}}</span></button>
    '''}};

const CURRENT_THEME_TEMPLATE = TEMPLATE_OPTIONS [ Ng2BootstrapConfig.theme ] ||
    TEMPLATE_OPTIONS.bs3;

@Component (selector: "monthpicker, [monthpicker]")
@View (template: '''
<table [hidden]="datePicker.datepickerMode!==\'month\'" role="grid">
  <thead>
    <tr>
      <th>
        <button type="button" class="btn btn-default btn-sm pull-left"
                (click)="datePicker.move(-1)" tabindex="-1">
          <i class="glyphicon glyphicon-chevron-left"></i>
        </button></th>
      <th>
        <button [id]="uniqueId + \'-title\'"
                type="button" class="btn btn-default btn-sm"
                (click)="datePicker.toggleMode()"
                [disabled]="datePicker.datepickerMode === maxMode"
                [ng-class]="{disabled: datePicker.datepickerMode === maxMode}" tabindex="-1" style="width:100%;">
          <strong>{{title}}</strong>
        </button>
      </th>
      <th>
        <button type="button" class="btn btn-default btn-sm pull-right"
                (click)="datePicker.move(1)" tabindex="-1">
          <i class="glyphicon glyphicon-chevron-right"></i>
        </button>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr *ng-for="#rowz of rows">
      <td *ng-for="#dtz of rowz" class="text-center" role="gridcell" id="{{dtz.uid}}" [ng-class]="dtz.customClass">
        ${ CURRENT_THEME_TEMPLATE.MONTH_BUTTON}
      </td>
    </tr>
  </tbody>
</table>
  ''', directives: const [ FORM_DIRECTIVES, CORE_DIRECTIVES, NgClass])
class MonthPicker
    implements OnInit {
  DatePickerInner datePicker;

  String title;

  List<dynamic> rows = [];

  MonthPicker(this .datePicker) {}

  onInit() {
    var self = this;
    this.datePicker.stepMonth = { "years" : 1};
    this.datePicker.setRefreshViewHandler(() {
      List<dynamic> months = new List(12);
      num year = this.activeDate.getFullYear();
      var date;
      for (var i = 0; i < 12; i ++) {
        date = new Date (year, i, 1);
        this.fixTimeZone(date);
        months [ i ] = this.createDateObject(date, this.formatMonth);
        months [ i ].uid = this.uniqueId + "-" + i;
      }
      self.title = this.dateFilter(this.activeDate, this.formatMonthTitle);
      self.rows = this.split(months, 3);
    }, "month");
    this.datePicker.setCompareHandler((date1, date2) {
      var d1 = new Date (date1.getFullYear(), date1.getMonth());
      var d2 = new Date (date2.getFullYear(), date2.getMonth());
      return d1.getTime() - d2.getTime();
    }, "month");
    this.datePicker.refreshView();
  }
}