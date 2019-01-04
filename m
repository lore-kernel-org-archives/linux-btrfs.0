Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85CEC43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 01:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C42C2184B
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 01:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=MendixTechnologyBV.onmicrosoft.com header.i=@MendixTechnologyBV.onmicrosoft.com header.b="uvDUzBG9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfADBg4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 20:36:56 -0500
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:41657
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727196AbfADBg4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 20:36:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=MendixTechnologyBV.onmicrosoft.com; s=selector1-mendix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4Pxnr+ZzpfTVAT8Lc+28yo92e7TE0SERZLzQwYtCEw=;
 b=uvDUzBG9mgDrT7Ay4nD7R27/c5HWs65Gjz9vVIu4O8eEVf5qvkl3FePA3mv75VF5lBeNi59AZHzl+RSrJfL/aSAOQgnmsZAgb65gqKtowgeMVx0EOYuvbLG+aJ3Bkq6dDG0gij9HXUPrRoHdL1EtqOmQClwUJrgDKAkN+kTii1Q=
Received: from DB6PR0601MB2568.eurprd06.prod.outlook.com (10.168.81.137) by
 DB6PR0601MB2566.eurprd06.prod.outlook.com (10.168.81.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1495.7; Fri, 4 Jan 2019 01:36:49 +0000
Received: from DB6PR0601MB2568.eurprd06.prod.outlook.com
 ([fe80::64c9:15d8:9c7b:92c3]) by DB6PR0601MB2568.eurprd06.prod.outlook.com
 ([fe80::64c9:15d8:9c7b:92c3%6]) with mapi id 15.20.1495.005; Fri, 4 Jan 2019
 01:36:48 +0000
From:   Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>,
        Nazar Mokrynskyi <nazar@mokrynskyi.com>
CC:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent
 backref)
Thread-Topic: Unrecoverable btrfs corruption (backref bytes do not match
 extent backref)
Thread-Index: AQHUo7GRMT9BMY2INUS2DiPdWqowQaWeToUAgAAExQCAAAE7AA==
Date:   Fri, 4 Jan 2019 01:36:48 +0000
Message-ID: <e0422250-b985-668f-e6a9-909cbbbe56f9@mendix.com>
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
 <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
 <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
In-Reply-To: <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
x-originating-ip: [2001:980:4a41:fb::12]
x-clientproxiedby: AM5PR0102CA0014.eurprd01.prod.exchangelabs.com
 (2603:10a6:206::27) To DB6PR0601MB2568.eurprd06.prod.outlook.com
 (2603:10a6:4:6d::9)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Hans.van.Kranenburg@mendix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DB6PR0601MB2566;6:KUjqNW3BfhcBw28JFByH8OZ2qWFbenE7qVpDMbgicDIgv+MH3PO5k2iUJoozF+5wREgfjgjBJcDJby7VVLBpPZqpxYDWJG/Er9F/W3pn5/gqLjZ7lGb9Paup9GFLgZasq6hLno+zYpp6W7/GohyLiWsQaN0YXlxps1AKnPG5rPSgPck05561tifgsP8kUXVh3a8mr8DWkUcMA/r8NHyw6oHMWB/1sdcRPL7y7lJP477q/x1+jmxD52csaw6/PKbzEJHT1WarSe69TCOptjSI4qiVVbPKAXHJkgCGKFww1ENDF56C53hQxU1U6+Ms5N47y1F3d+KtiWLRr/s+dfvT+Wd3CduoMamhyjXVvbM9Z+INDMau5NNHIZrwRT8FZNEzJ2CSNAgPssDIuR5zOsGB0eQh1AqXIq6dD6w6jjOwXwET9f8qixGB2SPiSScHQUvRfT2AvDah9s270/e1Z/ihew==;5:cg8UppvAPMf9/hK35a8O5lTZl8429MfNATr1JKhHkcW4QM/r54+CQI4XzpsuWZgUf1rpGR0S6TbW/S5wKES/84tvPyyBsab1YdVAbin+P7A7xnF8vM4ZKO4e/80QphHInr032RN4R13bE3HLcZUpfDEV1gEtoBxwjny/kb7HkHa5s4kNLLt2dLUc+QhaitlDpNdOoh53MrfNYlrUIVYaTw==;7:EjMhfx858mfRuHow/xsv6AdX5H3wm34T7nKW2r3F8F/4J/0vOMhMyDY4rsJIKPM1HCQ8Dg435jZHaJdxsHd3yTCPWCuOW4oENSOVCW7Aqq3iOphoOPm8jin1jRLWmydy6DFxw2C3Qja5MkpW9l1k6Q==
