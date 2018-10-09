Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB083C65BD1
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 20:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B91F214C4
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 20:21:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="Ph1RoXJM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B91F214C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbeJJDkg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 23:40:36 -0400
Received: from mail-eopbgr10062.outbound.protection.outlook.com ([40.107.1.62]:6496
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727486AbeJJDkg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 23:40:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxvDFJP9aHgWqNOYLPUnai7P2mzv+SiMy7Vvv4u3+Yw=;
 b=Ph1RoXJMLMEqmJ4PNrY4tn2l1AsJqDEcqNTJZdT64U1d4gceVGBub/gjc8/DN742EcPk38Hg51hSj9GriTxVN8iO+cX1/zKDAYtokEiNXonNhtap6IZKEwtFdrRzbA4KXDZqtZQSpzarcG/7Py/Km9+/b+C5RUWG5T/w2q+QIfs=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4369.eurprd06.prod.outlook.com (52.135.150.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.27; Tue, 9 Oct 2018 20:21:48 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1207.024; Tue, 9 Oct 2018
 20:21:48 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] btrfs-progs: lowmem check: Add dev_item check for
 used bytes and total bytes
Thread-Topic: [PATCH v3 4/6] btrfs-progs: lowmem check: Add dev_item check for
 used bytes and total bytes
Thread-Index: AQHUXwLGruo5PAspCE6ya/8CkSvwHqUWDdiAgAAO5YCAAUCigA==
Date:   Tue, 9 Oct 2018 20:21:48 +0000
Message-ID: <ea2ee2d3-e6ec-3804-954c-888a85ebed7a@mendix.com>
References: <20181008123044.13413-1-wqu@suse.com>
 <20181008123044.13413-5-wqu@suse.com>
 <cd511cfa-baa2-6a13-2802-6eac1f47d8bb@mendix.com>
 <116d578f-8c21-366c-8eb8-84f2ca23c486@gmx.com>
In-Reply-To: <116d578f-8c21-366c-8eb8-84f2ca23c486@gmx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: HE1PR0202CA0011.eurprd02.prod.outlook.com
 (2603:10a6:3:8c::21) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4369;6:Y1fiB2SFzkh5dsdriSnQM+OLJy+RYKQIkeWmO/tORGewlslqsnjTIDG/+BalOkkhirLataZtaI9Ya8S6k0DTG16YrZg9NKnxsep3UhaiuzziA7nZtrD2y0G4ib/ALS/6W1+NMeF4Ts0NuZR8dya1lMqU0nz3V8C+pJ/glgC2Wpo7qa3SLJGn6V0XHyX7Jb1+4H9uUiWJ3A6AnPzUvOrS2nGm02ETtgkamS9a+UGdXwHDmXOoWWvCfl4NtE9SsTXAXqhKfEfXUUpsk8rE/GPOAwnXj25u+G6a5KFYzxFnO1ygpKvSl75OuMRcapNW5momkfizmKAJ3JcppQEyQrQvnKLeqLZXlaqAMgOp470RJ9BvcPwB5cDWXKF6Vz8/2UYlVOxX9tfB7hw45OSHN9N0arlbh7hs+cXXThGiuztkjnvw8FhghCuHvlF5/1DoclPWT7JuM097hH1+UJYNZftDEQ==;5:uCODpwhVKAe6PcZfcJWbILKBcfs0Yk/y9FA3YtVWHrKYFbrohkixYXAyUVbaDLdkN1xgSP9OhA6jDDuWIoA1MAbDa+jyFENqlfFI46ZmZe4jklvi37ZXseWZKKCNacH1LQWLzb9jEvXkuo1cx+bRxvLTCm+g8pID9htll0j+neA=;7:MMxdXGXfUy4WCnEndTE0D0n9k4PRFx8S696KU/Gt1TLDxyL4pyg6cXI6BmYHumyfURIHpA7vQByITPJwE0uO0nVPyG+znrf7fYobIFRCyXz2uBN5OJrhQv1+QFTkBcRnj7Xd7IDL8YsMu/jMT6vQOQhlS2ocPLtlfSNIP/kUgfr206n2oUOguaExQXOoJL4EYCdTjzEoA5W0FEGORsU/XZMUV2yoaAEGXNq8gIKc6EWLSKBk2LuJNZZG0EGU38Pc
x-ms-office365-filtering-correlation-id: 799961ac-20fc-49a1-71f0-08d62e24d70f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:AM0PR06MB4369;
x-ms-traffictypediagnostic: AM0PR06MB4369:
x-microsoft-antispam-prvs: <AM0PR06MB4369E51A6011E0EEFB6F9D03D4E70@AM0PR06MB4369.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123560045)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051);SRVR:AM0PR06MB4369;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4369;
x-forefront-prvs: 08200063E9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(396003)(39850400004)(136003)(346002)(189003)(199004)(6246003)(31696002)(229853002)(68736007)(71200400001)(72206003)(2501003)(25786009)(386003)(6512007)(14454004)(6436002)(71190400001)(53936002)(53546011)(6506007)(478600001)(2906002)(6486002)(6116002)(5250100002)(93886005)(36756003)(476003)(97736004)(305945005)(102836004)(316002)(446003)(256004)(486006)(8936002)(106356001)(2616005)(2900100001)(81166006)(5660300001)(65806001)(186003)(65826007)(105586002)(65956001)(81156014)(99286004)(86362001)(76176011)(64126003)(31686004)(58126008)(52116002)(8676002)(11346002)(110136005)(46003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4369;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: vkvDe9QLYmpMRD9G9OhVfKvnCpb3TMTGfFrt7YWGnZuu6MSzijBrDAa3G5Wtp5iyOAufa7ADDjBfOPStkXdighSxiaJABDQ60wQutcQBq1YftzMxl+sf+OLM/PBF1xJcH5xM51M9DWllW01SVNSq5aQ6f/poxXki9Kmw2bfEYuK/2x0xZYufkmUQjmyVfhn6FAByBE3R37u/M1z97v74bneyXsEs46eKW0FLy1EULMlz3ga6JFILjAZe/Q6yLYvtP8F8KE5qlzx6IgjnpWPH6Vj/Ql+yuhYcBh+pdEr5S7ZNmsq6lU5kFuMeUIMBDgzwpyBxHxOwrl/4sIOhtGKItmnj4yKiWfEKrf+0bhogaP8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F74362C00978B40B1B3A214F3176239@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 799961ac-20fc-49a1-71f0-08d62e24d70f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2018 20:21:48.5330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4369
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMDkvMjAxOCAwMzoxNCBBTSwgUXUgV2VucnVvIHdyb3RlOg0KPiANCj4gDQo+IE9uIDIw
MTgvMTAvOSDkuIrljYg2OjIwLCBIYW5zIHZhbiBLcmFuZW5idXJnIHdyb3RlOg0KPj4gT24gMTAv
MDgvMjAxOCAwMjozMCBQTSwgUXUgV2VucnVvIHdyb3RlOg0KPj4+IE9idmlvdXNseSwgdXNlZCBi
eXRlcyBjYW4ndCBiZSBsYXJnZXIgdGhhbiB0b3RhbCBieXRlcy4NCj4+Pg0KPj4+IFNpZ25lZC1v
ZmYtYnk6IFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPg0KPj4+IC0tLQ0KPj4+ICBjaGVjay9tb2Rl
LWxvd21lbS5jIHwgNSArKysrKw0KPj4+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCsp
DQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvY2hlY2svbW9kZS1sb3dtZW0uYyBiL2NoZWNrL21vZGUt
bG93bWVtLmMNCj4+PiBpbmRleCAwN2MwM2NhZDc3YWYuLjExNzNiOTYzYjhmMyAxMDA2NDQNCj4+
PiAtLS0gYS9jaGVjay9tb2RlLWxvd21lbS5jDQo+Pj4gKysrIGIvY2hlY2svbW9kZS1sb3dtZW0u
Yw0KPj4+IEBAIC00MDc0LDYgKzQwNzQsMTEgQEAgc3RhdGljIGludCBjaGVja19kZXZfaXRlbShz
dHJ1Y3QgYnRyZnNfZnNfaW5mbyAqZnNfaW5mbywNCj4+PiAgCXVzZWQgPSBidHJmc19kZXZpY2Vf
Ynl0ZXNfdXNlZChlYiwgZGV2X2l0ZW0pOw0KPj4+ICAJdG90YWxfYnl0ZXMgPSBidHJmc19kZXZp
Y2VfdG90YWxfYnl0ZXMoZWIsIGRldl9pdGVtKTsNCj4+PiAgDQo+Pj4gKwlpZiAodXNlZCA+IHRv
dGFsX2J5dGVzKSB7DQo+Pj4gKwkJZXJyb3IoImRldmljZSAlbGx1IGhhcyBpbmNvcnJlY3QgdXNl
ZCBieXRlcyAlbGx1ID4gdG90YWwgYnl0ZXMgJWxsdSIsDQo+Pj4gKwkJCWRldl9pZCwgdXNlZCwg
dG90YWxfYnl0ZXMpOw0KPj4+ICsJCXJldHVybiBBQ0NPVU5USU5HX01JU01BVENIOw0KPj4NCj4+
IFRoZSBtZXNzYWdlIGFuZCByZXR1cm4gY29kZSBwb2ludCBhdCBhbiBlcnJvciBpbiBhY2NvdW50
aW5nIGxvZ2ljLg0KPiANCj4gT25lIG9mIHRoZSBiaWdnZXN0IHByb2JsZW0gaW4gbG93bWVtIGlz
IHdlIGRvbid0IGFsd2F5cyBoYXZlIHRoZSBlcnJvcg0KPiBjb2RlIHdlIHJlYWxseSB3YW50Lg0K
PiANCj4gQW5kIHRoYXQncyB0aGUgY2FzZSBmb3IgdGhpcyBlcnJvciBtZXNzYWdlLg0KPiBJdCdz
IGluZGVlZCBub3QgYW4gYWNjb3VudGluZyBlcnJvciwgYXMgaW4gdGhhdCBjYXNlIChqdXN0IGxp
a2UgdGhhdA0KPiB0ZXN0IGNhc2UgaW1hZ2UpIHRoZSB1c2VkIGJ5dGVzIGlzIGNvcnJlY3QgYWNj
b3VudGVkLg0KPiANCj4gVGhlIGdvb2QgbmV3cyBpcywgdGhlIHJldHVybiB2YWx1ZSBpcyBuZXZl
ciByZWFsbHkgdXNlZCB0byBjbGFzc2lmeSB0aGUNCj4gZXJyb3IuDQo+IFNvIGFzIGxvbmcgYXMg
dGhlIGVycm9yIG1lc3NhZ2UgbWFrZXMgc2Vuc2UsIGl0J3Mgbm90IGEgYmlnIHByb2JsZW0uDQoN
CkFoYS4gQ2xlYXIsIHRoYW5rcyBmb3IgZXhwbGFpbmluZy4NCg0KPiANCj4gVGhhbmtzLA0KPiBR
dQ0KPiANCj4+DQo+PiBIb3dldmVyLCBpZiB5b3UgaGF2ZSBhIGZ1bGx5IGFsbG9jYXRlZCBkZXZp
Y2UgYW5kIGEgRFVQIGNodW5rIGVuZGluZw0KPj4gYmV5b25kIGRldmljZSwgdGhlbiBoYXZpbmcg
dXNlZCA+IHRvdGFsX2J5dGVzIGlzIGV4cGVjdGVkLi4uDQo+Pg0KPj4gU28gbWF5YmUgdGhlcmUn
cyB0d28gcG9zc2liaWxpdGllcy4uLiBUaGVyZSdzIGFuIGVycm9yIGluIHRoZSBhY2NvdW50aW5n
DQo+PiBsb2dpYywgb3IgdGhlcmUncyBhbiAib3Zlci1hbGxvY2F0aW9uIiwgd2hpY2ggaXMgYW5v
dGhlciB0eXBlIG9mIGlzc3VlDQo+PiB3aGljaCBwcm9kdWNlcyB1c2VkID4gdG90YWwgd2l0aCBj
b3JyZWN0IGFjY291bnRpbmcgbG9naWMuDQo+Pg0KPj4+ICsJfQ0KPj4+ICAJa2V5Lm9iamVjdGlk
ID0gZGV2X2lkOw0KPj4+ICAJa2V5LnR5cGUgPSBCVFJGU19ERVZfRVhURU5UX0tFWTsNCj4+PiAg
CWtleS5vZmZzZXQgPSAwOw0KPj4+DQo+Pg0KPj4NCj4gDQoNCg0KLS0gDQpIYW5zIHZhbiBLcmFu
ZW5idXJnDQo=
