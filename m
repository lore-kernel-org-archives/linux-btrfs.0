Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3ECC282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 250072086C
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:56:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="fhZeOZWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbfA3Q4W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:56:22 -0500
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:37284
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729299AbfA3Q4V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 11:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whzVjQOA07jwouBwOkFuFzvqltI8EJ9XqPTc5tmNpWY=;
 b=fhZeOZWqrNonloJwT/rewwqtUF5u2jzESd2nvQlPw9MEJLn7cz5IJJcTHl2DVFlhmDZCzLbPaAdEd6K/JciEySu1qYWE47+hvlvFs/EzPr9LD1hQxueklMzcMQTOD/wy3dj7m3Bx6e9IosOBwfCAjQhmJqQ6t/zOsaf6cSaZOCk=
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com (52.133.5.141) by
 HE1SPR00MB85.eurprd06.prod.outlook.com (10.172.127.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.17; Wed, 30 Jan 2019 16:56:15 +0000
Received: from HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::b4b2:baa:af13:df44]) by HE1PR0602MB3626.eurprd06.prod.outlook.com
 ([fe80::b4b2:baa:af13:df44%3]) with mapi id 15.20.1558.023; Wed, 30 Jan 2019
 16:56:15 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Christoph Anton Mitterer <calestyo@scientia.net>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: dm-integrity + mdadm + btrfs = no journal?
Thread-Topic: dm-integrity + mdadm + btrfs = no journal?
Thread-Index: AQHUuCiAG3pi3uHxbUi24d2HBU0LBKXHxooAgAApYwCAABQlAIAABQaA
Date:   Wed, 30 Jan 2019 16:56:14 +0000
Message-ID: <9e026f25-703f-0bde-2f35-b405f40d4a07@mendix.com>
References: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
 <5c11b6a4-de3d-2ba0-c5c6-65ea04cd0245@gmail.com>
 <6ce96b57897acb62101dd213f8127ffeb981ee90.camel@scientia.net>
 <c83b2619-240f-4048-7c4d-545226f4ef0a@mendix.com>
