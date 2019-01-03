Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7509C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 00:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 906AD2073F
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 00:58:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="BkZzpfEt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfACA6B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 19:58:01 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:21053
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbfACA6B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 19:58:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pifKcxuRWuN+VosdlZgh0rYMbRZwIalczK49detgx4=;
 b=BkZzpfEtwscXc1f+MjcznsJRe+flDU3Qe3i+HeBS/R+6GY/Ucn3P/0XV68k2UyqJIx+MOArYRsd8PnocbW44WZ5xf5t+H6Kg3pYCM6vbazJV5ESxbDfVOLfbqAChEB59n8kboJm3uzj8LZ4tv6sBrDjIonS+/wXUhgOeNcLdcew=
Received: from DB6PR0601MB2568.eurprd06.prod.outlook.com (10.168.81.137) by
 DB6PR0601MB2421.eurprd06.prod.outlook.com (10.169.213.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.6; Thu, 3 Jan 2019 00:57:55 +0000
Received: from DB6PR0601MB2568.eurprd06.prod.outlook.com
 ([fe80::64c9:15d8:9c7b:92c3]) by DB6PR0601MB2568.eurprd06.prod.outlook.com
 ([fe80::64c9:15d8:9c7b:92c3%6]) with mapi id 15.20.1495.005; Thu, 3 Jan 2019
 00:57:55 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
Thread-Topic: [PATCH RFC 0/2] Use new incompat feature BG_TREE to hugely
 reduce mount time
Thread-Index: AQHUnoigRflTLOEHkkKpJYQumZFta6WT3sSAgAADeYCACE8NgIAAhEMAgAAMB4A=
Date:   Thu, 3 Jan 2019 00:57:55 +0000
Message-ID: <59536453-b5f5-9283-bd87-d61e3abf211f@mendix.com>
References: <20181228083745.3134-1-wqu@suse.com>
 <38520a81-e5b0-35b5-bf81-966ea6ef2c45@suse.com>
 <d4ee763f-19b4-e50f-1746-d2ca4152a3c5@gmx.com>
 <20190102162113.GX23615@twin.jikos.cz>
 <e1b30348-71ae-148d-c7c6-9de98edbb6de@gmx.com>
In-Reply-To: <e1b30348-71ae-148d-c7c6-9de98edbb6de@gmx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM6P193CA0098.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::39) To DB6PR0601MB2568.eurprd06.prod.outlook.com
 (2603:10a6:4:6d::9)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB6PR0601MB2421;6:oq/e6QpFIvJh+xVN3uRYoWQOeNDvJjWL+5lBz9O1jCsT0t9P0gNOTRMW+ruhUWAd3G0DYpUOr5nJ3bIDhRkDMjjwPQsFh+x+x4VoQMWtNJQZwcce/TL6KR3GWzBKdqLWsrE1wlHiUSZPJMmir9b62u3MS7SXYXEdPBEKt+N2zZ4+yHcCsazw2tQSXX/vJif54YdsQOO7k6UgqOdSQ+w60CXEN9iJXFGomZpbTJP8eG34HKokoJ5pBX4gPJXkxb5rsgxAgbmkXkPoHwgvYeFfwMiMzRzfrveOh6PTskAc0WmlvQLQ3at6frVGbzSkhbVZDQSqgwm+sL8Z8nzrx+xwJyTzA2aJjg3ZAHmmo/4qBcZLw81UP0HVZ0bgY6jFagf8F6OJsxFRchBTcyQawSW1idIXZlqRvjSmEhwqE/joIk9etqLr6I/O/R4n/UJDk56v4FrknE3hlwV53ztXYtNIqw==;5:a4OHztL6wcdT6ZIAUB4XE3egKoJOTF9yRxSDfeMlKWfWbXBJ9nQD70a/9eRxcxRBT0OPo0pE5+6iCHsZIritXxZRhhNN5HAvVDv2GwoRJwZVbsRejj6eVvy07MrN5ObseIwG3eVK3InzIsicpqQRW923KnhTAWKPYkNGkL6tnTwnyvF4XfpDBj9ZXcomcM3RkgbwWwSjsp9zmxiLDxbxcw==;7:rgYpIcYNUF8rk2+uKPfNxZbb2xxyl0kksDo4M6H9zBm0wdZyKfA4XHtCBoHEjTYvjZU/LYB+arJnZx5yFURvFnwLyhMrSDQWy1fvAvMLC5HHp3csc4QWdgZocfkvZPob+XEXsTcaZ9tpQv8kwne0Sw==
