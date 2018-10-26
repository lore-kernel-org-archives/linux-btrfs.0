Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8A9C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A38C32064C
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="LWglUAFz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A38C32064C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbeJZUqt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:46:49 -0400
Received: from mail-eopbgr00083.outbound.protection.outlook.com ([40.107.0.83]:25731
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727491AbeJZUqt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 16:46:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/r+mIZPbKP0DdxvjoK83RazEOJpqF1hwpXs7/q0xIrA=;
 b=LWglUAFzcSbVR/oTrQ/bWMHr88FGJz8QXJCmJjTqxJwj5g/sm9HAee2wi6LcmRNjaXf3MqJo9vXwTi+c3fvEu0CkFQVi4wRuNntOE+nssea6KF+kCWmcfJpx8XMDkugxLdufv+66SGHas9qguvhnWbZ74UjlyDJ02lFhzRYkK84=
Received: from DB7PR06MB4680.eurprd06.prod.outlook.com (20.177.122.217) by
 DB7PR06MB5353.eurprd06.prod.outlook.com (20.178.47.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1250.30; Fri, 26 Oct 2018 12:09:15 +0000
Received: from DB7PR06MB4680.eurprd06.prod.outlook.com
 ([fe80::e57d:581a:45fb:622]) by DB7PR06MB4680.eurprd06.prod.outlook.com
 ([fe80::e57d:581a:45fb:622%5]) with mapi id 15.20.1273.025; Fri, 26 Oct 2018
 12:09:15 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/5] btrfs: Ensure at least 1g is free for balance
Thread-Topic: [PATCH 1/5] btrfs: Ensure at least 1g is free for balance
Thread-Index: AQHUbSEcl2ddzdacXkeVbplQvVUn1KUxbyiA
Date:   Fri, 26 Oct 2018 12:09:15 +0000
Message-ID: <34b2d8ff-d4f0-63a9-eb49-c26d9b84737c@mendix.com>
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1540554201-11305-2-git-send-email-nborisov@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
x-originating-ip: [85.146.242.35]
x-clientproxiedby: AM6PR02CA0028.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::41) To DB7PR06MB4680.eurprd06.prod.outlook.com
 (2603:10a6:10:53::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB7PR06MB5353;6:YEkmIpo6d5QdwBvKjEx0Nl3NMelhbRwg81EBkJ7p7i1VGoGfLSzS0nML4ycVqU4TJ/u8OEQTQkRvjPmuj2A5zOKtBDbjcSP7HQQP41uRtSEYk0oT7MxnqIJh7hoSzWUxG+HAJUZL+HAZ84F/jhvVGFdGBNw3zMOwMmNCAGeihktc4IrKrFzbJ6nsqrj+i3fld6i81h+LRv7gfEwSVYVBJDHjFDUsvhIopbrgijNkcS6TMxQ+vG1f3CTK6uam1+EJ4veCA3d8FduoPMeqQz8D3pykuZivw6AyUPk5jmWyIF/KKP+0AWBnF3RkUKzjwUvGipWQgCRMz+cGl1wYcezRQ1Nu6oYqWDZGR50vLQtd7iZOPsFHZp87X8yGtdeQ2SPwKUxLomxtElhXf2IGC+4t6epm8JhM+FJ1zMY4SKHMXtJDcZI2VMw41bzSK2hUmlu3GRGWnbMTvjNUrnxWojuYRQ==;5:gz8a3rfDCzzm7H8bAYtCYY8Hge3GjTcZJcIvFcoG3qrHUF8ka4Uqunx+3ApugISs2xcoGr7OBOAGECI7BaNZ9ZwPOBgErkkJnDNyUnc8JpwsXiUpXkQP2jcpoMBf3fSu1qxZO7CYKiAQaOYnqF1BMU1Cvm1qnLQ+M9XaDJbD97c=;7:pOTgNHh73DlQYzubNAZ+xDd2HDDmvFPviWz/gTiTQe7qYRrukJmdKfnCmM7QUEnnCJ0wIPcRadqX3kaKN6/GegYIywyWdwIAZceXeqDA1793ADl27ulI1kWu//QmB4M/UL88dn2WclRnM0M/NNvnfufDCmUVqNiv+/hxBmh6GA5PHe7dnC7c8TqZMYiM7MU3yPjUhmX3kiyQ0FAWqyh3XiSVHCB4Ts9co8dYDI13f0vxueF8SGNEY43IyYAB8O/n
x-ms-office365-filtering-correlation-id: 9f530c08-5efc-4471-2371-08d63b3bd8bd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:DB7PR06MB5353;
x-ms-traffictypediagnostic: DB7PR06MB5353:
x-microsoft-antispam-prvs: <DB7PR06MB5353360EF48A4CE5BECCD237D4F00@DB7PR06MB5353.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(10201501046)(93006095)(93001095)(3002001)(3231355)(944501410)(52105095)(148016)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:DB7PR06MB5353;BCL:0;PCL:0;RULEID:;SRVR:DB7PR06MB5353;
x-forefront-prvs: 083751FCA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(39850400004)(346002)(396003)(189003)(199004)(8936002)(106356001)(53936002)(31696002)(229853002)(2501003)(6486002)(65826007)(58126008)(76176011)(2906002)(102836004)(316002)(26005)(5250100002)(110136005)(11346002)(2900100001)(14454004)(476003)(97736004)(478600001)(14444005)(256004)(7736002)(72206003)(486006)(6512007)(6436002)(305945005)(575784001)(446003)(386003)(6246003)(6116002)(81166006)(65806001)(3846002)(64126003)(71200400001)(66066001)(186003)(86362001)(8676002)(99286004)(71190400001)(81156014)(6506007)(5660300001)(65956001)(53546011)(68736007)(105586002)(52116002)(2616005)(25786009)(36756003)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR06MB5353;H:DB7PR06MB4680.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: c6t5+5wdDKZjtCsVdeWWwnZhMrh4e1u58XNq6NSS3A7WIndis0CJFjwkid2bLRB6T6jkYKABSvuEHWUFaDPPecw+V18HYj+ZzLE9o9pw3mYdbcoYnm2NZsUNyC1l0mZvm9ZMSlCxFJXDkq6BBQLaoXfuLVmgspHevQiUPkYmFkRqTZTVombkMgAun4v1xaXLxf5GsUB7fLc5QAmU1U4dqAaS/3qpelYgXTfcHH6WBGGW49tJ+oxoUhpYE33R4u0OXCDoipcxx9laLGhOe8hWEvPNiY5POtZMX0yymagW/QlCQpP06T2lNbBBm1nQzJulS2sc+ex99WzRbjcHP+G7TuZ0FZekPWWpwgvfpvQKqpM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C2ABFF16C33AB44AB4E7E903AD1116F@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f530c08-5efc-4471-2371-08d63b3bd8bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2018 12:09:15.0531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB5353
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMjYvMTggMTo0MyBQTSwgTmlrb2xheSBCb3Jpc292IHdyb3RlOg0KPiBUaGUgZmlyc3Qg
cGFydCBvZiBiYWxhbmNlIG9wZXJhdGlvbiBpcyB0byBzaHJpbmsgZXZlcnkgY29uc3RpdHV0aW5n
DQo+IGRldmljZSB0byBlbnN1cmUgdGhlcmUgaXMgZnJlZSBzcGFjZSBmb3IgY2h1bmsgYWxsb2Nh
dGlvbi4NCg0KQSB2ZXJ5IHVzZWZ1bCB0aGluZyB0byBiZSBhYmxlIHRvIGRvIGlmIHRoZXJlJ3Mg
bm8gdW5hbGxvY2F0ZWQgcmF3IGRpc2sNCnNwYWNlIGxlZnQsIGlzIHVzZSBiYWxhbmNlIHRvIHJl
d3JpdGUgc29tZSBibG9ja2dyb3VwIGludG8gdGhlIGZyZWUNCnNwYWNlIG9mIG90aGVyIG9uZXMu
DQoNClRoaXMgZG9lcyBub3QgbmVlZCBhbnkgcmF3IHNwYWNlIGZvciBhIGNodW5rIGFsbG9jYXRp
b24uIFJlcXVpcmluZyBzbw0KbWFrZXMgaXQgdW5uZWNjZXNhcmlseSBtb3JlIGNvbXBsaWNhdGVk
IGZvciB1c2VycyB0byBmaXggdGhlIHNpdHVhdGlvbg0KdGhleSBnb3QgaW4uDQoNCj4gSG93ZXZl
ciwgdGhlIGNvZGUNCj4gaGFzIGJlZW4gYnVnZ3kgZXZlciBzaW5jZSBpdHMgaW50cm9kdWN0aW9u
IHNpbmNlIGNhbGN1bGF0aW5nIHRoZSBzcGFjZSB0byBzaHJpbmsNCj4gdGhlIGRldmljZSBieSB3
YXMgYm91bmRlZCBieSAxIG1iLiBNb3N0IGxpa2VseSB0aGUgb3JpZ2luYWwgaW50ZW50aW9uIHdh
cyB0bw0KPiBoYXZlIGFuIHVwcGVyIGJvdW5kIG9mIDFnIGFuZCBub3QgMW0sIHNpbmNlIHRoZSBs
YXJnZXN0IGNodW5rIHNpemUgaXMgMWcuIFRoaXMgDQo+IG1lYW5zIHRoZSBmaXJzdCBzdGFnZSBp
biBfX2J0cmZzX2JhbGFuY2Ugc28gZmFyIGhhcyBiZWVuIGEgbnVsbCBvcCBzaW5jZSBpdA0KPiBl
ZmZlY3RpdmVseSBmcmVlZCBqdXN0IGEgc2luZ2xlIG1lZ2FieXRlLg0KPiANCj4gRml4IHRoaXMg
Ynkgc2V0dGluZyBhbiB1cHBlciBib3VuZCBvZiBzaXplX3RvX2ZyZWUgb2YgMWcuIA0KPiANCj4g
U2lnbmVkLW9mZi1ieTogTmlrb2xheSBCb3Jpc292IDxuYm9yaXNvdkBzdXNlLmNvbT4NCj4gLS0t
DQo+ICBmcy9idHJmcy92b2x1bWVzLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9idHJmcy92b2x1
bWVzLmMgYi9mcy9idHJmcy92b2x1bWVzLmMNCj4gaW5kZXggZjQzNWQzOTcwMTllLi44YjBmZDdi
ZjM0NDcgMTAwNjQ0DQo+IC0tLSBhL2ZzL2J0cmZzL3ZvbHVtZXMuYw0KPiArKysgYi9mcy9idHJm
cy92b2x1bWVzLmMNCj4gQEAgLTM0NjcsNyArMzQ2Nyw3IEBAIHN0YXRpYyBpbnQgX19idHJmc19i
YWxhbmNlKHN0cnVjdCBidHJmc19mc19pbmZvICpmc19pbmZvKQ0KPiAgCWxpc3RfZm9yX2VhY2hf
ZW50cnkoZGV2aWNlLCBkZXZpY2VzLCBkZXZfbGlzdCkgew0KPiAgCQlvbGRfc2l6ZSA9IGJ0cmZz
X2RldmljZV9nZXRfdG90YWxfYnl0ZXMoZGV2aWNlKTsNCj4gIAkJc2l6ZV90b19mcmVlID0gZGl2
X2ZhY3RvcihvbGRfc2l6ZSwgMSk7DQo+IC0JCXNpemVfdG9fZnJlZSA9IG1pbl90KHU2NCwgc2l6
ZV90b19mcmVlLCBTWl8xTSk7DQo+ICsJCXNpemVfdG9fZnJlZSA9IG1pbl90KHU2NCwgc2l6ZV90
b19mcmVlLCBTWl8xRyk7DQo+ICAJCWlmICghdGVzdF9iaXQoQlRSRlNfREVWX1NUQVRFX1dSSVRF
QUJMRSwgJmRldmljZS0+ZGV2X3N0YXRlKSB8fA0KPiAgCQkgICAgYnRyZnNfZGV2aWNlX2dldF90
b3RhbF9ieXRlcyhkZXZpY2UpIC0NCj4gIAkJICAgIGJ0cmZzX2RldmljZV9nZXRfYnl0ZXNfdXNl
ZChkZXZpY2UpID4gc2l6ZV90b19mcmVlIHx8DQo+IA0KDQoNCi0tIA0KSGFucyB2YW4gS3JhbmVu
YnVyZw0K
