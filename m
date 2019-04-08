Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07374C10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 11:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C72AA20663
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 11:28:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=janustech.onmicrosoft.com header.i=@janustech.onmicrosoft.com header.b="NAIdg+oh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfDHL17 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 07:27:59 -0400
Received: from mail-eopbgr770098.outbound.protection.outlook.com ([40.107.77.98]:47937
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726253AbfDHL17 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 07:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=janustech.onmicrosoft.com; s=selector1-janustech-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8awCVAk8rq2m5jlPNEbzJWProzRdejh4OiTVUkdpeXA=;
 b=NAIdg+ohTQ7ySBWHDD7Lem+QfMCunQ/omzVW2g96vmH4mgyXlKBSOT4pb3u4B7un/4sfBYyoqoyj2jr4RuOi2zRf72AS+1orOFkBucBia/KNdvWvOjLMa7GP2UwtssxHhzKBRBq04xM4XdgXFvnLRiwP13R4UmdDPnBhoXC3zOg=
Received: from SN2PR07MB2621.namprd07.prod.outlook.com (10.167.15.27) by
 SN2PR07MB2624.namprd07.prod.outlook.com (10.167.15.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1771.16; Mon, 8 Apr 2019 11:27:52 +0000
Received: from SN2PR07MB2621.namprd07.prod.outlook.com
 ([fe80::2411:74b1:bdd8:e03]) by SN2PR07MB2621.namprd07.prod.outlook.com
 ([fe80::2411:74b1:bdd8:e03%8]) with mapi id 15.20.1771.016; Mon, 8 Apr 2019
 11:27:51 +0000
From:   Leonid Bloch <lbloch@janustech.com>
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
Subject: Cryptographically verifying a btrfs subvolume
Thread-Topic: Cryptographically verifying a btrfs subvolume
Thread-Index: AQHU7f4a8n5pp9onp0KRcnoRBIEvSQ==
Date:   Mon, 8 Apr 2019 11:27:51 +0000
Message-ID: <adac7db8-aed6-9573-ec09-4acd5059801e@janustech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0201CA0014.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::24) To SN2PR07MB2621.namprd07.prod.outlook.com
 (2603:10b6:804:7::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lbloch@janustech.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [141.226.29.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dac684b7-16e1-4b62-9b77-08d6bc153c5b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600139)(711020)(4605104)(2017052603328)(7193020);SRVR:SN2PR07MB2624;
x-ms-traffictypediagnostic: SN2PR07MB2624:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SN2PR07MB2624C4B3C9F610C282072178CA2C0@SN2PR07MB2624.namprd07.prod.outlook.com>
x-forefront-prvs: 0001227049
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39830400003)(136003)(396003)(346002)(376002)(189003)(199004)(2906002)(25786009)(97736004)(476003)(2616005)(36756003)(81156014)(256004)(486006)(316002)(86362001)(186003)(8676002)(26005)(81166006)(508600001)(52116002)(71200400001)(8936002)(4744005)(14454004)(71190400001)(99286004)(102836004)(66066001)(6506007)(6116002)(5660300002)(31686004)(31696002)(6436002)(386003)(3846002)(5640700003)(6486002)(15650500001)(68736007)(2501003)(7736002)(305945005)(4326008)(105586002)(53936002)(106356001)(2351001)(6306002)(6916009)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:SN2PR07MB2624;H:SN2PR07MB2621.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: janustech.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DaFCPD88iJazFSnjw42UydJ/zzsqe0qhNupKdxzP0I1OaCwoFxz2Tu856ZST0Vzf6/e1vTufsLmaVTVn5Cy9A2O/8mObQgz+1HOIvKxOyT1B5O3T7JxWl8wd4M16UCkiGlMk/D+TemYM4f+YI1wPQG1BFuhK44Fw0Cv32V9PYQfjtEqbk+v8rJMWyJEntCyWkssZWlO+1IK3ELwhLMuUrRfmbtkciE2CttIwQVxa0bpSxmz/eOITHArZHHOwKv9d/yQATTg5L/cLjr9GiT4HSXgmhp940hu1YhaqDK2CSlalVWhuFlMEYAVJy9sDNUPzAH4kb7eAUVmFFENlHLwmTR+ylQqYojH4C2xvUR2kquis9HMx6QLC9YccHRhdf7hxyIYScv3LS5GILgKGAa0E9PbuwbtvVQCOYEE6TKyS4+A=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F23135468FFC7F4695F02078B695D3EE@namprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: janustech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac684b7-16e1-4b62-9b77-08d6bc153c5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2019 11:27:51.7569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 34eb020e-3cf3-43a1-afeb-f5cf1310628e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR07MB2624
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

SGkgTGlzdCwNCg0KQ2FuIHlvdSBzdWdnZXN0IGEgd2F5IG9mIGNyeXB0b2dyYXBoaWNhbGx5IHZl
cmlmeWluZyB0aGUgY29udGVudCBvZiBhIA0KYnRyZnMgc3Vidm9sdW1lLCBiZXNpZGVzIHRoZSBu
YcOvdmUgYXBwcm9hY2gsIG9mIHJ1bm5pbmcgYSBjcnlwdG9ncmFwaGljIA0KaGFzaCBmdW5jdGlv
biBvbiB0aGUgb3V0cHV0IG9mIGJ0cmZzIHNlbmQ/DQoNCkJhY2sgaW4gMjAxNCwgYW4gUkZDIHBh
dGNoIHdhcyBzZW50IHRvIGFsbG93IHVzaW5nIHNoYTI1NiBpbnN0ZWFkIG9mIA0KY3JjMzJjIGZv
ciBjaGVja3N1bW1pbmcuDQooaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC81MzYz
MzExKQ0KSXQgd2FzIG5vdCBtZXJnZWQuIEhhZCBpdCBiZWVuIG1lcmdlZCwgb25lIGNvdWxkIGp1
c3QgY2hlY2sgdGhlIHJldHVybiANCnZhbHVlIG9mIGJ0cmZzIHNjcnViLCBpbnN0ZWFkIG9mIGNo
ZWNrc3VtbWluZyB0aGUgd2hvbGUgYnRyZnMgc2VuZCANCm91dHB1dCwgY29ycmVjdD8NCg0KDQpS
ZWdhcmRzLA0KTGVvbmlkLg0KX19fDQo=
