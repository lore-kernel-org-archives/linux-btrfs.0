Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50A2C10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2C41213F2
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 13:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=janustech.onmicrosoft.com header.i=@janustech.onmicrosoft.com header.b="FiFpgO7O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfDHNtx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 09:49:53 -0400
Received: from mail-eopbgr780090.outbound.protection.outlook.com ([40.107.78.90]:26702
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbfDHNtx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 09:49:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=janustech.onmicrosoft.com; s=selector1-janustech-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPnslcDsINgnqv5BlKlthRcT6D1RF+HPqBaXt3syjoU=;
 b=FiFpgO7OM74XMnUdCkDXiAplqdpNhrTpgly0rovVB7YHlKp76QfdYPhJJtjRlYSO/im0iwvH7v3lmJyJokZZ0w1S/n94N5VdKcT48XnFrQgi2EHLEhKyd42L4TwEB/VogBidJyDLmLH8fChf+/SKG/s9cHC6m9AqsNzq4wRfqno=
Received: from SN2PR07MB2621.namprd07.prod.outlook.com (10.167.15.27) by
 SN2PR07MB2510.namprd07.prod.outlook.com (10.167.14.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.16; Mon, 8 Apr 2019 13:49:50 +0000
Received: from SN2PR07MB2621.namprd07.prod.outlook.com
 ([fe80::2411:74b1:bdd8:e03]) by SN2PR07MB2621.namprd07.prod.outlook.com
 ([fe80::2411:74b1:bdd8:e03%8]) with mapi id 15.20.1771.016; Mon, 8 Apr 2019
 13:49:50 +0000
From:   Leonid Bloch <lbloch@janustech.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>
CC:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
Subject: Re: Cryptographically verifying a btrfs subvolume
Thread-Topic: Cryptographically verifying a btrfs subvolume
Thread-Index: AQHU7f4a8n5pp9onp0KRcnoRBIEvSaYyPM6AgAALDQA=
Date:   Mon, 8 Apr 2019 13:49:49 +0000
Message-ID: <0c1d5ee2-7427-0ce1-046e-f8bf4ef878b4@janustech.com>
References: <adac7db8-aed6-9573-ec09-4acd5059801e@janustech.com>
 <20190408131010.GA19386@linux-x5ow.site>
In-Reply-To: <20190408131010.GA19386@linux-x5ow.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR04CA0031.eurprd04.prod.outlook.com
 (2603:10a6:206:1::44) To SN2PR07MB2621.namprd07.prod.outlook.com
 (2603:10b6:804:7::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lbloch@janustech.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [141.226.29.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d636e7e5-e3a3-48a3-0c18-08d6bc2911c3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN2PR07MB2510;
x-ms-traffictypediagnostic: SN2PR07MB2510:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN2PR07MB2510C028116604E53355DB27CA2C0@SN2PR07MB2510.namprd07.prod.outlook.com>
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39830400003)(366004)(376002)(346002)(199004)(189003)(6916009)(99286004)(2906002)(76176011)(97736004)(31696002)(3846002)(305945005)(7736002)(66066001)(68736007)(31686004)(6116002)(6436002)(8936002)(106356001)(8676002)(81156014)(81166006)(105586002)(5660300002)(508600001)(4326008)(14454004)(6486002)(476003)(6246003)(54906003)(71200400001)(316002)(71190400001)(52116002)(446003)(36756003)(15650500001)(11346002)(25786009)(486006)(86362001)(102836004)(6512007)(6306002)(53936002)(229853002)(386003)(53546011)(26005)(6506007)(186003)(256004)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:SN2PR07MB2510;H:SN2PR07MB2621.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: janustech.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0A5zXt7LQ0dIUk1IfeIeYN0/B7izzwYtgapQxph3YdDsh3bs44DJK1wHZcJRMSHG8vVqsojF4AIs1ZEvYSeLgfgmyKFcZVVL8rWE8nx5tj5pOomQy9/BDYfkFjdLbxiKlHX9e63nur49/ufxK86RaIEs3X8jpT8Q9Z2I1VMIYhBkiZZMdaS/Mt+DXrTtsmCm4GZLl5PE5JZbb6M8l9T0xLxoenyuojz9BO8GSsNRGPlmddORfllQrBCL84KuCuG6bQbp02HGju9GXK7dWKZ/6t1yUhVcgtUQ0lTriCjbqAGQpH2XdjXjC4evJTWFhQQL5DdbigOsUJumcLofUV27BACePmGD9Zc/9ZI2cE72t/ZniJS3Nn88dtAX2J/jtv8aCQ3W/NGvNcC70o56np1plAA9WEEX6EnTdepuFHvZ1CA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <460615C63924E2479D0C4AE3A57C5ABF@namprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: janustech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d636e7e5-e3a3-48a3-0c18-08d6bc2911c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2019 13:49:50.0472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 34eb020e-3cf3-43a1-afeb-f5cf1310628e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2510
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

T24gNC84LzE5IDQ6MTAgUE0sIEpvaGFubmVzIFRodW1zaGlybiB3cm90ZToNCj4gT24gTW9uLCBB
cHIgMDgsIDIwMTkgYXQgMTE6Mjc6NTFBTSArMDAwMCwgTGVvbmlkIEJsb2NoIHdyb3RlOg0KPj4g
SGkgTGlzdCwNCj4+DQo+PiBDYW4geW91IHN1Z2dlc3QgYSB3YXkgb2YgY3J5cHRvZ3JhcGhpY2Fs
bHkgdmVyaWZ5aW5nIHRoZSBjb250ZW50IG9mIGENCj4+IGJ0cmZzIHN1YnZvbHVtZSwgYmVzaWRl
cyB0aGUgbmHDr3ZlIGFwcHJvYWNoLCBvZiBydW5uaW5nIGEgY3J5cHRvZ3JhcGhpYw0KPj4gaGFz
aCBmdW5jdGlvbiBvbiB0aGUgb3V0cHV0IG9mIGJ0cmZzIHNlbmQ/DQo+Pg0KPj4gQmFjayBpbiAy
MDE0LCBhbiBSRkMgcGF0Y2ggd2FzIHNlbnQgdG8gYWxsb3cgdXNpbmcgc2hhMjU2IGluc3RlYWQg
b2YNCj4+IGNyYzMyYyBmb3IgY2hlY2tzdW1taW5nLg0KPj4gKGh0dHBzOi8vcGF0Y2h3b3JrLmtl
cm5lbC5vcmcvcGF0Y2gvNTM2MzMxMSkNCj4+IEl0IHdhcyBub3QgbWVyZ2VkLiBIYWQgaXQgYmVl
biBtZXJnZWQsIG9uZSBjb3VsZCBqdXN0IGNoZWNrIHRoZSByZXR1cm4NCj4+IHZhbHVlIG9mIGJ0
cmZzIHNjcnViLCBpbnN0ZWFkIG9mIGNoZWNrc3VtbWluZyB0aGUgd2hvbGUgYnRyZnMgc2VuZA0K
Pj4gb3V0cHV0LCBjb3JyZWN0Pw0KPiANCj4gSGkgTGVvbmlkLA0KPiANCj4gSSdtIHdvcmtpbmcg
b24gdGhpcyBmZWF0dXJlIGN1cnJlbnRseSBidXQgdW5mb3J0dW5hdGVseSBnZXQgZGlzdHJhY3Rl
ZCB3aXRoDQo+IG90aGVyIHRoaW5ncyBhbGwgdG9vIG9mdGVuLg0KPiANCj4gVGhhbmtzIGZvciB5
b3VyIHBhdGllbmNlLg0KPiANCj4gQnl0ZSwNCj4gCUpvaGFubmVzDQoNCkhpIEpvaGFubmVzLA0K
DQpUaGFua3MgZm9yIGxldHRpbmcga25vdyEgQnRyZnMgaW5zcGVjdC1pbnRlcm5hbCBjc3VtLWR1
bXAgaW5kZWVkIHNvdW5kcyANCmF3ZXNvbWUhIFJlY3Vyc2l2ZWx5LCBvbiBhIHN1YnZvbHVtZSB0
aGF0IHdvdWxkIGJlIHBlcmZlY3QuIExldCBtZSBrbm93IA0KaWYgaGVscCBpcyBuZWVkZWQuDQoN
ClRoYW5rcywNCkxlb25pZC4NCl9fXw0K
