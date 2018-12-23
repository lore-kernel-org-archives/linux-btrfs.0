Return-Path: <SRS0=mU8m=PA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_MED,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457B8C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 00:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E69BA2173B
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 00:27:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=oakvillepondscapes.onmicrosoft.com header.i=@oakvillepondscapes.onmicrosoft.com header.b="gjuIp2mv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393022AbeLWAYJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 22 Dec 2018 19:24:09 -0500
Received: from mail-eopbgr1360055.outbound.protection.outlook.com ([40.107.136.55]:41568
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387711AbeLWAYI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Dec 2018 19:24:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oakvillepondscapes.onmicrosoft.com; s=selector1-pauljones-id-au;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdPHdTaAx8PMQEXPIyPrscnlsRM4bq69P2/6Z/ihwR8=;
 b=gjuIp2mvA7I7aShp4ZDUla6tmJcgWu4G57OYh0sSNeuJtRgx357D7GY3TFYlms4LCWHZTwm/YVBWeaam8o61X0vAuQnPGR2M+iPgwMGITajkVBjLUTMMrhPAtj4nclQEkZVq407FL8DkdlJJOfiSFdolMx9F1i+Lx23LnpzYTWk=
Received: from SYCPR01MB5086.ausprd01.prod.outlook.com (20.178.187.213) by
 SYCPR01MB4445.ausprd01.prod.outlook.com (20.178.185.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1446.21; Sun, 23 Dec 2018 00:24:02 +0000
Received: from SYCPR01MB5086.ausprd01.prod.outlook.com
 ([fe80::fcef:9ada:86dd:107e]) by SYCPR01MB5086.ausprd01.prod.outlook.com
 ([fe80::fcef:9ada:86dd:107e%3]) with mapi id 15.20.1446.026; Sun, 23 Dec 2018
 00:24:02 +0000
From:   Paul Jones <paul@pauljones.id.au>
To:     Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "devzero@web.de" <devzero@web.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: compress-force not really forcing compression?
Thread-Topic: compress-force not really forcing compression?
Thread-Index: AQHUl7FSg+ydTS1EoUKZW0iZ5EAYVqWGzosAgACj34CABAh3cA==
Date:   Sun, 23 Dec 2018 00:24:02 +0000
Message-ID: <SYCPR01MB5086BDC3A10DC10383C12EFB9EBA0@SYCPR01MB5086.ausprd01.prod.outlook.com>
References: <trinity-138fb9ef-e164-4c58-8ba8-04eaa9813254-1545234086993@3c-app-webde-bs26>
 <79977718-ac8f-3a62-529d-e9046c8066b2@gmx.com>
 <f527b243-4379-ec32-a6f2-3f04c72fb8d9@suse.com>
In-Reply-To: <f527b243-4379-ec32-a6f2-3f04c72fb8d9@suse.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paul@pauljones.id.au; 
x-originating-ip: [220.240.107.49]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;SYCPR01MB4445;6:N5wZPZSVJJqKY+7TTOkhWv/Dh5rheotDVqChIZos9czquof99ik6579QO6JpwmPOddw2RiSOJfbkpRUwiKPfHF50cR6ahhna8luf8ry56DDI4o07uhhDeb2NzeoyEducJFioqSNYSWYd0CNqjApZxzi9moo5/+2rbiUXOGQXl0OCiriiz5jjDqUDN9osvtA3VsaKk3B1eTU6B6yYjK67d5p4ajSpJ+yaXBiYjaArDBtEGSj55pcpDzQMRHUTzJhYzGE9kX4qhGMXNmq7ukdk3v8blVNrQdRsmyCkwRKBB1vE2hAFwbfzvG6KajPrLnCkvnXcZW3Jgir7nooftpC9RWsbtBijK+xOQviKGpOC0tdyqJrkDa5lxCguQK7suApviOIo7RxW/zBo0nAOj8iuDLibpbJwfoYidY1T3xKwdih3qYIocYaGRX9FlruYtXQSa039l/2FWGvOZUGzbsfcqA==;5:zqHsnZxYDPQctCqz3Va+vCIKL4ygVKDqVi0LwbLYKGZo6IGoPP8zC0/6juaTjh1qNtvgU48ynyYg0UCX1Oo1G2I7mNJmyJ5Y/8zOU0VOhpmhopGXDrsBWLivARqeHhqFw6A9eVuuQ/L5N4d1PGWGIOdP7TshO/3z0fntfSH854w=;7:bZK9OLQIlsV4wYrucB8VYX1z69mKkEa6n4YXI/2xuoh/3IsP2l43C5B69Dy4A+CUdBd3qm/fgTI82Uf/82pOJxyF5qXe8F8Xw5JVy9MRjDlAAoaGaGjsmXVW2ema2Ve0Tym9LA6p0+w67qkN6AUdtA==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 0f4bc9c3-d242-4310-9d33-08d6686cf0e5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:SYCPR01MB4445;
x-ms-traffictypediagnostic: SYCPR01MB4445:
x-microsoft-antispam-prvs: <SYCPR01MB44455AC7D19AE9465FF958DF9EBA0@SYCPR01MB4445.ausprd01.prod.outlook.com>
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(3230021)(908002)(999002)(5005026)(6040522)(2401047)(8121501046)(10201501046)(3002001)(93006095)(93001095)(3231475)(944501520)(52105112)(6041310)(20161123560045)(20161123564045)(20161123562045)(2016111802025)(20161123558120)(6043046)(201708071742011)(7699051)(76991095);SRVR:SYCPR01MB4445;BCL:0;PCL:0;RULEID:;SRVR:SYCPR01MB4445;
x-forefront-prvs: 0895DF8FFD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39830400003)(346002)(376002)(136003)(396003)(13464003)(189003)(199004)(110136005)(316002)(6506007)(53546011)(76176011)(186003)(26005)(102836004)(99286004)(7696005)(55016002)(6246003)(9686003)(53936002)(86362001)(2201001)(3846002)(6116002)(229853002)(8936002)(8676002)(81156014)(66066001)(97736004)(2906002)(14454004)(81166006)(2501003)(508600001)(305945005)(74316002)(68736007)(33656002)(446003)(11346002)(7736002)(476003)(486006)(25786009)(256004)(6436002)(5660300001)(105586002)(106356001)(74482002)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:SYCPR01MB4445;H:SYCPR01MB5086.ausprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: pauljones.id.au does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EM2VFtEDVlnTVqs+++AzSRWmgXv34vax8IOxDZ8A2dIMyAjylOc+5gqPDGY4eZB8kWSmK2Jjoj7qSv9ech4zzMW1Xg/CNQi7WpoqMOXalUVChZU711iMnpqGEMYKR8NyUyY0EsqIIBVk64mfj4N3TnzGDjbcV05v8rNUwiMNg+wmpEsrzRhE/X/8g9RzXA6RiU2lbZfOO8JUFaGviUnT2qLHt8HVHJNEa+MFBGKP2/WkMqMbZN9yV0PqUyENeXYZyFhgWBdMCHqcYMYWEeGsS7MttKb3WGYTx4ISxGRjZt6HhnFtH45uKU69GS7aLtqv
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: pauljones.id.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f4bc9c3-d242-4310-9d33-08d6686cf0e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2018 00:24:02.5489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8f216723-e13f-4cce-b84c-58d8f16a0082
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYCPR01MB4445
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LWJ0cmZzLW93bmVyQHZn
ZXIua2VybmVsLm9yZyA8bGludXgtYnRyZnMtDQo+IG93bmVyQHZnZXIua2VybmVsLm9yZz4gT24g
QmVoYWxmIE9mIE5pa29sYXkgQm9yaXNvdg0KPiBTZW50OiBUaHVyc2RheSwgMjAgRGVjZW1iZXIg
MjAxOCA5OjQ0IFBNDQo+IFRvOiBRdSBXZW5ydW8gPHF1d2VucnVvLmJ0cmZzQGdteC5jb20+OyBk
ZXZ6ZXJvQHdlYi5kZTsgbGludXgtDQo+IGJ0cmZzQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0
OiBSZTogY29tcHJlc3MtZm9yY2Ugbm90IHJlYWxseSBmb3JjaW5nIGNvbXByZXNzaW9uPw0KPiAN
Cj4gDQo+IA0KPiBPbiAyMC4xMi4xOCDQsy4gMjo1NyDRhy4sIFF1IFdlbnJ1byB3cm90ZToNCj4g
Pg0KPiA+DQo+ID4gT24gMjAxOC8xMi8xOSDkuIvljYgxMTo0MSwgZGV2emVyb0B3ZWIuZGUgd3Jv
dGU6DQo+ID4+IGRvZXMgY29tcHJlc3MtZm9yY2UgcmVhbGx5IGZvcmNlIGNvbXByZXNzaW9uPw0K
PiA+DQo+ID4gSXQgc2hvdWxkLg0KPiA+DQo+ID4gVGhlIG9ubHkgZXhjZXB0aW9uIGlzIGJsb2Nr
IHNpemUuDQo+ID4NCj4gPiBJZiB0aGUgZmlsZSBpcyBzbWFsbGVyIHRoYW4gdGhlIHNlY3RvciBz
aXplICg0SyBmb3IgeDg2XzY0KSwgdGhlbiBubw0KPiA+IGNvbXByZXNzaW9uIG5vIG1hdHRlciB3
aGF0ZXZlciB0aGUgbW91bnQgb3B0aW9ucyBhcmUuDQo+IA0KPiBXaGF0IEZPUkNFX0NPTVBSRVNT
IGRvZXMgaXMgaXQgZW5zdXJlcyB0aGF0IGNvbXByZXNzaW9uIGlzIGFsd2F5cyB0cmllZA0KPiBm
b3IgYSBmaWxlIChjaGVjayBjb2RlIGluIGNvbXByZXNzX2ZpbGVfcmFuZ2UgaW4gdGhlIGlmIChw
YWdlcykgYnJhbmNoKS4NCj4gSG93ZXZlciwgaWYgYnRyZnNfY29tcHJlc3NfcGFnZXMgZGV0ZWN0
cyBjb21wcmVzc2lvbiBtYWtlcyBubw0KPiBkaWZmZXJlbmNlIHRoZW4gJ2lmIChwYWdlcyknICBi
cmFuY2ggaXMgZXhlY3V0ZWQgc2luY2Ugd2lsbF9jb21wcmVzcyB3aWxsIG5vdA0KPiBiZSBzZXQg
YW5kIG9ubHkgdGhpbmcgaXQgd2lsbCBiZSBkbyBpcyBub3Qgc2V0IEJUUkZTX0lOT0RFX05PQ09N
UFJFU1MuDQo+IA0KPiBXaGF0IHRoaXMgYWxsIG1lYW5zIGlzIHRoYXQgd2l0aCBGT1JDRV9DT01Q
UkVTUyBmdXR1cmUgd3JpdGVzIHdpbGwgYWxzbyBiZQ0KPiB0cmllZCB0byBiZSBjb21wcmVzc2Vk
LiBGb3IgZXhhbXBsZSBpZiB5b3UgZG8gc29tZSBub24tY29tcHJlc3NpYmxlDQo+IHdyaXRlcyBv
biBhIGZpbGUgd2l0aCBubyBGT1JDRV9DT01QUkVTUyB0aGVuDQo+IEJUUkZTX0lOT0RFX05PQ09N
UFJFU1Mgd2lsbCBiZSBzZXQuIFRoaXMgbWVhbnMgdGhhdCBhbGwgZnV0dXJlDQo+IGludm9jYXRp
b24gb2YgaW5vZGVfbmVlZF9jb21wcmVzcyBmb3IgdGhpcyBpbm9kZSB3aWxsIHJldHVybiBmYWxz
ZS4gU28gaWYgYXQgYQ0KPiBsYXRlciB0aW1lIHRoZSBpbyBwYXR0ZXJuIGNoYW5nZXMgdG8gb25l
IHdoaWNoIGlzIGNvbXByZXNzaWJsZSB0aGVuIGl0IHdvbnQnDQo+IGJlIGNvbXByZXNzZWQuDQo+
IA0KPiBPVE9IIHdpdGggZm9yY2UtY29tcHJlc3MgeW91IHdpbGwgYWxzbyBiZSBjb21wcmVzc2lu
ZyB0aG9zZSBwb3J0aW9ucyBvZg0KPiB0aGUgZmlsZSB3aGljaCBhcmUgY29tcHJlc3NpYmxlLg0K
PiANCj4gSU1ITyB0aGUgbW9yZSBwZXJ0aW5lbnQgcXVlc3Rpb24gaXMgOg0KPiANCj4gSWYgYSBm
aWxlIGhhcyBwb3J0aW9ucyB3aGljaCBhcmUgbm90IGVhc2lseSBjb21wcmVzc2libGUgZG9lcyB0
aGF0IGltcGx5IGFsbA0KPiBmdXR1cmUgd3JpdGVzIGFyZSBhbHNvIGluY29tcHJlc3NpYmxlLiBJ
TU8gbm8sIHNvIEkgdGhpbmsgd2hhdCB3aWxsIGJlIHBydWRlbnQNCj4gaXMgcmVtb3ZlIEZPUkNF
X0NPTVBSRVNTIGFsdG9nZXRoZXIgYW5kIG1ha2UgdGhlIGNvZGUgYWN0IGFzIGlmIGl0J3MNCj4g
YWx3YXlzIG9uLg0KPiANCj4gQW55IG9waW5pb25zPw0KDQoNClRoYXQgaXMgYSBnb29kIGlkZWEu
IElmIEkgdHVybiBvbiBjb21wcmVzc2lvbiBJIHdvdWxkIGV4cGVjdCBldmVyeXRoaW5nIHRvIGJl
IGNvbXByZXNzZWQsIGV4Y2VwdCBpbiBjYXNlcyB3aGVyZSB0aGVyZSBpcyBubyBzaXplIGJlbmVm
aXQuDQo=
