Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A53C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 22:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C47FA2064A
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 22:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="haCMoA3J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C47FA2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbeJFFqk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 01:46:40 -0400
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:48960
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726399AbeJFFqj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Oct 2018 01:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6bj399omPbCx9jgXzWqF7WvH8qJPNUj8jtGxwSnhn8=;
 b=haCMoA3JB6AgZottvWZa6sl7KuMdGAFgA8b/ScdOc3yPI4u6UekARHbNGUeV6RFYPwyj6IVE2y6ycQmibOp9FU95Md5Wj/L5dZ79B8sHg2KKaNesKvRwbgxeLoqdhw6K7pwBqAWC5JbIe9DoKnDKMPhVXC+vYa/FpMT7gUkidts=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4450.eurprd06.prod.outlook.com (20.177.41.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1185.25; Fri, 5 Oct 2018 22:45:45 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1164.029; Fri, 5 Oct 2018
 22:45:45 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/6] btrfs: introduce nparity raid_attr
Thread-Topic: [PATCH 5/6] btrfs: introduce nparity raid_attr
Thread-Index: AQHUXCmKAvk47XrG20uhuTwfcIf01qUQuweAgACG8AA=
Date:   Fri, 5 Oct 2018 22:45:44 +0000
Message-ID: <c38ea36e-c827-4e4a-e42d-890a0278bcd1@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <20181004212443.26519-6-hans.van.kranenburg@mendix.com>
 <f3602299-4904-9a59-0a38-ab4525be1239@suse.com>
In-Reply-To: <f3602299-4904-9a59-0a38-ab4525be1239@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: HE1PR0402CA0032.eurprd04.prod.outlook.com
 (2603:10a6:7:7c::21) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4450;6:zi5jmp0N4ZWQwwZhySrpbjgDOh8ghDmePiQtvgOoAPZ8MOFi5xN+qALQxrCrvOd6Pvnsh1gh2iwvs/JRWp5xabMwXwe2jp7Ly72uFePC44HdRvr8MTWa9NBGB1g0zEF8nCYzW1yUQpVplRx6ge5a80pdCUdkTV1paRS7RybdfwRM51BYwIraC7J3T+bc2P1Krlftmkwk2mvdAwh5qPCfurZD+D9R+q5A7FMK/XhhcqV5/GJZp3o01G10RBxIL/wuwGZA2Mb/Iy186ula42Bme0kCLxTj9JADYgfHmwbOsBbqxvt2eLJFQ+Su4hH6tjKFetdVYuLcOt/Sl66Pzq9TDz5oxLgb4wOrsSKvmJj6l/H2P0+zfqHIdXemd8n0HxGKI6xhrcYRfGO2M0F+lRxOtiSgii+etGsyP3Q0Zt+33CgoDR83o2cmyNjCII0N7yG/7EZYx9zs0tjY6tJb94TFIw==;5:0PMCH5s5SKALO4RJDgyVivpwCyVXwSq0KGQnvracZ0/2E6jfxsSJyMvG1ZCe6XcFMSyNU360bffjTqgaGweeA/677cQoyn9CK6pn/ykPCyDgZSRb4wm2pwqBLYjR7O47foBbeEVPJE75hiD9ia/5sF4hJf0OZ0jqf0uwhcmtNJI=;7:kaHcgauQ5OD2fidK6D8DfzEFQYhVfKXtQlbE3nWpCcGbEZji3uAr1uyKzNJzM5w7D2TdkDZSeCRW8G9xcYTj1M9hUOE2wYJLW2xtptwXiWhK9dIoKn4kcjLmfzqA+db9b3QWMBTVX0fk/e9nCcRhnccF+jrrZu6x5qLLlDY+QNhGgx5oB4Y4xzbX0wzcyYqquop3j3hdKkKEbTQ7pSHhJLWe1i0EbuiXQola/2/9c1oQGAa8IPau5vivxfZdTU6Y
