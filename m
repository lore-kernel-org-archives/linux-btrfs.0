Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7A0C65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 15:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4B9B2077C
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 15:46:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="WArzzHAx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4B9B2077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbeJHW7K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 18:59:10 -0400
Received: from mail-eopbgr30067.outbound.protection.outlook.com ([40.107.3.67]:63456
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726348AbeJHW7J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 18:59:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5ifFVkVoWQuWezIJvlCIbAWMa5I8KEAwh47Sh3XYO8=;
 b=WArzzHAxSghYUT01M8fWUlzgO0ypn1TnqNe4SBF52ITlIcGGc/7ZQInbvxHL6ZQs8v2b56f7E14q80gxue2Jj3ao3XoQt/k8o+kpiMOiPPZRF7J0Kj3vKEFQBMx02npE8DxMg5v3yu/aZKC2CnKxPcknFzZV9RUTH4E1k+XaUgk=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB3922.eurprd06.prod.outlook.com (52.133.57.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.27; Mon, 8 Oct 2018 15:46:29 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1207.024; Mon, 8 Oct 2018
 15:46:29 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     =?utf-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?= 
        <holger@applied-asynchrony.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Curious problem: btrfs device stats & unpriviliged access
Thread-Topic: Curious problem: btrfs device stats & unpriviliged access
Thread-Index: AQHUXxMak/ScarELJUS5tWBWYhmxkKUVa38AgAANzICAAAS1AA==
Date:   Mon, 8 Oct 2018 15:46:29 +0000
Message-ID: <650dd0a2-f945-163d-d44b-db0f1cf21ac1@mendix.com>
References: <05c64256-71d3-81dc-3189-628e8cc0a5db@applied-asynchrony.com>
 <5eafba35-c79b-17f2-e296-aafddf06ebf1@mendix.com>
 <7bcc7f99-a857-6ef1-d2df-a256424d2b29@applied-asynchrony.com>
In-Reply-To: <7bcc7f99-a857-6ef1-d2df-a256424d2b29@applied-asynchrony.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [85.146.242.35]
x-clientproxiedby: DB6PR0501CA0046.eurprd05.prod.outlook.com
 (2603:10a6:4:67::32) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB3922;6:smEgQJWPxveQpOoqbb3PWFcZTsiwTRF8FwthYLb5gFEHmGsjP2Au0DSxeJOLMpOThwFY0Ib09UOy40BlIkLNexq90woHFk59PZ1nNQVvvG7k13bP/yZi+thpNPuDZxYao8g+pXKlVYQRCDOgN07r09mxIfBNR/3tfV9k9mfbN3/DTObnZg3HaYjLhXamF8rZKiKi/v8yUfpYK0/XYZznBeW/JleZx7HdpyYI36fKwiqtiXVXUdUIr07m5ycVF+iaMKbhvggGtbtoF+pJQa79Qgx/pIWaEfchzTVX0z7slw0jAlEKBQp5eYTJQ2bMBsxSzkwTvZWpQm2XRHe6y5xC2AzUy6NYcdmYYWjLEqFH7Vlt6HkHJidNhY6BkELuDFzhm8pEx+1Ynb9yyL85hQ1Aq/5JOZKPEg61/fTftqDxOmatkjaON+PX2UftVGSxF3aIAscO2LY0kx6GwJAWZLmegg==;5:9P2Z2LFl0vuFLu6jm1EsgeNm6QlrFNU2Tbo/bpNT14t3UE16o6f/rozVJb12NbW0xppzagl0w3sXY+o2BpuhmKli/0+k7de7O6WK/sLURwKriMg2CtJhxT5F7ybcTf3XI4l71zoe+v4vn1cXFcuIA68k83r9TQVHnTwJ5xUytkQ=;7:qY1BcIQbsNNbXMPuk4jGjq+6p5qEQptgVPRoF3pt3GgUT9ByBADokqPtkOgDsWIOK4C/TbXLRq+svxXwJmc/g3fEj1wXy0em5oF4bBbCR5wy5w/yWJLWkOphgGfVJfaeiS9GiamLKVD03mbiQohn25ajKT6plQ4H9xqkwai5grFeDlHpebj0g9LL1GhEGN1MPTBriliosKZoaebBSERL8lVdKPq9E32LH89BrA33fWfifTFsjZtAcvONAsnxFm+E
x-ms-office365-filtering-correlation-id: d55507a8-5eeb-470f-98a5-08d62d3536a6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:AM0PR06MB3922;
x-ms-traffictypediagnostic: AM0PR06MB3922:
x-microsoft-antispam-prvs: <AM0PR06MB3922AB7A33BFF8813164451BD4E60@AM0PR06MB3922.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(166708455590820);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991055);SRVR:AM0PR06MB3922;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB3922;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(376002)(346002)(366004)(136003)(189003)(199004)(64126003)(5660300001)(6306002)(36756003)(65956001)(66066001)(68736007)(31686004)(76176011)(102836004)(52116002)(3846002)(2900100001)(65806001)(6116002)(99286004)(6512007)(106356001)(53936002)(65826007)(14444005)(256004)(105586002)(25786009)(5250100002)(97736004)(81156014)(8676002)(71200400001)(71190400001)(81166006)(6486002)(58126008)(66574009)(316002)(229853002)(2906002)(305945005)(110136005)(478600001)(7736002)(476003)(2616005)(446003)(11346002)(53546011)(31696002)(386003)(6506007)(186003)(72206003)(14454004)(6246003)(86362001)(575784001)(8936002)(966005)(6436002)(26005)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB3922;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: yTjoh9kwH4fBrOzGfm0Bofl3kQumNDH7ak8jqxSL07psRBgDTRSAnS9AQRVmpMPE/xHwITO4k3sbVHbtH5Pcolr+kJj/QcEM0JhmfIgx8Bb/h7D8ibMKJ0X/pMeO6v47MRIPvc9t4T53Seb+OwDZTrMy9lqbk4uAmg1GafGWPYq7mQHOHS66+4veAdIDIdQ6AWfK2CywTiuPZNU8d2OHq5RB+GUsZ7NHRhag5f2lNAe6HiTP9PBnrzbzO7pB2Xm21CCc8yimbWguPttN/Ccr9COsDeLl9kFP5Tiq+uXiB39XezjxRu/B6CbXTaZZGrd40Zr2dhxaYsX381rS4xPHUgdngncnHP/mVV9xInaulYo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5308668F56017479B3CABCE955454F2@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d55507a8-5eeb-470f-98a5-08d62d3536a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 15:46:29.7411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB3922
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMDgvMjAxOCAwNToyOSBQTSwgSG9sZ2VyIEhvZmZzdMOkdHRlIHdyb3RlOg0KPiBPbiAx
MC8wOC8xOCAxNjo0MCwgSGFucyB2YW4gS3JhbmVuYnVyZyB3cm90ZToNCj4+PiBMb29raW5nIGF0
IHRoZSBrZXJuZWwgc2lkZSBvZiB0aGluZ3MgaW4gZnMvYnRyZnMvaW9jdGwuYyBJIHNlZSBib3Ro
DQo+Pj4gQlRSRlNfSU9DX1RSRUVfU0VBUkNIW19WMn0gdW5jb25kaXRpb25hbGx5IHJlcXVpcmUg
Q0FQX1NZU19BRE1JTi4NCj4+DQo+PiBUaGF0J3MgdGhlIHRyZWUgc2VhcmNoIGlvY3RsLCBmb3Ig
cmVhZGluZyBhcmJpdHJhcnkgbWV0YWRhdGEuDQo+Pg0KPj4gVGhlIGRldmljZSBzdGF0cyBpb2N0
bCBpcyBJT0NfR0VUX0RFVl9TVEFUUy4uLg0KPiANCj4gWWVhaC4uT0ssIHRoYXQgaXMgY2xlYXIg
YW5kIGdhdmUgbWUgdGhlIGhpbnQgdG8gYXNrOiB3aHkgaXMgaXQNCj4gY2FsbGluZyB0aGlzIGlu
IHRoZSBmaXJzdCBwbGFjZT8gQW5kIGFzIGl0IHR1cm5zIG91dCBbMV0gaXMgd2hlcmUNCj4gaXQg
c2VlbXMgdG8gZ28gd3JvbmcsIGFzIGlzX2Jsb2NrX2RldmljZSgpIHJldHVybnMgMCAoYXMgaXQg
c2hvdWxkKSwNCj4gZmlfYXJncy5udW1fZGV2aWNlcyBpcyBuZXZlciBzZXQgKHJlbWFpbnMgMCkg
YW5kIGl0IHByb2NlZWRzIHRvIGNhbGwNCj4gZXZlcnl0aGluZyBiZWxvdywgZXZlbnR1YWxseSBj
YWxsaW5nIHRoZSBCVFJGU19JT0NfRlNfSU5GTyBpb2N0bCBpbg0KPiAjMTcxMi4gQW5kIHRoYXQg
d29ya3MgZmluZToNCj4gDQo+IDE3MTEgaWYgKGZpX2FyZ3MtPm51bV9kZXZpY2VzICE9IDEpIHsN
Cj4gKGdkYikgcw0KPiAxNzEywqDCoMKgIHJldCA9IGlvY3RsKGZkLCBCVFJGU19JT0NfRlNfSU5G
TywgZmlfYXJncyk7DQo+IChnZGIpIHMNCj4gMTcxM8KgwqDCoCBpZiAocmV0IDwgMCkgew0KPiAo
Z2RiKSBwIHJldA0KPiAkMjggPSAwDQo+IChnZGIpIHAgKmZpX2FyZ3MNCj4gJDMwID0gew0KPiDC
oCBtYXhfaWQgPSAxLA0KPiDCoCBudW1fZGV2aWNlcyA9IDEsDQo+IMKgIGZzaWQgPSAieiU6XDM3
MVwzMTVcMDMzQVwyMDNcMjY3LlwyMDBcMjU1O0ZIXDIyMSIsDQo+IMKgIG5vZGVzaXplID0gMTYz
ODQsDQo+IMKgIHNlY3RvcnNpemUgPSA0MDk2LA0KPiDCoCBjbG9uZV9hbGlnbm1lbnQgPSA0MDk2
LA0KPiDCoCByZXNlcnZlZDMyID0gMCwNCj4gwqAgcmVzZXJ2ZWQgPSB7MCA8cmVwZWF0cyAxMjIg
dGltZXM+fQ0KPiB9DQo+IA0KPiBJdCdzIG9ubHkgd2hlbiBpdCBnb2VzIGludG8gc2VhcmNoX2No
dW5rX3RyZWVfZm9yX2ZzX2luZm8oKQ0KPiB3aGVyZSB0aGluZ3MgZmFpbCBkdWUgdG8gQ0FQX1NZ
U19BRE1JTi4NCj4gDQo+IEFuZCBhbGwgdGhpcyBleHBsYWlucyB0aGUgYWN0dWFsIGJ1Zzogd2hl
biBJIGNhbGwgYnRyZnMgZGV2aWNlIHN0YXRzDQo+IG5vdCBvbiB0aGUgbW91bnRwb2ludCAoYXMg
SSd2ZSBiZWVuIHRyeWluZyBhbGwgdGhpcyB0aW1lKSBidXQgcmF0aGVyDQo+IG9uIHRoZSBkZXZp
Y2UsIGl0IHdvcmtzIHByb3Blcmx5IHJpZ2h0IGF3YXkgYXMgcmVndWxhciB1c2VyOg0KPiANCj4g
KGdkYikgc2V0IGFyZ3MgZGV2aWNlIHN0YXRzIC9kZXYvbG9vcDANCj4gKGdkYikgcg0KPiBCcmVh
a3BvaW50IDEsIGdldF9mc19pbmZvIChwYXRoPXBhdGhAZW50cnk9MHg3ZmZmZmZmZmU1MjcgIi9k
ZXYvbG9vcDAiLA0KPiBmaV9hcmdzPWZpX2FyZ3NAZW50cnk9MHg3ZmZmZmZmZmQ0MDAsDQo+IMKg
wqDCoCBkaV9yZXQ9ZGlfcmV0QGVudHJ5PTB4N2ZmZmZmZmZkM2YwKSBhdCB1dGlscy5jOjE2NTIN
Cj4gMTY1MsKgwqDCoCB7DQo+IChnZGIpIGMNCj4gQ29udGludWluZy4NCj4gWy9kZXYvbG9vcDBd
LndyaXRlX2lvX2VycnPCoMKgwqAgMA0KPiBbL2Rldi9sb29wMF0ucmVhZF9pb19lcnJzwqDCoMKg
wqAgMA0KPiBbL2Rldi9sb29wMF0uZmx1c2hfaW9fZXJyc8KgwqDCoCAwDQo+IFsvZGV2L2xvb3Aw
XS5jb3JydXB0aW9uX2VycnPCoCAwDQo+IFsvZGV2L2xvb3AwXS5nZW5lcmF0aW9uX2VycnPCoCAw
DQo+IFtJbmZlcmlvciAxIChwcm9jZXNzIDI4MDUpIGV4aXRlZCBub3JtYWxseV0NCj4gDQo+IFNv
IHRoaXMgaXMgc2ltcGx5IGEgZGlzY3JlcGFuY3kgaW4gaGFuZGxpbmcgYSBkZXZpY2UgdnMuIHRo
ZSBkZXZpY2UocykNCj4gZm9yIGEgbW91bnRwb2ludC4NCg0KQXBwYXJlbnRseSBiYXNlZCBvbiB3
aGF0IHlvdSBwb2ludCBpdCBhdCwgaXQgZG9lcyBhIGRpZmZlcmVudCB0aGluZy4NCg0KSWYgeW91
IHBvaW50IGl0IGF0IGEgYmxvY2sgZGV2aWNlLCBpdCB3aWxsIHRyeSBvcGVuaW5nIHRoZSBibG9j
ayBkZXZpY2UNCnRvIGZpbmQgb3V0IHdoaWNoIGRldmlkIGl0IGhhcyAoZnJvbSB0aGUgc3VwZXJi
bG9jayksIGZpbmQgb3V0IHdoZXJlIGl0DQppcyBtb3VudGVkIGFuZCB0aGVuIG9ubHkgYXNrIGZv
ciBzdGF0cyBmb3IgdGhpcyBvbmUgZGV2aWNlLg0KDQotIyBidHJmcyBkZXYgc3RhdHMgL2Rldi94
dmRjDQpbL2Rldi94dmRjXS53cml0ZV9pb19lcnJzICAgIDANClsvZGV2L3h2ZGNdLnJlYWRfaW9f
ZXJycyAgICAgMA0KWy9kZXYveHZkY10uZmx1c2hfaW9fZXJycyAgICAwDQpbL2Rldi94dmRjXS5j
b3JydXB0aW9uX2VycnMgIDANClsvZGV2L3h2ZGNdLmdlbmVyYXRpb25fZXJycyAgMA0KDQpJZiB5
b3UgcG9pbnQgaXQgYXQgYSBtb3VudGVkIGZpbGVzeXN0ZW0sIGl0IGxpc3RzIHN0YXRzIGZvciBh
bGwgZGV2aWNlcy4NClNpbmNlIHRoZXJlJ3Mgbm8gd2F5IHRvIGdldCBhIGxpc3Qgb2YgZGV2aWRz
LCBpdCBkaXJlY3RseSBzZWFyY2hlcyB0aGUNCmNodW5rIHRyZWUgZGlyZWN0bHkgZm9yIGRldl9p
dGVtIG9iamVjdHMuDQoNCi0jIGJ0cmZzIGRldiBzdGF0cyAvbW91bnRwb2ludA0KWy9kZXYveHZk
Yl0ud3JpdGVfaW9fZXJycyAgICAwDQpbL2Rldi94dmRiXS5yZWFkX2lvX2VycnMgICAgIDANClsv
ZGV2L3h2ZGJdLmZsdXNoX2lvX2VycnMgICAgMA0KWy9kZXYveHZkYl0uY29ycnVwdGlvbl9lcnJz
ICAwDQpbL2Rldi94dmRiXS5nZW5lcmF0aW9uX2VycnMgIDANClsvZGV2L3h2ZGNdLndyaXRlX2lv
X2VycnMgICAgMA0KWy9kZXYveHZkY10ucmVhZF9pb19lcnJzICAgICAwDQpbL2Rldi94dmRjXS5m
bHVzaF9pb19lcnJzICAgIDANClsvZGV2L3h2ZGNdLmNvcnJ1cHRpb25fZXJycyAgMA0KWy9kZXYv
eHZkY10uZ2VuZXJhdGlvbl9lcnJzICAwDQpbL2Rldi94dmRkXS53cml0ZV9pb19lcnJzICAgIDAN
ClsvZGV2L3h2ZGRdLnJlYWRfaW9fZXJycyAgICAgMA0KWy9kZXYveHZkZF0uZmx1c2hfaW9fZXJy
cyAgICAwDQpbL2Rldi94dmRkXS5jb3JydXB0aW9uX2VycnMgIDANClsvZGV2L3h2ZGRdLmdlbmVy
YXRpb25fZXJycyAgMA0KDQpJIGRvIHRoZSBzYW1lIHRoaW5nIGluIHRoZSBuYWdpb3MgcGx1Z2lu
Og0KDQpodHRwczovL2dpdGh1Yi5jb20va25vcnJpZS9weXRob24tYnRyZnMvYmxvYi9tYXN0ZXIv
ZXhhbXBsZXMvbmFnaW9zL3BsdWdpbnMvY2hlY2tfYnRyZnMjTDEzMQ0KDQpmcy5kZXZpY2VzKCkg
YWxzbyBsb29rcyBmb3IgZGV2X2l0ZW1zIGluIHRoZSBjaHVuayB0cmVlOg0KDQpodHRwczovL2dp
dGh1Yi5jb20va25vcnJpZS9weXRob24tYnRyZnMvYmxvYi9tYXN0ZXIvYnRyZnMvY3RyZWUucHkj
TDQ4MQ0KDQpTbywgQk9PTSEgeW91IG5lZWQgcm9vdC4NCg0KT3IganVzdCBzdGFydCBhIDAsIGln
bm9yZSBlcnJvcnMgYW5kIHN0YXJ0IHRyeWluZyBhbGwgZGV2aWRzIHVudGlsIHlvdQ0KZm91bmQg
bnVtX2RldmljZXMgYW1vdW50IG9mIHRoZW0gdGhhdCB3b3JrLCB5b2xvLg0KDQo+PiBJIGNhbiBk
byB0aGUgZGV2aWNlIHN0YXRzIGlvY3RsIGFzIG5vcm1hbCB1c2VyOg0KPj4NCj4+IGltcG9ydCBi
dHJmcw0KPj4gZnMgPSBidHJmcy5GaWxlU3lzdGVtKCcvJykNCj4+IGJ0cmZzLnV0aWxzLnByZXR0
eV9wcmludChmcy5kZXZfc3RhdHMoMSkpDQo+Pg0KPj4gPGJ0cmZzLmlvY3RsLkRldlN0YXRzPg0K
Pj4gZGV2aWQ6IDENCj4+IG5yX2l0ZW1zOiA1DQo+PiBmbGFnczogMA0KPj4gd3JpdGVfZXJyczog
MA0KPj4gcmVhZF9lcnJzOiAwDQo+PiBmbHVzaF9lcnJzOiAwDQo+PiBnZW5lcmF0aW9uX2VycnM6
IDANCj4+IGNvcnJ1cHRpb25fZXJyczogMA0KPiANCj4gVGhhdCB3b3JrcyBmb3IgbWUgdG9vLCBh
bmQgdGhhdCdzIGFjdHVhbGx5IHRoZSBpbXBvcnRhbnQgcGFydC4gXG8vDQo+IEdsYWQgd2UgdGFs
a2VkIGFib3V0IGl0LiA6fQ0KPiANCj4gLWgNCj4gDQo+IFsxXQ0KPiBodHRwczovL2dpdGh1Yi5j
b20va2RhdmUvYnRyZnMtcHJvZ3MvYmxvYi83ZmFhY2EwZDlmNzhmNzE2MmFlNjAzMjMxZjY5M2Rk
OGUxYWYyYTQxL3V0aWxzLmMjTDE2NjYNCj4gDQo+IA0KDQoNCi0tIA0KSGFucyB2YW4gS3JhbmVu
YnVyZw0K
