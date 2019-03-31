Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E7AC4360F
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 11:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D504E20870
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 11:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfCaL1Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 07:27:24 -0400
Received: from mail-oln040092065108.outbound.protection.outlook.com ([40.92.65.108]:31876
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726873AbfCaL1X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 07:27:23 -0400
Received: from VE1EUR01FT059.eop-EUR01.prod.protection.outlook.com
 (10.152.2.52) by VE1EUR01HT050.eop-EUR01.prod.protection.outlook.com
 (10.152.3.140) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1750.16; Sun, 31 Mar
 2019 11:27:19 +0000
Received: from AM0PR03MB5745.eurprd03.prod.outlook.com (10.152.2.53) by
 VE1EUR01FT059.mail.protection.outlook.com (10.152.3.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.16 via Frontend Transport; Sun, 31 Mar 2019 11:27:19 +0000
Received: from AM0PR03MB5745.eurprd03.prod.outlook.com
 ([fe80::1c73:bc14:e50d:35d1]) by AM0PR03MB5745.eurprd03.prod.outlook.com
 ([fe80::1c73:bc14:e50d:35d1%4]) with mapi id 15.20.1750.014; Sun, 31 Mar 2019
 11:27:19 +0000
From:   Alberto Bursi <alberto.bursi@outlook.it>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
Thread-Topic: Is it possible that certain physical disk doesn't implement
 flush correctly?
Thread-Index: AQHU5vSOIf8Y3Zji40ahBYvjFy94yKYlm3uA
Date:   Sun, 31 Mar 2019 11:27:19 +0000
Message-ID: <AM0PR03MB5745ACEC53F69BC28AC480F592540@AM0PR03MB5745.eurprd03.prod.outlook.com>
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
In-Reply-To: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0006.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::18)
 To AM0PR03MB5745.eurprd03.prod.outlook.com (2603:10a6:208:176::10)
x-incomingtopheadermarker: OriginalChecksum:9016FA4FF31A8488B0DD308BDC7DF16FF9706F1D51ECEA855C32BF25D10FDD25;UpperCasedChecksum:980921BD897A50AFB192B81F5CDEE7F9C9C893FCCCB37E4F70ACD1216DB54B04;SizeAsReceived:7620;Count:49
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [xjxld9DUFhSAGZnyb47Y0ITT5hZZdGml]
x-microsoft-original-message-id: <8d3c3a30-0854-ca94-8fc4-0e835cfdd1c7@outlook.it>
x-ms-publictraffictype: Email
x-incomingheadercount: 49
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(20181119110)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031322404)(2017031324274)(2017031323274)(1601125500)(1603101475)(1701031045);SRVR:VE1EUR01HT050;
x-ms-traffictypediagnostic: VE1EUR01HT050:
x-microsoft-antispam-message-info: j2aq/0rYxDfqvlCeEXrli12oxK82quBo7AFWszfv82r3qKxB1tKTzGY0zOOhqL6N
Content-Type: text/plain; charset="utf-8"
Content-ID: <D22C06D166AC944C83AC21480DEAED11@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a7122734-3e44-41ed-e4fc-08d6b5cbd5c5
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2019 11:27:19.6263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR01HT050
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

DQpPbiAzMC8wMy8xOSAxMzozMSwgUXUgV2VucnVvIHdyb3RlOg0KPiBIaSwNCj4NCj4gSSdtIHdv
bmRlcmluZyBpZiBpdCdzIHBvc3NpYmxlIHRoYXQgY2VydGFpbiBwaHlzaWNhbCBkZXZpY2UgZG9l
c24ndA0KPiBoYW5kbGUgZmx1c2ggY29ycmVjdGx5Lg0KPg0KPiBFLmcuIHNvbWUgdmVuZG9yIGRv
ZXMgc29tZSBjb21wbGV4IGxvZ2ljYWwgaW4gdGhlaXIgaGRkIGNvbnRyb2xsZXIgdG8NCj4gc2tp
cCBjZXJ0YWluIGZsdXNoIHJlcXVlc3QgKGJ1dCBub3QgYWxsLCBvYnZpb3VzbHkpIHRvIGltcHJv
dmUgcGVyZm9ybWFuY2U/DQo+DQo+IERvIGFueW9uZSBzZWUgc3VjaCByZXBvcnRzPw0KPg0KPiBB
bmQgaWYgcHJvdmVzIHRvIGhhcHBlbmVkIGJlZm9yZSwgaG93IGRvIHdlIHVzZXJzIGRldGVjdCBz
dWNoIHByb2JsZW0/DQo+DQo+IENhbiB3ZSBqdXN0IGNoZWNrIHRoZSBmbHVzaCB0aW1lIGFnYWlu
c3QgdGhlIHdyaXRlIGJlZm9yZSBmbHVzaCBjYWxsPw0KPiBFLmcuIHdyaXRlIFggcmFuZG9tIGJs
b2NrcyBpbnRvIHRoYXQgZGV2aWNlLCBjYWxsIGZzeW5jKCkgb24gaXQsIGNoZWNrDQo+IHRoZSBl
eGVjdXRpb24gdGltZS4gUmVwZWF0IFkgdGltZXMsIGFuZCBjb21wYXJlIHRoZSBhdmcvc3RkLg0K
PiBBbmQgY2hhbmdlIFggdG8gMlgvNFgvLi4uLCByZXBlYXQgYWJvdmUgY2hlY2suDQo+DQo+IFRo
YW5rcywNCj4gUXUNCj4NCj4NCg0KQWZhaWsgSEREcyBhbmQgU1NEcyBkbyBsaWUgdG8gZnN5bmMo
KQ0KDQp1bmxlc3MgdGhlIHdyaXRlIGNhY2hlIGlzIHR1cm5lZCBvZmYgd2l0aCBoZHBhcm0sDQoN
CmhkcGFybSAtVzAgL2Rldi9zZGENCg0Kc2ltaWxhcmx5IHRvIFJBSUQgY29udHJvbGxlcnMuDQoN
CnNlZSBiZWxvdw0KDQpodHRwczovL2JyYWQubGl2ZWpvdXJuYWwuY29tLzIxMTY3MTUuaHRtbA0K
DQpodHRwczovL3F1ZXVlLmFjbS5vcmcvZGV0YWlsLmNmbT9pZD0yMzY3Mzc4DQoNCg0KLQ0KDQo=
