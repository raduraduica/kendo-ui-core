﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Areas/aspx/Views/Shared/Web.Master" %>

<%@ Import Namespace="Kendo.Mvc.Examples.Models" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

<%= Html.Kendo().Diagram<OrgChartShape, OrgChartConnection>()
        .Name("diagram")
        .DataSource(d => d
            .ShapeDataSource()
            .Model(m => 
            {
                m.Id(s => s.Id);
                m.Field(s => s.FirstName);
                m.Field(s => s.LastName);
                m.Field(s => s.Image);
                m.Field(s => s.Title);
            })
            .Read("ReadShapes", "Diagram")
            .Create("CreateShape", "Diagram")
            .Destroy("DestroyShape", "Diagram")
            .Update("UpdateShape", "Diagram")
        )
        .ConnectionsDataSource(d => d
            .Model(m =>
            {
                m.Id(c => c.Id);
                m.From(c => c.From);
                m.To(c => c.To);
            })
            .Read("ReadConnections", "Diagram")
            .Create("CreateConnection", "Diagram")
            .Destroy("DestroyConnection", "Diagram")
            .Update("UpdateConnection", "Diagram")
        )
        .Layout(l => l.Type(DiagramLayoutType.Layered))
        .ShapeDefaults(sd => sd
            .Visual("visualTemplate")
        )
        .ConnectionDefaults(cd => cd
            .Stroke(s => s
                .Color("#979797")
                .Width(2)
            )
        )
        .Events(events => events
            .ItemRotate("onItemRotate")
            .Pan("onPan")
            .Select("onSelect")
            .ZoomStart("onZoomStart")
            .ZoomEnd("onZoomEnd")
            .Click("onClick")
            .DataBound("onDataBound")
            .Edit("onEdit")
            .Add("onAdd")
            .Remove("onRemove")
            .Cancel("onCancel")
        )
%>
<div class="box">
    <h4>Console log</h4>
    <div class="console"></div>
</div>

<script>
    function onDataBound(e) {
        kendoConsole.log("Diagram data bound");
    }

    function onEdit(e) {
        kendoConsole.log("Diagram edit");
    }

    function onAdd(e) {
        kendoConsole.log("Diagram add");
    }

    function onRemove(e) {
        kendoConsole.log("Diagram remove");
    }

    function onCancel(e) {
        kendoConsole.log("Diagram cancel");
    }

    function onItemRotate(e) {
        var rotation = e.item.rotate();
        kendoConsole.log("Rotate - angle: " + rotation.angle + " center: " + rotation.x + "," + rotation.y);
    }

    function onPan(e) {
        kendoConsole.log("Pan: " + e.pan.toString());
    }

    function onSelect(e) {
        var action;
        var items;
        if (e.selected.length) {
            action = "Selected";
            items = e.selected;
        } else if (e.deselected.length) {
            action = "Deselected";
            items = e.deselected;
        }

        kendoConsole.log(action + ": " + items.length);
    }

    function onZoomStart(e) {
        kendoConsole.log("Zoom start: " + e.zoom);
    }

    function onZoomEnd(e) {
        kendoConsole.log("Zoom end: " + e.zoom);
    }

    function onClick(e) {
        kendoConsole.log("Click: " + elementText(e.item));
    }

    var diagram = kendo.dataviz.diagram;
    var Shape = diagram.Shape;
    var Connection = diagram.Connection;
    var Point = diagram.Point;

    function elementText(element) {
        var text;
        if (element instanceof Shape) {
            text = dataItemName(element.dataItem);
        } else if (element instanceof Point) {
            text = "(" + element.x + "," + element.y + ")";
        } else if (element instanceof Connection) {
            var source = element.source();
            var target = element.target();
            var sourceElement = source.shape || source;
            var targetElement = target.shape || target;
            text = elementText(sourceElement) + " - " + elementText(targetElement);
        }
        return text;
    }

    function dataItemName(dataItem) {
        return dataItem.FirstName + " " + dataItem.LastName;
    }

    function visualTemplate(options) {
        var dataviz = kendo.dataviz;
        var g = new dataviz.diagram.Group();
        var dataItem = options.dataItem;

        g.append(new dataviz.diagram.Rectangle({
            width: 210,
            height: 75,
            stroke: {
                width: 0
            },
            fill: dataItem.ColorScheme
        }));

        g.append(new dataviz.diagram.TextBlock({
            text: dataItem.FirstName + " " + dataItem.LastName,
            x: 85,
            y: 20,
            color: "#fff"
        }));

        g.append(new dataviz.diagram.TextBlock({
            text: dataItem.Title,
            x: 85,
            y: 40,
            color: "#fff"
        }));

        g.append(new dataviz.diagram.Image({
            source: "<%= Url.Content("~/content/dataviz/diagram/people/") %>" + dataItem.Image,
            x: 3,
            y: 3,
            width: 68,
            height: 68
        }));

        return g;
    }
</script>

</asp:Content>
