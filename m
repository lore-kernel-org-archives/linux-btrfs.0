Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCE4C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 23:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26F1320658
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 23:56:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="mOvI/iYZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26F1320658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbeJKHUf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 03:20:35 -0400
Received: from mail-eopbgr120041.outbound.protection.outlook.com ([40.107.12.41]:9893
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726029AbeJKHUf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 03:20:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+sIwhWP0WiAw6CNtywjc8PLMnG9AVhni4jXwvzBaBo=;
 b=mOvI/iYZRB/LrDL5Rz1kZa3GUDrVRGauafjSaHa7cVxw16ZmAzCsrQlArL1UBnDlZJHUnl2ENVh/Osx7xJhKFUhoHsEGJsHrV0OZK+TKAmBBsuOhy4rnD8pjAwot+IIxTeywPz+VrFx/OyHi4E+s4l8+NTqXvri3/CUXd5BlKIM=
Received: from PR1PR06MB4683.eurprd06.prod.outlook.com (20.177.208.160) by
 PR1PR06MB4683.eurprd06.prod.outlook.com (20.177.208.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.28; Wed, 10 Oct 2018 23:55:21 +0000
Received: from PR1PR06MB4683.eurprd06.prod.outlook.com
 ([fe80::b85d:7264:1c11:5898]) by PR1PR06MB4683.eurprd06.prod.outlook.com
 ([fe80::b85d:7264:1c11:5898%3]) with mapi id 15.20.1207.029; Wed, 10 Oct 2018
 23:55:21 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Chris Murphy <lists@colorremedies.com>,
        =?utf-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?= 
        <holger@applied-asynchrony.com>
CC:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Scrub aborts due to corrupt leaf
Thread-Topic: Scrub aborts due to corrupt leaf
Thread-Index: AQHUPYGdnLRbn9Zd00SmfxcljTH/fKTSu4UAgAAl0wCAACWQgIABZycAgAC9JwCAAAO/gIAAA70AgAEFvgCAFRNPAIAtmXwAgAAFjoCAABv7gIAAZ56A
Date:   Wed, 10 Oct 2018 23:55:21 +0000
Message-ID: <35ccf3c1-c18d-cce9-23b8-d24a35fe5549@mendix.com>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
 <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com>
 <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <CAJCQCtTV3a9rH6ystLCbLUVoh4b1LL5yXWiOBPp6Fa28efZf_w@mail.gmail.com>
In-Reply-To: <CAJCQCtTV3a9rH6ystLCbLUVoh4b1LL5yXWiOBPp6Fa28efZf_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM3PR03CA0064.eurprd03.prod.outlook.com
 (2603:10a6:207:5::22) To PR1PR06MB4683.eurprd06.prod.outlook.com
 (2603:10a6:102:2::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;PR1PR06MB4683;6:NA6sVKIjpS0H7r4SwdahLdsX3CBOmTBvd2/ZoiPs1SDVqbyQUJOHtMBe7HShf188KEjEkSPjbyRoWOIZjmOp9Ke/Kx1CxYuqlJytOBlL34TErUqylUMeWJHkhB1e34AV1b9Z5Wa2I3S+J3KMvp0yV7QeAcumBc+fLqfGvJDjNHW50QPPEmEtVkO23TVNi8DQjLswP4ozFZA3R9EHcQnvRVnsu4dUuuzzw9HIn5kDjuKjPJo8Jr94HIkBU+pZnaSQWR9oTPb9vW+HyKFV075SlLvQ97VDNmSzMP+yZW0+KyrxwAFxn5v1UbxmqytL84tUcLzYjsH0LRrjHIj3H9AgWmwFAteE7ol5a1hmx7xynOyS3j5GipDrM4oVFl2MW+090hZEzmzd5eZdF7Rbb3c+3sUWwt//Uyis4eq2dmHXoBu+hky/dbO8MW7y7hb7Av2XNMf7o5H2f/jjfhnH0i6z5w==;5:GAOWc0CroMVvyeh5g/I6x7B00N3gnlXHPgCBPV1Jza6tSPlIi2ikyVBDFR/0ZreKHWo+g7JJ+nL4YTe2hN5cqxI6pT++8kE75NDzNdXJzxMeAPQ/A8t43sBPB6GHwA97oBRiV81itIc80cBdwp92ajeOYyBjLbShMWA4JcwbD5I=;7:7rOasfZmPUWpMiEQciClQpqofoRpA8YcI76qks8GQxBfH49nlTe5ZrgRDTvpXzIStpwpwblriwNISlIf+EA6/QiOVjXSAjpCiZGUKbx8WKVVaHwiRJZRoGlSOv5QYfmNmt8hvpCC81WD2tmYeSkWYcY+etV5hn5S20C3t2b90Zy0VBXTj0q2BEi6kDtsLHbfYMR072+f9iiQmF2zRf4AXMbN6R9IHrkfRiUIV8F08/eJqNCUmm5b7b6KKRAN/oQX
x-ms-office365-filtering-correlation-id: 929a94b7-58da-4f36-a687-08d62f0bd68e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:PR1PR06MB4683;
x-ms-traffictypediagnostic: PR1PR06MB4683:
x-microsoft-antispam-prvs: <PR1PR06MB46832A48D27282B938559052D4E00@PR1PR06MB4683.eurprd06.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(3002001)(3231355)(944501410)(52105095)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(20161123558120)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123560045)(20161123562045)(201708071742011)(7699051);SRVR:PR1PR06MB4683;BCL:0;PCL:0;RULEID:;SRVR:PR1PR06MB4683;
x-forefront-prvs: 08213D42D3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(366004)(346002)(376002)(189003)(199004)(52314003)(31686004)(31696002)(105586002)(476003)(72206003)(106356001)(2616005)(53936002)(6512007)(86362001)(71190400001)(71200400001)(446003)(316002)(11346002)(102836004)(4326008)(186003)(6486002)(110136005)(46003)(25786009)(58126008)(54906003)(229853002)(66574009)(486006)(6116002)(6436002)(478600001)(6506007)(53546011)(8676002)(81156014)(6246003)(81166006)(386003)(52116002)(65826007)(8936002)(76176011)(5660300001)(2906002)(14444005)(97736004)(68736007)(256004)(305945005)(2900100001)(93886005)(14454004)(99286004)(36756003)(65956001)(65806001)(5250100002)(64126003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:PR1PR06MB4683;H:PR1PR06MB4683.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: EcwUopR8z5ji2THb49g3MVVGfA6kYQyDq254HbGx6Xv2OxXyq4SDB2FDhsP2HGiHZU5Zfw/w7SS9Ldv4HF90hzQhXvPfnv5zk81fgqbjH3bllLvAuWdnTCKkySGnw/XwGgF0YcI2ObB9T9Mue9b8xllo8mUQqL/5uo3zV5y2amog9mygEPs3i+kJmyIUuyC7Q3I1tQ7viW7YW9n7U+jDTkijaT1SFD5x3H/M9vaT+PbhIqJ4MnwRIr/YyBph0ZBfnD2bpdr671e4Y+C3fjnRY7C+dRUvpeGCWEp4rX8zDaVFhE40/IuW4PZAo3Ayxqj3PXyuazmmmiWpJ4/hQbDfprbxPeXMD7rKcb7cyHvhxvs=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <89065A41E77F55439F99725FE908F6A2@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929a94b7-58da-4f36-a687-08d62f0bd68e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2018 23:55:21.7041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1PR06MB4683
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMTAvMTAvMjAxOCAwNzo0NCBQTSwgQ2hyaXMgTXVycGh5IHdyb3RlOg0KPiBPbiBXZWQsIE9j
dCAxMCwgMjAxOCBhdCAxMDowNCBBTSwgSG9sZ2VyIEhvZmZzdMOkdHRlDQo+IDxob2xnZXJAYXBw
bGllZC1hc3luY2hyb255LmNvbT4gd3JvdGU6DQo+PiBPbiAxMC8xMC8xOCAxNzo0NCwgTGFya2lu
IExvd3JleSB3cm90ZToNCj4+ICguLikNCj4+Pg0KPj4+IEFib3V0IG9uY2UgYSB3ZWVrLCBvciBz
bywgSSdtIHJ1bm5pbmcgaW50byB0aGUgYWJvdmUgc2l0dWF0aW9uIHdoZXJlDQo+Pj4gRlMgc2Vl
bXMgdG8gZGVhZGxvY2suIEFsbCBJTyB0byB0aGUgRlMgYmxvY2tzLCB0aGVyZSBpcyBubyBJTw0K
Pj4+IGFjdGl2aXR5IGF0IGFsbC4gSSBoYXZlIHRvIGhhcmQgcmVib290IHRoZSBzeXN0ZW0gdG8g
cmVjb3Zlci4gVGhlcmUNCj4+PiBhcmUgbm8gZXJyb3IgaW5kaWNhdGlvbnMgZXhjZXB0IGZvciB0
aGUgZm9sbG93aW5nIHdoaWNoIG9jY3VycyB3ZWxsDQo+Pj4gYmVmb3JlIHRoZSBGUyBmcmVlemVz
IHVwOg0KPj4+DQo+Pj4gQlRSRlMgd2FybmluZyAoZGV2aWNlIGRtLTMpOiBibG9jayBncm91cCA3
ODY5MTg4MzI4NjUyOCBoYXMgd3JvbmcgYW1vdW50DQo+Pj4gb2YgZnJlZSBzcGFjZQ0KPj4+IEJU
UkZTIHdhcm5pbmcgKGRldmljZSBkbS0zKTogZmFpbGVkIHRvIGxvYWQgZnJlZSBzcGFjZSBjYWNo
ZSBmb3IgYmxvY2sNCj4+PiBncm91cCA3ODY5MTg4MzI4NjUyOCwgcmVidWlsZGluZyBpdCBub3cN
Cj4+Pg0KPj4+IERvIEkgaGF2ZSBhbnkgb3B0aW9ucyBvdGhlciB0aGUgbnVraW5nIHRoZSBGUyBh
bmQgc3RhcnRpbmcgb3Zlcj8NCj4+DQo+Pg0KPj4gVW5tb3VudCBjbGVhbmx5ICYgbW91bnQgYWdh
aW4gd2l0aCAtbyBzcGFjZV9jYWNoZT12Mi4NCj4gDQo+IEknbSBwcmV0dHkgc3VyZSB5b3UgaGF2
ZSB0byB1bW91bnQsIGFuZCB0aGVuIGNsZWFyIHRoZSBzcGFjZV9jYWNoZQ0KPiB3aXRoICdidHJm
cyBjaGVjayAtLWNsZWFyLXNwYWNlLWNhY2hlPXYxJyBhbmQgdGhlbiBkbyBhIG9uZSB0aW1lIG1v
dW50DQo+IHdpdGggLW8gc3BhY2VfY2FjaGU9djIuDQoNClRoZSAtLWNsZWFyLXNwYWNlLWNhY2hl
PXYxIGlzIG9wdGlvbmFsLCBidXQgcmVjb21tZW5kZWQsIGlmIHlvdSBhcmUNCnNvbWVvbmUgd2hv
IGRvIG5vdCBsaWtlcyB0byBrZWVwIGFjY3VtdWxhdGVkIGNydWZ0Lg0KDQpUaGUgdjIgbW91bnQg
KHJ3IG1vdW50ISEhKSBkb2VzIG5vdCByZW1vdmUgdGhlIHYxIGNhY2hlLiBJZiB5b3UganVzdA0K
bW91bnQgd2l0aCB2MiwgdGhlIHYxIGRhdGEga2VlcHMgYmVpbmcgdGhlcmUsIGRvaW5nIG5vdGhp
bmcgYW55IG1vcmUuDQoNCj4gQnV0IGFueXdheSwgdG8gbWUgdGhhdCBzZWVtcyBwcmVtYXR1cmUg
YmVjYXVzZSB3ZSBkb24ndCBldmVuIGtub3cNCj4gd2hhdCdzIGNhdXNpbmcgdGhlIHByb2JsZW0u
DQo+IA0KPiBhLiBGcmVlemluZyBtZWFucyB0aGVyZSdzIGEga2VybmVsIGJ1Zy4gSGFuZHMgZG93
bi4NCj4gYi4gSXMgaXQgZnJlZXppbmcgb24gdGhlIHJlYnVpbGQ/IE9yIHNvbWV0aGluZyBlbHNl
Pw0KPiBjLiBJIHRoaW5rIHRoZSBkZXZzIHdvdWxkIGxpa2UgdG8gc2VlIHRoZSBvdXRwdXQgZnJv
bSBidHJmcy1wcm9ncw0KPiB2NC4xNy4xLCAnYnRyZnMgY2hlY2sgLS1tb2RlPWxvd21lbScgYW5k
IHNlZSBpZiBpdCBmaW5kcyBhbnl0aGluZywgaW4NCj4gcGFydGljdWxhciBzb21ldGhpbmcgbm90
IHJlbGF0ZWQgdG8gZnJlZSBzcGFjZSBjYWNoZS4NCj4gDQo+IFJlYnVpbGRpbmcgZWl0aGVyIHZl
cnNpb24gb2Ygc3BhY2UgY2FjaGUgcmVxdWlyZXMgc3VjY2Vzc2Z1bGx5IHJlYWRpbmcNCj4gKGFu
ZCBwYXJzaW5nKSB0aGUgZXh0ZW50IHRyZWUuDQo+IA0KPiANCg0KDQotLSANCkhhbnMgdmFuIEty
YW5lbmJ1cmcNCg==
