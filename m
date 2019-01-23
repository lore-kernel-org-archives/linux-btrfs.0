Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 035D0C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 19:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B501621855
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 19:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="V3PIq5pu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfAWTcs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 14:32:48 -0500
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:7236
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725896AbfAWTcs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 14:32:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47hUqhNLkPK6G9j77nl2BvO7Weg3G6e7lFhtp8RL3Lk=;
 b=V3PIq5puwXdXueYA9UFfsJQa8l1UvNWXkHCwKNJBDQmTaWfXcHUmtXwrmlE7uRHGJ/8JeT/thFFxIVuzv+TTrKK5y9sPCxzbzEcnmXv5uhPRQi9Bj+4YVQNiXoRKwSDJUnANCNMM7U/Pl6qR4Shu+wIEZ4p+OQFOX5EXvZAJwQo=
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com (52.133.5.141) by
 HE1PR0602MB2777.eurprd06.prod.outlook.com (10.175.31.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.29; Wed, 23 Jan 2019 19:32:43 +0000
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::fd5c:43e4:4b35:730a]) by HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::fd5c:43e4:4b35:730a%2]) with mapi id 15.20.1537.031; Wed, 23 Jan 2019
 19:32:43 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP
 stripe size handling
Thread-Topic: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP
 stripe size handling
Thread-Index: AQHUp4hbmz1G2p+3LUilnjxye6F3E6WmG/0AgBbnSwCAABVaAIAAKESAgAAU2IA=
Date:   Wed, 23 Jan 2019 19:32:43 +0000
Message-ID: <84061712-32b6-35b7-eb1f-27eb9f85fd11@mendix.com>
References: <20190108192628.121270-1-sashal@kernel.org>
 <20190108192628.121270-72-sashal@kernel.org>
 <783ccf1f-65df-d388-079c-9449d4319c27@mendix.com>
 <20190123143732.GL202535@sasha-vm>
 <cb62ab8d-7d6f-de02-2912-3d9391a2bbb2@mendix.com>
 <20190123181805.GM202535@sasha-vm>
In-Reply-To: <20190123181805.GM202535@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM5PR0601CA0040.eurprd06.prod.outlook.com
 (2603:10a6:203:68::26) To HE1PR0602MB3626.eurprd06.prod.outlook.com
 (2603:10a6:7:8b::13)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1PR0602MB2777;6:toUQc8ukUKVNlrgsMdJ+zMzl++fPscAU/yCQzJCjAyn9FnT0np8CCSaT8RWqnJmQvTFKo5u3FcNlR/MIw99g7J5PIEoeC9JqlP1fS3GSmJgZ8K7u2c9/DIICKcLe/wboaBsZvv+AyAyuCD4AUIfkfMPevlAbIi1g/enfft5VcmdS5EFrsSQl0D/eSrLMgCaTSHZ/X+MY1llcWwt4DNjRyNcaWzdVJAqsihZjsXpX+9pt1hiGA9iMcP5xnwKsTsLo3BoU4qZG210anJYoV+pKTxlw7+EjjDlAr7HFn7bNq7FcM2JMp6FRIMt3ZTcKMrbSzRQyGdB4dZPyjAJqL2Lkq9Ou+0+4ZcS+INulqDakWfg8iKNP1T7lTOLhsvfj2jB8GPTdz8wzV9kTw8XWlflHa7EALSjIn9wgtHVNFWFk53Br0qtOq+uXUw5OfXJJJTF/JZXItUToHbp3uTA4j5SrkQ==;5:iYYYCwqwG3cEG9u2Gqmgcx/pCPO7n/5oi2zteyWwBBEg5bQc9XWtoJ8HVgurGiYuA1eHiSv8MIMRp41FwNT0X17fiB+IE+gTcZyNmzbafJLbkwMSyzcIxIv8VsqafACjIkbiXkbRkDDh4Zc6niK/rZLIfRGVOupsHKonc5usGHXF3YzB4jAOxR+kWaTSjmT/aUknIi3H0DWbYXofZmnfYQ==;7:e4Di9sU+0ZxSyBIdQz2P3t/a+I+Od9gkGOCTCvi1/p5HO2FsbK61v/wPbTY3JIw3hj7egv3hIElY5BnpKJo0EB4nUK8slPQ9D1l767n12xut1pUBHTRA0tpMWtWwVo/5AJGW2g8kFx1bvcjK30fqhA==
