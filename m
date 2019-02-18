Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F3DC4360F
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 09:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01996218AD
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 09:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="cPCxt650"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbfBRJzF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 04:55:05 -0500
Received: from mail-eopbgr150041.outbound.protection.outlook.com ([40.107.15.41]:46848
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725989AbfBRJzF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 04:55:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zP+g9lCuz0TYHGQwwRJuHbNIxKySzuflrv8onWmOYEA=;
 b=cPCxt650F9nfDj8Yre7KCe0ABE/ZXBAvRDg9YHFqJMNwQjF9TIeOiuWDTSdcWmSKQkmbtw7Ki8elwwdGYS0VSFpzPPEIBBiVeCXDdJRy3hswJLwiU7mhkySl0Y/GZeNG7qcqjdKufwmgadVb+3683Dui5mO+KgoqiwUGaOoAqmE=
Received: from DB7PR06MB5767.eurprd06.prod.outlook.com (20.177.193.208) by
 DB7PR06MB5340.eurprd06.prod.outlook.com (20.178.46.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Mon, 18 Feb 2019 09:55:01 +0000
Received: from DB7PR06MB5767.eurprd06.prod.outlook.com
 ([fe80::c575:c4a8:1776:a21e]) by DB7PR06MB5767.eurprd06.prod.outlook.com
 ([fe80::c575:c4a8:1776:a21e%4]) with mapi id 15.20.1622.018; Mon, 18 Feb 2019
 09:55:01 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>
CC:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Liu Bo <obuil.liubo@gmail.com>
Subject: Re: [PATCH v2] btrfs: ensure that a DUP or RAID1 block group has
 exactly two stripes
Thread-Topic: [PATCH v2] btrfs: ensure that a DUP or RAID1 block group has
 exactly two stripes
Thread-Index: AQHUx28qoP5RMjMGsUaVfr170zFPAaXlUSaA
Date:   Mon, 18 Feb 2019 09:55:01 +0000
Message-ID: <adbf2ddb-be6b-25c7-b74e-a337c97d12bd@mendix.com>
References: <20190218094850.13512-1-jthumshirn@suse.de>
In-Reply-To: <20190218094850.13512-1-jthumshirn@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM6PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::29) To DB7PR06MB5767.eurprd06.prod.outlook.com
 (2603:10a6:10:5f::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb50d990-b72b-4c80-47e1-08d6958725fc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:DB7PR06MB5340;
x-ms-traffictypediagnostic: DB7PR06MB5340:
x-microsoft-exchange-diagnostics: =?utf-8?B?MTtEQjdQUjA2TUI1MzQwOzIzOjZTbFZQMTJPcytsUEQvbzZJcnhoaW12OUxC?=
 =?utf-8?B?YkVvaUprcFhVMFpkc2ZJWHBsZHM3K3hmaEVqMnozd1NPS0tTMkJtU2Z3L3da?=
 =?utf-8?B?WWxWeitVSHZPV1dXZWY5OUp4T1JZUHdQTVRVdVJ2bVNocC9aaDczV3lhS0NJ?=
 =?utf-8?B?RGc2V2t2eHhUVHNGbmtxZ3pNeXVia21TZ3UzMGdod1JYbjBDWG42ZFdvMkgz?=
 =?utf-8?B?TlpYU3JCYnNPMEliaW52ZjJGMk14N3Y1eFU3YmtiOWV4TnBkUU91SzVQbGl1?=
 =?utf-8?B?bzYyZzRXWnhjYXo5ZGZSSFFiZmdhY0xHaStSTTc5em92dDErTWdoQjB0cWZF?=
 =?utf-8?B?NkJCU3hUUGlEVmdRMC9oSW5vUzFzYkh2RlF6SDdyZUxEUi8rREhDZVZJQ3pU?=
 =?utf-8?B?QlBVVnA5Mmd5dGw4UXJnTUtiaXc1OWFzcFVqY2VFR3VJVVZZWXpmSUZ3VVFr?=
 =?utf-8?B?elJ3QnlwZHdMVEg0OGpOc09MYmgvaWVrZUxtVTQ4ZHFnTHIwT0s5WFdTZkZP?=
 =?utf-8?B?UFdJVlNjMVFkdUVXU1pkTWlUdXI3eTZpV0FsNlovTHFyVldBbGdyRGhCQUJu?=
 =?utf-8?B?Y1dSMFVrVW8xZHBtbUIrQ1g1TmxRRzgzUWdGOHRCSXJ6UkpzclJDQVpYUVJD?=
 =?utf-8?B?VFZaWGZvNndjbGlpem1BRXQ4eTJKZE9DZDVqVnZER2J3Q3dWSmpuTlcxL2JF?=
 =?utf-8?B?NFkybjYvUmt4cTBZYVZGYmt6OU90d0JuYVFoaU1vT2E2QVBVS1o2ZDA2dXNk?=
 =?utf-8?B?ZE83UWorYlg2SEFIRHJTb2Y5QisyMlZFQVV2NEp6S2ROTjhUY2JqR0hwYjA0?=
 =?utf-8?B?dFZpeGpYQ3VaeHAxSTNkVkppajNwS2JjYWZBQzdsVXRJTi80YzVYOEM4cm5L?=
 =?utf-8?B?Mm9QVDRYWUFmdU5OSVlZU1BHdXFWS1pQK2lqNTVtd0tNTUpQUENJM3BNS0E5?=
 =?utf-8?B?bDZnK0crK3JKQVdrSWFnN1lyWjNDYmVSRk1FajdDYkpaUitZbHVDQWJweE9V?=
 =?utf-8?B?aUNLRDFCV3RINHluOURCdTBKQlRuc3pYMFZER2NrTGFuV29Hd244R21uVTUx?=
 =?utf-8?B?eEl3OCtxQm9wem1VU210Mk5mOEFXSXNtaHZXaWNTVDZZMEFlN1J5Q09ROEo4?=
 =?utf-8?B?bFdRRm1yTktZUGR5cHlhY0xvdCtNdHBTazhNU0c3b1JvajAyYWk0dks4UXhD?=
 =?utf-8?B?TysrdEgxRVNkNXB4anYyMnJLM1duVlhwVjg4Z3IvNE5vUFljcFlwWHF6MmlD?=
 =?utf-8?B?K0lBazF5TEpFMWRDNW4wanFWV0U4dm93a3h3QURDK2FBNHNsdWwwVzFSZGI2?=
 =?utf-8?B?clAzVnBQZTdwUUwrM3V2dUhLNEJ4OTN6UTFBTFdRR2svOGhRZ1l1b0JsSWZt?=
 =?utf-8?B?eUhmbERYSThrdXYrSTdDR25YemZsV1ZXZlRvZ0FkWmY3cWIrM0pmOGxCbVdh?=
 =?utf-8?B?YmhwQXBRTTBINjdTZlBQSWRrQ0psYTMxQ0xFME9SYnJvSjJuRUxQTC9IT3lN?=
 =?utf-8?B?aWVJaVNIK3pjV1lSR2p2aW1nOWYrUE0vajd1V2xUVE1rcEhrcW9IQmh3SVgx?=
 =?utf-8?B?UlNkNHBxdlBPWkZwSTVVY0xXZVJPYVdBV0R1cWdHK0UxblFMcDdxb0p3WXNV?=
 =?utf-8?B?aTNZYXFjRDdPYWNlTTJPWnZNR1VyWnFZZjVVbzRSWWhSL1hScjV2bHo3ZnpP?=
 =?utf-8?B?SWdBaDVVb1N0YTVJVCtKMGVrY0Z3NEhaZFJQd2ozSmp2bmJuTnA3T0YrKzdR?=
 =?utf-8?B?SWNMYjNmb0svQ0tqK09xdjIycUJhakdYZmY3LzJuT3M4S1ZCK2Q4czdoK2JW?=
 =?utf-8?B?T1RyMmpRVVB4K3JEeXozMWl2T0Ric21qL3NrbEcvOUhENnAxVWJTMlNqTDRB?=
 =?utf-8?B?dmE3QTNJcE1hOVRuSUlzc0k1RGVjVDh0ZkU3MFZRN3NSNVNDbDExZVlWbmNt?=
 =?utf-8?B?Y3Zqd29NTkxFaUpoQ3A2c2hkd1FnVFN3WHRqbUk1aS9WdjNWTWxtYTk0azVs?=
 =?utf-8?Q?3ePVHM?=
x-microsoft-antispam-prvs: <DB7PR06MB534068FFD94A1643ED1E0403D4630@DB7PR06MB5340.eurprd06.prod.outlook.com>
x-forefront-prvs: 09525C61DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(39850400004)(376002)(346002)(366004)(136003)(396003)(199004)(189003)(386003)(6512007)(31686004)(110136005)(5660300002)(71200400001)(316002)(58126008)(54906003)(31696002)(7736002)(65956001)(6506007)(99286004)(65806001)(2616005)(8936002)(8676002)(6486002)(81166006)(65826007)(229853002)(11346002)(305945005)(76176011)(86362001)(6436002)(186003)(68736007)(36756003)(52116002)(81156014)(14454004)(478600001)(476003)(53936002)(4326008)(256004)(446003)(102836004)(25786009)(105586002)(72206003)(97736004)(53546011)(71190400001)(46003)(64126003)(6246003)(6116002)(486006)(106356001)(2906002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR06MB5340;H:DB7PR06MB5767.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ICii7qmxJLgm2DI4LmupKdDagnkRfpUozZ0keCx8as9My9khUw40JgiCOjnGFdMQRvW2tw9B3dAi9suDBmXhXWlEJ53opaSSqfEykwUxBuLlAdP7T+yE1WAZdwjgOUhiNidpV7s2SZMrhcuRbodjGfdDl4sz7llE5Ee1J+aPM/sk52qFZKeFFPZ/4RyxCueXYf+QiuEMUHFe+A1tdUd2qn+gIIfSDR8GPy6LGgFVrhzoe0Vmk/aBzJVpqiB2I2strA58BjmJBjVgpIgHEYuZBfEIFWn3UKP0xbnUMCzbDZL7Z0vbke7erq/Fdk75r4ZsUMLV9C3zz0dXfmF8moE+V+vvpAKlPKfJbyYJpRgZuJ48Pv62op/xUg807ItbqERwRfemZ281Gju0LjwG32c5Fyij3tHFuIvgObzlQ1wmKJU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0712DFBC39E03E45BDF56BA4F2CBCA43@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb50d990-b72b-4c80-47e1-08d6958725fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2019 09:55:00.5965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB5340
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMi8xOC8xOSAxMDo0OCBBTSwgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOg0KPiBXZSByZWNl
bnRseSBoYWQgYSBjdXN0b21lciBpc3N1ZSB3aXRoIGEgY29ycnVwdGVkIGZpbGVzeXN0ZW0uIFdo
ZW4gdHJ5aW5nDQo+IHRvIG1vdW50IHRoaXMgaW1hZ2UgYnRyZnMgcGFuaWNrZWQgd2l0aCBhIGRp
dmlzaW9uIGJ5IHplcm8gaW4NCj4gY2FsY19zdHJpcGVfbGVuZ3RoKCkuDQo+IA0KPiBUaGUgY29y
cnVwdCBjaHVuayBoYWQgYSAnbnVtX3N0cmlwZXMnIHZhbHVlIG9mIDEuIGNhbGNfc3RyaXBlX2xl
bmd0aCgpDQo+IHRha2VzIHRoaXMgdmFsdWUgYW5kIGRpdmlkZXMgaXQgYnkgdGhlIG51bWJlciBv
ZiBjb3BpZXMgdGhlIFJBSUQgcHJvZmlsZSBpcw0KPiBleHBlY3RlZCB0byBoYXZlIHRvIGNhbGN1
bGF0ZSB0aGUgYW1vdW50IG9mIGRhdGEgc3RyaXBlcy4gQXMgYSBEVVAgcHJvZmlsZQ0KPiBpcyBl
eHBlY3RlZCB0byBoYXZlIDIgY29waWVzIHRoaXMgZGl2aXNpb24gcmVzdWx0ZWQgaW4gMS8yID0g
MC4gTGF0ZXIgdGhlbg0KPiB0aGUgJ2RhdGFfc3RyaXBlcycgdmFyaWFibGUgaXMgdXNlZCBhcyBh
IGRpdmlzb3IgaW4gdGhlIHN0cmlwZSBsZW5ndGgNCj4gY2FsY3VsYXRpb24gd2hpY2ggcmVzdWx0
cyBpbiBhIGRpdmlzaW9uIGJ5IDAgYW5kIHRodXMgYSBrZXJuZWwgcGFuaWMuDQo+IA0KPiBXaGVu
IGVuY291bnRlcmluZyBhIGZpbGVzeXN0ZW0gd2l0aCBhIERVUCBibG9jayBncm91cCBhbmQgYSAn
bnVtX3N0cmlwZXMnDQo+IHZhbHVlIHVuZXF1YWwgdG8gMiwgcmVmdXNlIG1vdW50aW5nIGFzIHRo
ZSBpbWFnZSBpcyBjb3JydXB0ZWQgYW5kIHdpbGwgbGVhZA0KPiB0byB1bmV4cGVjdGVkIGJlaGF2
aW91ci4NCj4gDQo+IENvZGUgaW5zcGVjdGlvbiBzaG93ZWQgYSBSQUlEMSBibG9jayBncm91cCBo
YXMgdGhlIHNhbWUgaXNzdWVzLg0KPiANCj4gRml4ZXM6IGUwNmNkM2RkN2NlYSAoIkJ0cmZzOiBh
ZGQgdmFsaWRhZHRpb24gY2hlY2tzIGZvciBjaHVuayBsb2FkaW5nIikNCj4gQ2M6IExpdSBCbyA8
b2J1aWwubGl1Ym9AZ21haWwuY29tPg0KPiBSZXZpZXdlZC1ieTogUXUgV2VucnVvIDx3cXVAc3Vz
ZS5jb20+DQo+IFJldmlld2VkLWJ5OiBOaWtvbGF5IEJvcmlzb3YgPG5ib3Jpc292QHN1c2UuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGp0aHVtc2hpcm5Ac3VzZS5k
ZT4NCj4gLS0tDQo+IENoYW5nZXMgdG8gdjE6DQo+IC0gQWxzbyBhZGQgdGhlIGNoZWNrIGZvciBS
QUlEMSAoSGFucykNCj4gLS0tDQo+ICBmcy9idHJmcy92b2x1bWVzLmMgfCA0ICsrLS0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZnMvYnRyZnMvdm9sdW1lcy5jIGIvZnMvYnRyZnMvdm9sdW1lcy5jDQo+IGluZGV4
IDAzZjIyM2FhNzE5NC4uYTRkMTJhZGEwNTY1IDEwMDY0NA0KPiAtLS0gYS9mcy9idHJmcy92b2x1
bWVzLmMNCj4gKysrIGIvZnMvYnRyZnMvdm9sdW1lcy5jDQo+IEBAIC02NzkxLDEwICs2NzkxLDEw
IEBAIHN0YXRpYyBpbnQgYnRyZnNfY2hlY2tfY2h1bmtfdmFsaWQoc3RydWN0IGJ0cmZzX2ZzX2lu
Zm8gKmZzX2luZm8sDQo+ICAJfQ0KPiAgDQo+ICAJaWYgKCh0eXBlICYgQlRSRlNfQkxPQ0tfR1JP
VVBfUkFJRDEwICYmIHN1Yl9zdHJpcGVzICE9IDIpIHx8DQo+IC0JICAgICh0eXBlICYgQlRSRlNf
QkxPQ0tfR1JPVVBfUkFJRDEgJiYgbnVtX3N0cmlwZXMgPCAxKSB8fA0KPiArCSAgICAodHlwZSAm
IEJUUkZTX0JMT0NLX0dST1VQX1JBSUQxICYmIG51bV9zdHJpcGVzICE9IDEpIHx8DQoNCkkgdGhp
bmsgeW91IG1lYW50ICE9IDIgaGVyZS4gSXQncyBqdXN0IGxpa2UgRFVQLCBidXQgd2l0aCB0aGUg
dHdvIG9mDQp0aGVtIG9uIGRpZmZlcmVudCBkZXZpY2VzIGluc3RlYWQgb2YgdGhlIHNhbWUuDQoN
Cj4gIAkgICAgKHR5cGUgJiBCVFJGU19CTE9DS19HUk9VUF9SQUlENSAmJiBudW1fc3RyaXBlcyA8
IDIpIHx8DQo+ICAJICAgICh0eXBlICYgQlRSRlNfQkxPQ0tfR1JPVVBfUkFJRDYgJiYgbnVtX3N0
cmlwZXMgPCAzKSB8fA0KPiAtCSAgICAodHlwZSAmIEJUUkZTX0JMT0NLX0dST1VQX0RVUCAmJiBu
dW1fc3RyaXBlcyA+IDIpIHx8DQo+ICsJICAgICh0eXBlICYgQlRSRlNfQkxPQ0tfR1JPVVBfRFVQ
ICYmIG51bV9zdHJpcGVzICE9IDIpIHx8DQo+ICAJICAgICgodHlwZSAmIEJUUkZTX0JMT0NLX0dS
T1VQX1BST0ZJTEVfTUFTSykgPT0gMCAmJg0KPiAgCSAgICAgbnVtX3N0cmlwZXMgIT0gMSkpIHsN
Cj4gIAkJYnRyZnNfZXJyKGZzX2luZm8sDQo+IA0KDQpUaGFua3MsDQoNCi0tIA0KSGFucyB2YW4g
S3JhbmVuYnVyZw0K
