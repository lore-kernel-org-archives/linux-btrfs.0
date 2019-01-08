Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAE5C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 23:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6668D2084D
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 23:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="BwNbtGlS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbfAHXwJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 18:52:09 -0500
Received: from mail-eopbgr40080.outbound.protection.outlook.com ([40.107.4.80]:53104
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727829AbfAHXwI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 18:52:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYUd72hajPkdr/WCY/0fCgh36c3zd85ZUUPgTTbg4tM=;
 b=BwNbtGlSM04zZVEH5HgVmftIEY7RX2+GyFRL7kTy/ZmPb6Jv54FckL9u/bQZhmwfmVQyBqt4T/Ahx9/PskUN8eOcEzbDszHPyZYxBv3y1PZtYqiFXqbkgT0bAJoBALAbm19NEuW5vQ0dwVBDyYxejcjRfUGCEfsXlHUMuTXhKns=
Received: from DB6PR0601MB2568.eurprd06.prod.outlook.com (10.168.81.137) by
 DB6PR0601MB2198.eurprd06.prod.outlook.com (10.168.57.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.9; Tue, 8 Jan 2019 23:52:02 +0000
Received: from DB6PR0601MB2568.eurprd06.prod.outlook.com
 ([fe80::64c9:15d8:9c7b:92c3]) by DB6PR0601MB2568.eurprd06.prod.outlook.com
 ([fe80::64c9:15d8:9c7b:92c3%6]) with mapi id 15.20.1495.011; Tue, 8 Jan 2019
 23:52:02 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP
 stripe size handling
Thread-Topic: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP
 stripe size handling
Thread-Index: AQHUp4hbmz1G2p+3LUilnjxye6F3E6WmCzoA
Date:   Tue, 8 Jan 2019 23:52:02 +0000
Message-ID: <783ccf1f-65df-d388-079c-9449d4319c27@mendix.com>
References: <20190108192628.121270-1-sashal@kernel.org>
 <20190108192628.121270-72-sashal@kernel.org>
In-Reply-To: <20190108192628.121270-72-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM6P191CA0038.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::15) To DB6PR0601MB2568.eurprd06.prod.outlook.com
 (2603:10a6:4:6d::9)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB6PR0601MB2198;6:fKRIFsN21GeNi+LSurkSSUGJP5T9RSXSyRfY/I61YLHtmJgbpVyuC+fHHpNRmLp+zWa/IQeUPwe3HHLWvrpv/7vTNt3abR9HoFVWBhpOK6b/N8LD7AcHFJ7w/0wlu3bluCw3Ku7ckIZeP+IYzeVBuxknI6Nps7WD88jKA69ppt1C2EKs5FjQuNio2K0Dqb/soIr41u48WAo+gpIpOCz5tir+c7Lj1qb9f1QN9YOw5CR7Phh863rcU6vMkqrtI1OJW6dTBJNbW5ujP+bDGlL6AON+tY0Sak+okTKsb86vgH8moxmnHCMmbyYWeqqDfLrBXnYNqpdH6byV1BkauptJINQzOMnaQbolhXtBeFj3nrY8IHII6rk9JVRyGHaomw74l8gAR/jfPaRra2RVn9YwxGaH4pCvC/JTor7HzF+CZn+3/THSlDDejS/jPkxckCfiM9BUn6JZ2N5hcpMsBwzcUw==;5:/enspifNe+Cz7ui0n3Y0zeLzxrdPmo6anLenRWPjya+liKYLz1RJXVm0n+oLy368KXZCSnJORUK6jGgjkXh3vnGzGGI8D5Gk6BI/WJ983pvNBeeG0aWOX37yBRpgQq+nQQMd1YeRWWwk2mvvt/57ntCahetMK0B4mOulBIcau7OxeDdqm0qRJzLowUfgDmygpxE5kARUj5U1dbaiE5jfIw==;7:eCcWudciYyahAyztkxhCYqU7kIbtJJIrfaDaVc6G+dbf2s8qODE6ufNkep5S7cOgYGwR2x3C1HQgvnaSSqRgjkTiOo9D2JFaVnxQDs8GihFBCvTi8QL8me0z5JzVLu4+5spe4x8fBt0bzGpzjpV1Kw==
x-ms-office365-filtering-correlation-id: 0b7c3e55-117d-49dc-2724-08d675c448f9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:DB6PR0601MB2198;
x-ms-traffictypediagnostic: DB6PR0601MB2198:
x-microsoft-antispam-prvs: <DB6PR0601MB2198580AE338D412233C00F6D48A0@DB6PR0601MB2198.eurprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(93006095)(93001095)(3231475)(944501520)(52105112)(3002001)(10201501046)(6041310)(20161123564045)(20161123558120)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:DB6PR0601MB2198;BCL:0;PCL:0;RULEID:;SRVR:DB6PR0601MB2198;
x-forefront-prvs: 0911D5CE78
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(396003)(136003)(346002)(39850400004)(199004)(189003)(31696002)(36756003)(2201001)(97736004)(7736002)(446003)(31686004)(86362001)(575784001)(105586002)(14444005)(6512007)(11346002)(46003)(229853002)(486006)(53936002)(106356001)(476003)(54906003)(110136005)(2616005)(6506007)(76176011)(386003)(6246003)(2501003)(64126003)(186003)(102836004)(217873002)(256004)(58126008)(316002)(53546011)(65806001)(25786009)(52116002)(65956001)(71190400001)(72206003)(4326008)(14454004)(71200400001)(65826007)(8676002)(6486002)(99286004)(6116002)(68736007)(478600001)(81156014)(2906002)(5660300001)(8936002)(305945005)(81166006)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0601MB2198;H:DB6PR0601MB2568.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:3;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mPeE/H84snbsz+ECA8QbfX/jeXEPtgXLobKA1XcGOdDeqCm5hoGQ0yedbCsUEgErgHPc7v+CW3I6BRMHbj6DSz46+MW+KH2POqSZucohV6/xEFOHXip9Q7EL1OBIJ1P6GCHxPyOHhm80KQMBVhAWckgLlfRn5WTVdnyb7+01/wer6HCKC8Hvs+PkdVhk3ZzCp6paMHp5h+nMgmUyBA6NY7qgOtSwET7YCNMPbhuFSKvni5gtogzyBgf99XsclBCZkUsW4OwzG90ODfyXaDpiVxDWE0bBuewPMhcm7MJIwlhQF2LEonwMtqXc25xxSlIz
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <41D2C526786D6F4FBDEC35C816727343@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b7c3e55-117d-49dc-2724-08d675c448f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2019 23:52:01.5331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0601MB2198
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SGkgU2FzaGEsDQoNCk9uIDEvOC8xOSA4OjI1IFBNLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4gRnJv
bTogSGFucyB2YW4gS3JhbmVuYnVyZyA8aGFucy52YW4ua3JhbmVuYnVyZ0BtZW5kaXguY29tPg0K
PiANCj4gWyBVcHN0cmVhbSBjb21taXQgYmFmOTIxMTRjN2U2ZGQ2MTI0YWEzZDUwNmU0YmM0YjY5
NGRhM2JjMyBdDQo+IA0KPiBDb21taXQgOTJlMjIyZGY3YiAiYnRyZnM6IGFsbG9jX2NodW5rOiBm
aXggRFVQIHN0cmlwZSBzaXplIGhhbmRsaW5nIg0KPiBmaXhlZCBjYWxjdWxhdGluZyB0aGUgc3Ry
aXBlX3NpemUgZm9yIGEgbmV3IERVUCBjaHVuay4NCg0KVGhhdCBvbmUgYWxzbyBlbmRlZCB1cCBh
czoNCg0KNC4xNC1zdGFibGUNCjAxMzZiZDcyMzhiMmNiODIzODQyNmFmNDE4M2VkMGIwMjE2NWMz
ZjkNCg0KNC45LXN0YWJsZQ0KODg5MGJhZTAzZjRkYmExYzIyOTJlNTQ0NTY4MmI1NTZhZjRlOGYx
Yg0KDQo0LjQtc3RhYmxlDQo5N2MzZTQ2ZWY1Mzc0ODI3ODI4NmZjMDlkY2MzMGIxMzhkNjY3N2M0
DQoNCjMuMTYuNTctcmMxDQpmNjhmNDYyODRhMTk5ZjY4MzdjMWQ1Yjk0YTZhZTk3OWEyY2M0NjNj
DQoNCldoaWxlIGhpdHRpbmcgdGhlIGZhaWx1cmUgY29uZGl0aW9uIHdpdGhvdXQgYWRkaW5nICJj
cmFmdGluZyIgc3RlcHMgdG8NCm1ha2UgaXQgZXhhY3RseSBtYXRjaCB0aGUgc2NlbmFyaW8gaXMg
dW5saWtlbHksIGl0IG1pZ2h0IGJlIGdvb2QgaWYgd2UNCmp1c3QgZ28gYWxsIHRoZSB3YXkgYmFj
ayB3aXRoIHRoaXMgcmVncmVzc2lvbiBmaXg/DQoNClRoYW5rcywNCkhhbnMNCg0KPiBIb3dldmVy
LCB0aGUgc2FtZSBjYWxjdWxhdGlvbiByZWFwcGVhcnMgYSBiaXQgbGF0ZXIsIGFuZCB0aGF0IG9u
ZSB3YXMNCj4gbm90IGNoYW5nZWQgeWV0LiBUaGUgcmVzdWx0aW5nIGJ1ZyB0aGF0IGlzIGV4cG9z
ZWQgaXMgdGhhdCB0aGUgbmV3bHkNCj4gYWxsb2NhdGVkIGRldmljZSBleHRlbnRzICgnc3RyaXBl
cycpIGNhbiBoYXZlIGEgZmV3IE1pQiBvdmVybGFwIHdpdGggdGhlDQo+IG5leHQgdGhpbmcgc3Rv
cmVkIGFmdGVyIHRoZW0sIHdoaWNoIGlzIGFub3RoZXIgZGV2aWNlIGV4dGVudCBvciB0aGUgZW5k
DQo+IG9mIHRoZSBkaXNrLg0KPiANCj4gVGhlIHNjZW5hcmlvIGluIHdoaWNoIHRoaXMgY2FuIGhh
cHBlbiBpczoNCj4gKiBUaGUgYmxvY2sgZGV2aWNlIGZvciB0aGUgZmlsZXN5c3RlbSBpcyBsZXNz
IHRoYW4gMTBHaUIgaW4gc2l6ZS4NCj4gKiBUaGUgYW1vdW50IG9mIGNvbnRpZ3VvdXMgZnJlZSB1
bmFsbG9jYXRlZCBkaXNrIHNwYWNlIGNob3NlbiB0byB1c2UgZm9yDQo+ICAgY2h1bmsgYWxsb2Nh
dGlvbiBpcyAyMCUgb2YgdGhlIHRvdGFsIGRldmljZSBzaXplLCBvciBhIGZldyBNaUIgbW9yZSBv
cg0KPiAgIGxlc3MuDQo+IA0KPiBBbiBleGFtcGxlOg0KPiAtIFRoZSBmaWxlc3lzdGVtIGRldmlj
ZSBpcyA3ODgwTWlCIChtYXhfY2h1bmtfc2l6ZSBnZXRzIHNldCB0byA3ODhNaUIpDQo+IC0gVGhl
cmUncyAxNTc4TWlCIHVuYWxsb2NhdGVkIHJhdyBkaXNrIHNwYWNlIGxlZnQgaW4gb25lIGNvbnRp
Z3VvdXMNCj4gICBwaWVjZS4NCj4gDQo+IEluIHRoaXMgY2FzZSBzdHJpcGVfc2l6ZSBpcyBmaXJz
dCBjYWxjdWxhdGVkIGFzIDc4OU1pQiwgKGhhbGYgb2YNCj4gMTU3OE1pQikuDQo+IA0KPiBTaW5j
ZSA3ODlNaUIgKHN0cmlwZV9zaXplICogZGF0YV9zdHJpcGVzKSA+IDc4OE1pQiAobWF4X2NodW5r
X3NpemUpLCB3ZQ0KPiBlbnRlciB0aGUgaWYgYmxvY2suIE5vdyBzdHJpcGVfc2l6ZSB2YWx1ZSBp
cyBpbW1lZGlhdGVseSBvdmVyd3JpdHRlbg0KPiB3aGlsZSBjYWxjdWxhdGluZyBhbiBhZGp1c3Rl
ZCB2YWx1ZSBiYXNlZCBvbiBtYXhfY2h1bmtfc2l6ZSwgd2hpY2ggZW5kcw0KPiB1cCBhcyA3ODhN
aUIuDQo+IA0KPiBOZXh0LCB0aGUgdmFsdWUgaXMgcm91bmRlZCB1cCB0byBhIDE2TWlCIGJvdW5k
YXJ5LCA4MDBNaUIsIHdoaWNoIGlzDQo+IGFjdHVhbGx5IG1vcmUgdGhhbiB0aGUgdmFsdWUgd2Ug
aGFkIGJlZm9yZS4gSG93ZXZlciwgdGhlIGxhc3QgY29tcGFyaXNvbg0KPiBmYWlscyB0byBkZXRl
Y3QgdGhpcywgYmVjYXVzZSBpdCdzIGNvbXBhcmluZyB0aGUgdmFsdWUgd2l0aCB0aGUgdG90YWwN
Cj4gYW1vdW50IG9mIGZyZWUgc3BhY2UsIHdoaWNoIGlzIGFib3V0IHR3aWNlIHRoZSBzaXplIG9m
IHN0cmlwZV9zaXplLg0KPiANCj4gSW4gdGhlIGV4YW1wbGUgYWJvdmUsIHRoaXMgbWVhbnMgdGhh
dCB0aGUgcmVzdWx0aW5nIHJhdyBkaXNrIHNwYWNlIGJlaW5nDQo+IGFsbG9jYXRlZCBpcyAxNjAw
TWlCLCB3aGlsZSBvbmx5IGEgZ2FwIG9mIDE1NzhNaUIgaGFzIGJlZW4gZm91bmQuIFRoZQ0KPiBz
ZWNvbmQgZGV2aWNlIGV4dGVudCBvYmplY3QgZm9yIHRoaXMgRFVQIGNodW5rIHdpbGwgb3Zlcmxh
cCBmb3IgMjJNaUINCj4gd2l0aCB3aGF0ZXZlciBjb21lcyBuZXh0Lg0KPiANCj4gVGhlIHVuZGVy
bHlpbmcgcHJvYmxlbSBoZXJlIGlzIHRoYXQgdGhlIHN0cmlwZV9zaXplIGlzIHJldXNlZCBhbGwg
dGhlDQo+IHRpbWUgZm9yIGRpZmZlcmVudCB0aGluZ3MuIFNvLCB3aGVuIGVudGVyaW5nIHRoZSBj
b2RlIGluIHRoZSBpZiBibG9jaywNCj4gc3RyaXBlX3NpemUgaXMgaW1tZWRpYXRlbHkgb3Zlcndy
aXR0ZW4gd2l0aCBzb21ldGhpbmcgZWxzZS4gSWYgbGF0ZXIgd2UNCj4gZGVjaWRlIHdlIHdhbnQg
dG8gaGF2ZSB0aGUgcHJldmlvdXMgdmFsdWUgYmFjaywgdGhlbiB0aGUgbG9naWMgdG8NCj4gY29t
cHV0ZSBpdCB3YXMgY29weSBwYXN0ZWQgaW4gYWdhaW4uDQo+IA0KPiBXaXRoIHRoaXMgY2hhbmdl
LCB0aGUgdmFsdWUgaW4gc3RyaXBlX3NpemUgaXMgbm90IHVubmVjZXNzYXJpbHkNCj4gZGVzdHJv
eWVkLCBzbyB0aGUgZHVwbGljYXRlZCBjYWxjdWxhdGlvbiBpcyBub3QgbmVlZGVkIGFueSBtb3Jl
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGFucyB2YW4gS3JhbmVuYnVyZyA8aGFucy52YW4ua3Jh
bmVuYnVyZ0BtZW5kaXguY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBTdGVyYmEgPGRzdGVy
YmFAc3VzZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVs
Lm9yZz4NCj4gLS0tDQo+ICBmcy9idHJmcy92b2x1bWVzLmMgfCAxNiArKysrKysrLS0tLS0tLS0t
DQo+ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL3ZvbHVtZXMuYyBiL2ZzL2J0cmZzL3ZvbHVtZXMuYw0K
PiBpbmRleCBhNTY3ZWUwYmYwNjAuLjE3OTdhODJlYjdkZiAxMDA2NDQNCj4gLS0tIGEvZnMvYnRy
ZnMvdm9sdW1lcy5jDQo+ICsrKyBiL2ZzL2J0cmZzL3ZvbHVtZXMuYw0KPiBAQCAtNDc2OCwxOSAr
NDc2OCwxNyBAQCBzdGF0aWMgaW50IF9fYnRyZnNfYWxsb2NfY2h1bmsoc3RydWN0IGJ0cmZzX3Ry
YW5zX2hhbmRsZSAqdHJhbnMsDQo+ICAJLyoNCj4gIAkgKiBVc2UgdGhlIG51bWJlciBvZiBkYXRh
IHN0cmlwZXMgdG8gZmlndXJlIG91dCBob3cgYmlnIHRoaXMgY2h1bmsNCj4gIAkgKiBpcyByZWFs
bHkgZ29pbmcgdG8gYmUgaW4gdGVybXMgb2YgbG9naWNhbCBhZGRyZXNzIHNwYWNlLA0KPiAtCSAq
IGFuZCBjb21wYXJlIHRoYXQgYW5zd2VyIHdpdGggdGhlIG1heCBjaHVuayBzaXplDQo+ICsJICog
YW5kIGNvbXBhcmUgdGhhdCBhbnN3ZXIgd2l0aCB0aGUgbWF4IGNodW5rIHNpemUuIElmIGl0J3Mg
aGlnaGVyLA0KPiArCSAqIHdlIHRyeSB0byByZWR1Y2Ugc3RyaXBlX3NpemUuDQo+ICAJICovDQo+
ICAJaWYgKHN0cmlwZV9zaXplICogZGF0YV9zdHJpcGVzID4gbWF4X2NodW5rX3NpemUpIHsNCj4g
LQkJc3RyaXBlX3NpemUgPSBkaXZfdTY0KG1heF9jaHVua19zaXplLCBkYXRhX3N0cmlwZXMpOw0K
PiAtDQo+IC0JCS8qIGJ1bXAgdGhlIGFuc3dlciB1cCB0byBhIDE2TUIgYm91bmRhcnkgKi8NCj4g
LQkJc3RyaXBlX3NpemUgPSByb3VuZF91cChzdHJpcGVfc2l6ZSwgU1pfMTZNKTsNCj4gLQ0KPiAg
CQkvKg0KPiAtCQkgKiBCdXQgZG9uJ3QgZ28gaGlnaGVyIHRoYW4gdGhlIGxpbWl0cyB3ZSBmb3Vu
ZCB3aGlsZSBzZWFyY2hpbmcNCj4gLQkJICogZm9yIGZyZWUgZXh0ZW50cw0KPiArCQkgKiBSZWR1
Y2Ugc3RyaXBlX3NpemUsIHJvdW5kIGl0IHVwIHRvIGEgMTZNQiBib3VuZGFyeSBhZ2FpbiBhbmQN
Cj4gKwkJICogdGhlbiB1c2UgaXQsIHVubGVzcyBpdCBlbmRzIHVwIGJlaW5nIGV2ZW4gYmlnZ2Vy
IHRoYW4gdGhlDQo+ICsJCSAqIHByZXZpb3VzIHZhbHVlIHdlIGhhZCBhbHJlYWR5Lg0KPiAgCQkg
Ki8NCj4gLQkJc3RyaXBlX3NpemUgPSBtaW4oZGV2aWNlc19pbmZvW25kZXZzIC0gMV0ubWF4X2F2
YWlsLA0KPiArCQlzdHJpcGVfc2l6ZSA9IG1pbihyb3VuZF91cChkaXZfdTY0KG1heF9jaHVua19z
aXplLA0KPiArCQkJCQkJICAgZGF0YV9zdHJpcGVzKSwgU1pfMTZNKSwNCj4gIAkJCQkgIHN0cmlw
ZV9zaXplKTsNCj4gIAl9DQo+ICANCj4NCg==