x-ms-office365-filtering-correlation-id: 8771ef59-5a2e-4a84-0735-08d671e517e0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:DB6PR0601MB2566;
x-ms-traffictypediagnostic: DB6PR0601MB2566:
x-microsoft-antispam-prvs: <DB6PR0601MB25665C2938207365FB325E0CD48E0@DB6PR0601MB2566.eurprd06.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(3230021)(908002)(999002)(5005026)(6040522)(8220060)(2401047)(8121501046)(93006095)(93001095)(10201501046)(3231475)(944501520)(52105112)(3002001)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123562045)(20161123558120)(201708071742011)(7699051)(76991095);SRVR:DB6PR0601MB2566;BCL:0;PCL:0;RULEID:;SRVR:DB6PR0601MB2566;
x-forefront-prvs: 0907F58A24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39850400004)(136003)(366004)(376002)(396003)(189003)(199004)(64126003)(6486002)(14454004)(105586002)(4326008)(106356001)(6512007)(76176011)(229853002)(25786009)(52116002)(6246003)(478600001)(6436002)(53936002)(72206003)(316002)(14444005)(256004)(110136005)(36756003)(58126008)(305945005)(65826007)(68736007)(5660300001)(7736002)(81156014)(6506007)(386003)(2616005)(476003)(97736004)(8936002)(65956001)(86362001)(65806001)(99286004)(31696002)(31686004)(6116002)(486006)(2906002)(186003)(11346002)(81166006)(446003)(46003)(71190400001)(71200400001)(8676002)(102836004)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0601MB2566;H:DB6PR0601MB2568.eurprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mendix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lj5z5IU7ka0e8ekKWA7XZzjAvW9LBop3wMZf/sQiCODOT0csfN9Bdz5cJf1J2Hn5p3UNL+5pzMNQAoXFnETPnB5XG/V0qPb+RNKvJenlvW50enlkuTOY7HYFGbS0FKoeqThQQJu1bwDHgOJJCaO6ss3DWgrIdMQaaf23tqZXCsj1e3SSkXtP4r5NbAnVrHvL9O9qKhFglnaomiF86jh97VqS3wmkZgvA8rYxTsKlX6z6Ph2I7V5Cr+uA7cIuXv/pCiUAO039bhGi8xaDbUn51d8uGi0eWPnMkRW9OAR8A0EbZzDjiLX+k8f/FZQEfem7
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF00B76E8FEC21478A9F7AF8DB86D675@eurprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mendix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8771ef59-5a2e-4a84-0735-08d671e517e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2019 01:36:47.9323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b4e3c78d-8e3b-46d8-bc56-5540da23ba4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0601MB2566
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gMS80LzE5IDI6MzIgQU0sIFF1IFdlbnJ1byB3cm90ZToNCj4gDQo+IA0KPiBPbiAyMDE5LzEv
NCDkuIrljYg5OjE1LCBDaHJpcyBNdXJwaHkgd3JvdGU6DQo+PiBPbiBUaHUsIEphbiAzLCAyMDE5
IGF0IDM6MTMgUE0gTmF6YXIgTW9rcnluc2t5aSA8bmF6YXJAbW9rcnluc2t5aS5jb20+IHdyb3Rl
Og0KPj4NCj4+PiByb290QHVidW50dTp+IyBidHJmc2NrIC9kZXYvbWFwcGVyL2x1a3MtNzM5OTY3
ZjEtOTc3MC00NzBhLWEwMzEtOGQ4YjhiY2RiMzUwDQo+Pj4gd2FybmluZywgYmFkIHNwYWNlIGlu
Zm8gdG90YWxfYnl0ZXMgMjE1NTg3MjI1NiB1c2VkIDIxNTU4NzYzNTINCj4+PiB3YXJuaW5nLCBi
YWQgc3BhY2UgaW5mbyB0b3RhbF9ieXRlcyAzMjI5NjE0MDgwIHVzZWQgMzIyOTYxODE3Ng0KPj4+
IHdhcm5pbmcsIGJhZCBzcGFjZSBpbmZvIHRvdGFsX2J5dGVzIDQzMDMzNTU5MDQgdXNlZCA0MzAz
MzYwMDAwDQo+Pj4gd2FybmluZywgYmFkIHNwYWNlIGluZm8gdG90YWxfYnl0ZXMgNTM3NzA5Nzcy
OCB1c2VkIDUzNzcxMDE4MjQNCj4+PiB3YXJuaW5nLCBiYWQgc3BhY2UgaW5mbyB0b3RhbF9ieXRl
cyA2NDUwODM5NTUyIHVzZWQgNjQ1MDg0MzY0OA0KPj4+IHdhcm5pbmcsIGJhZCBzcGFjZSBpbmZv
IHRvdGFsX2J5dGVzIDc1MjQ1ODEzNzYgdXNlZCA3NTI0NTg1NDcyDQo+Pj4gd2FybmluZywgYmFk
IHNwYWNlIGluZm8gdG90YWxfYnl0ZXMgODU5ODMyMzIwMCB1c2VkIDg1OTgzMjcyOTYNCj4+PiB3
YXJuaW5nLCBiYWQgc3BhY2UgaW5mbyB0b3RhbF9ieXRlcyA5NjcyMDY1MDI0IHVzZWQgOTY3MjA2
OTEyMA0KPj4+IHdhcm5pbmcsIGJhZCBzcGFjZSBpbmZvIHRvdGFsX2J5dGVzIDEwNzQ1ODA2ODQ4
IHVzZWQgMTA3NDU4MTA5NDQNCj4+PiB3YXJuaW5nLCBiYWQgc3BhY2UgaW5mbyB0b3RhbF9ieXRl
cyAxMTgxOTU0ODY3MiB1c2VkIDExODE5NTUyNzY4DQo+Pj4gd2FybmluZywgYmFkIHNwYWNlIGlu
Zm8gdG90YWxfYnl0ZXMgMTI4OTMyOTA0OTYgdXNlZCAxMjg5MzI5NDU5Mg0KPj4+IHdhcm5pbmcs
IGJhZCBzcGFjZSBpbmZvIHRvdGFsX2J5dGVzIDEzOTY3MDMyMzIwIHVzZWQgMTM5NjcwMzY0MTYN
Cj4+PiB3YXJuaW5nLCBiYWQgc3BhY2UgaW5mbyB0b3RhbF9ieXRlcyAxNTA0MDc3NDE0NCB1c2Vk
IDE1MDQwNzc4MjQwDQo+Pj4gd2FybmluZywgYmFkIHNwYWNlIGluZm8gdG90YWxfYnl0ZXMgMTYx
MTQ1MTU5NjggdXNlZCAxNjExNDUyMDA2NA0KPj4+IHdhcm5pbmcsIGJhZCBzcGFjZSBpbmZvIHRv
dGFsX2J5dGVzIDE3MTg4MjU3NzkyIHVzZWQgMTcxODgyNjE4ODgNCj4+PiB3YXJuaW5nLCBiYWQg
c3BhY2UgaW5mbyB0b3RhbF9ieXRlcyAxODI2MTk5OTYxNiB1c2VkIDE4MjYyMDAzNzEyDQo+Pj4g
d2FybmluZywgYmFkIHNwYWNlIGluZm8gdG90YWxfYnl0ZXMgMTkzMzU3NDE0NDAgdXNlZCAxOTMz
NTc0NTUzNg0KPj4+IHdhcm5pbmcsIGJhZCBzcGFjZSBpbmZvIHRvdGFsX2J5dGVzIDIwNDA5NDgz
MjY0IHVzZWQgMjA0MDk0ODczNjANCj4+PiB3YXJuaW5nLCBiYWQgc3BhY2UgaW5mbyB0b3RhbF9i
eXRlcyAyMTQ4MzIyNTA4OCB1c2VkIDIxNDgzMjI5MTg0DQo+Pj4gd2FybmluZywgYmFkIHNwYWNl
IGluZm8gdG90YWxfYnl0ZXMgMjI1NTY5NjY5MTIgdXNlZCAyMjU1Njk3MTAwOA0KPj4+IHdhcm5p
bmcsIGJhZCBzcGFjZSBpbmZvIHRvdGFsX2J5dGVzIDIzNjMwNzA4NzM2IHVzZWQgMjM2MzA3MTI4
MzINCj4+PiB3YXJuaW5nLCBiYWQgc3BhY2UgaW5mbyB0b3RhbF9ieXRlcyAyNDcwNDQ1MDU2MCB1
c2VkIDI0NzA0NDU0NjU2DQo+Pj4gd2FybmluZywgYmFkIHNwYWNlIGluZm8gdG90YWxfYnl0ZXMg
MjU3NzgxOTIzODQgdXNlZCAyNTc3ODE5NjQ4MA0KPj4+IHdhcm5pbmcsIGJhZCBzcGFjZSBpbmZv
IHRvdGFsX2J5dGVzIDI2ODUxOTM0MjA4IHVzZWQgMjY4NTE5MzgzMDQNCj4+PiB3YXJuaW5nLCBi
YWQgc3BhY2UgaW5mbyB0b3RhbF9ieXRlcyAyNzkyNTY3NjAzMiB1c2VkIDI3OTI1NjgwMTI4DQo+
Pj4gd2FybmluZywgYmFkIHNwYWNlIGluZm8gdG90YWxfYnl0ZXMgMjg5OTk0MTc4NTYgdXNlZCAy
ODk5OTQyMTk1Mg0KPj4+IHdhcm5pbmcsIGJhZCBzcGFjZSBpbmZvIHRvdGFsX2J5dGVzIDMwMDcz
MTU5NjgwIHVzZWQgMzAwNzMxNjM3NzYNCj4+PiB3YXJuaW5nLCBiYWQgc3BhY2UgaW5mbyB0b3Rh
bF9ieXRlcyAzMTE0NjkwMTUwNCB1c2VkIDMxMTQ2OTA1NjAwDQo+Pj4gd2FybmluZywgYmFkIHNw
YWNlIGluZm8gdG90YWxfYnl0ZXMgMzIyMjA2NDMzMjggdXNlZCAzMjIyMDY0NzQyNA0KPiANCj4g
SSdtIG5vdCBzdXJlIHdoYXQgdGhpcyBtZWFucy4NCj4gSSB0aG91Z2h0IGl0J3MgZnJlZSBzcGFj
ZSBjYWNoZSwgYnV0IGNvZGUgZG9lc24ndCBwcm92ZSB0aGF0Lg0KDQpJIHdhcyB0aGlua2luZyBh
Ym91dCBhICdzcGFjZScsIHdoaWNoIGluIGJ0cmZzLCBpcyBhIGNvbGxlY3Rpb24gb2YgYWxsDQpi
bG9jayBncm91cHMgd2hpY2ggaGF2ZSBhIHNwZWNpZmljIGNvbWJpbmF0aW9uIG9mIHR5cGUvcHJv
ZmlsZSwgbGlrZQ0KJ0RhdGEsIFJBSUQxJy4NCg0KTm90ZSB0aGF0IHRoZSBkaWZmZXJlbmNlIGJl
dHdlZW4gdGhlIHR3byBudW1iZXJzIGluIGV2ZXJ5IGxpbmUgc2VlbXMgdG8NCmJlIDQwOTYgYnl0
ZXMuDQoNCj4gWy4uLl0NCg0KLS0gDQpIYW5zIHZhbiBLcmFuZW5idXJnDQo=