x-ms-office365-filtering-correlation-id: a56caab5-9a2e-42d1-f3ac-08d62b144923
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:AM0PR06MB4450;
x-ms-traffictypediagnostic: AM0PR06MB4450:
x-microsoft-antispam-prvs: <AM0PR06MB4450A116856FB02C06CC9AD8D4EB0@AM0PR06MB4450.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(93006095)(93001095)(3231355)(944501410)(52105095)(3002001)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051);SRVR:AM0PR06MB4450;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4450;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(256004)(6506007)(53546011)(68736007)(65956001)(25786009)(81166006)(81156014)(71190400001)(8936002)(76176011)(8676002)(14454004)(71200400001)(7736002)(106356001)(52116002)(99286004)(6116002)(316002)(476003)(46003)(2616005)(446003)(36756003)(305945005)(105586002)(386003)(11346002)(102836004)(31696002)(97736004)(486006)(65806001)(58126008)(186003)(86362001)(72206003)(6486002)(5660300001)(53936002)(478600001)(6512007)(64126003)(110136005)(229853002)(6436002)(31686004)(6246003)(2900100001)(65826007)(2906002)(5250100002)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4450;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 22pVEaakyQ+PEK/Q1F73ZMotqJdMUmeced/FfdAfZDRLpy/awfd6FkXRYJddiPRJzgW0d7qWyst6TpZP1mJRkZQmtJ32PxTXM8ISatWqoC1l8lKZkJ+eqjEXgtqPO3+5nanLUld40K8Ov1nUijNz2X9YNkoC+qOtl6Is1rb1BpaeZ5MwuZ1wTHDTDIfCTUk1EumdG0/85auav1L8ffHgGUjL1N75DOXm8VMzmXohZpNpcK07wrVWWEoDtWqQ4iceAVpsq6uUJwGJAq30P0eupeaG+pViwZx9txzt0+htQskh9aTWrZ5KE04dGSN7B72yvhTDAujNphLtJLmJfDWlqBsNqlVIA9ki1qT+wxmsPJo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAFA4BAE59F514499A3CFE8442D9E5DE@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56caab5-9a2e-42d1-f3ac-08d62b144923
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 22:45:44.9843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4450
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMDUvMjAxOCAwNDo0MiBQTSwgTmlrb2xheSBCb3Jpc292IHdyb3RlOg0KPiANCj4gDQo+
IE9uICA1LjEwLjIwMTggMDA6MjQsIEhhbnMgdmFuIEtyYW5lbmJ1cmcgd3JvdGU6DQo+PiBJbnN0
ZWFkIG9mIGhhcmRjb2RpbmcgZXhjZXB0aW9ucyBmb3IgUkFJRDUgYW5kIFJBSUQ2IGluIHRoZSBj
b2RlLCB1c2UgYW4NCj4+IG5wYXJpdHkgZmllbGQgaW4gcmFpZF9hdHRyLg0KPj4NCj4+IFNpZ25l
ZC1vZmYtYnk6IEhhbnMgdmFuIEtyYW5lbmJ1cmcgPGhhbnMudmFuLmtyYW5lbmJ1cmdAbWVuZGl4
LmNvbT4NCj4+IC0tLQ0KPj4gIGZzL2J0cmZzL3ZvbHVtZXMuYyB8IDE4ICsrKysrKysrKysrLS0t
LS0tLQ0KPj4gIGZzL2J0cmZzL3ZvbHVtZXMuaCB8ICAyICsrDQo+PiAgMiBmaWxlcyBjaGFuZ2Vk
LCAxMyBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9m
cy9idHJmcy92b2x1bWVzLmMgYi9mcy9idHJmcy92b2x1bWVzLmMNCj4+IGluZGV4IGQ4MmIzZDcz
NWViZS4uNDUzMDQ2NDk3YWM4IDEwMDY0NA0KPj4gLS0tIGEvZnMvYnRyZnMvdm9sdW1lcy5jDQo+
PiArKysgYi9mcy9idHJmcy92b2x1bWVzLmMNCj4+IEBAIC0zNyw2ICszNyw3IEBAIGNvbnN0IHN0
cnVjdCBidHJmc19yYWlkX2F0dHIgYnRyZnNfcmFpZF9hcnJheVtCVFJGU19OUl9SQUlEX1RZUEVT
XSA9IHsNCj4+ICAJCS50b2xlcmF0ZWRfZmFpbHVyZXMgPSAxLA0KPj4gIAkJLmRldnNfaW5jcmVt
ZW50CT0gMiwNCj4+ICAJCS5uY29waWVzCT0gMiwNCj4+ICsJCS5ucGFyaXR5ICAgICAgICA9IDAs
DQo+PiAgCQkucmFpZF9uYW1lCT0gInJhaWQxMCIsDQo+PiAgCQkuYmdfZmxhZwk9IEJUUkZTX0JM
T0NLX0dST1VQX1JBSUQxMCwNCj4+ICAJCS5taW5kZXZfZXJyb3IJPSBCVFJGU19FUlJPUl9ERVZf
UkFJRDEwX01JTl9OT1RfTUVULA0KPj4gQEAgLTQ5LDYgKzUwLDcgQEAgY29uc3Qgc3RydWN0IGJ0
cmZzX3JhaWRfYXR0ciBidHJmc19yYWlkX2FycmF5W0JUUkZTX05SX1JBSURfVFlQRVNdID0gew0K
Pj4gIAkJLnRvbGVyYXRlZF9mYWlsdXJlcyA9IDEsDQo+PiAgCQkuZGV2c19pbmNyZW1lbnQJPSAy
LA0KPj4gIAkJLm5jb3BpZXMJPSAyLA0KPj4gKwkJLm5wYXJpdHkgICAgICAgID0gMCwNCj4+ICAJ
CS5yYWlkX25hbWUJPSAicmFpZDEiLA0KPj4gIAkJLmJnX2ZsYWcJPSBCVFJGU19CTE9DS19HUk9V
UF9SQUlEMSwNCj4+ICAJCS5taW5kZXZfZXJyb3IJPSBCVFJGU19FUlJPUl9ERVZfUkFJRDFfTUlO
X05PVF9NRVQsDQo+PiBAQCAtNjEsNiArNjMsNyBAQCBjb25zdCBzdHJ1Y3QgYnRyZnNfcmFpZF9h
dHRyIGJ0cmZzX3JhaWRfYXJyYXlbQlRSRlNfTlJfUkFJRF9UWVBFU10gPSB7DQo+PiAgCQkudG9s
ZXJhdGVkX2ZhaWx1cmVzID0gMCwNCj4+ICAJCS5kZXZzX2luY3JlbWVudAk9IDEsDQo+PiAgCQku
bmNvcGllcwk9IDIsDQo+PiArCQkubnBhcml0eSAgICAgICAgPSAwLA0KPj4gIAkJLnJhaWRfbmFt
ZQk9ICJkdXAiLA0KPj4gIAkJLmJnX2ZsYWcJPSBCVFJGU19CTE9DS19HUk9VUF9EVVAsDQo+PiAg
CQkubWluZGV2X2Vycm9yCT0gMCwNCj4+IEBAIC03Myw2ICs3Niw3IEBAIGNvbnN0IHN0cnVjdCBi
dHJmc19yYWlkX2F0dHIgYnRyZnNfcmFpZF9hcnJheVtCVFJGU19OUl9SQUlEX1RZUEVTXSA9IHsN
Cj4+ICAJCS50b2xlcmF0ZWRfZmFpbHVyZXMgPSAwLA0KPj4gIAkJLmRldnNfaW5jcmVtZW50CT0g
MSwNCj4+ICAJCS5uY29waWVzCT0gMSwNCj4+ICsJCS5ucGFyaXR5ICAgICAgICA9IDAsDQo+PiAg
CQkucmFpZF9uYW1lCT0gInJhaWQwIiwNCj4+ICAJCS5iZ19mbGFnCT0gQlRSRlNfQkxPQ0tfR1JP
VVBfUkFJRDAsDQo+PiAgCQkubWluZGV2X2Vycm9yCT0gMCwNCj4+IEBAIC04NSw2ICs4OSw3IEBA
IGNvbnN0IHN0cnVjdCBidHJmc19yYWlkX2F0dHIgYnRyZnNfcmFpZF9hcnJheVtCVFJGU19OUl9S
QUlEX1RZUEVTXSA9IHsNCj4+ICAJCS50b2xlcmF0ZWRfZmFpbHVyZXMgPSAwLA0KPj4gIAkJLmRl
dnNfaW5jcmVtZW50CT0gMSwNCj4+ICAJCS5uY29waWVzCT0gMSwNCj4+ICsJCS5ucGFyaXR5ICAg
ICAgICA9IDAsDQo+PiAgCQkucmFpZF9uYW1lCT0gInNpbmdsZSIsDQo+PiAgCQkuYmdfZmxhZwk9
IDAsDQo+PiAgCQkubWluZGV2X2Vycm9yCT0gMCwNCj4+IEBAIC05Nyw2ICsxMDIsNyBAQCBjb25z
dCBzdHJ1Y3QgYnRyZnNfcmFpZF9hdHRyIGJ0cmZzX3JhaWRfYXJyYXlbQlRSRlNfTlJfUkFJRF9U
WVBFU10gPSB7DQo+PiAgCQkudG9sZXJhdGVkX2ZhaWx1cmVzID0gMSwNCj4+ICAJCS5kZXZzX2lu
Y3JlbWVudAk9IDEsDQo+PiAgCQkubmNvcGllcwk9IDEsDQo+PiArCQkubnBhcml0eSAgICAgICAg
PSAyLA0KPj4gIAkJLnJhaWRfbmFtZQk9ICJyYWlkNSIsDQo+PiAgCQkuYmdfZmxhZwk9IEJUUkZT
X0JMT0NLX0dST1VQX1JBSUQ1LA0KPj4gIAkJLm1pbmRldl9lcnJvcgk9IEJUUkZTX0VSUk9SX0RF
Vl9SQUlENV9NSU5fTk9UX01FVCwNCj4+IEBAIC0xMDksNiArMTE1LDcgQEAgY29uc3Qgc3RydWN0
IGJ0cmZzX3JhaWRfYXR0ciBidHJmc19yYWlkX2FycmF5W0JUUkZTX05SX1JBSURfVFlQRVNdID0g
ew0KPj4gIAkJLnRvbGVyYXRlZF9mYWlsdXJlcyA9IDIsDQo+PiAgCQkuZGV2c19pbmNyZW1lbnQJ
PSAxLA0KPj4gIAkJLm5jb3BpZXMJPSAxLA0KPj4gKwkJLm5wYXJpdHkgICAgICAgID0gMiwNCj4+
ICAJCS5yYWlkX25hbWUJPSAicmFpZDYiLA0KPj4gIAkJLmJnX2ZsYWcJPSBCVFJGU19CTE9DS19H
Uk9VUF9SQUlENiwNCj4+ICAJCS5taW5kZXZfZXJyb3IJPSBCVFJGU19FUlJPUl9ERVZfUkFJRDZf
TUlOX05PVF9NRVQsDQo+PiBAQCAtNDU5Nyw2ICs0NjA0LDggQEAgc3RhdGljIGludCBfX2J0cmZz
X2FsbG9jX2NodW5rKHN0cnVjdCBidHJmc190cmFuc19oYW5kbGUgKnRyYW5zLA0KPj4gIAlpbnQg
ZGV2c19taW47CQkvKiBtaW4gZGV2cyBuZWVkZWQgKi8NCj4+ICAJaW50IGRldnNfaW5jcmVtZW50
OwkvKiBuZGV2cyBoYXMgdG8gYmUgYSBtdWx0aXBsZSBvZiB0aGlzICovDQo+PiAgCWludCBuY29w
aWVzOwkJLyogaG93IG1hbnkgY29waWVzIHRvIGRhdGEgaGFzICovDQo+PiArCWludCBucGFyaXR5
OwkJLyogbnVtYmVyIG9mIHN0cmlwZXMgd29ydGggb2YgYnl0ZXMgdG8NCj4+ICsJCQkJICAgc3Rv
cmUgcGFyaXR5IGluZm9ybWF0aW9uICovDQo+PiAgCWludCByZXQ7DQo+PiAgCXU2NCBtYXhfc3Ry
aXBlX3NpemU7DQo+PiAgCXU2NCBtYXhfY2h1bmtfc2l6ZTsNCj4+IEBAIC00NjIzLDYgKzQ2MzIs
NyBAQCBzdGF0aWMgaW50IF9fYnRyZnNfYWxsb2NfY2h1bmsoc3RydWN0IGJ0cmZzX3RyYW5zX2hh
bmRsZSAqdHJhbnMsDQo+PiAgCWRldnNfbWluID0gYnRyZnNfcmFpZF9hcnJheVtpbmRleF0uZGV2
c19taW47DQo+PiAgCWRldnNfaW5jcmVtZW50ID0gYnRyZnNfcmFpZF9hcnJheVtpbmRleF0uZGV2
c19pbmNyZW1lbnQ7DQo+PiAgCW5jb3BpZXMgPSBidHJmc19yYWlkX2FycmF5W2luZGV4XS5uY29w
aWVzOw0KPj4gKwlucGFyaXR5ID0gYnRyZnNfcmFpZF9hcnJheVtpbmRleF0ubnBhcml0eTsNCj4+
ICANCj4+ICAJaWYgKHR5cGUgJiBCVFJGU19CTE9DS19HUk9VUF9EQVRBKSB7DQo+PiAgCQltYXhf
c3RyaXBlX3NpemUgPSBTWl8xRzsNCj4+IEBAIC00NzUyLDEzICs0NzYyLDcgQEAgc3RhdGljIGlu
dCBfX2J0cmZzX2FsbG9jX2NodW5rKHN0cnVjdCBidHJmc190cmFuc19oYW5kbGUgKnRyYW5zLA0K
Pj4gIAkgKiB0aGlzIHdpbGwgaGF2ZSB0byBiZSBmaXhlZCBmb3IgUkFJRDEgYW5kIFJBSUQxMCBv
dmVyDQo+PiAgCSAqIG1vcmUgZHJpdmVzDQo+PiAgCSAqLw0KPj4gLQlkYXRhX3N0cmlwZXMgPSBu
dW1fc3RyaXBlcyAvIG5jb3BpZXM7DQo+PiAtDQo+PiAtCWlmICh0eXBlICYgQlRSRlNfQkxPQ0tf
R1JPVVBfUkFJRDUpDQo+PiAtCQlkYXRhX3N0cmlwZXMgPSBudW1fc3RyaXBlcyAtIDE7DQo+PiAt
DQo+PiAtCWlmICh0eXBlICYgQlRSRlNfQkxPQ0tfR1JPVVBfUkFJRDYpDQo+PiAtCQlkYXRhX3N0
cmlwZXMgPSBudW1fc3RyaXBlcyAtIDI7DQo+PiArCWRhdGFfc3RyaXBlcyA9IChudW1fc3RyaXBl
cyAtIG5wYXJpdHkpIC8gbmNvcGllczsNCj4+ICANCj4+ICAJLyoNCj4+ICAJICogVXNlIHRoZSBu
dW1iZXIgb2YgZGF0YSBzdHJpcGVzIHRvIGZpZ3VyZSBvdXQgaG93IGJpZyB0aGlzIGNodW5rDQo+
PiBkaWZmIC0tZ2l0IGEvZnMvYnRyZnMvdm9sdW1lcy5oIGIvZnMvYnRyZnMvdm9sdW1lcy5oDQo+
PiBpbmRleCAyM2U5Mjg1ZDg4ZGUuLjBmZTAwNWI0Mjk1YSAxMDA2NDQNCj4+IC0tLSBhL2ZzL2J0
cmZzL3ZvbHVtZXMuaA0KPj4gKysrIGIvZnMvYnRyZnMvdm9sdW1lcy5oDQo+PiBAQCAtMzMxLDYg
KzMzMSw4IEBAIHN0cnVjdCBidHJmc19yYWlkX2F0dHIgew0KPj4gIAlpbnQgdG9sZXJhdGVkX2Zh
aWx1cmVzOyAvKiBtYXggdG9sZXJhdGVkIGZhaWwgZGV2cyAqLw0KPj4gIAlpbnQgZGV2c19pbmNy
ZW1lbnQ7CS8qIG5kZXZzIGhhcyB0byBiZSBhIG11bHRpcGxlIG9mIHRoaXMgKi8NCj4+ICAJaW50
IG5jb3BpZXM7CQkvKiBob3cgbWFueSBjb3BpZXMgdG8gZGF0YSBoYXMgKi8NCj4+ICsJaW50IG5w
YXJpdHk7CQkvKiBudW1iZXIgb2Ygc3RyaXBlcyB3b3J0aCBvZiBieXRlcyB0bw0KPj4gKwkJCQkg
ICBzdG9yZSBwYXJpdHkgaW5mb3JtYXRpb24gKi8NCj4gDQo+IFRoZSBkZXNjcmlwdGlvbiBjYW4g
YmUgc2ltcGxpZmllZCB0bzogbnVtYmVyIG9mIHBhcml0eSBzdHJpcGVzDQoNCldlbGwsIGlmICdz
dHJpcGUnIGlzIGEgc3lub255bSBmb3IgJ2RldmljZSBleHRlbnQnIGhlcmUsIHRoZW4NCnRlY2hu
aWNhbGx5IHRoYXQncyBpbmNvcnJlY3QsIHNpbmNlIGFsbCBwcm9maWxlcyB1c2luZyBwYXJpdHkg
ZG8NCmRpc3RyaWJ1dGUgdGhlIHBhcml0eSBkYXRhIG92ZXIgYWxsIHN0cmlwZXMuIElPVywgaXQn
cyBub3QgUkFJRDQuDQoNCkZvciB0aGUgY2FsY3VsYXRpb25zIGluIGhlcmUgd2UgdHJlYXQgaXQg
bGlrZSB0aGF0LCBiZWNhdXNlIG9uIHRoaXMNCmxldmVsIHdlIGRvbid0IGNhcmUgYWJvdXQgd2hh
dCBnb2VzIHdoZXJlIGxhdGVyLCBqdXN0IHRoYXQgdGhlIHRvdGFsDQphbW91bnQgb2YgYWxsb2Nh
dGVkIGJ5dGVzIGlzIHJpZ2h0Lg0KDQpUaGF0J3Mgd2h5IEkgdGhvdWdodCBwdXR0aW5nIGEgbGl0
dGxlIGhpbnQgaW4gdGhlcmUsIHRvIG1ha2UgdGhlIHJlYWRlcg0KdGhpbmsgYWJvdXQgaXQgYW5k
IHRoZW4gcmVhbGl6ZSB0aGF0IGl0J3MgYWN0dWFsbHkgbm90IHRoYXQgc2ltcGxlLiBBbmQNCmFw
cGFyZW50bHkgdGhhdCB3b3Jrcy4gOikNCg0KPiANCj4+ICAJaW50IG1pbmRldl9lcnJvcjsJLyog
ZXJyb3IgY29kZSBpZiBtaW4gZGV2cyByZXF1aXNpdGUgaXMgdW5tZXQgKi8NCj4+ICAJY29uc3Qg
Y2hhciByYWlkX25hbWVbOF07IC8qIG5hbWUgb2YgdGhlIHJhaWQgKi8NCj4+ICAJdTY0IGJnX2Zs
YWc7CQkvKiBibG9jayBncm91cCBmbGFnIG9mIHRoZSByYWlkICovDQo+Pg0KDQoNCi0tIA0KSGFu
cyB2YW4gS3JhbmVuYnVyZw0K
