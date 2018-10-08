Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE53BC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 14:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7279F2085B
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 14:54:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="NnDQOI6f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7279F2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbeJHWGN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 18:06:13 -0400
Received: from mail-ve1eur01on0083.outbound.protection.outlook.com ([104.47.1.83]:59226
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726159AbeJHWGN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 18:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsn8H/0xmE3EPppO/dnlmni5uy1CHBRanjKOBtT16/A=;
 b=NnDQOI6fzhiGWOi0PzoKAHXozdxnu3tU0fIbuJG2HVYkDSskmkijlkUtbtUm8kSHp0YGve8EgJnyD9XawlJEeRF7FVbSBFgQ9b5qX+co9g8AuV6u0yCL0/49WbQX8kXuy5HoyVqrmZhEO4CIMcbxZvToTpsnXXhqfEWUhRWd2fg=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4355.eurprd06.prod.outlook.com (52.135.150.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.27; Mon, 8 Oct 2018 14:54:01 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1207.024; Mon, 8 Oct 2018
 14:54:01 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     =?utf-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?= 
        <holger@applied-asynchrony.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Curious problem: btrfs device stats & unpriviliged access
Thread-Topic: Curious problem: btrfs device stats & unpriviliged access
Thread-Index: AQHUXxMak/ScarELJUS5tWBWYhmxkKUVa38AgAAD14A=
Date:   Mon, 8 Oct 2018 14:54:01 +0000
Message-ID: <a0fe89e7-e2c4-8816-0465-1994f0f2e9d4@mendix.com>
References: <05c64256-71d3-81dc-3189-628e8cc0a5db@applied-asynchrony.com>
 <5eafba35-c79b-17f2-e296-aafddf06ebf1@mendix.com>
In-Reply-To: <5eafba35-c79b-17f2-e296-aafddf06ebf1@mendix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [85.146.242.35]
x-clientproxiedby: VI1P195CA0077.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::30) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4355;6:G0W/VlYTO72zw0EEF4gHsB0gthCBX03bs4goBmXh0Vzf13PEKeVdmehyTXGBRvti+KYgfBQ7VLf7+7cmc09t13VZPvdOiPXo0/7h9fpQ7YCUWGICREV3j89d++h6GB8KB0r/7kCu4aJHRL6xr9Rms8EF+n1fRBmpa6pvSIDQAwh2if6P2uBkM4cghUgPm2UnESIeJ3FtwonF5PuX5lYS0RwKFjoB1czSVJ/V1dZkkKqdUV3oxgsn9ZJBFOYBeVxOC1//3IgVn3EVOPjO9na/K5wzTmzzXhZfYVkVohrB1LDficlhC26zrMbSPdL2F6Sou254L58h//Y9HlnAtFO7jGnE5ZooxJTVSgj0bAK8Yyl22MelFfwrp5JSlcXpdX6VYMXgJaJFr4D8UzC15vHc5ZR01HGTbJ5cw1Rx1t/8e/sE66aHk6VFG1l7+Y89FRu6wDEfpftiNdN4KDAwS03yhA==;5:jS66wZmoV/ccwcYDHs4E2DsGnXq2tuv28Y5LLy/gBoojsgSdcAhJ+7FHnxVv4lGQDMZZtWEQg2b2ty/TuyE+Pbfjxj+1B3LXTlz6M/BTQqApKsEGr3kwT9opdpAxGk+frc7HFme1o6p9TJqo5SUa17VmnT/DURfrzwKKwt98XYw=;7:9dG1S62RqUW28aU5FA5KK6/WENm7Cd3FrVgGwn8+2YmNW72fWxghvoaReDrbmuZjHUCJAQHxlI5edAKvNjGWXWmJb/3QYnDdv7rrrb090VaPZla/bdRHJaqAnYQ+JAyphI+qPOd7D46BWTCeEOqZ1Crwz1iTmb338ZP1RJOoZK//EwNYJ4HWt0AfBgx0CvgU4rCAr2kQXWQlyVY2VkrUE3ijC2IYI26zeQAfbl8zCDqYiUTK1uGjNqDqAk9ULFOg
x-ms-office365-filtering-correlation-id: e05c951c-17ab-4514-3592-08d62d2de1d9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:AM0PR06MB4355;
x-ms-traffictypediagnostic: AM0PR06MB4355:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-microsoft-antispam-prvs: <AM0PR06MB435525196AF6BB90C0F2DAFBD4E60@AM0PR06MB4355.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(166708455590820);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991055);SRVR:AM0PR06MB4355;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4355;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(346002)(376002)(136003)(39850400004)(396003)(366004)(189003)(199004)(8936002)(110136005)(65806001)(65956001)(386003)(305945005)(6506007)(66066001)(53546011)(72206003)(966005)(2906002)(5250100002)(186003)(99286004)(76176011)(8676002)(81156014)(81166006)(7736002)(53936002)(52116002)(478600001)(6436002)(6246003)(6486002)(6306002)(229853002)(14454004)(6512007)(105586002)(106356001)(71200400001)(71190400001)(97736004)(6116002)(5660300001)(65826007)(26005)(316002)(2900100001)(36756003)(68736007)(64126003)(11346002)(446003)(31696002)(476003)(256004)(66574009)(31686004)(14444005)(25786009)(102836004)(2616005)(58126008)(86362001)(3846002)(486006)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4355;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: hSQaxk3NvnIUGgHNkQKdLPmWBzhbcB8GOYthjMis/cYNYOYgAjNh3uvhTvrcTX7ELThWyARom912IjwkAqJAxwx0hOtl9z55D0Mc0nAVAMvs44ge6UIWhttgz7wXm7rvJmymhLJ93YonWjkv9CJXAt2NrHxBMBo/KLCM6RPX6toSXsrcUDj6umV1WAz5cDEYeytHDUC4YZr75RP/Q7Cqr8ZqZJxM0lGLgtW+ZAjTc1FHbpKJ/yA8alqHJD6cOPCxveRCN6qPD7rRC2AkeJaVlGuodO9K48KnBGMqQNZxOSfY25FAi6xHNmp3D4zYXNDTFAxu9O3Wm+BUID4jXYCwlQ==
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3F70600F89D7C479B6D211FDA9CD535@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e05c951c-17ab-4514-3592-08d62d2de1d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 14:54:01.1825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4355
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMDgvMjAxOCAwNDo0MCBQTSwgSGFucyB2YW4gS3JhbmVuYnVyZyB3cm90ZToNCj4gT24g
MTAvMDgvMjAxOCAwNDoyNyBQTSwgSG9sZ2VyIEhvZmZzdMOkdHRlIHdyb3RlOg0KPj4gKG1vdmlu
ZyB0aGUgZGlzY3Vzc2lvbiBoZXJlIGZyb20gR0ggWzFdKQ0KPj4NCj4+IEFwcGFyZW50bHkgdGhl
cmUgaXMgc29tZXRoaW5nIHdlaXJkIGdvaW5nIG9uIHdpdGggdGhlIGRldmljZSBzdGF0cw0KPj4g
aW9jdGxzLiBJIGNhbm5vdCBnZXQgdGhlbSB0byB3b3JrIGFzIHJlZ3VsYXIgdXNlciwgd2hpbGUg
dGhleSB3b3JrDQo+PiBmb3IgRGF2aWQuIEEgZnJpZW5kIGNvbmZpcm1zIHRoZSBzYW1lIGlzc3Vl
IG9uIGhpcyBzeXN0ZW0gLSBubyBhY2Nlc3MNCj4+IGFzIG5vbi1yb290Lg0KPj4NCj4+IFNvIEkg
bWFkZSBhIG5ldyBlbXB0eSBmcywgbW91bnRlZCBpdCwgYnVpbHQgYnRyZnMtcHJvZ3MtNC4xNy4x
IHdpdGgNCj4+IGRlYnVnIHN5bWJvbHMgYW5kIHN0ZXBwZWQgaW50byBzZWFyY2hfY2h1bmtfdHJl
ZV9mb3JfZnNfaW5mbygpLg0KPj4gRXZlcnl0aGluZyBpcyBmaW5lLCBhbGwgYXJncyBhcmUgY29y
cmVjdCwgcmlnaHQgdW50aWw6DQo+Pg0KPj4gKGdkYikgcw0KPj4gMTYxNMKgwqDCoCByZXQgPSBp
b2N0bChmZCwgQlRSRlNfSU9DX1RSRUVfU0VBUkNILCAmc2VhcmNoX2FyZ3MpOw0KPj4gKGdkYikg
cw0KPj4gMTYxNcKgwqDCoCBpZiAocmV0IDwgMCkNCj4+IChnZGIpIHAgcmV0DQo+PiAkNCA9IC0x
DQo+PiAoZ2RiKSBwIHNlYXJjaF9hcmdzDQo+PiAkNSA9IHtrZXkgPSB7dHJlZV9pZCA9IDMsIG1p
bl9vYmplY3RpZCA9IDEsIG1heF9vYmplY3RpZCA9IDEsIG1pbl9vZmZzZXQNCj4+ID0gMSwNCj4+
IG1heF9vZmZzZXQgPSAxODQ0Njc0NDA3MzcwOTU1MTYxNSwgbWluX3RyYW5zaWQgPSAwLCBtYXhf
dHJhbnNpZCA9DQo+PiAxODQ0Njc0NDA3MzcwOTU1MTYxNSwNCj4+IG1pbl90eXBlID0gMjE2LCBt
YXhfdHlwZSA9IDIxNiwgbnJfaXRlbXMgPSAzMCwgdW51c2VkID0gMCwgdW51c2VkMSA9IDAsDQo+
PiB1bnVzZWQyID0gMCwNCj4+IHVudXNlZDMgPSAwLCB1bnVzZWQ0ID0gMH0sIGJ1ZiA9ICdcMDAw
JyA8cmVwZWF0cyAzOTkxIHRpbWVzPn0NCj4+DQo+PiBMb29raW5nIGF0IHRoZSBrZXJuZWwgc2lk
ZSBvZiB0aGluZ3MgaW4gZnMvYnRyZnMvaW9jdGwuYyBJIHNlZSBib3RoDQo+PiBCVFJGU19JT0Nf
VFJFRV9TRUFSQ0hbX1YyfSB1bmNvbmRpdGlvbmFsbHkgcmVxdWlyZSBDQVBfU1lTX0FETUlOLg0K
PiANCj4gVGhhdCdzIHRoZSB0cmVlIHNlYXJjaCBpb2N0bCwgZm9yIHJlYWRpbmcgYXJiaXRyYXJ5
IG1ldGFkYXRhLg0KPiANCj4gVGhlIGRldmljZSBzdGF0cyBpb2N0bCBpcyBJT0NfR0VUX0RFVl9T
VEFUUy4uLg0KPiANCj4gSSBjYW4gZG8gdGhlIGRldmljZSBzdGF0cyBpb2N0bCBhcyBub3JtYWwg
dXNlcjoNCj4gDQo+IGltcG9ydCBidHJmcw0KPiBmcyA9IGJ0cmZzLkZpbGVTeXN0ZW0oJy8nKQ0K
PiBidHJmcy51dGlscy5wcmV0dHlfcHJpbnQoZnMuZGV2X3N0YXRzKDEpKQ0KPiANCj4gPGJ0cmZz
LmlvY3RsLkRldlN0YXRzPg0KPiBkZXZpZDogMQ0KPiBucl9pdGVtczogNQ0KPiBmbGFnczogMA0K
PiB3cml0ZV9lcnJzOiAwDQo+IHJlYWRfZXJyczogMA0KPiBmbHVzaF9lcnJzOiAwDQo+IGdlbmVy
YXRpb25fZXJyczogMA0KPiBjb3JydXB0aW9uX2VycnM6IDANCg0KQnkgdGhlIHdheSwgSSBjYW4g
YWxzbyBkbyBCVFJGU19JT0NfRlNfSU5GTywgQlRSRlNfSU9DX0RFVl9JTkZPIGFuZA0KQlRSRlNf
SU9DX1NQQUNFX0lORk8gYXMgbm9ybWFsIHVzZXIuDQoNCkhvd2V2ZXIsIHdoaWxlIGZzX2luZm8g
dGVsbHMgbWUgdGhhdCB0aGVyZSBhcmUgbnVtX2RldmljZXMgZGV2aWNlcywNCnRoZXJlJ3Mgbm8g
cGxhY2Ugd2hlcmUgeW91IGNhbiBhY3R1YWxseSBnZXQgd2hpY2ggZGV2aWRzIHRoZXNlIGFyZSwg
YW5kDQp5b3UgbmVlZCB0byBwcm92aWRlIHRoZW0gb25lIGJ5IG9uZSB0byBkZXZfaW5mbyBhbmQg
ZGV2X3N0YXRzLi4uIDoNCg0KYnRyZnMudXRpbHMucHJldHR5X3ByaW50KGZzLmZzX2luZm8oKSkN
Cg0KPGJ0cmZzLmlvY3RsLkZzSW5mbz4NCm1heF9pZDogMQ0KbnVtX2RldmljZXM6IDENCm5vZGVz
aXplOiA0MDk2DQpzZWN0b3JzaXplOiA0MDk2DQpjbG9uZV9hbGlnbm1lbnQ6IDQwOTYNCmZzaWQ6
IDkxMDc3Y2E1LTY1NTktNGE5MC05ZDAzLTkxMmQzYTMzNDEyZQ0KDQpidHJmcy51dGlscy5wcmV0
dHlfcHJpbnQoZnMuZGV2X2luZm8oMSkpDQo8YnRyZnMuaW9jdGwuRGV2SW5mbz4NCmRldmlkOiAx
DQpieXRlc191c2VkOiA2MDY5OTk2NzQ4OA0KdG90YWxfYnl0ZXM6IDEwNzM3NDE4MjQwMA0KcGF0
aDogL2Rldi94dmRhDQp1dWlkOiA3ZTk5OGJhYS1iNTMzLTQ0NzYtOTEzMi1kN2Q3NDhkMjgwNDQN
Cg0KDQpidHJmcy51dGlscy5wcmV0dHlfcHJpbnQoZnMuc3BhY2VfaW5mbygpKQ0KLQ0KICA8YnRy
ZnMuaW9jdGwuU3BhY2VJbmZvPg0KICBmbGFnczogRGF0YSwgc2luZ2xlDQogIHRvdGFsX2J5dGVz
OiA1NC4wMEdpQg0KICB1c2VkX2J5dGVzOiA1My4yN0dpQg0KLQ0KICA8YnRyZnMuaW9jdGwuU3Bh
Y2VJbmZvPg0KICBmbGFnczogU3lzdGVtLCBzaW5nbGUNCiAgdG90YWxfYnl0ZXM6IDMyLjAwTWlC
DQogIHVzZWRfYnl0ZXM6IDEyLjAwS2lCDQotDQogIDxidHJmcy5pb2N0bC5TcGFjZUluZm8+DQog
IGZsYWdzOiBNZXRhZGF0YSwgc2luZ2xlDQogIHRvdGFsX2J5dGVzOiAyLjUwR2lCDQogIHVzZWRf
Ynl0ZXM6IDEuMzBHaUINCi0NCiAgPGJ0cmZzLmlvY3RsLlNwYWNlSW5mbz4NCiAgZmxhZ3M6IEds
b2JhbFJlc2VydmUsIHNpbmdsZQ0KICB0b3RhbF9ieXRlczogMTgxLjAyTWlCDQogIHVzZWRfYnl0
ZXM6IDAuMDBCDQoNCg0KPiANCj4+IFNvIHdoeSBjYW4gRGF2ZSBnZXQgaGlzIGRldiBzdGF0cyBh
cyB1bnByaXZpbGVnZWQgdXNlcj8NCj4+IERvZXMgdGhpcyB3b3JrIGZvciBhbnlib2R5IGVsc2U/
IEFuZCB3aHk/IDopDQo+Pg0KPj4gY2hlZXJzDQo+PiBIb2xnZXINCj4+DQo+PiBbMV0NCj4+IGh0
dHBzOi8vZ2l0aHViLmNvbS9wcm9tZXRoZXVzL25vZGVfZXhwb3J0ZXIvaXNzdWVzLzExMDAjaXNz
dWVjb21tZW50LTQyNzgyMzE5MA0KPj4NCj4gDQo+IA0KDQoNCi0tIA0KSGFucyB2YW4gS3JhbmVu
YnVyZw0K
