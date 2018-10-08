Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD23C677D4
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 14:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF4C3204EC
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 14:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="XMbD+3Nf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF4C3204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbeJHVxG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:53:06 -0400
Received: from mail-eopbgr50044.outbound.protection.outlook.com ([40.107.5.44]:1536
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726159AbeJHVxF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 17:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CBYZdCBFNfASwSg1f5NAdc49c41DKkj3OQn/iezgiQo=;
 b=XMbD+3NfUMUQ6qcHx+0bEwXM55x8heZdfDjOeZv2+zVqKxKLQ0/BSiWtc+AHG3wvoNAWqKuoQHIN8df5viEYsYHvH6xKFHb/9D/hPiJLjpanIb5lJnZ4PbZ49zU40DI+IaymFcAfNU1RWTFrMK/44vqsjWJBKJCU4PhuLG2bDsc=
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com (52.133.57.29) by
 AM0PR06MB4596.eurprd06.prod.outlook.com (20.178.18.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.27; Mon, 8 Oct 2018 14:40:16 +0000
Received: from AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a]) by AM0PR06MB3921.eurprd06.prod.outlook.com
 ([fe80::5063:8a39:67e0:5e0a%3]) with mapi id 15.20.1207.024; Mon, 8 Oct 2018
 14:40:16 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     =?utf-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?= 
        <holger@applied-asynchrony.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Curious problem: btrfs device stats & unpriviliged access
