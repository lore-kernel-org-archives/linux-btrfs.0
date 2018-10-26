Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797AAC6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DAAD2084D
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:37:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="Ml4VYQcl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DAAD2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbeJZVN6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 17:13:58 -0400
Received: from mail-eopbgr30069.outbound.protection.outlook.com ([40.107.3.69]:20064
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727607AbeJZVN6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 17:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VNvlWewJhY5aJXj1bwgVXsgCP/w4zywjlXwb5ORIq8=;
 b=Ml4VYQclS8z794MXjUfaYKsTztSTKkJNYiesqjP7KW2prEHpbURk2HPV4Z7SBntxi4qiWHDHLZpQNN9ipxdUkaInSleHjn9FFx4WkGMLmtl3oyPHm1mbHiLxCl9ev7e/oEYls4qipY80SZeGebtbtiL9ySADYFuVyBqpIeWTnuM=
Received: from DB7PR06MB4680.eurprd06.prod.outlook.com (20.177.122.217) by
 DB7PR06MB4332.eurprd06.prod.outlook.com (52.135.140.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.30; Fri, 26 Oct 2018 12:36:57 +0000
Received: from DB7PR06MB4680.eurprd06.prod.outlook.com
 ([fe80::e57d:581a:45fb:622]) by DB7PR06MB4680.eurprd06.prod.outlook.com
 ([fe80::e57d:581a:45fb:622%5]) with mapi id 15.20.1273.025; Fri, 26 Oct 2018
 12:36:57 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/5] btrfs: Ensure at least 1g is free for balance
Thread-Topic: [PATCH 1/5] btrfs: Ensure at least 1g is free for balance
Thread-Index: AQHUbSEcl2ddzdacXkeVbplQvVUn1KUxkK+A///gcQCAAAXHAA==
Date:   Fri, 26 Oct 2018 12:36:57 +0000
Message-ID: <2e142754-d328-bf29-97db-cae5c227bc53@mendix.com>
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-2-git-send-email-nborisov@suse.com>
 <34b2d8ff-d4f0-63a9-eb49-c26d9b84737c@mendix.com>
 <6b03ed20-4ee6-4342-c287-618343f3b8ad@suse.com>
In-Reply-To: <6b03ed20-4ee6-4342-c287-618343f3b8ad@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
x-originating-ip: [85.146.242.35]
x-clientproxiedby: AM5PR0701CA0002.eurprd07.prod.outlook.com
 (2603:10a6:203:51::12) To DB7PR06MB4680.eurprd06.prod.outlook.com
 (2603:10a6:10:53::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB7PR06MB4332;6:tqikdPmVzcBO4s2jQbW0iLvlRi/veobQA/YPKhED+NW5OQUV1w8jwUieSclU8RrtUWiQjyB76C7SqKIfmJKItM6TdCFWnQoT/sQ2JIEMf2AJapu3VEJyRl/VVKOGBxVyxuhKn54sczse3AjaFlW8UeL/bSnstxBY4kERzfn9aJMl3N08qaEx1bN3NVcrilGKc2qofHeFfkbHjZ3VbmJQlcrn4sK2BzVznpy6qqG4MDOXyc1JEduvHLmj95moddi+yVLg6wSh+OulfXKkbR8VVxtFlRGNDJ2zadhygoh+1Sm3wOF6+919XW2u484JZ8PL75JVU15H+2KZlt6gwRY5ky3MQp8BY+xPgtVaSTBKAOGdhUfJdem/5Ask+gBR4voMgWR/JqVynqLGYpFiKDaAWtt7N+nG9+crhA8aaYnceZocNhhLT7JG57buP6lnIqTaT5Jn609IcEUrQQFjw5HmZg==;5:bSzK5mfRxI4aVHC55r2Jp4F3TekvmbZn23/Wjjkp8BaPNv0JDrdLO2XTsPrwQ77/0uaS9MbAPecwG+h6dRrS3LGnuLP7OhyNzrFn373e0DUlpk+YA+AXWCXUCdF1rEHULrb+Nz4sn7Fa1iheC6VUBHgBX2VkTElRCedFwInZYaA=;7:CX54urC5sUTGmxa4V0f0YgD1IGPqHGRfrKvuAmLoz4ITCGkkBvDAkZt7Ibj2VQPyWxAQGrEvf0zeVvYz1y+2ytiSiIUxRglIAYUkBMxOwJhtNd43VT7SLidDSBpc1ePpp2QoFQ83XYSv+vzcCFhwNVEULAyjrZs6F3nMdhnIbybI/HeD1bwh/u72pOdKVJMqqzyQk7x3NgfEUYOCvkA7DDbJ5CFl0N3MjQncwby6XG+zyrWn04DDA3AGKqzDEg6h
x-ms-office365-filtering-correlation-id: 00d1f87c-a07a-44f0-ee91-08d63b3fb7dc
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DB7PR06MB4332;
x-ms-traffictypediagnostic: DB7PR06MB4332:
x-microsoft-antispam-prvs: <DB7PR06MB43327E59AB8256D0C4664540D4F00@DB7PR06MB4332.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123562045)(20161123564045)(20161123560045)(201708071742011)(7699051)(76991095);SRVR:DB7PR06MB4332;BCL:0;PCL:0;RULEID:;SRVR:DB7PR06MB4332;
x-forefront-prvs: 083751FCA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(39850400004)(346002)(376002)(189003)(199004)(52116002)(76176011)(25786009)(81166006)(81156014)(4326008)(2900100001)(99286004)(5250100002)(53936002)(31696002)(65806001)(2501003)(305945005)(68736007)(6506007)(53546011)(66066001)(65956001)(7736002)(72206003)(102836004)(386003)(14454004)(5660300001)(36756003)(65826007)(105586002)(31686004)(106356001)(478600001)(93886005)(6116002)(86362001)(575784001)(316002)(97736004)(71200400001)(58126008)(71190400001)(3846002)(6436002)(229853002)(8936002)(14444005)(256004)(11346002)(446003)(6512007)(486006)(2616005)(476003)(26005)(8676002)(6246003)(110136005)(6486002)(2906002)(64126003)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR06MB4332;H:DB7PR06MB4680.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: EnlxSJB8FyXB/ZWOgadBnJ8DapEzl5d2s2kvmTxqSw6dJSHOM80Gn7FdzLNuTmYXftXiYt3OpztoJJvzDqj3xucxdIJf52bcwvEINwjuh+EGiz5YWu+fqWLhPzRVRs9WeZmskDq41cUoytKOgJ5PV2qD4XHnXW2w1YzJC05gvJLt0fyWi7aWbvGNLHQx/UYWyNzPuUxuLY3lPAp7jllmf7Ikq9aVAu+5ACnjsxIHWvQRf2KCXN8jrh7bhTQFxe1EvMv3DRvpKYNOfRHVcDTub5sxssxTZLiRpPawhFl+EuBfrbcKTJMvU1jUJAF92TsQFLGe7S+bsLhIdv0H3eZmHC80xfjmHFwFkhAzk9ejJ60=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <41FDA68BE1E8CD48B77323E1B48A1061@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d1f87c-a07a-44f0-ee91-08d63b3fb7dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2018 12:36:57.8655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB4332
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMjYvMTggMjoxNiBQTSwgTmlrb2xheSBCb3Jpc292IHdyb3RlOg0KPiANCj4gKEFkZGlu
ZyBDaHJpcyB0byBDQyBzaW5jZSBoZSBpcyB0aGUgb3JpZ2luYWwgYXV0aG9yIG9mIHRoZSBjb2Rl
KQ0KPiANCj4gT24gMjYuMTAuMjAxOCAxNTowOSwgSGFucyB2YW4gS3JhbmVuYnVyZyB3cm90ZToN
Cj4+IE9uIDEwLzI2LzE4IDE6NDMgUE0sIE5pa29sYXkgQm9yaXNvdiB3cm90ZToNCj4+PiBUaGUg
Zmlyc3QgcGFydCBvZiBiYWxhbmNlIG9wZXJhdGlvbiBpcyB0byBzaHJpbmsgZXZlcnkgY29uc3Rp
dHV0aW5nDQo+Pj4gZGV2aWNlIHRvIGVuc3VyZSB0aGVyZSBpcyBmcmVlIHNwYWNlIGZvciBjaHVu
ayBhbGxvY2F0aW9uLg0KPj4NCj4+IEEgdmVyeSB1c2VmdWwgdGhpbmcgdG8gYmUgYWJsZSB0byBk
byBpZiB0aGVyZSdzIG5vIHVuYWxsb2NhdGVkIHJhdyBkaXNrDQo+PiBzcGFjZSBsZWZ0LCBpcyB1
c2UgYmFsYW5jZSB0byByZXdyaXRlIHNvbWUgYmxvY2tncm91cCBpbnRvIHRoZSBmcmVlDQo+PiBz
cGFjZSBvZiBvdGhlciBvbmVzLg0KPj4NCj4+IFRoaXMgZG9lcyBub3QgbmVlZCBhbnkgcmF3IHNw
YWNlIGZvciBhIGNodW5rIGFsbG9jYXRpb24uIFJlcXVpcmluZyBzbw0KPj4gbWFrZXMgaXQgdW5u
ZWNjZXNhcmlseSBtb3JlIGNvbXBsaWNhdGVkIGZvciB1c2VycyB0byBmaXggdGhlIHNpdHVhdGlv
bg0KPj4gdGhleSBnb3QgaW4uDQo+IA0KPiBUaGUgY3VycmVudCBsb2dpYyBvZiB0aGUgY29kZSBk
b2Vzbid0IHByZWNsdWRlIHRoaXMgdXNlIGNhc2Ugc2luY2UgaWYgd2UNCj4gY2FuJ3Qgc2hyaW5r
IHdlIGp1c3QgcHJvY2VlZCB0byByZWxvY2F0aW9uLiBTbyBldmVuIGlmIDFnIGlzIHJlcGxhY2Vk
DQo+IHdpdGggNWViIGFuZCBzaHJpbmtfZGV2aWNlIGFsd2F5cyBmYWlscyBiYWxhbmNpbmcgd2ls
bCBzdGlsbCBwcm9jZWVkLg0KPiANCj4gSG93ZXZlciwgYWxsIG9mIHRoaXMgcmVhbGx5IG1ha2Vz
IG1lIHdvbmRlciBkbyB3ZSBldmVuIG5lZWQgdGhpcyAiZmlyc3QNCj4gc3RhZ2UiIGNvZGUgaW4g
YmFsYW5jaW5nIChDaHJpcywgYW55IHRob3VnaHRzPykuDQoNCkhhdmluZyBzb21ldGhpbmcgdGhh
dCB0cmllcyB0byBmcmVlIHVwIDFHIG9uIGVhY2ggZGV2aWNlIGNhbiBiZSB2ZXJ5DQp1c2VmdWwg
d2hlbiBjb252ZXJ0aW5nIHRvIGFub3RoZXIgcHJvZmlsZS4gSSBndWVzcyB0aGF0J3Mgd2h5IGl0
IGlzIHRoZXJlLg0KDQpBbmQgc2hyaW5rIGRldmljZSArIGdyb3cgZGV2aWNlIGlzIGEgbmljZSB3
YXkgdG8gdHJ5IHBhY2tpbmcgc29tZSBkYXRhDQppbnRvIG90aGVyIGV4aXN0aW5nIGJsb2NrIGdy
b3Vwcy4gT25seS4uLiBpZiBzaHJpbmsrZ3JvdyBpcyBkb25lIGZvcg0KZWFjaCBkZXZpY2UgYWZ0
ZXIgZWFjaCBvdGhlciwgYW5kIHRoZXJlJ3Mgb25lIHdpdGggMUcgdW5hbGxvY2F0ZWQgbGVmdCwN
CmFuZCBpdCBjYW4ndCBlYXNpbHkgbW92ZSBpdCBpbnRvIGV4aXN0aW5nIGZyZWUgc3BhY2UsIHRo
ZW4gaXQgbWF5IGp1c3QNCmJlIG1vdmluZyBkYXRhIGFyb3VuZCB0byB0aGUgbmV4dCBkaXNrIGFs
bCB0aGUgdGltZSBJIGd1ZXNzLCBlbmRpbmcgdXANCndpdGggdGhlIHNhbWUgc2l0dWF0aW9uIGFz
IGJlZm9yZS4gOkQNCg0KPj4+IEhvd2V2ZXIsIHRoZSBjb2RlDQo+Pj4gaGFzIGJlZW4gYnVnZ3kg
ZXZlciBzaW5jZSBpdHMgaW50cm9kdWN0aW9uIHNpbmNlIGNhbGN1bGF0aW5nIHRoZSBzcGFjZSB0
byBzaHJpbmsNCj4+PiB0aGUgZGV2aWNlIGJ5IHdhcyBib3VuZGVkIGJ5IDEgbWIuIE1vc3QgbGlr
ZWx5IHRoZSBvcmlnaW5hbCBpbnRlbnRpb24gd2FzIHRvDQo+Pj4gaGF2ZSBhbiB1cHBlciBib3Vu
ZCBvZiAxZyBhbmQgbm90IDFtLCBzaW5jZSB0aGUgbGFyZ2VzdCBjaHVuayBzaXplIGlzIDFnLiBU
aGlzIA0KPj4+IG1lYW5zIHRoZSBmaXJzdCBzdGFnZSBpbiBfX2J0cmZzX2JhbGFuY2Ugc28gZmFy
IGhhcyBiZWVuIGEgbnVsbCBvcCBzaW5jZSBpdA0KPj4+IGVmZmVjdGl2ZWx5IGZyZWVkIGp1c3Qg
YSBzaW5nbGUgbWVnYWJ5dGUuDQo+Pj4NCj4+PiBGaXggdGhpcyBieSBzZXR0aW5nIGFuIHVwcGVy
IGJvdW5kIG9mIHNpemVfdG9fZnJlZSBvZiAxZy4gDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBO
aWtvbGF5IEJvcmlzb3YgPG5ib3Jpc292QHN1c2UuY29tPg0KPj4+IC0tLQ0KPj4+ICBmcy9idHJm
cy92b2x1bWVzLmMgfCAyICstDQo+Pj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL3ZvbHVtZXMuYyBi
L2ZzL2J0cmZzL3ZvbHVtZXMuYw0KPj4+IGluZGV4IGY0MzVkMzk3MDE5ZS4uOGIwZmQ3YmYzNDQ3
IDEwMDY0NA0KPj4+IC0tLSBhL2ZzL2J0cmZzL3ZvbHVtZXMuYw0KPj4+ICsrKyBiL2ZzL2J0cmZz
L3ZvbHVtZXMuYw0KPj4+IEBAIC0zNDY3LDcgKzM0NjcsNyBAQCBzdGF0aWMgaW50IF9fYnRyZnNf
YmFsYW5jZShzdHJ1Y3QgYnRyZnNfZnNfaW5mbyAqZnNfaW5mbykNCj4+PiAgCWxpc3RfZm9yX2Vh
Y2hfZW50cnkoZGV2aWNlLCBkZXZpY2VzLCBkZXZfbGlzdCkgew0KPj4+ICAJCW9sZF9zaXplID0g
YnRyZnNfZGV2aWNlX2dldF90b3RhbF9ieXRlcyhkZXZpY2UpOw0KPj4+ICAJCXNpemVfdG9fZnJl
ZSA9IGRpdl9mYWN0b3Iob2xkX3NpemUsIDEpOw0KPj4+IC0JCXNpemVfdG9fZnJlZSA9IG1pbl90
KHU2NCwgc2l6ZV90b19mcmVlLCBTWl8xTSk7DQo+Pj4gKwkJc2l6ZV90b19mcmVlID0gbWluX3Qo
dTY0LCBzaXplX3RvX2ZyZWUsIFNaXzFHKTsNCj4+PiAgCQlpZiAoIXRlc3RfYml0KEJUUkZTX0RF
Vl9TVEFURV9XUklURUFCTEUsICZkZXZpY2UtPmRldl9zdGF0ZSkgfHwNCj4+PiAgCQkgICAgYnRy
ZnNfZGV2aWNlX2dldF90b3RhbF9ieXRlcyhkZXZpY2UpIC0NCj4+PiAgCQkgICAgYnRyZnNfZGV2
aWNlX2dldF9ieXRlc191c2VkKGRldmljZSkgPiBzaXplX3RvX2ZyZWUgfHwNCj4+Pg0KPj4NCj4+
DQoNCg0KLS0gDQpIYW5zIHZhbiBLcmFuZW5idXJnDQo=