x-ms-office365-filtering-correlation-id: 18540784-770d-4f3d-5e3a-08d681698b4e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(49563074)(7193020);SRVR:HE1PR0602MB2777;
x-ms-traffictypediagnostic: HE1PR0602MB2777:
x-microsoft-antispam-prvs: <HE1PR0602MB27778F08D983B6E39B88DF1BD4990@HE1PR0602MB2777.eurprd06.prod.outlook.com>
x-forefront-prvs: 0926B0E013
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(366004)(396003)(39850400004)(189003)(199004)(31696002)(25786009)(68736007)(105586002)(86362001)(53936002)(316002)(97736004)(54906003)(58126008)(2906002)(36756003)(65956001)(478600001)(65806001)(6486002)(7736002)(93886005)(305945005)(256004)(14444005)(5024004)(65826007)(6436002)(64126003)(6512007)(102836004)(14454004)(8676002)(6246003)(46003)(8936002)(99286004)(6116002)(229853002)(72206003)(81166006)(81156014)(99936001)(476003)(31686004)(2616005)(52116002)(4326008)(217873002)(76176011)(6346003)(386003)(446003)(106356001)(71200400001)(71190400001)(186003)(11346002)(6506007)(53546011)(486006)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0602MB2777;H:HE1PR0602MB3626.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nBdFynPq7Fcwn2phiee8LpqED60cMhBq8EoFf6kvpU6jMAq89S6JzVi/bRyYk989YagzLfdQmHKJ1SPNSJa9Z0xjW74uFfAMxsYoiiziXzoD0G5fE88/1OK7ZfKus0ec88UZu71Ezir57qPUC9h5lhxyKIGKb53RDYzP30R8ONkheFVK+1LbT8jOiYdXSquumVjpGv4ZtrFotGVBywkxJum+ZC+RUifs07/WJXHLObrvAIWAFGKjyk92//TiPSNDe6ZEI1pCq0QJ23uO1551AL9D2WYcD8kxq4F930Qyu7TKf9aUf0yHq9zqKUpbaVbjKAEz81mQ6ZM3Z28Mad++uNJ0ttAgwiO9ZYZpu8s1d78yP3TcSHdxJn3A+HhKUOnxBIwrSbSfVBJiPGAwVnShOHld8Pam5+QFpYS5Ehmgwd4=
Content-Type: multipart/mixed;
        boundary="_002_8406171232b635b7eb1f27eb9f85fd11mendixcom_"
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18540784-770d-4f3d-5e3a-08d681698b4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2019 19:32:42.2247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB2777
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--_002_8406171232b635b7eb1f27eb9f85fd11mendixcom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <07B8ED6FE6A95B4880A5B0961AED3F2F@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64

