Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72C9C10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90D9321473
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:31:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=janustech.onmicrosoft.com header.i=@janustech.onmicrosoft.com header.b="Tbzzi/Ol"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfDHNbA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 09:31:00 -0400
Received: from mail-eopbgr680119.outbound.protection.outlook.com ([40.107.68.119]:23641
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726523AbfDHNbA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 09:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=janustech.onmicrosoft.com; s=selector1-janustech-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQRk6K8xVOqmSg68Vao7dN+95T1qbUP2lT7H0e1aVC0=;
 b=Tbzzi/OlDT4et8zvt/LLToIDW6Tt1BCCvFOMrmUU6fmrrF0ocgK2lXFfSFZ+rtxS62bb+CseAdGGIGZLfjYwMtTKRsKwhFM5kaIC15XGrR1mMb6MJkztI9w3bWm30Uj7rOQrcpV4dVfJSi1YdY6JvLWfgv75zATcsyf/KDRsFks=
Received: from SN2PR07MB2621.namprd07.prod.outlook.com (10.167.15.27) by
 SN2PR07MB2526.namprd07.prod.outlook.com (10.167.14.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.21; Mon, 8 Apr 2019 13:30:58 +0000
Received: from SN2PR07MB2621.namprd07.prod.outlook.com
 ([fe80::2411:74b1:bdd8:e03]) by SN2PR07MB2621.namprd07.prod.outlook.com
 ([fe80::2411:74b1:bdd8:e03%8]) with mapi id 15.20.1771.016; Mon, 8 Apr 2019
 13:30:57 +0000
From:   Leonid Bloch <lbloch@janustech.com>
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
Subject: Re: Cryptographically verifying a btrfs subvolume
Thread-Topic: Cryptographically verifying a btrfs subvolume
Thread-Index: AQHU7f4a8n5pp9onp0KRcnoRBIEvSaYyNYGAgAANFQA=
Date:   Mon, 8 Apr 2019 13:30:57 +0000
Message-ID: <15a6861e-3752-3c51-5c4f-59bebf19a235@janustech.com>
References: <adac7db8-aed6-9573-ec09-4acd5059801e@janustech.com>
 <25abc057-4ff8-5a73-ee4b-0afda4fab16d@gmail.com>
In-Reply-To: <25abc057-4ff8-5a73-ee4b-0afda4fab16d@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR08CA0008.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::20) To SN2PR07MB2621.namprd07.prod.outlook.com
 (2603:10b6:804:7::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lbloch@janustech.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [141.226.29.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee675f4c-85c3-4283-2212-08d6bc266ee7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN2PR07MB2526;
x-ms-traffictypediagnostic: SN2PR07MB2526:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN2PR07MB252666A0304C2E2ED96993ABCA2C0@SN2PR07MB2526.namprd07.prod.outlook.com>
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(376002)(396003)(39830400003)(199004)(189003)(508600001)(25786009)(110136005)(105586002)(316002)(14454004)(81166006)(31686004)(81156014)(8676002)(106356001)(97736004)(66574012)(36756003)(8936002)(15650500001)(99286004)(3846002)(6116002)(6436002)(71190400001)(71200400001)(52116002)(6486002)(256004)(6246003)(66066001)(14444005)(4326008)(2616005)(305945005)(7736002)(2906002)(102836004)(53546011)(53936002)(6506007)(386003)(6306002)(186003)(86362001)(2501003)(229853002)(76176011)(26005)(31696002)(486006)(11346002)(446003)(476003)(6512007)(68736007)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN2PR07MB2526;H:SN2PR07MB2621.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: janustech.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LPxGqcND29dXW3aUHqLYKyDnoaBm9hpA2F4RHU5sIU849pYsK2A9zSjrPY7mWh9X4iWBza5TQ6BewldKOV8/XeWBUxq798P70s8aJ3b9UMEgnpHdL+irf8RokvgLb3JlXPLaPmuSsI9Ozo7Nibc0knrlpT59/55dil5MkeahZawoqJaY1yiWaDSUwq4ctSZqESo4OqJZCF0Usv33eeiyXTQmlC6QSIKeiEvtr/gMvorCBbfuhiBDXjGY4xgBz8zQQA6AAbsHM9GYx2M27hfN4LQLjJezC7sjbza+bHcHpPZ8sPwEIx9z632iBlbdu9dlqsJLNc3wy+b5bXkG8yQ+x0P1XN+XLRwbHV7z7D4nr0jOdaVHt4vpIU+UF9wghhq/tzy6nrCcRv2nOKljdhuUA87eSJ/8aI46keeQBRP+uaQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <708602090DB507419966BE891862A113@namprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: janustech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee675f4c-85c3-4283-2212-08d6bc266ee7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2019 13:30:57.8036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 34eb020e-3cf3-43a1-afeb-f5cf1310628e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2526
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gNC84LzE5IDM6NDQgUE0sIEF1c3RpbiBTLiBIZW1tZWxnYXJuIHdyb3RlOg0KPiBPbiAyMDE5
LTA0LTA4IDA3OjI3LCBMZW9uaWQgQmxvY2ggd3JvdGU6DQo+PiBIaSBMaXN0LA0KPj4NCj4+IENh
biB5b3Ugc3VnZ2VzdCBhIHdheSBvZiBjcnlwdG9ncmFwaGljYWxseSB2ZXJpZnlpbmcgdGhlIGNv
bnRlbnQgb2YgYQ0KPj4gYnRyZnMgc3Vidm9sdW1lLCBiZXNpZGVzIHRoZSBuYcOvdmUgYXBwcm9h
Y2gsIG9mIHJ1bm5pbmcgYSBjcnlwdG9ncmFwaGljDQo+PiBoYXNoIGZ1bmN0aW9uIG9uIHRoZSBv
dXRwdXQgb2YgYnRyZnMgc2VuZD8NCj4gUnVubmluZyBCVFJGUyBvbiB0b3Agb2YgZG0taW50ZWdy
aXR5IGFuZCBkbS1jcnlwdCB3aXRoIHRoZW0gc2V0IHVwIHRvIA0KPiBwcm92aWRlIEFFQUQtc3R5
bGUgZW5jcnlwdGlvbiBjb21lcyB0byBtaW5kIGFzIGFuIG9wdGlvbiwgYW5kIHdvdWxkIA0KPiBh
Y3R1YWxseSBwcm92aWRlIGEgbXVjaCBoaWdoZXIgbGV2ZWwgb2YgdmVyaWZpY2F0aW9uIHRoYW4g
anVzdCB2ZXJpZnlpbmcgDQo+IHRoZSBjb250ZW50IG9mIGEgc3Vidm9sdW1lIChpdCB3aWxsIHZl
cmlmeSB0aGUgZW50aXJlIGZpbGVzeXN0ZW0pLg0KDQpUaGFua3MhIFRoYXQncyBhY3R1YWxseSBh
IGdvb2QgcG9pbnQsIEkgd291bGQgbGlrZSB0byB2ZXJpZnkgYSBzcGVjaWZpYyANCnN1YnZvbHVt
ZShzKSwgd2hpbGUgb24gb3RoZXJzIHRoZSBjb250ZW50IGNhbiBjaGFuZ2UuDQoNClRoYXQncyBh
IGdvb2QgcG9pbnQgY2F1c2UgaXQgc2hvd3MgdGhhdCBJIHdhcyB3cm9uZyBhc3N1bWluZyB0aGF0
IGJ0cmZzIA0Kc2NydWIgd291bGQgaGVscCAtIGl0IHdpbGwgc2NydWIgdGhlIGVudGlyZSBmaWxl
c3lzdGVtIGFzIHdlbGwsIGFuZCANCmNvbXBhcmUgY2hlY2tzdW1zIGludGVybmFsbHksIHdoaWNo
IGlzIG5vdCB3aGF0IEkgd2FudCAtIEkgd2FudCB0byANCmNvbXBhcmUgdG8gc29tZSBleHRlcm5h
bCBjaGVja3N1bS4gU29ycnkgZm9yIHRoZSBjb25mdXNpb24gdGhlcmUuDQoNCj4+DQo+PiBCYWNr
IGluIDIwMTQsIGFuIFJGQyBwYXRjaCB3YXMgc2VudCB0byBhbGxvdyB1c2luZyBzaGEyNTYgaW5z
dGVhZCBvZg0KPj4gY3JjMzJjIGZvciBjaGVja3N1bW1pbmcuDQo+PiAoaHR0cHM6Ly9wYXRjaHdv
cmsua2VybmVsLm9yZy9wYXRjaC81MzYzMzExKQ0KPj4gSXQgd2FzIG5vdCBtZXJnZWQuIEhhZCBp
dCBiZWVuIG1lcmdlZCwgb25lIGNvdWxkIGp1c3QgY2hlY2sgdGhlIHJldHVybg0KPj4gdmFsdWUg
b2YgYnRyZnMgc2NydWIsIGluc3RlYWQgb2YgY2hlY2tzdW1taW5nIHRoZSB3aG9sZSBidHJmcyBz
ZW5kDQo+PiBvdXRwdXQsIGNvcnJlY3Q/DQo+IEluIHRoZW9yeSB5ZXMsIHByb3ZpZGVkIHlvdSBq
dXN0IHdhbnQgaGFzaGVzIGFuZCBub3QgYW4gSE1BQy4NCg==