x-ms-office365-filtering-correlation-id: 9936c512-829b-4898-17a5-08d671167ede
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600109)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DB6PR0601MB2421;
x-ms-traffictypediagnostic: DB6PR0601MB2421:
x-microsoft-antispam-prvs: <DB6PR0601MB2421546888B0F14778DE6F5CD48D0@DB6PR0601MB2421.eurprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(3231475)(944501520)(52105112)(3002001)(93006095)(93001095)(10201501046)(6041310)(20161123560045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(201708071742011)(7699051)(76991095);SRVR:DB6PR0601MB2421;BCL:0;PCL:0;RULEID:;SRVR:DB6PR0601MB2421;
x-forefront-prvs: 0906E83A25
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(396003)(376002)(346002)(366004)(189003)(199004)(97736004)(486006)(6116002)(229853002)(36756003)(6436002)(2501003)(6486002)(31686004)(65826007)(5660300001)(6306002)(105586002)(6512007)(93886005)(2906002)(186003)(86362001)(71200400001)(106356001)(71190400001)(386003)(6506007)(53546011)(102836004)(46003)(446003)(11346002)(2616005)(476003)(52116002)(25786009)(31696002)(53936002)(76176011)(6246003)(316002)(110136005)(305945005)(99286004)(58126008)(64126003)(478600001)(966005)(81166006)(72206003)(81156014)(68736007)(8936002)(8676002)(7736002)(14444005)(217873002)(256004)(65806001)(14454004)(65956001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0601MB2421;H:DB6PR0601MB2568.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ibUJQUjvV2+WpiZ/Ez5DeRnXdrJXLj+MMH9RJQ/+cQeUo3CBa2bkiQ4QkvGKRxMfv5R2Ud97SdVhOFR/JuuHTi0YwqaWL6qJR0cAicBiQLklGKIWl3D1nkoNVDN43tQ1AeNvylJdC0XaJyWWiCE1y9JAVANRxIgn5wiFSmS+hWFZvTG+8FVBqAjllMphD5pOo7nDYwS1e726vpOYqwiAlh3eVOroqnHsynsQ/AgG8Xnopi+1dZ5DEolkerh4vAClPBa6MZNumoHhOzbCAfPxHKnQc5FXdGPBcS4/UsEKFTSqpBrg6eDj+y/kuZazJlXN
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <8935716EAFF3434AB4C803AC9D619B77@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9936c512-829b-4898-17a5-08d671167ede
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2019 00:57:55.5894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0601MB2421
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SGksDQoNCk9uIDEvMy8xOSAxOjE0IEFNLCBRdSBXZW5ydW8gd3JvdGU6DQo+IA0KPiANCj4gT24g
MjAxOS8xLzMg5LiK5Y2IMTI6MjEsIERhdmlkIFN0ZXJiYSB3cm90ZToNCj4+IE9uIEZyaSwgRGVj
IDI4LCAyMDE4IGF0IDA1OjI4OjEzUE0gKzA4MDAsIFF1IFdlbnJ1byB3cm90ZToNCj4+PiBPbiAy
MDE4LzEyLzI4IOS4i+WNiDU6MTUsIE5pa29sYXkgQm9yaXNvdiB3cm90ZToNCj4+Pj4gT24gMjgu
MTIuMTgg0LMuIDEwOjM3INGHLiwgUXUgV2VucnVvIHdyb3RlOg0KPj4+Pj4gVGhpcyBwYXRjaHNl
dCBjYW4gYmUgZmV0Y2hlZCBmcm9tOg0KPj4+Pj4gaHR0cHM6Ly9naXRodWIuY29tL2FkYW05MDA3
MTAvbGludXgvdHJlZS9iZ190cmVlDQo+Pj4+PiBXaGljaCBpcyBiYXNlZCBvbiB2NC4yMC1yYzEg
dGFnLg0KPj4+Pj4NCj4+Pj4+IFRoaXMgcGF0Y2hzZXQgd2lsbCBodWdlbHkgcmVkdWNlIG1vdW50
IHRpbWUgb2YgbGFyZ2UgZnMgYnkgcHV0dGluZyBhbGwNCj4+Pj4+IGJsb2NrIGdyb3VwIGl0ZW1z
IGludG8gaXRzIG93biB0cmVlLg0KDQpUaGFua3MgYSBsb3QgZm9yIHdyaXRpbmcgYSBwcm9vZiBv
ZiBjb25jZXB0IGZvciB0aGlzISBUaGlzIGlzIGdyZWF0Lg0KDQo+Pj4+PiBUaGUgb2xkIGJlaGF2
aW9yIHdpbGwgdHJ5IHRvIHJlYWQgb3V0IGFsbCBibG9jayBncm91cCBpdGVtcyBhdCBtb3VudA0K
Pj4+Pj4gdGltZSwgaG93ZXZlciBkdWUgdG8gdGhlIGtleSBvZiBibG9jayBncm91cCBpdGVtcyBh
cmUgc2NhdHRlcmVkIGFjcm9zcw0KPj4+Pj4gdG9ucyBvZiBleHRlbnQgaXRlbXMsIHdlIG11c3Qg
Y2FsbCBidHJmc19zZWFyY2hfc2xvdCgpIGZvciBlYWNoIGJsb2NrDQo+Pj4+PiBncm91cC4NCj4+
Pj4+DQo+Pj4+PiBJdCB3b3JrcyBmaW5lIGZvciBzbWFsbCBmcywgYnV0IHdoZW4gbnVtYmVyIG9m
IGJsb2NrIGdyb3VwcyBnb2VzIGJleW9uZA0KPj4+Pj4gMjAwLCBzdWNoIHRyZWUgc2VhcmNoIHdp
bGwgYmVjb21lIGEgcmFuZG9tIHJlYWQsIGNhdXNpbmcgb2J2aW91cyBzbG93DQo+Pj4+PiBkb3du
Lg0KPj4+Pj4NCj4+Pj4+IE9uIHRoZSBvdGhlciBoYW5kLCBidHJmc19yZWFkX2NodW5rX3RyZWUo
KSBpcyBzdGlsbCB2ZXJ5IGZhc3QsIHNpbmNlIHdlDQo+Pj4+PiBwdXQgQ0hVTktfSVRFTVMgaW50
byB0aGVpciBvd24gdHJlZSBhbmQgcGFja2FnZSB0aGVtIG5leHQgdG8gZWFjaCBvdGhlci4NCj4+
Pj4+DQo+Pj4+Pg0KPj4+Pj4gRm9sbG93aW5nIHRoaXMgaWRlYSwgd2UgY291bGQgZG8gdGhlIHNh
bWUgdGhpbmcgZm9yIGJsb2NrIGdyb3VwIGl0ZW1zLA0KPj4+Pj4gc28gaW5zdGVhZCBvZiB0cmln
Z2VyaW5nIGJ0cmZzX3NlYXJjaF9zbG90KCkgZm9yIGVhY2ggYmxvY2sgZ3JvdXAsIHdlDQo+Pj4+
PiBqdXN0IGNhbGwgYnRyZnNfbmV4dF9pdGVtKCkgYW5kIHVuZGVyIG1vc3QgY2FzZSB3ZSBjb3Vs
ZCBmaW5pc2ggaW4NCj4+Pj4+IG1lbW9yeSwgYW5kIGh1Z2VseSBzcGVlZCB1cCBtb3VudCAoc2Vl
IEJFTkNITUFSSyBiZWxvdykuDQoNCittYW55LCB0aGlzIGlzIGEgdXNhYmlsaXR5ICJidWciIHRo
YXQgY29tZXMgdXAgcmVndWxhcmx5IG9uIG1haWxpbmcgbGlzdA0KYW5kIElSQywgcGVvcGxlIGFz
a2luZyB3aHkgdGhlaXIgZmlsZXN5c3RlbSB0YWtlcyBsb25nIHRvIG1vdW50Lg0KDQpJIGFsc28g
aGF2ZSBzb21lIGZpbGVzeXN0ZW1zIHRoYXQgSSBoYXZlIHRvIHNldCBub2F1dG8gaW4gZnN0YWIs
IGFuZA0KdGhlbiBhZnRlciBib290aW5nIG1vdW50IG1hbnVhbGx5LCBhbmQgdGhlbiBkbyBzb21l
IG90aGVyIG1hbnVhbCB0YXNrcywNCmJlY2F1c2UgaGF2aW5nIHRoZW0gbW91bnQgYXV0b21hdGlj
YWxseSBkdXJpbmcgYm9vdCBjYXVzZXMgdGltZW91dHMgYW5kDQpzdHVmZi4NCg0KPj4+Pj4gVGhl
IG9ubHkgZGlzYWR2YW50YWdlIGlzLCB0aGlzIG1ldGhvZCBpbnRyb2R1Y2UgYW4gaW5jb21wYXRp
YmxlIGZlYXR1cmUsDQo+Pj4+PiBzbyBleGlzdGluZyBmcyBjYW4ndCB1c2UgdGhpcyBmZWF0dXJl
IGRpcmVjdGx5Lg0KPj4+Pj4gRWl0aGVyIHNwZWNpZnkgaXQgYXQgbWtmcyB0aW1lLCBvciB1c2Ug
YnRyZnMtcHJvZ3Mgb2ZmbGluZSBjb252ZXJ0IHRvb2wNCj4+Pj4+ICgqKS4NCj4+Pj4NCj4+Pj4g
V2hhdCBpZiB3ZSBzdGFydCByZWNvcmRpbmcgYmxvY2sgZ3JvdXAgaXRlbXMgaW4gdGhlIGNodW5r
IHRyZWU/DQo+Pj4NCj4+PiBUaGVuIGNodW5rIHRyZWUgd2lsbCBiZSB0b28gaG90Lg0KPj4+DQo+
Pj4gQ3VycmVudGx5IGNodW5rIHRyZWUgaXMgcHJldHR5IHN0YWJsZSwgb25seSBnZXQgbW9kaWZp
ZWQgYXQgYmcNCj4+PiBjcmVhdGlvbi9kZWxldGlvbiB0aW1lLg0KPj4+DQo+Pj4gQ29uc2lkZXJp
bmcgaG93IGltcG9ydGFudCBjaHVuayB0cmVlIGlzLCBJIHByZWZlciB0byBtYWtlIGNodW5rIHJv
b3QgYXMNCj4+PiBjb2xkIGFzIHBvc3NpYmxlLg0KDQpUaGlzIG1ha2VzIHNlbnNlLg0KDQo+Pj4g
T24gdGhlIG90aGVyIGhhbmQsIGJsb2NrIGdyb3VwIGl0ZW1zIGFyZSBwcmV0dHkgaG90IChhbHRo
b3VnaCBsZXNzIGhvdA0KPj4+IGNvbXBhcmVkIHRvIG9sZCBleHRlbnQgdHJlZSksIHNvIGl0IHN0
aWxsIG1ha2VzIHNlbnNlIHRvIHB1dCB0aGVtIGludG8NCj4+PiBvbmUgdHJlZSwgYWxsb3cgY2h1
bmsgdHJlZSB0byBiZSBhcyBjb2xkIGFzIGljZSwgd2hpbGUga2VlcCBibG9jayBncm91cA0KPj4+
IGl0ZW1zIHJlbGF0aXZlbHkgc2FmZSBjb21wYXJlZCB0byBvbGQgZXh0ZW50IHRyZWUuDQo+Pg0K
Pj4gQSBmZWF0dXJlIGxpa2UgdGhpcyBzaG91bGQgY29tZSB3aXRoIGFuIGFuYWx5c2lzIG9mIGJv
dGggYXBwcm9hY2hlcyBpbg0KPj4gYWR2YW5jZS4gQm90aCBoYXZlIHByb3MgYW5kIGNvbnMgdGhh
dCB3ZSBuZWVkIHRvIHdlaWdoLiBFZy4gSSdtIG5vdCBtb3JlDQo+PiBmb3Igc3RvcmluZyB0aGUg
aXRlbXMgaW4gYW4gZXhpc3RpbmcgdHJlZSwgcG9zc2libHkgY3JlYXRpbmcgYSBuZXcgdHJlZQ0K
Pj4gaXRlbSB0aGF0IHdvdWxkIHBhY2sgdGhlIGJnIGl0ZW1zIHRvZ2V0aGVyIGF0IHRoZSBiZWdp
bm5pbmcgb2YgdGhlIHRyZWUuDQo+Pg0KPj4gVGhlIHVwZGF0ZSBmcmVxdWVuY3kgb2YgdGhlIHRy
ZWUgaXMgYW4gYXNwZWN0IHRoYXQgSSBoYXZlbid0IGNvbnNpZGVyZWQNCj4+IGJlZm9yZSBidXQg
SSB0aGluayBpdCdzIGEgZ29vZCBwb2ludC4NCj4+DQo+PiBUaGUgdHJlZSBob2xkaW5nIHRoZSBi
ZyBpdGVtcyBjYW4gYmUgY29uc2lkZXJlZCBmdW5kYW1lbnRhbCBhbmQgcmVxdWlyZXMNCj4+IGEg
YmFja3VwIHBvaW50ZXIgaW4gdGhlIHN1cGVyYmxvY2suIFNvIHRoaXMgd291bGQgbmVlZCBtb3Jl
IHdvcmsuDQo+IA0KPiBSaWdodCwgZm9yIGJhY2t1cCByb290IGl0IGluZGVlZCBtYWtlcyBzZW5z
ZS4NCg0KSSBkb24ndCByZWFsbHkgdW5kZXJzdGFuZCB3aHkgdGhpcyBiYWNrdXAgcm9vdHMgbWVj
aGFuaXNtIGtlZXBzIGJlaW5nIGENCnRoaW5nLCBiZWNhdXNlIHRlY2huaWNhbGx5IGJ0cmZzIGNh
bm5vdCBndWFyYW50ZWUgYXQgYWxsIHRoYXQgdGhlcmUgd2lsbA0KYmUgYW55dGhpbmcgdXNhYmxl
IGxlZnQgcmlnaHQgYWZ0ZXIgdGhlIG9sZCBtZXRhZGF0YSBleHRlbnRzIGFyZQ0KdW5waW5uZWQu
Li4/DQoNCj4gSG93ZXZlciBmb3IgYW5vdGhlciBrZXkgdHlwZSBtZXRob2QsIEkgZG9uJ3QgcmVh
bGx5IHRoaW5rIHRoZXJlIGlzIGFueSBwcm8uDQo+IA0KPiBUbyBwYWNrIGJnIGl0ZW1zIHRvZ2V0
aGVyLCBuZXcga2V5IHR5cGUgaXMgbmVlZGVkIGFueXdheS4NCg0KTm90IGlmIHRoZSBibG9jayBn
cm91cCBpdGVtcyBhcmUgdGhlIG9ubHkgdGhpbmcgaW4gdGhlIHRyZWUuLi4/DQoNCj4gV2l0aCBu
ZXcga2V5IHR5cGUsIG5vIG1hdHRlciB3aGVyZSB0aGUgbmV3IGJnIGl0ZW1zIGFyZSwgb2xkZXIg
a2VybmVsDQo+IHdvbid0IGJlIGNvbXBhdGlibGUsIHRodXMgc3RpbGwgSU5DT01QQVQgZmVhdHVy
ZS4NCj4gDQo+IEFuZCBmb3Igd2hhdGV2ZXIgdGhlIHRyZWUgaG9sZGluZyBibG9jayBncm91cCBp
dGVtcywgaXQgd2lsbCBiZSBhcyBob3QNCj4gYXMgZXh0ZW50IHRyZWUgdXNlZCB0byBiZSwgYnJp
bmcgdXAgdGhlIGNvcnJ1cHRpb24gcG9zc2liaWxpdHkgdG8gdGhlDQo+IHdoYXRldmVyIHRoZSBl
eGlzdGluZyBpcy4gT3Igc2xvdyBkb3duIHRoZSB0cmVlLg0KPiANCj4gU28gYXQgbGVhc3QgZnJv
bSBteSByZXNwZWN0IG9mIHZpZXcsIHN0b3JpbmcgKG5ldykgYmcgaXRlbXMgaW4gZXhpc3RpbmcN
Cj4gdHJlZSBkb2Vzbid0IG1ha2Ugc2Vuc2UuDQo+IA0KPiBIb3dldmVyIEkgdGhpbmsgd2Ugc2hv
dWxkIHB1dCBtb3JlIGRpc2N1c3Npb24gb24gdGhlIHBvc3NpYmxlIG5ldyBibG9jaw0KPiBncm91
cCBpdGVtIHN0cnVjdHVyZSBkZXNpZ24uDQo+IEUuZy4gUmVtb3ZlIGNodW5rX29iamVjdGlkIG1l
bWJlciwgb3IgZXZlbiBlYWNoIGJsb2NrIGdyb3VwIGhhcyBpdHMgb3duDQo+IHRyZWUuDQoNCkp1
c3QgdGhpbmtpbmcgb3V0IGxvdWQuLi4NCg0KSXQgc2VlbXMgdG8gbWUgdGhhdCBrZWVwaW5nIHRo
ZSBzYW1lIGtleSB0eXBlIGFuZCBidHJmc19ibG9ja19ncm91cF9pdGVtDQpzdHJ1Y3QgYW5kIHNh
bWUga2V5IHZhbHVlcyBhcyB0aGV5IGhhdmUgaW4gZXh0ZW50IHRyZWUgd291bGQgYmUNCmRlc2ly
YWJsZSBpZiBib3RoIG9sZCBhbmQgbmV3IGNvZGUgaGFzIHRvIGNvLWV4aXN0IGluIHRoZSBrZXJu
ZWwuDQoNClRoaXMgaXMgZWFzeSB0byByZXZpZXcuLi4NCg0KLQlzdHJ1Y3QgYnRyZnNfcm9vdCAq
cm9vdCA9IGZzX2luZm8tPmV4dGVudF9yb290Ow0KKwlzdHJ1Y3QgYnRyZnNfcm9vdCAqcm9vdDsN
Cg0KWy4uLl0NCg0KKwlpZiAoYnRyZnNfZnNfaW5jb21wYXQoZnNfaW5mbywgQkdfVFJFRSkpDQor
CQlyb290ID0gZnNfaW5mby0+Ymdfcm9vdDsNCisJZWxzZQ0KKwkJcm9vdCA9IGZzX2luZm8tPmV4
dGVudF9yb290Ow0KDQouLi5idXQgY3JlYXRpbmcgYSBuZXcgZGlmZmVyZW50IHN0cnVjdCBhbmQg
a2V5IHR5cGUgd291bGQgY2F1c2UgbXVjaA0KbW9yZSBpbnZhc2l2ZSBjb2RlIGNoYW5nZXMgYW5k
IGR1cGxpY2F0aW9uIChhbmQgYnVncykgYWxsIG92ZXIgdGhlDQpwbGFjZSwgb3Igd3JhcHBlcnMg
dG8gaGFuZGxlIGVpdGhlciBzY2VuYXJpby4NCg0KSSBtZWFuLCB3aG8gY2FyZXMgYWJvdXQgc29t
ZSB1bnVzZWQgY2h1bmtfb2JqZWN0aWQgZmllbGQgb24gYSBtdWx0aS1UaUINCmZpbGVzeXN0ZW0u
Li4NCg0KSSdkIHZvdGUgZm9yIGRvaW5nIHRoaW5ncywgYW5kIG1vcmUgImRlc2lnbiBmb3IgdG9k
YXkiLiBPdGhlcndpc2UgdGhlDQpzYW1lIG1pZ2h0IGhhcHBlbiB0aGF0IGFsc28gaGFwcGVucyB3
aXRoIHNvbWUgb3RoZXIgdG9waWNzIGV2ZXJ5IHRpbWUuLi4NCml0IGVuZHMgdXAgd2l0aCB0aGUg
aWRlYSB0byByZXdyaXRlIGhhbGYgYnRyZnMgYW5kIHRoZW4gaW4gdGhlIGVuZA0Kbm90aGluZyBo
YXBwZW5zIGF0IGFsbCwgYW5kIHRoZSB1c2VycyBhcmUgc3RpbGwgdW5oYXBweS4gOy0pDQoNCkV2
ZW4gd2hlbiBzcGxpdHRpbmcgdGhlIGV4dGVudCB0cmVlIGludG8gbXVsdGlwbGUgdHJlZXMgZXZl
ciwgaXQgd291bGQNCnN0aWxsIGJlIGEgZ29vZCBpZGVhIHRvIGhhdmUgdGhpcyBCR19UUkVFLg0K
DQotLSANCkhhbnMgdmFuIEtyYW5lbmJ1cmcNCg==