KEFkZCB0byBDYzogQmVuIEh1dGNoaW5ncykNCg0KT24gMS8yMy8xOSA3OjE4IFBNLCBTYXNoYSBM
ZXZpbiB3cm90ZToNCj4gT24gV2VkLCBKYW4gMjMsIDIwMTkgYXQgMDM6NTQ6MDBQTSArMDAwMCwg
SGFucyB2YW4gS3JhbmVuYnVyZyB3cm90ZToNCj4+IE9uIDEvMjMvMTkgMzozNyBQTSwgU2FzaGEg
TGV2aW4gd3JvdGU6DQo+Pj4gT24gVHVlLCBKYW4gMDgsIDIwMTkgYXQgMTE6NTI6MDJQTSArMDAw
MCwgSGFucyB2YW4gS3JhbmVuYnVyZyB3cm90ZToNCj4+Pj4gSGkgU2FzaGEsDQo+Pj4+DQo+Pj4+
IE9uIDEvOC8xOSA4OjI1IFBNLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4+Pj4+IEZyb206IEhhbnMg
dmFuIEtyYW5lbmJ1cmcgPGhhbnMudmFuLmtyYW5lbmJ1cmdAbWVuZGl4LmNvbT4NCj4+Pj4+DQo+
Pj4+PiBbIFVwc3RyZWFtIGNvbW1pdCBiYWY5MjExNGM3ZTZkZDYxMjRhYTNkNTA2ZTRiYzRiNjk0
ZGEzYmMzIF0NCj4+Pj4+DQo+Pj4+PiBDb21taXQgOTJlMjIyZGY3YiAiYnRyZnM6IGFsbG9jX2No
dW5rOiBmaXggRFVQIHN0cmlwZSBzaXplIGhhbmRsaW5nIg0KPj4+Pj4gZml4ZWQgY2FsY3VsYXRp
bmcgdGhlIHN0cmlwZV9zaXplIGZvciBhIG5ldyBEVVAgY2h1bmsuDQo+Pj4+DQo+Pj4+IFRoYXQg
b25lIGFsc28gZW5kZWQgdXAgYXM6DQo+Pj4+DQo+Pj4+IDQuMTQtc3RhYmxlDQo+Pj4+IDAxMzZi
ZDcyMzhiMmNiODIzODQyNmFmNDE4M2VkMGIwMjE2NWMzZjkNCj4+Pj4NCj4+Pj4gNC45LXN0YWJs
ZQ0KPj4+PiA4ODkwYmFlMDNmNGRiYTFjMjI5MmU1NDQ1NjgyYjU1NmFmNGU4ZjFiDQo+Pj4+DQo+
Pj4+IDQuNC1zdGFibGUNCj4+Pj4gOTdjM2U0NmVmNTM3NDgyNzgyODZmYzA5ZGNjMzBiMTM4ZDY2
NzdjNA0KPj4+Pg0KPj4+PiAzLjE2LjU3LXJjMQ0KPj4+PiBmNjhmNDYyODRhMTk5ZjY4MzdjMWQ1
Yjk0YTZhZTk3OWEyY2M0NjNjDQo+Pj4+DQo+Pj4+IFdoaWxlIGhpdHRpbmcgdGhlIGZhaWx1cmUg
Y29uZGl0aW9uIHdpdGhvdXQgYWRkaW5nICJjcmFmdGluZyIgc3RlcHMgdG8NCj4+Pj4gbWFrZSBp
dCBleGFjdGx5IG1hdGNoIHRoZSBzY2VuYXJpbyBpcyB1bmxpa2VseSwgaXQgbWlnaHQgYmUgZ29v
ZCBpZiB3ZQ0KPj4+PiBqdXN0IGdvIGFsbCB0aGUgd2F5IGJhY2sgd2l0aCB0aGlzIHJlZ3Jlc3Np
b24gZml4Pw0KPj4+DQo+Pj4gV2hhdCBkbyB5b3UgbWVhbiB3aXRoICJhbGwgdGhlIHdheSBiYWNr
Ij8NCj4+DQo+PiBPaCwgYXBvbG9naWVzIGZvciBub3QgdXNpbmcgdW5hbWJpZ2lvdXMgcGhyYXNp
bmcuDQo+Pg0KPj4gSSBtZWFuLCBpdCBzZWVtcyB0aGUgYXV0b3NlbGVjdGlvbiBvbmx5IGZvdW5k
IDkyZTIyMmRmN2IgaW4gcGxhY2VzIHdoZXJlDQo+PiBpdCdzIGFjdHVhbGx5IGNhbGxlZCA5MmUy
MjJkZjdiLCBhbmQgbm90IHdoZXJlIGl0IHdhcyBjaGVycnktcGlja2VkLg0KPj4NCj4+IFNvLCBm
b3IgbXkgb3duIHVuZGVyc3RhbmRpbmc6IElmIEkgaGF2ZSB0byBkbyBzb21ldGhpbmcgbGlrZSB0
aGlzIGV2ZXINCj4+IGFnYWluLCB0aGVuIHNob3VsZCBJIGhhdmUgYWRkZWQgaXQgbGlrZSB0aGlz
IGluc2lkZSBiYWY5MjExNGM/DQo+Pg0KPj4gRml4ZXM6IDkyZTIyMmRmN2IgKCJidHJmczogYWxs
b2NfY2h1bms6IGZpeCBEVVAgc3RyaXBlIHNpemUgaGFuZGxpbmciKQ0KPj4gRml4ZXM6IDAxMzZi
ZDcyMzggKCJidHJmczogYWxsb2NfY2h1bms6IGZpeCBEVVAgc3RyaXBlIHNpemUgaGFuZGxpbmci
KQ0KPj4gRml4ZXM6IDg4OTBiYWUwM2YgKCJidHJmczogYWxsb2NfY2h1bms6IGZpeCBEVVAgc3Ry
aXBlIHNpemUgaGFuZGxpbmciKQ0KPj4gRml4ZXM6IDk3YzNlNDZlZjUgKCJidHJmczogYWxsb2Nf
Y2h1bms6IGZpeCBEVVAgc3RyaXBlIHNpemUgaGFuZGxpbmciKQ0KPj4gRml4ZXM6IGY2OGY0NjI4
NGEgKCJidHJmczogYWxsb2NfY2h1bms6IGZpeCBEVVAgc3RyaXBlIHNpemUgaGFuZGxpbmciKQ0K
Pj4NCj4+IFRoYW5rcyBmb3IgeW91ciBwYXRpZW5jZSwgOikNCj4gDQo+IEFoLCB0aGUgc2NyaXB0
cyBoYXZlIGVub3VnaCAiYnJhaW5zIiB0byBkZWFsIHdpdGggdGhlc2Ugb24gdGhlaXIgb3duLCBz
bw0KPiBubyBuZWVkIHRvIGFubm90YXRlIHRoYXQgbXVjaC4NCj4gDQo+IFRoaXMgcGF0Y2ggd2Fz
bid0IGFwcGxpZWQgdG8gb2xkZXIgdHJlZXMgYmVjYXVzZSBpdCBkaWRuJ3QgY2hlcnJ5LXBpY2sN
Cj4gY2xlYW5seSBvbiB0b3Agb2YgdGhlbS4gTG9va2luZyBhdCBpdCBub3csIGl0IHNlZW1zIHRv
IGRlcGVuZCBvbg0KPiA3OTNmZjJjODhjNiAoImJ0cmZzOiB2b2x1bWVzOiBDbGVhbnVwIHN0cmlw
ZSBzaXplIGNhbGN1bGF0aW9uIikgd2hpY2gNCj4gY2FuIHBvc3NpYmx5IGJlIHBpY2tlZCB1cCBp
ZiBpdCBtYWtlcyBzZW5zZS4NCg0KT2ssIEkgZ2V0IGl0Lg0KDQpUaGUgY2hhbmdlcyBhcmUgcmVh
bGx5IGxpbWl0ZWQgdG8gdGhlIGZldyBsaW5lcyBpbiB0aGF0IGlmIGJsb2NrLiBBbmQNCjc5M2Zm
MmM4OGM2IGFsc28gaXMsIGFuZCBpdCBkb2Vzbid0IGNoYW5nZSB0aGUgYmVoYXZpb3IsIHNvIHRo
YXQncyBnb29kLg0KDQpGb3IgMy4xNi55IGl0IGFsc28gZmlyc3QgbmVlZHMgYSBsaXR0bGUgcGFy
dCBvZiBiOGI5M2FkZGRlIGZyb20gRGF2aWQNClN0ZXJiYSwgd2hpY2ggaXMgYSBjb2xsZWN0aW9u
IG9mIGNvZGluZyBzdHlsZSBjaGFuZ2VzIGluIHF1aXRlIHNvbWUNCnBsYWNlcy4gQWZ0ZXIgdGhh
dCA3OTNmZjJjODhjNiBhbmQgdGhlbiBiYWY5MjExNGM3IGFwcGx5IGNsZWFubHksIG9ubHkNCnRv
dWNoIHRoYXQgc2luZ2xlIHBhcnQgb2YgdGhlIGNvZGUgYW5kIGVuZCB1cCB3aXRoIHRoZSByaWdo
dCB0aGluZy4NCg0KSSBhdHRhY2hlZCAzLjE2LnktV0lQLXBhcnRpYWxseS1hcHBseS1iOGI5M2Fk
ZGRlLnBhdGNoIGFzIHF1aWNrIGFuZA0KZGlydHkgZXhhbXBsZSwgcGxlYXNlIGxldCBtZSBrbm93
IGhvdyB0aGlzIHNob3VsZCBiZSBkb25lIHByb3Blcmx5Lg0KDQpGb3IgNC40LCA0LjkgYW5kIDQu
MTQsIGZpcnN0IDc5M2ZmMmM4OGM2IGFuZCB0aGVuIGJhZjkyMTE0YzcgaW5kZWVkIGFsc28NCmVu
ZCB1cCB3aXRoIHRoZSByaWdodCB0aGluZy4gSSBqdXN0IHRyaWVkIHRoYXQgaGVyZS4NCg0KVGhh
bmtzLA0KLS0gDQpIYW5zIHZhbiBLcmFuZW5idXJnDQo=