In-Reply-To: <c83b2619-240f-4048-7c4d-545226f4ef0a@mendix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
x-originating-ip: [85.146.242.35]
x-clientproxiedby: AM5PR0402CA0013.eurprd04.prod.outlook.com
 (2603:10a6:203:90::23) To HE1PR0602MB3626.eurprd06.prod.outlook.com
 (2603:10a6:7:8b::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;HE1SPR00MB85;6:i/QkXnAScC0aQ5vFNXeW7Exg9Dg+1FH7VhjuB5sEP8h6r5hkTKrmO/N9kUn3/bGzTCgQkrbFlwDntWKToi3HIVAokyvic7iN0tSg1DFcA6xYZ0OEgLZZIAwPcw5QhemYocQ25dMtzORz1R+IUbBVt0U38IcGUAdyhN/WZ27se+B6xZ9wDi0LZcI2exC5IXxsp9Pu9R2D2K91Hnc0iN2st5hGWWkFinqwJWwPDgyJDdJAihCpFs3HDX48XNSkX0vPuqwoUwieB1S3fp8AhMwbP1WajMjG/PkL6awy8U+VpJ++7ifLhTldkhoM4mlXykxMAxCQSw3O2ZDVn5ZyHXuTxrAwcTDEHfa7ysGoX1k05L345WQHwt/BmLaeWz4UCuP5XYI7S+5Vi/1SVdjOggkH8BY46Ip9/VxfK7Ho01pPVVaUHeIQdDQctGq2VuO7BRPgNf5CNWkYDK/CfDmT1FRLZg==;5:k9hKBzgZF/00Moz1kW/mpyEd83n3eOlvydfvz6YvPROVB/y7NW70+hXoSt3K/EkGX/EpsG2Tglc1nSgaHtCJpGNpSh7vZHy/e/Rd4qQ1zuWbEcZ+svpcqhnCX2xxqChItbJOaSoAaqHlH/bZyzpdgS42kbZxg0Nkr0Rrq+Te5hffex0ZGgsPtHPfeFuP4lxiXsjlRJFl9+28XKSsVRvSQg==;7:FZ5NltV5qu8oX+c9hjHW2awW75S8Homzi9mI4N+7Q5U+BkhVeQMb08k3sGz3/RdtN/ui1ZIvJ4+HlymX4AHfe9SDjmA9rAJSFEoRURh1qTIE3gre+i49UJfW6MBnF9UN8CPrBxOfGXtFFRHrwpd96g==
x-ms-office365-filtering-correlation-id: 7d31b3ce-0035-46dd-788c-08d686d3d87e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:HE1SPR00MB85;
x-ms-traffictypediagnostic: HE1SPR00MB85:
x-microsoft-antispam-prvs: <HE1SPR00MB85C502777984DE9A5F0688D4900@HE1SPR00MB85.eurprd06.prod.outlook.com>
x-forefront-prvs: 0933E9FD8D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39850400004)(376002)(136003)(366004)(396003)(189003)(199004)(6436002)(966005)(6486002)(478600001)(72206003)(7736002)(8936002)(97736004)(86362001)(8676002)(81166006)(68736007)(81156014)(305945005)(14454004)(2906002)(53936002)(446003)(65956001)(65806001)(31696002)(66066001)(65826007)(36756003)(6246003)(58126008)(76176011)(486006)(39060400002)(52116002)(110136005)(316002)(99286004)(71190400001)(6512007)(6306002)(71200400001)(386003)(53546011)(6506007)(102836004)(186003)(26005)(64126003)(2616005)(31686004)(3846002)(6116002)(93886005)(11346002)(105586002)(106356001)(256004)(229853002)(14444005)(476003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1SPR00MB85;H:HE1PR0602MB3626.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LxIqmoO3U4acMik0ZvLRgeY97DYWIb1k1ImU1XfmU2SeCqrUSM7480W+MFjroFRBKjihT92fKY/xwV6hsYeQCG4ERo3ctI1xvznV9BWKVMBaGgyPhJExp9c6YddGt9uVGlRyQuq+ffKafAN14SEXQk+aOZPkN7BpT0uBEJciUZYOs9cM8nEzx9RTaIgVYUSL5XqYBUKGkmLOXfCs97O50EVPWHvaWGI5tEYohUZU45ivUvAtLFtO3F9IAZlE4tOS2fxzdUistb+oWgRbWy4fpB2QCoUQ9Uo/AHXgJoqEOzC0L8Csy7TJQlUCe2xqs/3mp3bSp9mTs4oyp6MRq9YEYIGrXC97Fo9LAtmPLQFjxzvfLREyhqXpPoZDEVo45+CjFRbE1zDhVyF510ycMRkwoVJjSvIeH9GRqx3dShSLj9E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <749BB59D5C26214D88F7AB6CD20F0174@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d31b3ce-0035-46dd-788c-08d686d3d87e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2019 16:56:14.6017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1SPR00MB85
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMS8zMC8xOSA1OjM4IFBNLCBIYW5zIHZhbiBLcmFuZW5idXJnIHdyb3RlOg0KPiBPbiAxLzMw
LzE5IDQ6MjYgUE0sIENocmlzdG9waCBBbnRvbiBNaXR0ZXJlciB3cm90ZToNCj4+IE9uIFdlZCwg
MjAxOS0wMS0zMCBhdCAwNzo1OCAtMDUwMCwgQXVzdGluIFMuIEhlbW1lbGdhcm4gd3JvdGU6DQo+
Pj4gUnVubmluZyBkbS1pbnRlZ3JpdHkgd2l0aG91dCBhIGpvdXJuYWwgaXMgcm91Z2hseSBlcXVp
dmFsZW50IHRvDQo+Pj4gdXNpbmcgDQo+Pj4gdGhlIG5vYmFycmllciBtb3VudCBvcHRpb24gKHRo
ZSBqb3VybmFsIGlzIHVzZWQgdG8gcHJvdmlkZSB0aGUgc2FtZSANCj4+PiBndWFyYW50ZWVzIHRo
YXQgYmFycmllcnMgZG8pLiAgSU9XLCBkb24ndCBkbyB0aGlzIHVubGVzcyB5b3UgYXJlDQo+Pj4g
d2lsbGluZyANCj4+PiB0byBsb3NlIHRoZSB3aG9sZSB2b2x1bWUuDQo+Pg0KPj4gVGhhdCBzb3Vu
ZHMgYSBiaXQgc3RyYW5nZSB0byBtZS4NCj4+DQo+PiBNeSB1bmRlcnN0YW5kaW5nIHdhcyB0aGF0
IHRoZSBpZGVhIG9mIGJlaW5nIGFibGUgdG8gZGlzYWJsZSB0aGUgam91cm5hbA0KPj4gb2YgZG0t
aW50ZWdyaXR5IHdhcyBqdXN0IHRvIGF2b2lkIGFueSBkb3VibGUgd29yaywgaWYgZXF1aXZhbGVu
dA0KPj4gZ3VhcmFudGVlcyBhcmUgYWxyZWFkeSBnaXZlbiBieSBoaWdoZXIgbGV2ZWxzLg0KPj4N
Cj4+IElmIGJ0cmZzIGlzIGJ5IGl0c2VsZiBhbHJlYWR5IHNhZmUgKGJ5IHVzaW5nIGJhcnJpZXJz
KSwgdGhlbiBJJ2QgaGF2ZQ0KPj4gZXhwZWN0ZWQgdGhhdCBub3QgdHJhbnNhY3Rpb24gaXMgY29t
bWl0dGVkLCB1bmxlc3MgaXQgZ290IHRocm91Z2ggYWxsDQo+PiBsb3dlciBsYXllcnMuLi4gc28g
ZWl0aGVyIGV2ZXJ5dGhpbmcgd29ya3Mgd2VsbCBvbiB0aGUgZG0taW50ZWdyaXR5DQo+PiBiYXNl
IChhbmQgdGh1cyBubyBqb3VybmFsIGlzIG5lZWRlZCkuLi4gb3IgaXQgZmFpbHMgdGhlcmUuLi4g
YnV0IHRoZW4NCj4+IGJ0cmZzIHdvdWxkIGFscmVhZHkgc2FmZSBieSBpdCdzIG93biBtZWFucyAo
YmFycmllcnMgKyBDb1cpPw0KPiANCj4gVGhpcy4gRXhhY3RseSB0aGlzLg0KPiANCj4gVGhlIHJl
YXNvbiB0aGF0IHRoaXMgam91cm5hbCBvZiBkbS1pbnRlZ3JpdHkgaGFzIHRvIGJlIHVzZWQgaXMg
YmVjYXVzZQ0KPiBkYXRhIGFuZCB0aGUgY2hlY2tzdW0gb2YgdGhhdCBkYXRhIGdldHMgd3JpdHRl
biBpbiB0d28gZGlmZmVyZW50IHBsYWNlcy4NCj4gVGhlIHJlc3VsdCBvZiB1c2luZyBpdCBpcyB0
aGF0IHlvdSdsbCBhbHdheXMgcmVhZCBiYWNrIGRhdGEgd2l0aA0KPiBtYXRjaGluZyBjaGVja3N1
bXMsIGVpdGhlciB0aGUgcHJldmlvdXMgZGF0YSwgb3IgdGhlIG5ldyBkYXRhLg0KPiANCj4gaHR0
cHM6Ly9hcnhpdi5vcmcvcGRmLzE4MDcuMDAzMDkucGRmDQo+IFNlZSBTZWN0aW9uIDQuNCAiUmVj
b3Zlcnkgb24gV3JpdGUgRmFpbHVyZSIuDQo+IA0KPiAiQSBkZXZpY2UgbXVzdCBwcm92aWRlIGF0
b21pYyB1cGRhdGluZyBvZiBib3RoIGRhdGEgYW5kIG1ldGFkYXRhLiAgQQ0KPiBzaXR1YXRpb24g
aW4gd2hpY2ggb25lIHBhcnQgaXMgd3JpdHRlbiB0byBtZWRpYSB3aGlsZSBhbm90aGVyIHBhcnQN
Cj4gZmFpbGVkIG11c3Qgbm90IG9jY3VyLiINCj4gDQo+IE5vdywgdGhlIGdyZWF0IHRoaW5nIGhl
cmUgaXMgdGhhdCBidHJmcyBkb2VzIG5vdCBvdmVyd3JpdGUgZGlzayBkYXRhIGluDQo+IHBsYWNl
LiBJdCB3cml0ZXMgb3V0IG5ldyBkYXRhLCBtZXRhZGF0YSBhbmQgdGhlbiB0aGUgc3VwZXJibG9j
ay4gU28sDQo+IGUuZy4gb24gcG93ZXIgbG9zcywgSSBkb24ndCBjYXJlIGFib3V0IHdoYXRldmVy
IGhhcHBlbmVkIHRvIHdyaXRlcyB0aGF0DQo+IGFyZSBub3QgdmlzaWJsZSBiZWNhdXNlIHRoZSBz
dXBlcmJsb2NrIHdhcyBuZXZlciB3cml0dGVuPyBCdHJmcyB3aWxsIG5vdA0KPiByZWFkIHRoZXNl
IGRpc2sgc2VjdG9ycyBiYWNrLCBiZWNhdXNlIGl0J3MgdW51c2VkIHNwYWNlLg0KDQpTbywgdG8g
cmVpdGVyYXRlIGZyb20gZmlyc3QgcG9zdCwgdGhpcyBtZWFucyB0aGF0IEkgY2Fubm90IHVzZSBu
b2NvdyBvcg0KZGlyZWN0aW8iLCBiZWNhdXNlIGl0IGdvZXMgYXJvdW5kIHRoZSBjb3cgc2FmZXR5
IG5ldC4NCg0KQWxzbywgdGhlcmUgaXMgc3RpbGwgYSByaXNrLCB3aGljaCBpcyBvZiBjb3Vyc2Ug
d3JpdGluZyB0aGUgc3VwZXJibG9ja3MuDQpJZiBhbGwgY29waWVzIG9mIHN1cGVyYmxvY2sgb24g
YSBzaW5nbGUgZGV2aWNlIGFyZSB3cml0dGVuLCBhbmQgYWxsIG9mDQp0aGVtIGxhY2sgdGhlIHVw
ZGF0ZWQgY2hlY2tzdW0sIHRoZW4gSSdsbCBsb3NlIHRoZSBmcywgYW5kIHdpbGwgaGF2ZSB0bw0K
ZWl0aGVyIHJlcGFpciB0aGF0IG1hbnVhbGx5LCBvciByZXN0b3JlIGZyb20gc2VuZC9yZWNlaXZl
IGJhY2t1cHMgb2YgYQ0KZmV3IG1pbnV0ZXMgYWdvLg0KDQo+IEFsc28sIGl0J3Mgbm90IGEgd3Jp
dGUgaG9sZSBsaWtlIGluIFJBSUQ1NiwgYmVjYXVzZSB3aGVuICJwdWxsaW5nIHRoZQ0KPiBwbHVn
IiBiZXR3ZWVuIHdyaXRpbmcgb3V0IGRhdGEgYW5kIG1ldGFkYXRhLCB0aGUgY2hlY2tzdW1zIG9m
IG9sZGVyDQo+IGV4aXN0aW5nIGRhdGEgc2VjdG9ycyBhcmUgbm90IGNvcnJ1cHRlZCwgb25seSBu
ZXcgd3JpdGVzIHRoYXQgd2VyZSBpbg0KPiBmbGlnaHQuLi4gSSB0aGluay4uLiBCdXQgdGhlIHRo
ZSBwZGYgaXMgc3RpbGwgbWVudGlvbmluZyAoYWxzbyBpbiA0LjQpDQo+ICJGdXJ0aGVybW9yZSwg
bWV0YWRhdGEgc2VjdG9ycyBhcmUgcGFja2VkIHdpdGggdGFncyBmb3IgbXVsdGlwbGUNCj4gc2Vj
dG9yczsgdGh1cywgYSB3cml0ZSBmYWlsdXJlIG11c3Qgbm90IGNhdXNlIGFuIGludGVncml0eSB2
YWxpZGF0aW9uDQo+IGZhaWx1cmUgZm9yIG90aGVyIHNlY3RvcnMiLiBGcm9tIHRoZSBkZXNpZ24s
IEkgY2FuIGhvd2V2ZXIgbm90IHNlZSBob3cNCj4gdGhpcyBjb3VsZCBoYXBwZW4uDQo+IA0KPiBJ
IGFza2VkIG9uIGRtLWRldmVsIGxpc3QgYSB3aGlsZSBhZ28gYWJvdXQgdGhpcywgYnV0IHRoZSBt
YWlsaW5nIGxpc3QNCj4gcG9zdCBuZXZlciBnb3QgYW55IHJlcGx5Lg0KDQpIYW5zDQo=
