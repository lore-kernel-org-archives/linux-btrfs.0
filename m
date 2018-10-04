Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19248C64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 22:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC96920854
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 22:21:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="SAdbzvKL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC96920854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbeJEFQx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 01:16:53 -0400
Received: from mail-ve1eur01on0067.outbound.protection.outlook.com ([104.47.1.67]:4224
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbeJEFQx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Oct 2018 01:16:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/dFYWWebNn3PtDAwIb9aURQf8dst6YzsnA6J74bVfs=;
 b=SAdbzvKLzjJlnwQCDlRrkCdutz8x6LKsN23w0SY+JbbiOoGI3pT3+p+bX1poGoiBGp77o37LOxHgpy3bZ3R59UOqgtaHbnSKpItlDEFFvCIKz6bnNRc1OeIfzinFodr4IzR/PWCgkH029xVWV9UidYUXGRIVmmzX2H4B2MJpkOs=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4244.eurprd06.prod.outlook.com (52.135.150.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.25; Thu, 4 Oct 2018 22:21:20 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1164.029; Thu, 4 Oct 2018
 22:21:20 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/6] btrfs: introduce nparity raid_attr
Thread-Topic: [PATCH 5/6] btrfs: introduce nparity raid_attr
Thread-Index: AQHUXCmKAvk47XrG20uhuTwfcIf01qUPqNEA
Date:   Thu, 4 Oct 2018 22:21:20 +0000
Message-ID: <255aba7e-4a4f-4e64-4af9-cda80a96e91e@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <20181004212443.26519-6-hans.van.kranenburg@mendix.com>
In-Reply-To: <20181004212443.26519-6-hans.van.kranenburg@mendix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: VI1PR02CA0067.eurprd02.prod.outlook.com
 (2603:10a6:802:14::38) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4244;6:gNSLdIHxRtYcpLyFv2vrPPP4Jf5oynqImDpJALWvkZOv9zYAN4E8kh+avKF6Qj3UUf/HyWoMrx/npG2VviD7qObSUsbXJshKj5GBaTE1to4HOqlvxbxU5qZ7vCSvl9cqKHQCN3x2uTn9Z2S+6cRL2Q2FkF+GAr6HwnQkS9pqWONgqMi8vvFH4DMib63jgQt7t86fmrit5cZ4Q2CwAfK6QRtvz+s/MuoFyn20U4G/WgUMeDJ1KeBQp+nrryr6ZUdbHJNcN0fI4/0aGk1CcTH9NSUix6b6CzEtACAQ/3BExoLtlgbh3hpd1b+7U9KZcDbuVdZuGMW0dXmXqiME5a8PJcDYPDqg7L1KmlUubUSvE4hHvUmrCP7i3md6WbpKdsGn9ELiwU+3XWpR7eL6HhCD/beahl3EwO2lgXrSDOpFfF9yyUi5UKVBGXNH3itBU3IeuFmrks0XZvOkddmOKJn9TA==;5:Fj5jXCBjlhB4lFO7WzhSZC0tuLu8P6947GaG3E+EpJ8QtAk3L5X0mHto2+63gcog0u6tvsmv04eTq1NZQEVE9NlFdUKKUYf9pBhBNPiQGHbDKz9Ne4ofLVYptOTcJSg8heKrQjhLNp5NHsNnzCk66UbBeDpnjmAf97M9jbB6UBM=;7:RMuzh+vm5UUoTJ9ZQUKsKp6CkMlMHuy96tvhFHxUuhlu0owuDLEYqV4N4bXg1IPmxzRq18kwdUV8UfhEmwwiwdWO5wWpaYGZLAZeksTikY1ZLVCnbueKmXfLoPazsXXd1ci744HGIAIE1voXcjm67fagMheoCHmYcfH1dIzRs4hPrKUs8GsIhGc4PaVYKBedqFl/DD47uWbPmZTcPoTWgGxLlghAiq530iflaV2ps9Nskmcfj471yD1ntnydQ2Mx
x-ms-office365-filtering-correlation-id: b6aca9f8-1a36-4c5d-22bd-08d62a47b618
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:AM0PR06MB4244;
x-ms-traffictypediagnostic: AM0PR06MB4244:
x-microsoft-antispam-prvs: <AM0PR06MB4244337992435BE99EEE2F9CD4EA0@AM0PR06MB4244.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(20161123562045)(201708071742011)(7699051);SRVR:AM0PR06MB4244;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4244;
x-forefront-prvs: 0815F8251E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(39850400004)(136003)(396003)(189003)(199004)(8676002)(476003)(486006)(186003)(11346002)(229853002)(446003)(102836004)(2906002)(2900100001)(31696002)(86362001)(6512007)(256004)(305945005)(46003)(7736002)(8936002)(5640700003)(81166006)(81156014)(6506007)(31686004)(386003)(2616005)(53546011)(53936002)(25786009)(6246003)(6436002)(6486002)(76176011)(68736007)(316002)(71190400001)(71200400001)(5660300001)(65826007)(6116002)(105586002)(478600001)(36756003)(2351001)(52116002)(5250100002)(106356001)(2501003)(58126008)(14454004)(64126003)(72206003)(97736004)(99286004)(6916009)(65806001)(65956001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4244;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: SQ/55QP52PwGMS9msit50+xPIecIJp7dE9bEBicd8mYL3Ag14lyCLl0Gqlh9b9ndPUxcu7buj7y+rM5miXGrA/EFiWTW28uZoJCAX8vVGe92oSjlQfwCRS2cioz18ZpF1We8CE84lUP/mM8NOTDQlIvVCRreLHi0MEBHNklTI31PTp3tVaiuMgG4iPzrTP+leflvRRwHnCroPTs4cqNZFj+1QyrysJOz5tW2+zGP/AqukmmkN10+NukW4bYIseTdyMzCYxeHyg4DrRsqNnwKknzW/7TS0T1L4vOJ0YN0N/dnLUNOV35BGQoMAc6/4jncRT2cBmMkrUUky1xcEzxuzvjiStEqzQ7j8we8ZpR60R4=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <75C05ECC49574F419EC69B40247D07AC@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6aca9f8-1a36-4c5d-22bd-08d62a47b618
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2018 22:21:20.8707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4244
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMDQvMjAxOCAxMToyNCBQTSwgSGFucyB2YW4gS3JhbmVuYnVyZyB3cm90ZToNCj4gSW5z
dGVhZCBvZiBoYXJkY29kaW5nIGV4Y2VwdGlvbnMgZm9yIFJBSUQ1IGFuZCBSQUlENiBpbiB0aGUg
Y29kZSwgdXNlIGFuDQo+IG5wYXJpdHkgZmllbGQgaW4gcmFpZF9hdHRyLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogSGFucyB2YW4gS3JhbmVuYnVyZyA8aGFucy52YW4ua3JhbmVuYnVyZ0BtZW5kaXgu
Y29tPg0KPiAtLS0NCj4gIGZzL2J0cmZzL3ZvbHVtZXMuYyB8IDE4ICsrKysrKysrKysrLS0tLS0t
LQ0KPiAgZnMvYnRyZnMvdm9sdW1lcy5oIHwgIDIgKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTMg
aW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9idHJm
cy92b2x1bWVzLmMgYi9mcy9idHJmcy92b2x1bWVzLmMNCj4gaW5kZXggZDgyYjNkNzM1ZWJlLi40
NTMwNDY0OTdhYzggMTAwNjQ0DQo+IC0tLSBhL2ZzL2J0cmZzL3ZvbHVtZXMuYw0KPiArKysgYi9m
cy9idHJmcy92b2x1bWVzLmMNCj4gQEAgLTM3LDYgKzM3LDcgQEAgY29uc3Qgc3RydWN0IGJ0cmZz
X3JhaWRfYXR0ciBidHJmc19yYWlkX2FycmF5W0JUUkZTX05SX1JBSURfVFlQRVNdID0gew0KPiAg
CQkudG9sZXJhdGVkX2ZhaWx1cmVzID0gMSwNCj4gIAkJLmRldnNfaW5jcmVtZW50CT0gMiwNCj4g
IAkJLm5jb3BpZXMJPSAyLA0KPiArCQkubnBhcml0eSAgICAgICAgPSAwLA0KPiAgCQkucmFpZF9u
YW1lCT0gInJhaWQxMCIsDQo+ICAJCS5iZ19mbGFnCT0gQlRSRlNfQkxPQ0tfR1JPVVBfUkFJRDEw
LA0KPiAgCQkubWluZGV2X2Vycm9yCT0gQlRSRlNfRVJST1JfREVWX1JBSUQxMF9NSU5fTk9UX01F
VCwNCj4gQEAgLTQ5LDYgKzUwLDcgQEAgY29uc3Qgc3RydWN0IGJ0cmZzX3JhaWRfYXR0ciBidHJm
c19yYWlkX2FycmF5W0JUUkZTX05SX1JBSURfVFlQRVNdID0gew0KPiAgCQkudG9sZXJhdGVkX2Zh
aWx1cmVzID0gMSwNCj4gIAkJLmRldnNfaW5jcmVtZW50CT0gMiwNCj4gIAkJLm5jb3BpZXMJPSAy
LA0KPiArCQkubnBhcml0eSAgICAgICAgPSAwLA0KPiAgCQkucmFpZF9uYW1lCT0gInJhaWQxIiwN
Cj4gIAkJLmJnX2ZsYWcJPSBCVFJGU19CTE9DS19HUk9VUF9SQUlEMSwNCj4gIAkJLm1pbmRldl9l
cnJvcgk9IEJUUkZTX0VSUk9SX0RFVl9SQUlEMV9NSU5fTk9UX01FVCwNCj4gQEAgLTYxLDYgKzYz
LDcgQEAgY29uc3Qgc3RydWN0IGJ0cmZzX3JhaWRfYXR0ciBidHJmc19yYWlkX2FycmF5W0JUUkZT
X05SX1JBSURfVFlQRVNdID0gew0KPiAgCQkudG9sZXJhdGVkX2ZhaWx1cmVzID0gMCwNCj4gIAkJ
LmRldnNfaW5jcmVtZW50CT0gMSwNCj4gIAkJLm5jb3BpZXMJPSAyLA0KPiArCQkubnBhcml0eSAg
ICAgICAgPSAwLA0KPiAgCQkucmFpZF9uYW1lCT0gImR1cCIsDQo+ICAJCS5iZ19mbGFnCT0gQlRS
RlNfQkxPQ0tfR1JPVVBfRFVQLA0KPiAgCQkubWluZGV2X2Vycm9yCT0gMCwNCj4gQEAgLTczLDYg
Kzc2LDcgQEAgY29uc3Qgc3RydWN0IGJ0cmZzX3JhaWRfYXR0ciBidHJmc19yYWlkX2FycmF5W0JU
UkZTX05SX1JBSURfVFlQRVNdID0gew0KPiAgCQkudG9sZXJhdGVkX2ZhaWx1cmVzID0gMCwNCj4g
IAkJLmRldnNfaW5jcmVtZW50CT0gMSwNCj4gIAkJLm5jb3BpZXMJPSAxLA0KPiArCQkubnBhcml0
eSAgICAgICAgPSAwLA0KPiAgCQkucmFpZF9uYW1lCT0gInJhaWQwIiwNCj4gIAkJLmJnX2ZsYWcJ
PSBCVFJGU19CTE9DS19HUk9VUF9SQUlEMCwNCj4gIAkJLm1pbmRldl9lcnJvcgk9IDAsDQo+IEBA
IC04NSw2ICs4OSw3IEBAIGNvbnN0IHN0cnVjdCBidHJmc19yYWlkX2F0dHIgYnRyZnNfcmFpZF9h
cnJheVtCVFJGU19OUl9SQUlEX1RZUEVTXSA9IHsNCj4gIAkJLnRvbGVyYXRlZF9mYWlsdXJlcyA9
IDAsDQo+ICAJCS5kZXZzX2luY3JlbWVudAk9IDEsDQo+ICAJCS5uY29waWVzCT0gMSwNCj4gKwkJ
Lm5wYXJpdHkgICAgICAgID0gMCwNCj4gIAkJLnJhaWRfbmFtZQk9ICJzaW5nbGUiLA0KPiAgCQku
YmdfZmxhZwk9IDAsDQo+ICAJCS5taW5kZXZfZXJyb3IJPSAwLA0KPiBAQCAtOTcsNiArMTAyLDcg
QEAgY29uc3Qgc3RydWN0IGJ0cmZzX3JhaWRfYXR0ciBidHJmc19yYWlkX2FycmF5W0JUUkZTX05S
X1JBSURfVFlQRVNdID0gew0KPiAgCQkudG9sZXJhdGVkX2ZhaWx1cmVzID0gMSwNCj4gIAkJLmRl
dnNfaW5jcmVtZW50CT0gMSwNCj4gIAkJLm5jb3BpZXMJPSAxLA0KPiArCQkubnBhcml0eSAgICAg
ICAgPSAyLA0KDQpBaGVtLCB0aGlzIG9idmlvdXNseSBuZWVkcyB0byBiZSAxLiBBbm90aGVyIHJl
b3JnYW5pemUvcmViYXNlLWZhaWwuDQoNCj4gIAkJLnJhaWRfbmFtZQk9ICJyYWlkNSIsDQo+ICAJ
CS5iZ19mbGFnCT0gQlRSRlNfQkxPQ0tfR1JPVVBfUkFJRDUsDQo+ICAJCS5taW5kZXZfZXJyb3IJ
PSBCVFJGU19FUlJPUl9ERVZfUkFJRDVfTUlOX05PVF9NRVQsDQo+IEBAIC0xMDksNiArMTE1LDcg
QEAgY29uc3Qgc3RydWN0IGJ0cmZzX3JhaWRfYXR0ciBidHJmc19yYWlkX2FycmF5W0JUUkZTX05S
X1JBSURfVFlQRVNdID0gew0KPiAgCQkudG9sZXJhdGVkX2ZhaWx1cmVzID0gMiwNCj4gIAkJLmRl
dnNfaW5jcmVtZW50CT0gMSwNCj4gIAkJLm5jb3BpZXMJPSAxLA0KPiArCQkubnBhcml0eSAgICAg
ICAgPSAyLA0KPiAgCQkucmFpZF9uYW1lCT0gInJhaWQ2IiwNCj4gIAkJLmJnX2ZsYWcJPSBCVFJG
U19CTE9DS19HUk9VUF9SQUlENiwNCj4gIAkJLm1pbmRldl9lcnJvcgk9IEJUUkZTX0VSUk9SX0RF
Vl9SQUlENl9NSU5fTk9UX01FVCwNCj4gQEAgLTQ1OTcsNiArNDYwNCw4IEBAIHN0YXRpYyBpbnQg
X19idHJmc19hbGxvY19jaHVuayhzdHJ1Y3QgYnRyZnNfdHJhbnNfaGFuZGxlICp0cmFucywNCj4g
IAlpbnQgZGV2c19taW47CQkvKiBtaW4gZGV2cyBuZWVkZWQgKi8NCj4gIAlpbnQgZGV2c19pbmNy
ZW1lbnQ7CS8qIG5kZXZzIGhhcyB0byBiZSBhIG11bHRpcGxlIG9mIHRoaXMgKi8NCj4gIAlpbnQg
bmNvcGllczsJCS8qIGhvdyBtYW55IGNvcGllcyB0byBkYXRhIGhhcyAqLw0KPiArCWludCBucGFy
aXR5OwkJLyogbnVtYmVyIG9mIHN0cmlwZXMgd29ydGggb2YgYnl0ZXMgdG8NCj4gKwkJCQkgICBz
dG9yZSBwYXJpdHkgaW5mb3JtYXRpb24gKi8NCj4gIAlpbnQgcmV0Ow0KPiAgCXU2NCBtYXhfc3Ry
aXBlX3NpemU7DQo+ICAJdTY0IG1heF9jaHVua19zaXplOw0KPiBAQCAtNDYyMyw2ICs0NjMyLDcg
QEAgc3RhdGljIGludCBfX2J0cmZzX2FsbG9jX2NodW5rKHN0cnVjdCBidHJmc190cmFuc19oYW5k
bGUgKnRyYW5zLA0KPiAgCWRldnNfbWluID0gYnRyZnNfcmFpZF9hcnJheVtpbmRleF0uZGV2c19t
aW47DQo+ICAJZGV2c19pbmNyZW1lbnQgPSBidHJmc19yYWlkX2FycmF5W2luZGV4XS5kZXZzX2lu
Y3JlbWVudDsNCj4gIAluY29waWVzID0gYnRyZnNfcmFpZF9hcnJheVtpbmRleF0ubmNvcGllczsN
Cj4gKwlucGFyaXR5ID0gYnRyZnNfcmFpZF9hcnJheVtpbmRleF0ubnBhcml0eTsNCj4gIA0KPiAg
CWlmICh0eXBlICYgQlRSRlNfQkxPQ0tfR1JPVVBfREFUQSkgew0KPiAgCQltYXhfc3RyaXBlX3Np
emUgPSBTWl8xRzsNCj4gQEAgLTQ3NTIsMTMgKzQ3NjIsNyBAQCBzdGF0aWMgaW50IF9fYnRyZnNf
YWxsb2NfY2h1bmsoc3RydWN0IGJ0cmZzX3RyYW5zX2hhbmRsZSAqdHJhbnMsDQo+ICAJICogdGhp
cyB3aWxsIGhhdmUgdG8gYmUgZml4ZWQgZm9yIFJBSUQxIGFuZCBSQUlEMTAgb3Zlcg0KPiAgCSAq
IG1vcmUgZHJpdmVzDQo+ICAJICovDQo+IC0JZGF0YV9zdHJpcGVzID0gbnVtX3N0cmlwZXMgLyBu
Y29waWVzOw0KPiAtDQo+IC0JaWYgKHR5cGUgJiBCVFJGU19CTE9DS19HUk9VUF9SQUlENSkNCj4g
LQkJZGF0YV9zdHJpcGVzID0gbnVtX3N0cmlwZXMgLSAxOw0KPiAtDQo+IC0JaWYgKHR5cGUgJiBC
VFJGU19CTE9DS19HUk9VUF9SQUlENikNCj4gLQkJZGF0YV9zdHJpcGVzID0gbnVtX3N0cmlwZXMg
LSAyOw0KPiArCWRhdGFfc3RyaXBlcyA9IChudW1fc3RyaXBlcyAtIG5wYXJpdHkpIC8gbmNvcGll
czsNCj4gIA0KPiAgCS8qDQo+ICAJICogVXNlIHRoZSBudW1iZXIgb2YgZGF0YSBzdHJpcGVzIHRv
IGZpZ3VyZSBvdXQgaG93IGJpZyB0aGlzIGNodW5rDQo+IGRpZmYgLS1naXQgYS9mcy9idHJmcy92
b2x1bWVzLmggYi9mcy9idHJmcy92b2x1bWVzLmgNCj4gaW5kZXggMjNlOTI4NWQ4OGRlLi4wZmUw
MDViNDI5NWEgMTAwNjQ0DQo+IC0tLSBhL2ZzL2J0cmZzL3ZvbHVtZXMuaA0KPiArKysgYi9mcy9i
dHJmcy92b2x1bWVzLmgNCj4gQEAgLTMzMSw2ICszMzEsOCBAQCBzdHJ1Y3QgYnRyZnNfcmFpZF9h
dHRyIHsNCj4gIAlpbnQgdG9sZXJhdGVkX2ZhaWx1cmVzOyAvKiBtYXggdG9sZXJhdGVkIGZhaWwg
ZGV2cyAqLw0KPiAgCWludCBkZXZzX2luY3JlbWVudDsJLyogbmRldnMgaGFzIHRvIGJlIGEgbXVs
dGlwbGUgb2YgdGhpcyAqLw0KPiAgCWludCBuY29waWVzOwkJLyogaG93IG1hbnkgY29waWVzIHRv
IGRhdGEgaGFzICovDQo+ICsJaW50IG5wYXJpdHk7CQkvKiBudW1iZXIgb2Ygc3RyaXBlcyB3b3J0
aCBvZiBieXRlcyB0bw0KPiArCQkJCSAgIHN0b3JlIHBhcml0eSBpbmZvcm1hdGlvbiAqLw0KPiAg
CWludCBtaW5kZXZfZXJyb3I7CS8qIGVycm9yIGNvZGUgaWYgbWluIGRldnMgcmVxdWlzaXRlIGlz
IHVubWV0ICovDQo+ICAJY29uc3QgY2hhciByYWlkX25hbWVbOF07IC8qIG5hbWUgb2YgdGhlIHJh
aWQgKi8NCj4gIAl1NjQgYmdfZmxhZzsJCS8qIGJsb2NrIGdyb3VwIGZsYWcgb2YgdGhlIHJhaWQg
Ki8NCj4gDQoNCg0KLS0gDQpIYW5zIHZhbiBLcmFuZW5idXJnDQo=
