Return-Path: <SRS0=ihwP=S6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCAFC43219
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 16:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 889D620693
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Apr 2019 16:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfD1QSI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Apr 2019 12:18:08 -0400
Received: from mail-oln040092070062.outbound.protection.outlook.com ([40.92.70.62]:9602
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726818AbfD1QSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Apr 2019 12:18:07 -0400
Received: from VE1EUR03FT062.eop-EUR03.prod.protection.outlook.com
 (10.152.18.54) by VE1EUR03HT159.eop-EUR03.prod.protection.outlook.com
 (10.152.19.169) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1835.13; Sun, 28 Apr
 2019 16:18:04 +0000
Received: from AM0PR03MB4131.eurprd03.prod.outlook.com (10.152.18.53) by
 VE1EUR03FT062.mail.protection.outlook.com (10.152.18.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1835.13 via Frontend Transport; Sun, 28 Apr 2019 16:18:04 +0000
Received: from AM0PR03MB4131.eurprd03.prod.outlook.com
 ([fe80::6528:d04:d553:6431]) by AM0PR03MB4131.eurprd03.prod.outlook.com
 ([fe80::6528:d04:d553:6431%4]) with mapi id 15.20.1835.015; Sun, 28 Apr 2019
 16:18:04 +0000
From:   Alberto Bursi <alberto.bursi@outlook.it>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: recommended way to allow mounting of degraded array at boot
Thread-Topic: recommended way to allow mounting of degraded array at boot
Thread-Index: AQHU/d31Onzwd1rCNUeCv+KQtRmTYg==
Date:   Sun, 28 Apr 2019 16:18:04 +0000
Message-ID: <AM0PR03MB413128509989947DE4AA7DEF92380@AM0PR03MB4131.eurprd03.prod.outlook.com>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MRXP264CA0046.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::34) To AM0PR03MB4131.eurprd03.prod.outlook.com
 (2603:10a6:208:74::28)
x-incomingtopheadermarker: OriginalChecksum:12AE36CF4D70BEF1F8C15A7E92F9FFBE798B0445EAF1DAC81374D39012D0AAD0;UpperCasedChecksum:5D40E805C7141BBE017E40D5823419229A1CC0E273F9DFFF76A0556F54FEFDC2;SizeAsReceived:7269;Count:46
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [WHsEmlS2PbmqlnPNb+bj2GBEJG1F4GQo]
x-microsoft-original-message-id: <5d96ffb9-594f-1134-2080-2c8697e50535@outlook.it>
x-ms-publictraffictype: Email
x-incomingheadercount: 46
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(5050001)(7020095)(20181119110)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031323274)(2017031324274)(2017031322404)(1601125500)(1603101475)(1701031045);SRVR:VE1EUR03HT159;
x-ms-traffictypediagnostic: VE1EUR03HT159:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-message-info: w3QX6z24wDQW8K4sZtrmKexNve6F9Sl2voIVN2AW/AspNwsBDmRBcKcWMIwqp/gaUwvsNhM/BddfToc9gtpLZyM1kLnO4arwTga+AampDoKeLP4AITqVxlcVnZ1mjM+eHtBfgI1kgllugKi2HyccKmV473bk3fXb+Dv1u+Sutl+C5ahtefNzRYTaNXNaEZzg
Content-Type: text/plain; charset="utf-8"
Content-ID: <3291794EE33EB84A8FF29B25A9868958@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e7e57f-e276-4b23-7b62-08d6cbf51773
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2019 16:18:04.8049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR03HT159
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SSBhbSBsb29raW5nIGZvciBhIHdheSB0byBtaW1pYyBtZGFkbSdzIGJlaGF2aW91ciBhbmQgaGF2
ZSBidHJmcyBtb3VudA0KYSBkZWdyYWRlZCBhcnJheSBvbiBib290IGFzIGxvbmcgYXMgaXQncyBu
b3QgYnJva2VuIChzcGVjaWZpYyB1c2UgY2FzZTogDQpSQUlEMSB3aXRoIGEgc2luZ2xlIGRpc2sg
bWlzc2luZy9kZWFkKQ0KDQpTbyBmYXIgdGhlIG9ubHkgdGhpbmcgSSBjb3VsZCB0aGluayBvZiAo
YW5kIEkndmUgc2VlbiBzdWdnZXN0ZWQgDQplbHNld2hlcmUpIGlzIHRvIGFkZCB0aGUgImRlZ3Jh
ZGVkIiBtb3VudCBvcHRpb24NCmluIGtlcm5lbCBjb21tYW5kIGxpbmUgYW5kIGluIC9ldGMvZnN0
YWIuDQoNCkJ1dCBvbiB0aGUgd2lraSBJIHJlYWQgdGhhdCB0aGlzIGlzIGEgYmFkIGlkZWEgYmVj
YXVzZSBvZiB3aGF0IHRoZXkgY2FsbCANCiJJbmNvbXBsZXRlIGNodW5rIGNvbnZlcnNpb24iIGlz
c3VlIFsxXQ0KDQp0aGF0IHNheXMgSSBjYW4gb25seSBtb3VudCBpdCBkZWdyYWRlZCAod2hlbiBp
dCBpcyBhY3R1YWxseSBtaXNzaW5nIGEgDQpkaXNrKSBydyBPTkUgVElNRSBhbmQgdGhlbiB0aGUg
ZmlsZXN5c3RlbSB3b3VsZCBnbyByby4NCg0KSXMgdGhhdCBzdGlsbCBhIHRoaW5nPyBBcmUgdGhl
cmUgb3RoZXIgd2F5cyBvZiBkb2luZyB3aGF0IEkgd2FudD8NCg0KDQotQWxiZXJ0bw0KDQoNCjEu
IA0KaHR0cHM6Ly9idHJmcy53aWtpLmtlcm5lbC5vcmcvaW5kZXgucGhwL0dvdGNoYXMjcmFpZDFf
dm9sdW1lc19vbmx5X21vdW50YWJsZV9vbmNlX1JXX2lmX2RlZ3JhZGVkDQoNCg==
