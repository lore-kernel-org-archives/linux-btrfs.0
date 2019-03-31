Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AC7C4360F
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 23:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D8CC20870
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 23:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbfCaXHU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 19:07:20 -0400
Received: from mail-oln040092069105.outbound.protection.outlook.com ([40.92.69.105]:16495
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731335AbfCaXHU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 19:07:20 -0400
Received: from AM5EUR02FT018.eop-EUR02.prod.protection.outlook.com
 (10.152.8.53) by AM5EUR02HT156.eop-EUR02.prod.protection.outlook.com
 (10.152.9.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1750.20; Sun, 31 Mar
 2019 23:07:16 +0000
Received: from AM0PR03MB5745.eurprd03.prod.outlook.com (10.152.8.57) by
 AM5EUR02FT018.mail.protection.outlook.com (10.152.8.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.20 via Frontend Transport; Sun, 31 Mar 2019 23:07:16 +0000
Received: from AM0PR03MB5745.eurprd03.prod.outlook.com
 ([fe80::1c73:bc14:e50d:35d1]) by AM0PR03MB5745.eurprd03.prod.outlook.com
 ([fe80::1c73:bc14:e50d:35d1%4]) with mapi id 15.20.1750.014; Sun, 31 Mar 2019
 23:07:16 +0000
From:   Alberto Bursi <alberto.bursi@outlook.it>
To:     "J. Bruce Fields" <bfields@fieldses.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
CC:     Supercilious Dude <supercilious.dude@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
Thread-Topic: Is it possible that certain physical disk doesn't implement
 flush correctly?
Thread-Index: AQHU5vSOIf8Y3Zji40ahBYvjFy94yKYkIlqAgAAA0wCAAAE/AIAAATgAgAABjACAAAK+gIACLyaAgAAF9oA=
Date:   Sun, 31 Mar 2019 23:07:16 +0000
Message-ID: <AM0PR03MB57458DE4ECD60598920D9CC092540@AM0PR03MB5745.eurprd03.prod.outlook.com>
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
 <16edb2d0-ee41-908f-e0bf-5c27160ccff7@gmx.com>
 <CAGmvKk5wk9RFhBr20X850MjFDkudzrZvjWVJxGg4GkhtrDfKUw@mail.gmail.com>
 <948a62d3-aa3e-418e-00df-d73d4dbfb5a6@gmx.com>
 <CAGmvKk5wFJNLbiJdYGA5PVFUnAURfN4Uk=JiGUaCndcepa51NA@mail.gmail.com>
 <4f5586f7-aef1-4e2a-2aee-5d040c023c68@gmx.com>
 <20190331224553.GA17421@fieldses.org>
In-Reply-To: <20190331224553.GA17421@fieldses.org>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14)
 To AM0PR03MB5745.eurprd03.prod.outlook.com (2603:10a6:208:176::10)
x-incomingtopheadermarker: OriginalChecksum:B5A46AB74DC4F05476BEC9D6B6EB723DE0099C43168CFC73EED14FEE487CA99B;UpperCasedChecksum:A5DFC8E6EBE95DE0521CD8F59E00C7FAA5AF6B5905F6FB893D8AC960D6803E2D;SizeAsReceived:8160;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [yLQhkyiWB70ZQPZWCDOHBU6Rif8t4893]
x-microsoft-original-message-id: <d80d6364-c25c-5a99-96f0-5ba3fa5ed96d@outlook.it>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(20181119110)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031322404)(2017031323274)(2017031324274)(1601125500)(1603101475)(1701031045);SRVR:AM5EUR02HT156;
x-ms-traffictypediagnostic: AM5EUR02HT156:
x-microsoft-antispam-message-info: GpIWuE9LCRlwoh7At4h+FHdyfOOObZ/A6B4/Xgf8Zb81eBf14L2W4Y9eZxgjd3MI
Content-Type: text/plain; charset="utf-8"
Content-ID: <9301F670CBB38E4FB1BA31580D207959@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c17c9686-0359-421b-827e-08d6b62d9dcd
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2019 23:07:16.2592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5EUR02HT156
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

DQpPbiAwMS8wNC8xOSAwMDo0NSwgSi4gQnJ1Y2UgRmllbGRzIHdyb3RlOg0KPiBPbiBTYXQsIE1h
ciAzMCwgMjAxOSBhdCAwOToyNDozN1BNICswODAwLCBRdSBXZW5ydW8gd3JvdGU6DQo+Pg0KPj4g
T24gMjAxOS8zLzMwIOS4i+WNiDk6MTQsIFN1cGVyY2lsaW91cyBEdWRlIHdyb3RlOg0KPj4+IE9u
IFNhdCwgMzAgTWFyIDIwMTkgYXQgMTM6MDksIFF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214
LmNvbT4gd3JvdGU6DQo+Pj4+IElmIGNvbnRyb2xsZXIgaXMgZG9pbmcgc28sIGl0IG11c3QgaGF2
ZSBpdHMgb3duIHBvd2VyIG9yIGF0IGxlYXN0IGZpbmlzaA0KPj4+PiBmbHVzaCB3aGVuIGNvbnRy
b2xsZXIgd3JpdGVzIHRvIGl0cyBmYXN0IGNhY2hlLg0KPj4+Pg0KPj4+IFRoZSBjb250cm9sbGVy
IGhhcyBpdHMgb3duIGJhdHRlcnkgYmFja3VwIHRvIHBvd2VyIHRoZSBEUkFNIGNhY2hlLCBhcw0K
Pj4+IHdlbGwgYXMgZmxhc2ggc3RvcmFnZSB0byBkdW1wIGl0IG9udG8gaW4gdGhlIGV4Y2VlZGlu
Z2x5IHVubGlrZWx5DQo+Pj4gZXZlbnQgdGhhdCB0aGUgYmF0dGVyeSBnZXRzIGRlcGxldGVkLg0K
Pj4+DQo+Pj4+IEZvciBjYWNoZSBjYXNlLCBpZiB3ZSBoYXZlIGVub3VnaCBkYXRhLCB3ZSBjb3Vs
ZCBzdGlsbCBmaW5kIHNvbWUgY2x1ZSBvbg0KPj4+PiB0aGUgZmx1c2ggZXhlY3V0aW9uIHRpbWUu
DQo+Pj4+DQo+Pj4+IERlc3BpdGUgdGhhdCwgZm9yIHRoYXQgZW50ZXJwcmlzZSBsZXZlbCB1c2Fn
ZSwgaXQncyBPSy4NCj4+Pj4NCj4+Pj4gQnV0IGZvciBjb25zdW1lciBsZXZlbCBzdG9yYWdlLCBJ
J20gbm90IHN1cmUsIGVzcGVjaWFsbHkgZm9yIEhERHMsIGFuZA0KPj4+PiBtYXliZSBOVk1lIGRl
dmljZXMuDQo+Pj4+DQo+Pj4gSG93IGRvIHlvdSBkaXN0aW5ndWlzaCB3aG8gaXMgYSB3aG8/IEFt
IEkgYW4gZW50ZXJwcmlzZSBvciBhIGNvbnN1bWVyPw0KPj4gRWFzeSwgcHJpY2UuIDpQDQo+Pg0K
Pj4gVG8gYmUgaG9uZXN0LCBJIGRvbid0IHJlYWxseSBjYXJlIGFib3V0IHRoYXQgZmFuY3kgdXNl
IGNhc2UuDQo+PiBJdCdzIHRoZSB2ZW5kb3IgZG9pbmcgaXRzIHdvcmssIGFuZCBpZiBzb21ldGhp
bmcgd3JvbmcgaGFwcGVuZWQsDQo+PiBjdXN0b21lciB3aWxsIHllbGwgYXQgdGhlbS4NCj4+DQo+
PiBJJ20gbW9yZSBpbnRlcmVzdGluZyBpbiB0aGUgY29uc3VtZXIgbGV2ZWwgc2l0dWF0aW9uLg0K
PiBUaGUgZmVhdHVyZSBzZWVtcyB0byBiZSBhZHZlcnRpc2VkIGFzICJwb3dlciBsb3NzIHByb3Rl
Y3Rpb24iIG9yDQo+ICJlbmhhbmNlZCBwb3dlciBsb3NzIGRhdGEgcHJvdGVjdGlvbiIuICBXaGlj
aCBtYWtlcyBpdCBzb3VuZCBsaWtlIGEgZGF0YQ0KPiBzYWZldHkgZmVhdHVyZSB3aGVuIHJlYWxs
eSBpdCdzIGEgcGVyZm9ybWFuY2UgZmVhdHVyZS4gIEUuZy4gdGhlc2UgYXJlDQo+IHRoZSBJbnRl
bCBkcml2ZXMgd2l0aCAiRVBMRFAiOg0KPg0KPiAJaHR0cHM6Ly9hcmsuaW50ZWwuY29tL2NvbnRl
bnQvd3d3L3VzL2VuL2Fyay9zZWFyY2gvZmVhdHVyZWZpbHRlci5odG1sP3Byb2R1Y3RUeXBlPTM1
MTI1JjBfRVBMRFA9VHJ1ZQ0KPg0KPiBMYXN0IEkgY2hlY2tlZCB0aGVyZSB3ZXJlIHNvbWUgdGhh
dCB3ZXJlbid0IHRvbyBleHBlbnNpdmUuDQo+DQo+IC0tYi4NCg0KDQpBZmFpayBxdWl0ZSBhIGZl
dyBjb25zdW1lciBDcnVjaWFsIFNTRHMgZG8gaGF2ZSBwb3dlciBsb3NzIHByb3RlY3Rpb24gDQoo
dGhvc2UgdGhhdCBhZHZlcnRpc2UgaXQgZWl0aGVyIGhhdmUgYSBsYXJnZQ0KDQpiYW5rIG9mIGNh
cGFjaXRvcnMgb24gdGhlaXIgUENCIG9yIHVzZSBuZXdlciBmbGFzaCB0aGF0IGZvciBzb21lIHJl
YXNvbiANCmNhbiBkbyB3aXRob3V0IHRoYXQpDQoNCi1BbGJlcnRvDQoNCg==
