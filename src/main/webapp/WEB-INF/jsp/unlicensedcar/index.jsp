<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<div style="margin:5px 0 5px 0;"></div>

<div id="query_datagrid">
	<div class='query_toolbar' style="font-size:14px; margin:0px 0;padding-top:5px; padding-bottom:5px; color:#06C;">
		<div class="easyui-accordion" data-options="multiple:true" style="width:100%;height1:300px;">
			<div style="padding:10px;font-size:14px; margin:0px 0;padding-top:5px; padding-bottom:5px; color:#06C;">
				<p>
                <div>
				<form action="#">

					监控点
					<input id="query_camera1" type="text" style="width:20%;height:28px;">
                    <%--<input id="pub_map1" class="easyui-linkbutton" data-options="iconCls:'icon-search'" value="地图">--%>
                    <div href="javascript:void(0)" id="pub_map1" class="easyui-linkbutton" data-options="iconCls:'icon-search'">地图</div>

					过车时间段
					<input id="query_startTime1" type="text" name="startTime" style="width:11%;height:28px;">
					---
					<input id="query_endTime1" type="text" name="startTime" style="width:11%;height:28px;">
					<a href="javascript:void(0)" id="query_submit1"
					   class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
					<a href="javascript:void(0)" id="un_empty_submit1"
					   class="easyui-linkbutton" data-options="iconCls:'icon-clear'">重置</a>

				</form>
            </div>
				</p>
			</div>
			<div title="更多选项&ensp;▼" style="padding:10px;font-size:14px; margin:0px 0;padding-top:5px; padding-bottom:5px; color:#06C; ">
				<p>

				<form>
					品&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;牌
					<input id="vehicleBrand1" type="text" class="easyui-textbox" style="height:28px; width:8%">
					车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;系
					<input id="vehicleSeries1" type="text" class="easyui-textbox" style="height:28px; width:8%">
					款&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;型
					<input id="vehicleStyle1" type="text" class="easyui-textbox" style="height:28px; width:8%">
					车&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;型
					<input id="vehicleKind1" type="text" style="width:8%;height:28px;">
					<br/>

					<div style="height:5px;"></div>
						车道方向&nbsp;<input id="direction1" type="text" style="width:8%;height:28px;">
					地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;点
					<input id="location1" type="text" class="easyui-textbox" style="height:28px; width:8%;">
					特&nbsp;&nbsp;征&nbsp;&nbsp;物
					<input id="characteristic1" type="text" style="width:8%;height:28px;">
					车身颜色
					<input id="carColor1" type="text" class="easyui-textbox" style="height:28px;width:8%;">
					车牌可信度(≥)&nbsp;<input id="confidence1" type="text" style="width:8%;height:28px;">
				</form>

				</p>
			</div>


		</div>
	</div>
