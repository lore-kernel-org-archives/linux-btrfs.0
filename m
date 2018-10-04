Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2D4C64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A1FD20854
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="QDii1Uk6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A1FD20854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbeJEEbn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:31:43 -0400
Received: from mail-eopbgr20070.outbound.protection.outlook.com ([40.107.2.70]:44057
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726570AbeJEEbm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 00:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GU+EieCqsCHglFtYFLh2hJjB8Sog2o2T+U5/cpdu0n0=;
 b=QDii1Uk6IDQ3SN0yYfa8fBoJMip2UyCFX0RWwLYMgxWhBgtfVUmqBthzVUAbd6g9QLDxeSb/6ikdoJ7LlToecvWBbxDF/AJI1LkC0/G6J0i1sCBefyJFYEDhvpaZmDY85SCYA+TrRGbcbL5yo6rmxx62oGbaGkSjLwYr5KjDrZA=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4851.eurprd06.prod.outlook.com (20.178.19.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.23; Thu, 4 Oct 2018 21:36:24 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1164.029; Thu, 4 Oct 2018
 21:36:24 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/6] btrfs: alloc_chunk: improve chunk size variable name
Thread-Topic: [PATCH 2/6] btrfs: alloc_chunk: improve chunk size variable name
Thread-Index: AQHUXCmNdWVz3uBDu0CEEE/DXmMdzaUPnEMA
Date:   Thu, 4 Oct 2018 21:36:23 +0000
Message-ID: <9c87cb2c-8a2d-5927-16cd-01155d8a34aa@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <20181004212443.26519-3-hans.van.kranenburg@mendix.com>
In-Reply-To: <20181004212443.26519-3-hans.van.kranenburg@mendix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM5PR0402CA0011.eurprd04.prod.outlook.com
 (2603:10a6:203:90::21) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4851;6:b6mvsmy7lfbmzsZN0GPHU8Z2cZ3KTnTEYKnweChDP9HX5XgKB4tLcrj8Emv44NFWWixjEBtBPxPF1BFco2XRZ065WbrE172781BOUwGaRRnKkfdJRxcoFTWqPVdL0TrMLPgJynC3JspcQrF7LQ9j9/nOLB4XbjiUafZ+EnpZYt2S331B++n6e836SC4XQOzSezXRqM/PYXg2nClxftTUni5xF9o2jqq/LYn3gCbS4WU5JYd0tXpW076+rcekFAlKyuC+wsLKnm8dpHhuiJyjk+Con2WrY5alvcNKU/z1xDY9HUL9EZeTwTSa8xUtv6S8l83SBPlW25Ya3E57+yF3MgmvsvAN28FKe3adjLGW0C+GXYcBRJjuHks07O4ZHae4Q3IAzQGoscKkYWdHhof+gQV5IouYWeSuZNAGH7TiI20XwFVRaij4FuXWbAMXnCkThrpn0fRz0BYl+sLbOD3aag==;5:B9MMUdwYjYoTLX/56ZYDIdZiEzC4DWKKFV8tgH0aP8+UxCQs+oIbFPAD38ZHxNXFhSuBkVkZmO7Dk79wGXnTYRC3OX2x7tnAijLgy+SIZxd4tPzPM4K+wqnwpUaxWst3Cyh/FwPpzqJ/KGos2KRzV5RwDmIBk9uu1Xy7onvFukI=;7:29poWuRA0LhjEYMApMH1V84RDvTxMjj3LEtU2prbhr57ROS0h3600MX7e8CLbJC7u2ieXSCBTJsXomPF7B14N+yc7EEBUTanArfpfT+/rCZqZxNH7OQERhaKaNoSH2Y9O18b+H19B1AFxXLbxl0C3yhOtySoSVH6IckAJoeN92Sqk/0M8eloSbB3zrsZe3re6Uec6wlVOZLSB3n8j3w+xQVCSw1EznHgYLH6MUAxyjUWQ+8H/UxuVzZFK0BFZe2L
x-ms-office365-filtering-correlation-id: 8b876f41-5f54-479b-4e23-08d62a416e9a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:AM0PR06MB4851;
x-ms-traffictypediagnostic: AM0PR06MB4851:
x-microsoft-antispam-prvs: <AM0PR06MB48512A24EB83EDDB4CBF5CA9D4EA0@AM0PR06MB4851.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(10201501046)(3002001)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(20161123560045)(201708071742011)(7699051);SRVR:AM0PR06MB4851;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4851;
x-forefront-prvs: 0815F8251E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(366004)(136003)(39850400004)(189003)(199004)(36756003)(2900100001)(99286004)(186003)(25786009)(478600001)(76176011)(68736007)(2351001)(106356001)(446003)(58126008)(105586002)(305945005)(52116002)(7736002)(53936002)(14454004)(46003)(97736004)(72206003)(316002)(6246003)(71200400001)(229853002)(71190400001)(102836004)(65806001)(65956001)(6436002)(5250100002)(486006)(2501003)(53546011)(5640700003)(476003)(6116002)(6486002)(5660300001)(65826007)(64126003)(2906002)(11346002)(8676002)(86362001)(256004)(14444005)(6916009)(386003)(81156014)(8936002)(31686004)(6512007)(81166006)(31696002)(2616005)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4851;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: ImMipPTlvLig3A1FwubSzAM74w1K9HfvQ3TnqdBwLe8xe4TSXJHI2Q59TaIQW/sJhNWFZMz2A2k3aDgH/ZhbF5lEPGnG0hxrW5JI8toMx4nzoCQg87sf97lXRddDKcnvEFcd76whaWVRWkyxPrCaJeCLIIDhNHI9sK1nG0oVK92p0JpePFpJpW5ZUM8SpfrNXEuV97S8g8dW64UC2wGPrw89+LigEQgCUfN28t6nXriHoNV87p/tNww96oWQb74+VJNfgrezgrf8tK+P6IKrny3g+0P+TaA9iU51/nL3c1uajXvVQPchIsSeKn7yOiBqzTfEvcNSYt6w2C2y3/0rTmJpuBqwGC5Wnz7vDxxy/Wk=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <C96BA4C36CB61744893C3199235DD91C@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b876f41-5f54-479b-4e23-08d62a416e9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2018 21:36:23.9632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4851
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMDQvMjAxOCAxMToyNCBQTSwgSGFucyB2YW4gS3JhbmVuYnVyZyB3cm90ZToNCj4gbnVt
X2J5dGVzIGlzIHJlYWxseSBhIHdheSB0b28gZ2VuZXJpYyBuYW1lIGZvciBhIHZhcmlhYmxlIGlu
IHRoaXMNCj4gZnVuY3Rpb24uIFRoZXJlIGFyZSBhIGRvemVuIG90aGVyIHZhcmlhYmxlcyB0aGF0
IGhvbGQgYSBudW1iZXIgb2YgYnl0ZXMNCj4gYXMgdmFsdWUuDQo+IA0KPiBHaXZlIGl0IGEgbmFt
ZSB0aGF0IGFjdHVhbGx5IGRlc2NyaWJlcyB3aGF0IGl0IGRvZXMsIHdoaWNoIGlzIGhvbGRpbmcN
Cj4gdGhlIHNpemUgb2YgdGhlIGNodW5rIHRoYXQgd2UncmUgYWxsb2NhdGluZy4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IEhhbnMgdmFuIEtyYW5lbmJ1cmcgPGhhbnMudmFuLmtyYW5lbmJ1cmdAbWVu
ZGl4LmNvbT4NCj4gLS0tDQo+ICBmcy9idHJmcy92b2x1bWVzLmMgfCAxMiArKysrKysrLS0tLS0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZnMvYnRyZnMvdm9sdW1lcy5jIGIvZnMvYnRyZnMvdm9sdW1lcy5jDQo+
IGluZGV4IDljOWJiMTI3ZWVlZS4uNDBmYTg1ZTY4YjFmIDEwMDY0NA0KPiAtLS0gYS9mcy9idHJm
cy92b2x1bWVzLmMNCj4gKysrIGIvZnMvYnRyZnMvdm9sdW1lcy5jDQo+IEBAIC0xMjMsNiArMTIz
LDggQEAgY29uc3QgY2hhciAqZ2V0X3JhaWRfbmFtZShlbnVtIGJ0cmZzX3JhaWRfdHlwZXMgdHlw
ZSkNCj4gIAlyZXR1cm4gYnRyZnNfcmFpZF9hcnJheVt0eXBlXS5yYWlkX25hbWU7DQo+ICB9DQo+
ICANCj4gKw0KPiArDQoNCk1laCwgbWlzc2VkIHRoYXQgb25lLCB3aWxsIHJlbW92ZS4NCg0KPiAg
c3RhdGljIGludCBpbml0X2ZpcnN0X3J3X2RldmljZShzdHJ1Y3QgYnRyZnNfdHJhbnNfaGFuZGxl
ICp0cmFucywNCj4gIAkJCQlzdHJ1Y3QgYnRyZnNfZnNfaW5mbyAqZnNfaW5mbyk7DQo+ICBzdGF0
aWMgaW50IGJ0cmZzX3JlbG9jYXRlX3N5c19jaHVua3Moc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZz
X2luZm8pOw0KPiBAQCAtNDU5OSw3ICs0NjAxLDcgQEAgc3RhdGljIGludCBfX2J0cmZzX2FsbG9j
X2NodW5rKHN0cnVjdCBidHJmc190cmFuc19oYW5kbGUgKnRyYW5zLA0KPiAgCXU2NCBtYXhfc3Ry
aXBlX3NpemU7DQo+ICAJdTY0IG1heF9jaHVua19zaXplOw0KPiAgCXU2NCBzdHJpcGVfc2l6ZTsN
Cj4gLQl1NjQgbnVtX2J5dGVzOw0KPiArCXU2NCBjaHVua19zaXplOw0KPiAgCWludCBuZGV2czsN
Cj4gIAlpbnQgaTsNCj4gIAlpbnQgajsNCj4gQEAgLTQ4MDEsOSArNDgwMyw5IEBAIHN0YXRpYyBp
bnQgX19idHJmc19hbGxvY19jaHVuayhzdHJ1Y3QgYnRyZnNfdHJhbnNfaGFuZGxlICp0cmFucywN
Cj4gIAltYXAtPnR5cGUgPSB0eXBlOw0KPiAgCW1hcC0+c3ViX3N0cmlwZXMgPSBzdWJfc3RyaXBl
czsNCj4gIA0KPiAtCW51bV9ieXRlcyA9IHN0cmlwZV9zaXplICogZGF0YV9zdHJpcGVzOw0KPiAr
CWNodW5rX3NpemUgPSBzdHJpcGVfc2l6ZSAqIGRhdGFfc3RyaXBlczsNCj4gIA0KPiAtCXRyYWNl
X2J0cmZzX2NodW5rX2FsbG9jKGluZm8sIG1hcCwgc3RhcnQsIG51bV9ieXRlcyk7DQo+ICsJdHJh
Y2VfYnRyZnNfY2h1bmtfYWxsb2MoaW5mbywgbWFwLCBzdGFydCwgY2h1bmtfc2l6ZSk7DQo+ICAN
Cj4gIAllbSA9IGFsbG9jX2V4dGVudF9tYXAoKTsNCj4gIAlpZiAoIWVtKSB7DQo+IEBAIC00ODE0
LDcgKzQ4MTYsNyBAQCBzdGF0aWMgaW50IF9fYnRyZnNfYWxsb2NfY2h1bmsoc3RydWN0IGJ0cmZz
X3RyYW5zX2hhbmRsZSAqdHJhbnMsDQo+ICAJc2V0X2JpdChFWFRFTlRfRkxBR19GU19NQVBQSU5H
LCAmZW0tPmZsYWdzKTsNCj4gIAllbS0+bWFwX2xvb2t1cCA9IG1hcDsNCj4gIAllbS0+c3RhcnQg
PSBzdGFydDsNCj4gLQllbS0+bGVuID0gbnVtX2J5dGVzOw0KPiArCWVtLT5sZW4gPSBjaHVua19z
aXplOw0KPiAgCWVtLT5ibG9ja19zdGFydCA9IDA7DQo+ICAJZW0tPmJsb2NrX2xlbiA9IGVtLT5s
ZW47DQo+ICAJZW0tPm9yaWdfYmxvY2tfbGVuID0gc3RyaXBlX3NpemU7DQo+IEBAIC00ODMyLDcg
KzQ4MzQsNyBAQCBzdGF0aWMgaW50IF9fYnRyZnNfYWxsb2NfY2h1bmsoc3RydWN0IGJ0cmZzX3Ry
YW5zX2hhbmRsZSAqdHJhbnMsDQo+ICAJcmVmY291bnRfaW5jKCZlbS0+cmVmcyk7DQo+ICAJd3Jp
dGVfdW5sb2NrKCZlbV90cmVlLT5sb2NrKTsNCj4gIA0KPiAtCXJldCA9IGJ0cmZzX21ha2VfYmxv
Y2tfZ3JvdXAodHJhbnMsIDAsIHR5cGUsIHN0YXJ0LCBudW1fYnl0ZXMpOw0KPiArCXJldCA9IGJ0
cmZzX21ha2VfYmxvY2tfZ3JvdXAodHJhbnMsIDAsIHR5cGUsIHN0YXJ0LCBjaHVua19zaXplKTsN
Cj4gIAlpZiAocmV0KQ0KPiAgCQlnb3RvIGVycm9yX2RlbF9leHRlbnQ7DQo+ICANCj4gDQoNCg0K
LS0gDQpIYW5zIHZhbiBLcmFuZW5idXJnDQo=
