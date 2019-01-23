Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D4EC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 16:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1454B21726
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 16:24:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="EJklCcjZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfAWQYB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 11:24:01 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:29185
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726236AbfAWQYB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 11:24:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgwlSlNHpIqIn2W3SzFPmNAExF89/2QhOeN1YK5dhW0=;
 b=EJklCcjZl5FiqXvmRCVTeICGTeFBmU9HEw3OcXaa9G0qZnvx4s70/ofh9LAkSUJigJSWwIQlTJFWcB377aoeM0/Wa4uwJc5AQ3klzES32cT7LUPMbvc/53FKjP64CRFFTGLYfCkNY5hubA3Zjo8us2NE7rHGglRO4XE+o82dur8=
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com (52.133.5.141) by
 HE1PR0602MB3324.eurprd06.prod.outlook.com (10.171.196.160) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.29; Wed, 23 Jan 2019 16:23:53 +0000
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::fd5c:43e4:4b35:730a]) by HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::fd5c:43e4:4b35:730a%2]) with mapi id 15.20.1537.031; Wed, 23 Jan 2019
 16:23:53 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Nikolay Borisov <nborisov@suse.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Dennis Katsonis <dennisk@netspace.net.au>
CC:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: Incremental receive completes succesfully despite missing files
Thread-Topic: Incremental receive completes succesfully despite missing files
Thread-Index: AQHUsKvEidmBdsnBU0uW4O415p7q16W6TmeAgAJhdwCAAAtbgIAAQyMAgAAB5YCAAA50gA==
Date:   Wed, 23 Jan 2019 16:23:53 +0000
Message-ID: <f2d23645-ebd4-3799-bad8-2050764375bc@mendix.com>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
 <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
 <8e5c7ee5-4507-66d2-6642-2e37ff11b897@mendix.com>
 <f191c52b-740f-f432-1307-dbb8f4010f66@suse.com>
