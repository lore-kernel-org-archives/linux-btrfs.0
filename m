Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4189AC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 16:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA73A216FD
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 16:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="LW8tw4eF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA73A216FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbeKNCoy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 21:44:54 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:47520
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730836AbeKNCox (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 21:44:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKfnus1oJzMRMokL13HDfbNS/vO7Lga3NK02B9IzAtc=;
 b=LW8tw4eF/fcYwlzyHxlsSFJMtqPZ16BHa3cpcmIEtePmCpsi6ygFGVpLz+97cC2iz2Eu5FztZiJExwTsmgomET6g5iEI71ASruGmBRt3qtz7iaLc/DIsZUHawTtj6wOLMMbuezuxiGPWKTmGc58XfaU1i6jAcKx90UouI5LRapw=
Received: from DB7PR06MB4680.eurprd06.prod.outlook.com (20.177.122.217) by
 DB7PR06MB4742.eurprd06.prod.outlook.com (20.177.123.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1294.27; Tue, 13 Nov 2018 16:45:54 +0000
Received: from DB7PR06MB4680.eurprd06.prod.outlook.com
 ([fe80::e57d:581a:45fb:622]) by DB7PR06MB4680.eurprd06.prod.outlook.com
 ([fe80::e57d:581a:45fb:622%5]) with mapi id 15.20.1294.045; Tue, 13 Nov 2018
 16:45:54 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Thread-Topic: [PATCH 0/6] Chunk allocator DUP fix and cleanups
Thread-Index: AQHUXCmOSBgrE/nJs0WTXuGELqo9PaUaMbCAgABsAACAM24pgIAAHIKA
Date:   Tue, 13 Nov 2018 16:45:54 +0000
Message-ID: <a27c0ac1-ccb6-591e-066f-c399f5a546e3@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
 <20181011151346.GR29418@twin.jikos.cz>
 <98354c0d-2bed-340e-4f8e-734307c82863@mendix.com>
 <20181113150351.GB24115@twin.jikos.cz>
In-Reply-To: <20181113150351.GB24115@twin.jikos.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [85.146.242.35]
x-clientproxiedby: AM6P194CA0082.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::23) To DB7PR06MB4680.eurprd06.prod.outlook.com
 (2603:10a6:10:53::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB7PR06MB4742;6:ZFjRKQezg770xEbnCm2n4R7D+JzI+Did1Sfc9mbaCsM0OPqqfu1t4gQiO9GtvmJu7Jy3iUxNT1OaVy839IHVM/41dkn4/M4jmxfeIazHYl9K59l8L73MOrWW0i0N4tmcy9B7YyzQPEzttVYW4yrMgpcnuhwrhKcpxe8BhytpH7Sg70zKJnNIJ+JsojroEiYn8VFBZiv1fVMTFzYnoc5xoMUOkI7PhmKNZrOl60uYfZd0uFt2VDQLsksz0r44QuOmdABAZ953mggHVl3jpPjQY1ZpxtsruJ54pzc19Hd6awrK2PRPPM6RlLEACtJ8TYZTcENyD/fwMosPbJ+Tjqn6TAlxxgMIIQGJGjcbDpyXntxtvUQ5G2HkY+BMybPIZPhzpARf/0N926S/KagGQgGda5tUubHHEf5LBoPe6/LSK91+JGDDZgYlp93bQFibfEGQE8MKicFviGGH8hUNQbgq5g==;5:oH/hGhFTj89bSpU5gJMX8jxtRUmAyIZ/8JH0z0bbOsC2HBKF2nn89+hVdbhEnam6OOCi2RZIfH9yowy3i/o0fQdfIz5Cwbdh2w4AvxrvIDgTD9LPTRm/Vs6dc0uVpSf3sfUx7LvPxIThAvngZB0JwaE+zXIvKUdkUSEey6QbdnA=;7:gVXwhOeefstuSu0pdsZO8Uoho597kMNybdyRnGEpS2kixMzFFp8Zd0gifllIv3MyzrqmGawXNZgywFOjbcheZxVFPjsIoJhBuRsIy0d15OD44CKxLAmb0dJcdya7AtjHK88fN5zTiyhaKy/rzQl5WA==
x-ms-office365-filtering-correlation-id: af92aa8a-4e52-4b01-34dc-08d649877a80
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390060)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DB7PR06MB4742;
x-ms-traffictypediagnostic: DB7PR06MB4742:
x-microsoft-antispam-prvs: <DB7PR06MB47429F62C6D4475A53A6EF9DD4C20@DB7PR06MB4742.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(271806183753584)(788757137089);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(52105112)(148016)(149066)(150057)(6041310)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123564045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:DB7PR06MB4742;BCL:0;PCL:0;RULEID:;SRVR:DB7PR06MB4742;
x-forefront-prvs: 085551F5A8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(478600001)(97736004)(2906002)(7736002)(966005)(25786009)(72206003)(6116002)(305945005)(6436002)(5660300001)(486006)(93886005)(8936002)(446003)(81156014)(6512007)(6246003)(3846002)(53936002)(2900100001)(11346002)(6306002)(105586002)(8676002)(65826007)(81166006)(106356001)(52116002)(102836004)(476003)(2616005)(36756003)(53546011)(6506007)(386003)(66066001)(65806001)(186003)(26005)(31686004)(71190400001)(71200400001)(65956001)(14444005)(316002)(256004)(229853002)(110136005)(2501003)(58126008)(64126003)(68736007)(14454004)(31696002)(99286004)(76176011)(86362001)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR06MB4742;H:DB7PR06MB4680.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: RSHfcI9HQrFYqBs0YNV8n4PEKKw3oFTI8y/u+BZXDnbVTmLxZOuMgcF5ur1xryNopgj7d0st7sAsM3D3w2inHYeXKc7Ko5RJvmNftoFJY7Vr2C9Cz1wuK+uQ63KNZOK+5GeMgozWMP8+wv6F5siIvQoKpgktxKijrs9zdwZL3PXmSd288i3w1U2+LM17DcJkPxR9xcSj7SiSnIBJe+0tqxzAHFVW2CF3/x2PS6wqAGUpu40u/0Tp7TDTzNq2IMgQU+d0HUtOzArOPub+XaXRCX2tTl4eL5JhOmChyfdH+4cf9QJSxTDYPZ3CUtgshXaweNf3F3aLUz/1SvScJMXBlpuPP4ZMWlunRl2O/Y8Iyko=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <88BEAD145B35F042BD8235DB6B0A7823@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af92aa8a-4e52-4b01-34dc-08d649877a80
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2018 16:45:54.8332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB4742
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTEvMTMvMTggNDowMyBQTSwgRGF2aWQgU3RlcmJhIHdyb3RlOg0KPiBPbiBUaHUsIE9jdCAx
MSwgMjAxOCBhdCAwNzo0MDoyMlBNICswMDAwLCBIYW5zIHZhbiBLcmFuZW5idXJnIHdyb3RlOg0K
Pj4gT24gMTAvMTEvMjAxOCAwNToxMyBQTSwgRGF2aWQgU3RlcmJhIHdyb3RlOg0KPj4+IE9uIFRo
dSwgT2N0IDA0LCAyMDE4IGF0IDExOjI0OjM3UE0gKzAyMDAsIEhhbnMgdmFuIEtyYW5lbmJ1cmcg
d3JvdGU6DQo+Pj4+IFRoaXMgcGF0Y2ggc2V0IGNvbnRhaW5zIGFuIGFkZGl0aW9uYWwgZml4IGZv
ciBhIG5ld2x5IGV4cG9zZWQgYnVnIGFmdGVyDQo+Pj4+IHRoZSBwcmV2aW91cyBhdHRlbXB0IHRv
IGZpeCBhIGNodW5rIGFsbG9jYXRvciBidWcgZm9yIG5ldyBEVVAgY2h1bmtzOg0KPj4+Pg0KPj4+
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1idHJmcy83ODJmNjAwMC0zMGMwLTAwODUt
YWJkMi03NGVjNTgyN2M5MDNAbWVuZGl4LmNvbS9ULyNtNjA5Y2NiNWQzMjk5OGU4YmE1Y2ZhOTkw
MWMxYWI1NmEzOGE2ZjM3NA0KPj4+Pg0KPj4+PiBUaGUgRFVQIGZpeCBpcyAiZml4IG1vcmUgRFVQ
IHN0cmlwZSBzaXplIGhhbmRsaW5nIi4gSSBkaWQgdGhhdCBvbmUNCj4+Pj4gYmVmb3JlIHN0YXJ0
aW5nIHRvIGNoYW5nZSBtb3JlIHRoaW5ncyBzbyBpdCBjYW4gYmUgYXBwbGllZCB0byBlYXJsaWVy
DQo+Pj4+IExUUyBrZXJuZWxzLg0KPj4+Pg0KPj4+PiBCZXNpZGVzIHRoYXQgcGF0Y2gsIHdoaWNo
IGlzIGZpeGluZyB0aGUgYnVnIGluIGEgd2F5IHRoYXQgaXMgbGVhc3QNCj4+Pj4gaW50cnVzaXZl
LCBJIGFkZGVkIGEgYnVuY2ggb2Ygb3RoZXIgcGF0Y2hlcyB0byBoZWxwIGdldHRpbmcgdGhlIGNo
dW5rDQo+Pj4+IGFsbG9jYXRvciBjb2RlIGluIGEgc3RhdGUgdGhhdCBpcyBhIGJpdCBsZXNzIGVy
cm9yLXByb25lIGFuZA0KPj4+PiBidWctYXR0cmFjdGluZy4NCj4+Pj4NCj4+Pj4gV2hlbiBydW5u
aW5nIHRoaXMgYW5kIHRyeWluZyB0aGUgcmVwcm9kdWN0aW9uIHNjZW5hcmlvLCBJIGNhbiBub3cg
c2VlDQo+Pj4+IHRoYXQgdGhlIGNyZWF0ZWQgRFVQIGRldmljZSBleHRlbnQgaXMgODI3MzI2NDY0
IGJ5dGVzIGxvbmcsIHdoaWNoIGlzDQo+Pj4+IGdvb2QuDQo+Pj4+DQo+Pj4+IEkgd3JvdGUgYW5k
IHRlc3RlZCB0aGlzIG9uIHRvcCBvZiBsaW51cyA0LjE5LXJjNS4gSSBzdGlsbCBuZWVkIHRvIGNy
ZWF0ZQ0KPj4+PiBhIGxpc3Qgb2YgcmVsYXRlZCB1c2UgY2FzZXMgYW5kIHRlc3QgbW9yZSB0aGlu
Z3MgdG8gYXQgbGVhc3Qgd2Fsaw0KPj4+PiB0aHJvdWdoIGEgYnVuY2ggb2Ygb2J2aW91cyB1c2Ug
Y2FzZXMgdG8gc2VlIGlmIHRoZXJlJ3Mgbm90aGluZyBleHBsb2RpbmcNCj4+Pj4gdG9vIHF1aWNr
bHkgd2l0aCB0aGVzZSBjaGFuZ2VzLiBIb3dldmVyLCBJJ20gcXVpdGUgY29uZmlkZW50IGFib3V0
IGl0LA0KPj4+PiBzbyBJJ20gc2hhcmluZyBhbGwgb2YgaXQgYWxyZWFkeS4NCj4+Pj4NCj4+Pj4g
QW55IGZlZWRiYWNrIGFuZCByZXZpZXcgaXMgYXBwcmVjaWF0ZWQuIEJlIGdlbnRsZSBhbmQga2Vl
cCBpbiBtaW5kIHRoYXQNCj4+Pj4gSSdtIHN0aWxsIHZlcnkgbXVjaCBpbiBhIGxlYXJuaW5nIHN0
YWdlIHJlZ2FyZGluZyBrZXJuZWwgZGV2ZWxvcG1lbnQuDQo+Pj4NCj4+PiBUaGUgcGF0Y2hlcyBs
b29rIGdvb2QsIHRoYW5rcy4gUHJvYmxlbSBpcyBleHBsYWluZWQsIHByZXBhcmF0b3J5IHdvcmsg
aXMNCj4+PiBzZXBhcmF0ZWQgZnJvbSB0aGUgZml4IGl0c2VsZi4NCj4+DQo+PiBcby8NCj4+DQo+
Pj4+IFRoZSBzdGFibGUgcGF0Y2hlcyBoYW5kbGluZyB3b3JrZmxvdyBpcyBub3QgMTAwJSBjbGVh
ciB0byBtZSB5ZXQuIEkNCj4+Pj4gZ3Vlc3MgSSBoYXZlIHRvIGFkZCBhIEZpeGVzOiBpbiB0aGUg
RFVQIHBhdGNoIHdoaWNoIHBvaW50cyB0byB0aGUNCj4+Pj4gcHJldmlvdXMgY29tbWl0IDkyZTIy
MmRmN2IuDQo+Pj4NCj4+PiBBbG1vc3Qgbm9ib2R5IGRvZXMgaXQgcmlnaHQsIG5vIHdvcnJpZXMu
IElmIHlvdSBjYW4gaWRlbnRpZnkgYSBzaW5nbGUNCj4+PiBwYXRjaCB0aGF0IGludHJvZHVjZXMg
YSBidWcgdGhlbiBpdCdzIGZvciBGaXhlczosIG90aGVyd2lzZSBhIENDOiBzdGFibGUNCj4+PiB3
aXRoIHZlcnNpb24gd2hlcmUgaXQgbWFrZXMgc2Vuc2UgJiBhcHBsaWVzIGlzIGVub3VnaC4gSSBk
byB0aGF0IGNoZWNrDQo+Pj4gbXlzZWxmIHJlZ2FyZGxlc3Mgb2Ygd2hhdCdzIGluIHRoZSBwYXRj
aC4NCj4+DQo+PiBJdCdzIDkyZTIyMmRmN2IgYW5kIHRoZSB0aGluZyBJJ20gbm90IHN1cmUgYWJv
dXQgaXMgaWYgaXQgYWxzbyB3aWxsDQo+PiBjYXRjaCB0aGUgc2FtZSBwYXRjaCB3aGljaCB3YXMg
YWxyZWFkeSBiYWNrcG9ydGVkIHRvIExUUyBrZXJuZWxzIHNpbmNlDQo+PiA5MmUyMjJkZjdiIGFs
c28gaGFzIEZpeGVzIGluIGl0Li4uIFNvIGJ5IG5vdyB0aGUgbmV3IGJ1ZyBpcyBpbiA0LjE5LA0K
Pj4gNC4xNCwgNC45LCA0LjQsIDMuMTYuLi4NCj4+DQo+Pj4gSSByYW4gdGhlIHBhdGNoZXMgaW4g
YSBWTSBhbmQgaGl0IGEgZGl2aXNpb24tYnktemVybyBpbiB0ZXN0DQo+Pj4gZnN0ZXN0cy9idHJm
cy8wMTEsIHN0YWNrdHJhY2UgYmVsb3cuIEZpcnN0IGd1ZXNzIGlzIHRoYXQgaXQncyBjYXVzZWQg
YnkNCj4+PiBwYXRjaCAzLzYuDQo+Pg0KPj4gQWggaW50ZXJlc3RpbmcsIGRldiByZXBsYWNlLg0K
Pj4NCj4+IEknbGwgcGxheSBhcm91bmQgd2l0aCByZXBsYWNlIGFuZCBmaW5kIG91dCBob3cgdG8g
cnVuIHRoZSB0ZXN0cyBwcm9wZXJseQ0KPj4gYW5kIHRoZW4gcmVwcm9kdWNlIHRoaXMuDQo+Pg0K
Pj4gVGhlIGNvZGUgaW50cm9kdWNlZCBpbiBwYXRjaCAzIGlzIHJlbW92ZWQgYWdhaW4gaW4gcGF0
Y2ggNiwgc28gSSBkb24ndA0KPj4gc3VzcGVjdCB0aGF0IG9uZS4gOikNCj4+DQo+PiBCdXQsIEkn
bGwgZmluZCBvdXQuDQo+Pg0KPj4gVGhhbmtzIGZvciB0ZXN0aW5nLg0KPiANCj4gSSd2ZSBtZXJn
ZWQgcGF0Y2hlcyAxLTUgdG8gbWlzYy1uZXh0IGFzIHRoZXkgc2VlbSB0byBiZSBzYWZlIGFuZCBw
YXNzDQo+IGZzdGVzdHMsIHBsZWFzZSBsZXQgbWUga25vdyB3aGVuIHlvdSBoYXZlIHVwZGF0ZXMg
dG8gdGhlIGxhc3Qgb25lLg0KPiBUaGFua3MuDQoNCkknbGwgZGVmaW5pdGVseSBmb2xsb3cgdXAg
b24gdGhhdC4gSXQgaGFzIG5vdCBoYXBwZW5lZCBiZWNhdXNlIHNvbWV0aGluZw0KYWJvdXQgdG9k
byBsaXN0cyBhbmQgb3JkZXJpbmcgd29yayBhbmQgbm90IGRvaW5nIHRvbyBtYW55IHRoaW5ncyBh
dCB0aGUNCnNhbWUgdGltZS4NCg0KVGhhbmtzIGZvciBhbHJlYWR5IGNvbmZpcm1pbmcgaXQgd2Fz
IG5vdCBwYXRjaCAzIGJ1dCA2IHRoYXQgaGFzIHRoZQ0KcHJvYmxlbSwgSSBhbHJlYWR5IHN1c3Bl
Y3RlZCB0aGF0Lg0KDQpGb3IgcGF0Y2ggMywgdGhlIGFjdHVhbCBmaXgsIGhvdyBkbyB3ZSBnZXQg
dGhhdCBvbiB0b3Agb2Ygb2xkIHN0YWJsZQ0Ka2VybmVscyB3aGVyZSB0aGUgcHJldmlvdXMgZml4
ICg5MmUyMjJkZjdiKSBpcyBpbj8gQmVjYXVzZSBvZiB0aGUgRml4ZXM6DQpsaW5lIHRoYXQgb25l
IHdhcyBwaWNrZWQgYWdhaW4gaW4gNC4xNCwgNC45LCA0LjQgYW5kIGV2ZW4gMy4xNi4gSG93IGRv
ZXMNCnRoaXMgd29yaz8gRG9lcyBpdCBuZWVkIGFsbCB0aGUgb3RoZXIgY29tbWl0IGlkcyBmcm9t
IHRob3NlIGJyYW5jaGVzIGluDQpGaXhlcyBsaW5lcz8gT3IgaXMgdGhlcmUgbWFnaWMgc29tZXdo
ZXJlIHRoYXQgZG9lcyB0aGlzPw0KDQpGcm9tIHlvdXIgImRldmVsb3BtZW50IGN5Y2xlIG9wZW4i
IG1haWxzLCBJIHVuZGVyc3RhbmQgdGhhdCBmb3IgdGVzdGluZw0KbXlzZWxmLCBJIHdvdWxkIHRl
c3QgYmFzZWQgb24gbWlzYy1uZXh0LCBmb3ItbmV4dCBvciBmb3IteC55IGluIHRoYXQNCm9yZGVy
IGRlcGVuZGluZyBvbiB3aGVyZSB0aGUgZmlyc3QgNSBhcmUgeWV0IGF0IHRoYXQgbW9tZW50Pw0K
DQpIYW5zDQo=