</div>
<script>
	(function () {
		var tab = util.getSelectedTab();
		var pictureServerHost = '${PictureServerHost}/';
		//监控点自动完成多选框
		var $query_camera = tab.find('#query_camera1'),
				$query_datagrid = tab.find('#query_datagrid')

        //存放被选择的监控点
        var camIdArr = [],camNameArr = [];
        //树形下拉框 监控点
        var cameraIds = $query_camera.combotree({
            url: '/camera/camLstTree.action',
            animate:true,
            multiple:true,
            onCheck:function(node,checked) {
                util.checkCam(cameraIds,node,camIdArr,camNameArr,checked);
            },
            onClick:function(node) {
                util.checkCam(cameraIds,node,camIdArr,camNameArr,node.checked);
            },
            onChange:function(nVal,oVal) {
                util.checkCamWithMap(cameraIds);
            }
        });
		var startTime = tab.find('#query_startTime1').datetimebox({
			editable: false
		});
		var endTime = tab.find('#query_endTime1').datetimebox({
			editable: false
		});
		var plate = tab.find("#plate");
		var location = tab.find("#location1");
		//var vehicleBrand = tab.find("#vehicleBrand");
		var vehicleStyle = tab.find("#vehicleStyle1");
		var direction = tab.find("#direction1").combobox({
			data: [{
				value: '0',
				text: '未知'
			}, {
				value: '3',
				text: '向上'
			}, {
				value: '4',
				text: '向下'
			}, {
				value: '1',
				text: '向左'
			}, {
				value: '2',
				text: '向右'
			}]
		});
		var confidence = tab.find("#confidence1").combobox({
			data: [{
				value: '0',
				text: '0'
			}, {
				value: '20',
				text: '20'
			}, {
				value: '40',
				text: '40'
			}, {
				value: '60',
				text: '60'
			}, {
				value: '80',
				text: '80'
			}, {
				value: '100',
				text: '100'
			}]
		});
		var carColor = tab.find("#carColor1").combogrid({
			multiple: true,
			idField: 'value',
			textField: 'text',
            editable:false,
			columns: [[
				{field: 'value', title: 'value', hidden: true},
				{field: 'checkbox', checkbox: true},
				{field: 'text', title: '颜色', width: 95}
			]],
			data: [{
				value: '黑',
				text: '黑'
			}, {
				value: '蓝',
				text: '蓝'
			}, {
				value: '青',
				text: '青'
			}, {
                value: '灰',
                text: '灰'
            }, {
				value: '灰(银)',
				text: '灰（银）'
			}, {
				value: '绿',
				text: '绿'
			}, {
				value: '红',
				text: '红'
			}, {
				value: '白',
				text: '白'
			}, {
				value: '黄',
				text: '黄'
			}, {
				value: '棕',
				text: '棕'
			}, {
				value: '粉',
				text: '粉'
			}]
		});

		var vehicleKind = tab.find("#vehicleKind1").combobox({
			url:"js/json/vehicleKind.json",
			valueField:"value",
			textField:"text"
		});
		var characteristic = tab.find("#characteristic1").combogrid({
			multiple: true,
			idField: 'value',
			textField: 'text',
            editable:false,
			columns: [[
				{field: 'value', title: 'value', hidden: true},
				{field: 'checkbox', checkbox: true},
				{field: 'text', title: '特征物名称', width: 150}
			]],
			data: [{
				value: 'tag',
				text: '年检标'
			}, {
				value: 'paper',
				text: '纸巾盒'
			}, {
				value: 'sun',
				text: '遮阳板'
			}, {
				value: 'drop',
				text: '挂饰'
			}]
		});
		// 一层Combo
		var vehicleBrand = tab.find("#vehicleBrand1").combobox({
			//editable:false, //不可编辑状态  品牌太多 支持匹配
			url: '/brandmodel/listbrand.action',
			dataType: 'json',
			type: 'post',
            onChange: function (record) {  //onSelect 用户点击时触发的事件  在此的意义在于，用户点击一级后自动二级combobox
				$.ajax({
					type: 'post',
					url: '/brandmodel/listsubbrand.action',
					data: {brandName: tab.find("#vehicleBrand1").combobox("getValue")},
					success: function (d) {
						var data = [];
						$.each(d, function (i, o) {
							var obj = {value: o.carSeries, text: o.carSeries};
							data.push(obj);
						})
						vehicleSeries.combobox({
							onLoadSuccess: function () {  //清空三级下拉框 就是成功加载完触发的事件 当一级combobox改变时，二级和三级就需要清空
								vehicleStyle.combobox("clear");
								vehicleSeries.combobox("clear");
							},
							data: data,
                            onChange: function (record) {

								$.ajax({
									type: 'post',
									url: '/brandmodel/listcar.action',
									data: {
										brandName: tab.find("#vehicleBrand1").combobox("getValue"),
										carSeries: tab.find("#vehicleSeries1").combobox("getValue")
									},
									success: function (d) {
										var data = [];
										$.each(d, function (i, o) {
											var obj = {value: o.modelsName, text: o.modelsName};
											data.push(obj);
										})
										vehicleStyle.combobox({
											data: data,
                                            onChange: function (record) {

											}
										});
									}
								});

							}
						});
					}
				});

			},
			valueField: 'brandName',
			textField: 'brandName',
			value: ''
		});
		/******************************************************************************************************/
		//下面的俩个是组件，

		//  二层Combo
		var vehicleSeries = tab.find("#vehicleSeries1").combobox({
			editable: false, //不可编辑状态
			value: ''
		});

		//三层Combo
		var vehicleStyle = tab.find("#vehicleStyle1").combobox({
			editable: false, //不可编辑状态
			value: ''
		});
		var getParamData = function () {
			var data = {
				cameraIds: cameraIds.combo('getValues').join(),
				startTime: startTime.combo('getValue'),
				endTime: endTime.combo('getValue'),
				plate: plate.val(),
				location: location.val(),
				carColor: carColor.combo('getValues').join(),
				direction: direction.combo('getValue'),
				confidence: confidence.textbox().val(),
				vehicleKind: vehicleKind.combo('getValue'),
				vehicleBrand: vehicleBrand.combo('getValue'),
				vehicleSeries: vehicleSeries.combo('getValue'),
				vehicleStyle: vehicleStyle.combo('getValue'),
				characteristic: characteristic.combo('getValues').join()
			}

			$.each(data, function (k, v) {
				data[k] = $.trim(v);
			})

			return data;
		}

		tab.find('#query_submit1').click(function (e) {
			e.preventDefault();
			$query_datagrid.datagrid("reload");
		});
        tab.on('click', '#pub_map1', function (e) {
            e.preventDefault();
            pubMapWindow.open(cameraIds,camIdArr,camNameArr);
        });

		$('#un_empty_submit1').click(function (e) {
		 var $form = tab.find('form');
            camIdArr = [];
            camNameArr = [];
		 //清空表单数据
		 $form.form('reset');
			$("#direction1").combobox('reset');
			$("#location1").textbox('reset');
			$("#characteristic1").combogrid('reset');
			$("#carColor1").combogrid('reset');
			$("#confidence1").combobox('reset');
		 });

		var loadResultDatas = function (pageNumber, callback) {

			var datagrid = $query_datagrid.datagrid({
				url: '/unlicensedcar/query.action',
				loadMsg: '数据载入中',
				pagination: true,
				pageNumber: pageNumber,
				rownumbers: true,
				fit: true,
				singleSelect: true,
				//*过车时间（绝对时间）、*方向、*地点、*经度、*纬度、
				columns: [[
					{
						field: 'operation', title: '操作', formatter: function (v, row) {
						var html = '';
						if (row.taskType == 2 && row.resourceType == 2) {
							html = '<a href="javascript:void(0)" onclick=video_player.play(\"' + row.path.replace(/\\/gm, '\\\\') + '\",' + row.frame_index + ') >播放片段</a>';
						}
						return html;
					}
					},
					{field: 'license', title: '车牌', width: 100},
					/*{field: 'characteristic', title: '特征物', formatter:util.formateCharacteristic,width:120},*/
					{
						field: 'tag', title: '年检标', width: 50,
						formatter: function (value, row, index) {
							if (value == 1) {
								return '有';
							} else if (value == 0) {
								return '无';
							}
						}
					},
					{
						field: 'paper', title: '纸巾盒', width: 50,
						formatter: function (value, row, index) {
							if (value == 1) {
								return '有';
							} else if (value == 0) {
								return '无';
							}
						}
					},
					{
						field: 'sun', title: '遮阳板', width: 50,
						formatter: function (value, row, index) {
							if (value == 1) {
								return '放下';
							} else if (value == 0) {
								return '未放下';
							}
						}
					},
					{
						field: 'drop', title: '挂饰', width: 50,
						formatter: function (value, row, index) {
							if (value == 1) {
								return '有';
							} else if (value == 0) {
								return '无';
							}
						}
					},
					{field: 'vehicleKind', title: '车型', width: 70},
					{field: 'vehicleBrand', title: '品牌', width: 70},
					{field: 'vehicleSeries', title: '车系', width: 70},
					{field: 'vehicleStyle', title: '款型', width: 70},
					{field: 'carColor', title: '车身颜色', width: 80},
					{field: 'direction', title: '方向', width: 50},
					{field: 'location', title: '监控点', width: 150},
					//{field:'longitude',title:'经度' ,width:150},
					//{field:'latitude',title:'纬度' ,width:150},
					{field: 'resultTime', title: '过车时间', formatter: util.formateTime, width: 150}/*,
					 //暂时不需要
					 {field: 'showResult', title: '查看结果', formatter: function(v,row){
					 var rowId=row.serialNumber
					 var html='<button id="'+rowId+'" class="showResult">查看结果</button>';
					 tab.off('click','#'+rowId).on('click','#'+rowId,function(){
					 showResultWindow(row)
					 })
					 return html;
					 }
					 }*/
				]],
				toolbar: tab.find('.query_toolbar', datagrid),
				onDblClickRow: function (index, row) {
					detail_window.open(row,pictureServerHost,datagrid,loadResultDatas);
				},
				onBeforeLoad: function (p) {
					$.extend(p, getParamData());
				},
				onLoadSuccess: function (pager) {
					licenseBox(pager.rows);
					$.each(pager.rows, function (i, o) {
						o.index = i;
					});
					if (typeof callback == 'function') {
						callback();
						//这个callback用于在查看结果详情的时候,翻下一张,翻页时弹出一个window显示结果详情
						//若不设为null,在上面的翻页后datagrid loadSuccess(包括查询,刷新等)后依然会弹出一个window
						callback = null;
					}
				}
			})
		}
		loadResultDatas();
//车牌下拉框
		var licenseBox = function (rows) {
			var datas = rows,
					oo = {},
					licenseArray = [];

			$.each(datas, function (i, e) {
				if (e.license in oo) {
					oo[e.license].push(e)
				} else {
					oo[e.license] = [e]
				}
			})
			//若当前页相同车牌数量>1，则把它添加到数组中
			var i = 0;
			$.each(oo, function (license, num) {
				if (num.length > 1) {
					licenseArray[i] = {value: oo[license], text: license}
					++i;
				}
			})
			trailcombo(licenseArray)
		}

		tab.find('.query_toolbar').on('click', '#show_trail_combo', function (e) {
			e.preventDefault();
			var datas = tab.find('#trailcombo').combobox('getData');

			if (datas.length == 0) {
				$.messager.show({
					title: '提示消息',
					msg: '没有可以显示的轨迹',
					timeout: 3000,
					showType: 'slide'
				})
			}
			if (datas.length != 0) {
				var text = tab.find('#trailcombo').combobox('getText');
				var values = datas.filter(function (d) {
					return d.text == text;
				});

				if (values.length == 0) {
					$.messager.show({
						title: '提示消息',
						msg: '请选择需要查看轨迹的车牌号',
						timeout: 3000,
						showType: 'slide'
					})
				} else {
					var $map = tab.find("#main_map");
					var map = $map.data('map');

					//先清除上一次显示的轨迹
					map.clearOverlays();
					util.showTrail(values[0].value.sort(function (a, b) {
						return a.resultTime > b.resultTime ? 1 : -1;
					}), 'red', 3)
				}
			}
		})
//初始化显示轨迹下拉列表,显示相同车牌的数量大于1的车牌

		var trailcombo = function (data) {
			var trailcombo1 = tab.find('#trailcombo').combobox({
				editable: false,
				data: data,
				onShowPanel: function () {
					trailcombo1.combo('setValue', undefined)
				}
			})
		};

		$query_datagrid.datagrid('getPanel').on("keyup", 'input:text', function (e) {
			if (e.keyCode == 13) {
				$query_datagrid.datagrid('reload');
			}
		});
		// IE下只读INPUT键入BACKSPACE 后退问题
		$("input[readOnly]").keydown(function (e) {
			e.preventDefault();
		});
	})();
</script>
