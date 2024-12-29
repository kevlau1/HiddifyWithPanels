// services/order_service.dart
import 'package:hiddify/features/panel/xboard/models/order_model.dart';

import 'package:hiddify/features/panel/xboard/services/http_service/http_service.dart';

class OrderService {
  final HttpService _httpService = HttpService();

  Future<List<Order>> fetchUserOrders(String accessToken) async {
    final result = await _httpService.getRequest(
      "/api/v1/user/order/fetch",
      headers: {'Authorization': accessToken},
    );

    final ordersJson = result["data"] as List;
    return ordersJson
        .map((json) => Order.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getOrderDetails(
      String tradeNo, String accessToken) async {
    return await _httpService.getRequest(
      "/api/v1/user/order/detail?trade_no=$tradeNo",
      headers: {'Authorization': accessToken},
    );
  }

  Future<Map<String, dynamic>> cancelOrder(
      String tradeNo, String accessToken) async {
    return await _httpService.postRequest(
      "/api/v1/user/order/cancel",
      {"trade_no": tradeNo},
      headers: {'Authorization': accessToken},
    );
  }

  Future<Map<String, dynamic>> createOrder(String accessToken, int planId, String period) async {
    final result = await _httpService.postRequest(
      "/api/v1/user/order/save",
      {
        "plan_id": planId.toString(), // 确保 plan_id 以字符串形式传递
        "period": period,             // 确保 period 是一个非空字符串
      },
      headers: {'Authorization': accessToken},
    );
  
    // 检查 result 是否包含 "data"
    if (result["data"] == null) {
      throw Exception("Order creation failed: No data received");
    }
  
    return {"orderId": result["data"]};
  }

}