In-Reply-To: <f191c52b-740f-f432-1307-dbb8f4010f66@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM5PR0701CA0016.eurprd07.prod.outlook.com
 (2603:10a6:203:51::26) To HE1PR0602MB3626.eurprd06.prod.outlook.com
 (2603:10a6:7:8b::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1PR0602MB3324;6:SwG5HbSOf/4d4m3t1hnGqKT9aF7Z9NxWOJZbCLbHFZZbUQZA4gjZeXpL1iKUpbBld4WLcZJ7jVXx5scKeM6DFA9uPhbwICpUnjaxB85L7PIt8u0gdTuvTwiFIi+gRoqF53L6atP1g43+DjoHjO7YsoEY3pXSGhCjInwy+gtGByq7aTM7WW4nEljVGN6xNUVtvnvsVLSpXz42nlIUwojZs6PyxOI48vgLD89WV53DmZAgd4yPJfxN/5r61eIQsXikifzojQSTKGAE7eYFfutWC8WQsxfChSG7gS4Fu02glkKG7lBtLvfj41986fdWUmDmxfzsTXKxfoCDb//F5l11YoxNA81vWH1/9tJyR4XsKW1ANBjMZVcolP6VpZV/PiSBZBIMuoMDJx4PT9xnuzpJJwiu49ij9sBvuFkZLz8HklM4iFg5iJQ/1Ao3X0UmJ8X5ciwfqQq4KpxXGM1b118IPA==;5:WhQb96VyW5P9N9GZ9r+Qudj3KLMTvDjpXxj366Is86pifLtGTw9D1i/355bSdbwAhtmX2hv+8WZqXt578Z6RO0ShTKx5hKGWUJSMI1Sr+UrMWZBrkef/tzFBShtHspDy/ZU8DCR/XLW3bee7sTNdJsKanx+D8+V2VeCIyEZC4auu3ttR84mfUrUmasoGsvNQXnvl+yNIwMVkxAC1AoUC9w==;7:WNRaZyun4drv6xi/hv+z8BcSMzUvjnER5hzgzz5DPseqE3xHiF3I6wWz3mrt0Faagj0YT/VpfNBuc4Ljlgmj8D45sJzv9oTVuuNJk5GmgwoN97dvFCyeg2DgPoV71xAEf/w9Y02VeVnuD1SZgWP4eQ==
x-ms-office365-filtering-correlation-id: bfec7926-043e-49b4-d31d-08d6814f2a6a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:HE1PR0602MB3324;
x-ms-traffictypediagnostic: HE1PR0602MB3324:
x-microsoft-antispam-prvs: <HE1PR0602MB3324E251E19E6F4B99A7525FD4990@HE1PR0602MB3324.eurprd06.prod.outlook.com>
x-forefront-prvs: 0926B0E013
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(346002)(136003)(39850400004)(376002)(189003)(199004)(81156014)(8676002)(81166006)(11346002)(446003)(8936002)(305945005)(65806001)(65956001)(54906003)(76176011)(46003)(110136005)(2616005)(58126008)(186003)(14454004)(316002)(52116002)(7736002)(25786009)(39060400002)(4326008)(72206003)(53936002)(6246003)(6512007)(6306002)(966005)(93886005)(36756003)(478600001)(6436002)(71190400001)(486006)(229853002)(71200400001)(102836004)(64126003)(86362001)(476003)(99286004)(6486002)(31696002)(386003)(65826007)(97736004)(105586002)(6116002)(106356001)(68736007)(31686004)(53546011)(6506007)(2906002)(256004)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0602MB3324;H:HE1PR0602MB3626.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yMbtd5hKAw93w5wTV47xIuzB4gUB5qCrJcrp7xo744n2YbsnVQ/CmJSZ/Y4rRjpjBPf37y7U07IZ/egqKTY2Hnyo24/6uwSUp9zbOaWvdQdqTqNnRSnjRbhOhbrFRds18nHRYtifnFqT5Zsp4pHmSyo0qXH4RRu5vVpo5RyGh0FJQPJcYj/MbP2yTF3UtHrvJgyGqu51UoWC1bIm7kTLvBYLChh9rHaIQitYqL2MzvGf/GmJuZk0rDEsQ1kcWMRyrsYcd2gFMgcaf9b1Jv8Fc6ZH68zXGP87+vHgSWgv/pWlSGFT9OypcrSvJmAn1VYcopiq/Oof70tuxb0KA103DRRn9dkR2ipL89IjJyyRBpo1JhjkkOy+r48o49ze1GTxtaRzppM1iHCMeSey14Kd95VxFMiV4tdk2JD9DXeYyW8=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <914223A3ABD4A340A08B4A898884F042@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfec7926-043e-49b4-d31d-08d6814f2a6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2019 16:23:52.7873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0602MB3324
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMS8yMy8xOSA0OjMyIFBNLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6DQo+IA0KPiANCj4gT24g
MjMuMDEuMTkg0LMuIDE3OjI1INGHLiwgSGFucyB2YW4gS3JhbmVuYnVyZyB3cm90ZToNCj4+IE9u
IDEvMjMvMTkgMTI6MjUgUE0sIEFuZHJlaSBCb3J6ZW5rb3Ygd3JvdGU6DQo+Pj4gT24gV2VkLCBK
YW4gMjMsIDIwMTkgYXQgMTo0NSBQTSBEZW5uaXMgS2F0c29uaXMgPGRlbm5pc2tAbmV0c3BhY2Uu
bmV0LmF1PiB3cm90ZToNCj4+Pj4gSSB0aGluayBteSBwcmV2aW91cyBlLW1haWwgZGlkIG5vdCBn
byB0aHJvdWdoLiAgQmFzaWNhbGx5LCBpZiBpdCBpcw0KPj4+PiBhc3N1bWVkIHRoYXQgYSBidHJm
cy1yZWNlaXZlIG9wZXJhdGlvbiB3aWxsIHJlc3VsdCBpbiBhIHN1YnZvbHVtZSB3aGljaA0KPj4+
PiBtYXRjaGVzIHRoZSBzb3VyY2UgZmlsZSBmb3IgZmlsZSwgdGhlbiB0aGlzIGFzc3VtcHRpb24g
b3IgZXhwZWN0YXRpb24NCj4+Pj4gd29uJ3QgYmUgbWV0IGlmIG9uZSBkZWxldGVzIGZpbGVzIGZy
b20gdGhlIHN1YnZvbHVtZSBhdCB0aGUgcmVjZWl2aW5nDQo+Pj4+IGVuZCB3aGljaCBpcyBnb2lu
ZyB0byBiZSByZWZlcnJlZCB0byBhcyB0aGUgcGFyZW50Lg0KPj4+Pg0KPj4+DQo+Pj4gVGhpcyBp
cyBveHltb3Jvbi4gYnRyZnMgc2VuZC9yZWNlaXZlIGFwcGx5IHRvIHJlYWQtb25seSBzdWJ2b2x1
bWVzLg0KPj4+IFlvdSBhcmUgbm90IGFibGUgdG8gbW9kaWZ5IHRoZW0uIEFzIHNvb24gYXMgeW91
IHJlbW92ZSByZWFkLW9ubHkgYml0LA0KPj4+IHlvdSBhcmUgZnVsbHkgcmVzcG9uc2libGUgZm9y
IGNvbnNlcXVlbmNlcy4NCj4+Pg0KPj4+PiBUaGlzIGNhbiBoYXBwZW4gaW5hZHZlcnRlbnRseSwN
Cj4+Pg0KPj4+IEl0IGNhbm5vdC4gWW91IGRvIG5vdCBpbmFkdmVydGVudGx5IG1ha2Ugc3Vidm9s
dW1lIHJlYWQtd3JpdGUuIEFuZCBpZg0KPj4+IHlvdSBkbywgeW91IGFyZSBleHBlY3RlZCB0byBr
bm93IHdoYXQgeW91IGFyZSBkb2luZy4NCj4+Pg0KPj4+IFRoYXQgc2FpZCwgYmV0dGVyIGlmIGJ0
cmZzIGRpZCBub3QgYWxsb3cgZmxpcHBpbmcgcmVhZC1vbmx5IGJpdCBpbiB0aGUNCj4+PiBmaXJz
dCBwbGFjZS4NCj4+DQo+PiArMTAwDQo+Pg0KPj4gQnV0IHRoZW4gb25seSBkaXNhbGxvdyBpZiB0
aGUgc3Vidm9sIGhhcyBhIHZhbHVlIGluIHRoZSByZWNlaXZlZF91dWlkDQo+PiBmaWVsZCwgSSdk
IHNheS4NCj4+DQo+PiBBbmQgdGhlIHRvb2xpbmcgY291bGQgZGlzcGxheSBhIG5pY2UgZXJyb3Ig
bWVzc2FnZSwgdGVsbGluZyB0aGUgdXNlciB0bw0KPj4gbWFrZSBhIHJ3IHNuYXBzaG90IG9mIHRo
ZSByZWNlaXZlZCBzdWJ2b2wgaW5zdGVhZCwgd2hpY2ggd2lsbCBoYXZlIGFuDQo+PiBlbXB0eSBy
ZWNlaXZlZF91dWlkIGZpZWxkIGFnYWluLg0KPj4NCj4+IEVSUk9SOiBzdWJ2b2x1bWUgaXMgYSBy
ZWNlaXZlZCBzdWJ2b2x1bWUsIHdoaWNoIGNhbm5vdCBiZSBtYWRlIHJlYWQtd3JpdGUNCj4+IEVS
Uk9SOiBzdWdnZXN0aW9uOyBtYWtlIGEgcmVhZC13cml0ZSBzbmFwc2hvdCBvZiBpdCBpbnN0ZWFk
DQo+Pg0KPj4gU2V0dGluZyBzb21ldGhpbmcgcm8gbWFudWFsbHkgKGUuZy4gdG8gcHJldmVudCBh
Y2NpZGVudGFsIGRlbGV0aW9uIG9mIGENCj4+IHN0YXRpYyBzZXQgb2YgZGF0YSkgaXMgc3RpbGwg
YWxzbyBhIHVzZSBjYXNlLg0KPiANCj4gSSBoYWQgYSBwYXRjaCB3aGljaCB3aGVuIHRoZSBybyBi
aXQgaXMgZmxpcHBlZCBvbiBhIHNuYXBzaG90LCB0aGVuIGl0J3MNCj4gcGFyZW50IHNuYXBzaG90
IHV1aWQgZXRjIGlzIGRlbGV0ZWQuIEJlY2F1c2UgYXQgdGhhdCBwb2ludCBpdCBjYW5ub3QgYmUN
Cj4gZ3VhcmFudGVlZCB0aGF0IHRoZXJlIGlzIGFueSByZWxhdGlvbnNoaXAgYmV0d2VlbiBwYXJl
bjwtPnNuYXBzaG90LiBJZToNCj4gDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWJ0
cmZzLzE1MjA4NDcwMjAtODA0OS0xLWdpdC1zZW5kLWVtYWlsLW5ib3Jpc292QHN1c2UuY29tLw0K
PiANCj4gaGFzIGFueW9uZSB0cmllZCBpdD8NCg0KT2gsIGl0IHNlZW1zIHRoYXQgb25lIG5ldmVy
IGdvdCBhbnkgcmVwbHkuDQoNCldoZW4gbG9va2luZyBhdCBpdCBmcm9tIGFuIGVuZCB1c2VyIHBl
cnNwZWN0aXZlLCBJJ2QgbXVjaCBtb3JlIGxpa2UgdG8NCmhhdmUgaXQgZXhwbGljaXRseSB0ZWxs
IG1lIEknbSBkb2luZyBzb21ldGhpbmcgc3R1cGlkLCByZWZ1c2UgYW5kDQplZHVjYXRlIG1lIHRo
YW4gb2JleWluZyBhbmQgYWRkaW5nIG1vcmUgaW1wbGljaXQgYmVoYXZpb3VyIHRoYXQgSSBjYW5u
b3QNCnJldmVydCBhbnkgbW9yZSBteXNlbGYuDQoNCkUuZy4gSSdtIGEgbmV3IGJ0cmZzIHVzZXIs
IEkganVzdCBzZW50IHRoaXMgMVRpQiBvZiBkYXRhIGZvciB0aGUgZmlyc3QNCnRpbWUsIGFuZCBu
b3cgSSdtIG9mIGNvdXJzZSBjdXJpb3VzIGFuZCB0cnlpbmcgbW9yZSB0aGluZ3Mgb3V0Lg0KDQpU
cnlpbmcgc2V0dGluZyBydyAoJ29vaCEgdGhhdCB3b3JrcycpIGFuZCB0aGVuIHF1aWNrbHkgc2V0
dGluZyBybyBiYWNrDQp3aWxsIGRlc3Ryb3kgdGhlIHNlbmQvcmVjZWl2ZSByZWxhdGlvbnNoaXAg
d2l0aG91dCBtZW50aW9uaW5nIGFueXRoaW5nDQp0byB0aGUgdXNlciwgYW5kIGluIGNvbWJpbmF0
aW9uIHdpdGggc3Vic2VxdWVudCBjcnlwdGljIGVycm9ycyBmcm9tDQppbmNyZW1lbnRhbCBzZW5k
L3JlY2VpdmUgKCJjYW5ub3QgZmluZCBwYXJlbnQgc3Vidm9sdW1lIiBvciBzb21ldGhpbmcpDQpp
dCB3aWxsIGVuZCB1cCB3aXRoIHNtYXNoaW5nIGtleWJvYXJkcyBhbmQgdGhyb3dpbmcgY29tcHV0
ZXJzIG91dCBvZiB0aGUNCndpbmRvdy4NCg0KQWZ0ZXIgYXNraW5nIG9uIElSQyBhbmQgcHJvdmlk
aW5nIG91dHB1dCBvZiBidHJmcyBzdWIgbGlzdCBldGMgdGhlIHVzZXINCmlzIHRvbGQgdGhhdCB0
aGF0IHN1YnZvbCB3YXMgbmV2ZXIgcmVjZWl2ZWQgYmVjYXVzZSBpdCBkb2Vzbid0IGhhdmUgYQ0K
cmVjZWl2ZWRfdXVpZCwgYW5kIHRoZW4gc29tZW9uZSBhc2tzICJkaWQgeW91IHR1cm4gaXQgcncg
YXQgc29tZQ0KcG9pbnQ/Ii4gTm93IHRoZSB1c2VyIHJlbWVtYmVycywgInllcywgSSB3YXMgZXhw
ZXJpbWVudGluZyBhbmQgSSBkaWRuJ3QNCnNlZSBhbiBlcnJvciBvciB3YXJuaW5nIiwgYW5kIGlz
IHRoZW4gdG9sZCB0byByZXNlbmQgdGhlIDFUaUIgb2YgZGF0YS4NCiJCdXQgaXQncyB0aGVyZSBh
bHJlYWR5ISIgTm93IHNvbWVvbmUgY29tZXMgdXAgd2l0aCBhIHNuaXBwZXQgb2YgcHl0aG9uDQpj
b2RlIHRvIHJlc2V0IHRoZSByZWNlaXZlZF91dWlkIHdpdGggdGhlIGlvY3RsLCBhbmQuLi4NCg0K
OkQNCg0KPj4+PiBvciBldmVuIHRocm91Z2ggZmlsZXN5c3RlbSBjb3JydXB0aW9uDQo+Pj4+ICh3
aGljaCBJIGV4cGVyaWVuY2VkKS4NCj4+Pj4NCj4+Pg0KPj4+IEFuZCBpZiBjb3JydXB0aW9uIGhh
cHBlbmVkIGFmdGVyIGFwcGx5aW5nIGNoYW5nZXM/IEVuZCByZXN1bHQgaW4gdGhlDQo+Pj4gc2Ft
ZS4gT2YgY291cnNlIGl0IHdvdWxkIGJlIHBlcmZlY3QgaWYgYnRyZnMgY291bGQgbm90aWNlIGFu
ZCB3YXJuDQo+Pj4geW91LCBJIGp1c3QgZG8gbm90IHNlZSBob3cgaXQgY2FuIHJlYWxpc3RpY2Fs
bHkgYmUgaW1wbGVtZW50ZWQuDQo+Pj4NCj4+DQo+Pg0KDQoNCi0tIA0KSGFucyB2YW4gS3JhbmVu
YnVyZw0K