Thread-Topic: Curious problem: btrfs device stats & unpriviliged access
Thread-Index: AQHUXxMak/ScarELJUS5tWBWYhmxkKUVa38A
Date:   Mon, 8 Oct 2018 14:40:16 +0000
Message-ID: <5eafba35-c79b-17f2-e296-aafddf06ebf1@mendix.com>
References: <05c64256-71d3-81dc-3189-628e8cc0a5db@applied-asynchrony.com>
In-Reply-To: <05c64256-71d3-81dc-3189-628e8cc0a5db@applied-asynchrony.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [85.146.242.35]
x-clientproxiedby: HE1PR0202CA0009.eurprd02.prod.outlook.com
 (2603:10a6:3:8c::19) To AM0PR06MB3921.eurprd06.prod.outlook.com
 (2603:10a6:208:b2::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR06MB4596;6:5Pj60I6OcyfmuWDkse/va43gIWs6BK2PegxgNZT+0NjsJiOoUvXHW5jLhVD77WuzBbbx+sk1rkhntKQn6JE0c/R9Z1ZEin3He4tbtnFISp4jXXHNy/c7OToitvzcL3d9weWnNRLD4OrF/jK25pLS5u0LQ9dy1dvrYLNaUPFDOYnSRrH9LzuBtjdb8RQjaPRRYh/+bnxQcE7D9kT3aCaWLt/IppQhfaTGZBScGoGuNtzGtIhGTwpsDuozME1Rsu4botzr9jV77gAWi0YbNcHbF+eUMI7M1BsMLbDN0e9GdU1Oq3tUFRh2kfHs31TFYztz/Vk5/zK2Ejn85sblHsTmwWKJexUa04P15CJHFJRTTKz25sb6XqU9/pQuLxHnpn4HoNT6/j7Ah3yQi751QlfhoAhNn280OIuFNexlDLSNbh/LJi5aT4Gjcs8xX+gJ0thcol7GV2UjVKygNJi67MBvWg==;5:1TggckD06l/cGMEHEMxR9T/UDNOO1yNgex2IoKLCh5j8fMXX4RvdodkcdsP7nkgux/vsXoOvFAW7L6neTCcIpOdYxde3h60LQ87LuI2srF88Qf74rVCUGgQzzbEADcK3YC9GZq5Br8wgFv+rBdS6WWRTtp4S8aPY+YltIL4oehw=;7:PyCSytpZXCaFNKA4RuQHLZB5XutPcEj0aUO9P8zo8zRxzTacPPnzrsyzqFAubpX3FekMd4pbRaucytc8TWj6TU7CKBCipmCrNr0n9nb5sZ0R16WNdWEX57YHBiD93kCClYrjVliqGnWRqjwlz3XZpb5kjqigNdNVJSlSt8hXOcYoloAf1qx87VRmVhOoBUnR34v+zhLM24fUp124fT5ver9T8OpFcQpBDSAAH3iO6zUr7++5yaLm7Kn1AsltJHkK
x-ms-office365-filtering-correlation-id: b6bbdecf-2366-46e9-0d51-08d62d2bf692
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:AM0PR06MB4596;
x-ms-traffictypediagnostic: AM0PR06MB4596:
x-microsoft-antispam-prvs: <AM0PR06MB4596E1598959B051D27FD3AAD4E60@AM0PR06MB4596.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(166708455590820);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(93006095)(93001095)(3231355)(944501410)(52105095)(10201501046)(3002001)(149066)(150057)(6041310)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123560045)(20161123558120)(201708071742011)(7699051);SRVR:AM0PR06MB4596;BCL:0;PCL:0;RULEID:;SRVR:AM0PR06MB4596;
x-forefront-prvs: 081904387B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(346002)(136003)(376002)(189003)(199004)(72206003)(66574009)(65956001)(65806001)(6506007)(316002)(71200400001)(11346002)(71190400001)(446003)(64126003)(110136005)(3846002)(6246003)(53936002)(36756003)(476003)(66066001)(2616005)(86362001)(256004)(8936002)(58126008)(966005)(6116002)(14454004)(2900100001)(229853002)(7736002)(5660300001)(97736004)(2906002)(14444005)(31696002)(65826007)(53546011)(386003)(478600001)(68736007)(8676002)(305945005)(81166006)(81156014)(486006)(76176011)(52116002)(102836004)(105586002)(26005)(6512007)(6306002)(6436002)(106356001)(25786009)(31686004)(186003)(6486002)(5250100002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR06MB4596;H:AM0PR06MB3921.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: KipVOdepoSW3svlP+bhdEW0kg5bY9A6BKDN0ln6UY0LOxIZhyNv/YANo/2oWxPG4Er+XS+Oa5AgaDr8EDQioWPs9Gaf2adf8Q/C2Sz5ShnZwAknbYk9w+NUbTLC4M2vtO75q+bwXSCQuBK2mqDkkJWVG6i99OfKTA1pMvxw3Z8ogAwR/Asom0b7uOy2ZN7SWCKl5ew+xohVlng5hRzbPDRq4rru7IdV93S54nW6ZtQz5eJxdCyPuI+S1qi5h/SX8bfM68lv+1eHgagzWvT7d00WM1FUztlmsVz2Xgw8KYohCld8LpT48/drcUjeJ9VkEMgCJhvDzm9p7NtqaMyhgGA==
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <2061D25C1830B74F8C2F8F63937B82FA@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6bbdecf-2366-46e9-0d51-08d62d2bf692
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2018 14:40:16.8248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB4596
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMDgvMjAxOCAwNDoyNyBQTSwgSG9sZ2VyIEhvZmZzdMOkdHRlIHdyb3RlOg0KPiAobW92
aW5nIHRoZSBkaXNjdXNzaW9uIGhlcmUgZnJvbSBHSCBbMV0pDQo+IA0KPiBBcHBhcmVudGx5IHRo
ZXJlIGlzIHNvbWV0aGluZyB3ZWlyZCBnb2luZyBvbiB3aXRoIHRoZSBkZXZpY2Ugc3RhdHMNCj4g
aW9jdGxzLiBJIGNhbm5vdCBnZXQgdGhlbSB0byB3b3JrIGFzIHJlZ3VsYXIgdXNlciwgd2hpbGUg
dGhleSB3b3JrDQo+IGZvciBEYXZpZC4gQSBmcmllbmQgY29uZmlybXMgdGhlIHNhbWUgaXNzdWUg
b24gaGlzIHN5c3RlbSAtIG5vIGFjY2Vzcw0KPiBhcyBub24tcm9vdC4NCj4gDQo+IFNvIEkgbWFk
ZSBhIG5ldyBlbXB0eSBmcywgbW91bnRlZCBpdCwgYnVpbHQgYnRyZnMtcHJvZ3MtNC4xNy4xIHdp
dGgNCj4gZGVidWcgc3ltYm9scyBhbmQgc3RlcHBlZCBpbnRvIHNlYXJjaF9jaHVua190cmVlX2Zv
cl9mc19pbmZvKCkuDQo+IEV2ZXJ5dGhpbmcgaXMgZmluZSwgYWxsIGFyZ3MgYXJlIGNvcnJlY3Qs
IHJpZ2h0IHVudGlsOg0KPiANCj4gKGdkYikgcw0KPiAxNjE0wqDCoMKgIHJldCA9IGlvY3RsKGZk
LCBCVFJGU19JT0NfVFJFRV9TRUFSQ0gsICZzZWFyY2hfYXJncyk7DQo+IChnZGIpIHMNCj4gMTYx
NcKgwqDCoCBpZiAocmV0IDwgMCkNCj4gKGdkYikgcCByZXQNCj4gJDQgPSAtMQ0KPiAoZ2RiKSBw
IHNlYXJjaF9hcmdzDQo+ICQ1ID0ge2tleSA9IHt0cmVlX2lkID0gMywgbWluX29iamVjdGlkID0g
MSwgbWF4X29iamVjdGlkID0gMSwgbWluX29mZnNldA0KPiA9IDEsDQo+IG1heF9vZmZzZXQgPSAx
ODQ0Njc0NDA3MzcwOTU1MTYxNSwgbWluX3RyYW5zaWQgPSAwLCBtYXhfdHJhbnNpZCA9DQo+IDE4
NDQ2NzQ0MDczNzA5NTUxNjE1LA0KPiBtaW5fdHlwZSA9IDIxNiwgbWF4X3R5cGUgPSAyMTYsIG5y
X2l0ZW1zID0gMzAsIHVudXNlZCA9IDAsIHVudXNlZDEgPSAwLA0KPiB1bnVzZWQyID0gMCwNCj4g
dW51c2VkMyA9IDAsIHVudXNlZDQgPSAwfSwgYnVmID0gJ1wwMDAnIDxyZXBlYXRzIDM5OTEgdGlt
ZXM+fQ0KPiANCj4gTG9va2luZyBhdCB0aGUga2VybmVsIHNpZGUgb2YgdGhpbmdzIGluIGZzL2J0
cmZzL2lvY3RsLmMgSSBzZWUgYm90aA0KPiBCVFJGU19JT0NfVFJFRV9TRUFSQ0hbX1YyfSB1bmNv
bmRpdGlvbmFsbHkgcmVxdWlyZSBDQVBfU1lTX0FETUlOLg0KDQpUaGF0J3MgdGhlIHRyZWUgc2Vh
cmNoIGlvY3RsLCBmb3IgcmVhZGluZyBhcmJpdHJhcnkgbWV0YWRhdGEuDQoNClRoZSBkZXZpY2Ug
c3RhdHMgaW9jdGwgaXMgSU9DX0dFVF9ERVZfU1RBVFMuLi4NCg0KSSBjYW4gZG8gdGhlIGRldmlj
ZSBzdGF0cyBpb2N0bCBhcyBub3JtYWwgdXNlcjoNCg0KaW1wb3J0IGJ0cmZzDQpmcyA9IGJ0cmZz
LkZpbGVTeXN0ZW0oJy8nKQ0KYnRyZnMudXRpbHMucHJldHR5X3ByaW50KGZzLmRldl9zdGF0cygx
KSkNCg0KPGJ0cmZzLmlvY3RsLkRldlN0YXRzPg0KZGV2aWQ6IDENCm5yX2l0ZW1zOiA1DQpmbGFn
czogMA0Kd3JpdGVfZXJyczogMA0KcmVhZF9lcnJzOiAwDQpmbHVzaF9lcnJzOiAwDQpnZW5lcmF0
aW9uX2VycnM6IDANCmNvcnJ1cHRpb25fZXJyczogMA0KDQo+IFNvIHdoeSBjYW4gRGF2ZSBnZXQg
aGlzIGRldiBzdGF0cyBhcyB1bnByaXZpbGVnZWQgdXNlcj8NCj4gRG9lcyB0aGlzIHdvcmsgZm9y
IGFueWJvZHkgZWxzZT8gQW5kIHdoeT8gOikNCj4gDQo+IGNoZWVycw0KPiBIb2xnZXINCj4gDQo+
IFsxXQ0KPiBodHRwczovL2dpdGh1Yi5jb20vcHJvbWV0aGV1cy9ub2RlX2V4cG9ydGVyL2lzc3Vl
cy8xMTAwI2lzc3VlY29tbWVudC00Mjc4MjMxOTANCj4gDQoNCg0KLS0gDQpIYW5zIHZhbiBLcmFu
ZW5idXJnDQo=