--_002_8406171232b635b7eb1f27eb9f85fd11mendixcom_
Content-Type: text/x-patch; name="3.16.y-WIP-partially-apply-b8b93addde.patch"
Content-Description: 3.16.y-WIP-partially-apply-b8b93addde.patch
Content-Disposition: attachment;
	filename="3.16.y-WIP-partially-apply-b8b93addde.patch"; size=871;
	creation-date="Wed, 23 Jan 2019 19:32:42 GMT";
	modification-date="Wed, 23 Jan 2019 19:32:42 GMT"
Content-ID: <59F233791C80F443A428EE432602F315@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSBmNTZjMjMxZjQyNTFmZDJjYWU1ZTVhYjNjY2MzOWU1N2M1N2M4M2NhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogSGFucyB2YW4gS3JhbmVuYnVyZyA8aGFuc0Brbm9ycmllLm9y
Zz4NCkRhdGU6IFdlZCwgMjMgSmFuIDIwMTkgMjA6MDM6NDkgKzAxMDANClN1YmplY3Q6IFtQQVRD
SF0gV0lQIHBhcnRpYWxseSBhcHBseSBiOGI5M2FkZGRlDQoNCi0tLQ0KIGZzL2J0cmZzL3ZvbHVt
ZXMuYyB8IDQgKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9mcy9idHJmcy92b2x1bWVzLmMgYi9mcy9idHJmcy92b2x1
bWVzLmMNCmluZGV4IDRhYTFhMjBmYzVkNy4uYjRiOThhNzVjYThiIDEwMDY0NA0KLS0tIGEvZnMv
YnRyZnMvdm9sdW1lcy5jDQorKysgYi9mcy9idHJmcy92b2x1bWVzLmMNCkBAIC00Mjc0LDggKzQy
NzQsOCBAQCBzdGF0aWMgaW50IF9fYnRyZnNfYWxsb2NfY2h1bmsoc3RydWN0IGJ0cmZzX3RyYW5z
X2hhbmRsZSAqdHJhbnMsDQogCSAqLw0KIAlpZiAoc3RyaXBlX3NpemUgKiBkYXRhX3N0cmlwZXMg
PiBtYXhfY2h1bmtfc2l6ZSkgew0KIAkJdTY0IG1hc2sgPSAoMVVMTCA8PCAyNCkgLSAxOw0KLQkJ
c3RyaXBlX3NpemUgPSBtYXhfY2h1bmtfc2l6ZTsNCi0JCWRvX2RpdihzdHJpcGVfc2l6ZSwgZGF0
YV9zdHJpcGVzKTsNCisNCisJCXN0cmlwZV9zaXplID0gZGl2X3U2NChtYXhfY2h1bmtfc2l6ZSwg
ZGF0YV9zdHJpcGVzKTsNCiANCiAJCS8qIGJ1bXAgdGhlIGFuc3dlciB1cCB0byBhIDE2TUIgYm91
bmRhcnkgKi8NCiAJCXN0cmlwZV9zaXplID0gKHN0cmlwZV9zaXplICsgbWFzaykgJiB+bWFzazsN
Ci0tIA0KMi4yMC4xDQoNCg==

--_002_8406171232b635b7eb1f27eb9f85fd11mendixcom_--
