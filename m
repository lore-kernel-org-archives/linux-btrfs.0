Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B66EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1F3E2082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:26:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fujitsu.onmicrosoft.com header.i=@fujitsu.onmicrosoft.com header.b="OAYq/Ako"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1F3E2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbeK1M0o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:26:44 -0500
Received: from esa6.fujitsucc.c3s2.iphmx.com ([68.232.159.83]:65236 "EHLO
        esa6.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726567AbeK1M0o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:26:44 -0500
X-IronPort-AV: E=McAfee;i="5900,7806,9090"; a="1653875"
X-IronPort-AV: E=Sophos;i="5.56,288,1539615600"; 
   d="scan'208";a="1653875"
Received: from mail-sg2apc01lp0246.outbound.protection.outlook.com (HELO APC01-SG2-obe.outbound.protection.outlook.com) ([65.55.88.246])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Nov 2018 10:26:54 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector1-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRb8C/qmmMckfH8AtL2Q0jqkbCGbVNb/dckm7inFlbo=;
 b=OAYq/AkoPhCukjXb4Qr0CJuudGFrvRkUiK2rXlYbZCOaS0TxfTffKR/6XYWx6M3GRxhvk1m8NClhOtmURknp/VRLr7iVmuTtSjPoNXWDsfquidzL36Z6nyeSwN6zYeWnJs8K29GVjkvL4dxdwjiPdfMtceHXV+d1YRETqrUgwDY=
Received: from TY2PR01MB3050.jpnprd01.prod.outlook.com (20.177.99.84) by
 TY2PR01MB2393.jpnprd01.prod.outlook.com (20.177.97.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1361.16; Wed, 28 Nov 2018 01:26:51 +0000
Received: from TY2PR01MB3050.jpnprd01.prod.outlook.com
 ([fe80::ec50:8330:3075:42b3]) by TY2PR01MB3050.jpnprd01.prod.outlook.com
 ([fe80::ec50:8330:3075:42b3%6]) with mapi id 15.20.1339.032; Wed, 28 Nov 2018
 01:26:51 +0000
From:   "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
To:     'Martin Steigerwald' <martin@lichtvoll.de>
CC:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH RESEND 0/8] btrfs-progs: sub: Relax the privileges of
 "subvolume list/show"
Thread-Topic: [PATCH RESEND 0/8] btrfs-progs: sub: Relax the privileges of
 "subvolume list/show"
Thread-Index: AQHUhg6SjyQ5gsYleEy/EzPIHoOfaKVjYIgAgAD5VCA=
Date:   Wed, 28 Nov 2018 01:26:51 +0000
Message-ID: <TY2PR01MB30508C63ABF2807AE175260EE5D10@TY2PR01MB3050.jpnprd01.prod.outlook.com>
References: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
 <1924429.dG6BgaDeF9@merkaba>
In-Reply-To: <1924429.dG6BgaDeF9@merkaba>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckerpolicyversion: FJ-ISEC-20180424-NoSave-enc
x-shieldmailcheckermailid: 276b53408c3d4ec6a9aaf9f13e9d7ed7
x-securitypolicycheck: OK by SHieldMailChecker v2.5.7
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=misono.tomohiro@fujitsu.com; 
x-originating-ip: [180.43.167.178]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;TY2PR01MB2393;6:ANtDhjKmWOdYQXATkSQRFv6P3aEduYrLorTeNFCdP9yjy2mWkANyI+JpLAcZhqXZjnzLCNHviiXMDeOXGreRlbxpp3zqWbkL2Xi6Rf+vIDTfwih0AB71oR/PrceT+PSGMW15Z5y8AeGxvMYiorMIH/+9o/uV5EVek1AH4JDDcMzWgsi35+5mNqI7bttD7HlJDBxjUzsdpvpPQ9mk0i+NO1iqgOzniSUQaWrA73O34gp6moexBVbqbVXBFKiaVraBOhzeblBqOaGgxqIFCPCJflqPmcD75hfPz6uafq1V4sysasX18WoF5DLAXTODb1r1lT/3scmqEhG3PxZbwK88UjR73eklGn2cTFUY5v+rxjLwd9pKzsN31zTTfJKxabANdQQOpvEjqXaSS18xAyyKlBDHlnn1WxQzth6C44wxsO1syw1+zVzA6y3/GiGJkurfXmecgeLUfwjh6eCJsv4xTA==;5:ZWPSa6afXSHSYk57clEZ1N7ktcScCa030TCJKEVuc+gkpMTl3YAwKvZTe08AbkcgVVMEG7FdwESlo7AO1TfxJwtYy45HTAsIoegyuUV/bW4TPZhRsNY20WoXdwbQuh7UUSd8H1uO/hyd5dY3uvqSQBT+hT5bRomQ+BXlaRMmCGc=;7:qaJeiQyprrCpklA4M04KAaqNn2lpP8rgH11R0vz7gcHtqkv/453zBmWChL11HT2ptwjR0cG91tkVPUhlHS8V5u0TquOeG/ZQ32h/JXQHl0JZaXLfwrPf765Fa9Ot9WEPlsUAly8RR+p5MGtARzbQXA==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 0c34d2ad-5993-4d22-c950-08d654d09315
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:TY2PR01MB2393;
x-ms-traffictypediagnostic: TY2PR01MB2393:
x-microsoft-antispam-prvs: <TY2PR01MB2393D232D8A4DB8C86D4CCF1E5D10@TY2PR01MB2393.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231443)(944501410)(52105112)(10201501046)(3002001)(93006095)(93001095)(6055026)(148016)(149066)(150057)(6041310)(20161123562045)(20161123564045)(20161123558120)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:TY2PR01MB2393;BCL:0;PCL:0;RULEID:;SRVR:TY2PR01MB2393;
x-forefront-prvs: 0870212862
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(366004)(136003)(396003)(13464003)(199004)(189003)(71200400001)(256004)(25786009)(33656002)(6246003)(71190400001)(85182001)(66066001)(3846002)(106356001)(6116002)(217873002)(6436002)(14444005)(229853002)(6916009)(105586002)(76176011)(6306002)(26005)(7696005)(476003)(486006)(9686003)(53546011)(14454004)(102836004)(97736004)(6506007)(186003)(55016002)(4326008)(8936002)(99286004)(7736002)(316002)(81166006)(8676002)(446003)(305945005)(478600001)(81156014)(74316002)(68736007)(966005)(11346002)(5660300001)(53936002)(86362001)(2906002)(777600001);DIR:OUT;SFP:1101;SCL:1;SRVR:TY2PR01MB2393;H:TY2PR01MB3050.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-microsoft-antispam-message-info: ebec9JjEv6hXc1QcmEcWW18p8dk/tlwG9nUGldPr/7CAua/ApqgQKKymBTD2uDJo1ZYcdxYKwxuMb0FA3RxkMHVa5EhiOd8LF2eQyLSXb3semYM/iS1AlhRxJykQQJgTeLDvnm0442faLo++1VQ987RGta74nsXamvJmuekC3gZm22BdmZ+Rs2Dxz5KHT/pOYQpcOTKU9xxVMgAFWoYio1RdQSk/kDlvhBkDejYIM8w20bzbLpEFitcDlwqQ+/nsMTaLGx/3RivHuJDWy9PjfE1So6k9pvAzavKqV4aPhmK1B8yEShtGs2SqzDH0be8NOMJk87V+jnDGCXvwMpk7Xsnw4JyzwTxtdtz0Ham6EVo=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c34d2ad-5993-4d22-c950-08d654d09315
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2018 01:26:51.6488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB2393
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

> -----Original Message-----
> From: Martin Steigerwald [mailto:martin@lichtvoll.de]
> Sent: Tuesday, November 27, 2018 6:48 PM
> To: Misono, Tomohiro <misono.tomohiro@fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH RESEND 0/8] btrfs-progs: sub: Relax the privileges
> of "subvolume list/show"
>=20
> Misono Tomohiro - 27.11.18, 06:24:
> > Importantly, in order to make output consistent for both root and
> > non-privileged user, this changes the behavior of "subvolume list":
> >  - (default) Only list in subvolume under the specified path.
> >    Path needs to be a subvolume.
>=20
> Does that work recursively?

Not in this version.

Previous version has -f option which recursively search and list subbvolume=
s
(only if they have the same btrfs fsid):
https://lore.kernel.org/linux-btrfs/84d06767762b4285ddefec0392ee16e2d7e06f6=
2.1529310485.git.misono.tomohiro@jp.fujitsu.com/

However, current "sub list" command already has many options and we cannot
add new one randomly, I drop the patches which add new options in this vers=
ion.
(In other word, previous version can be divided in two parts:=20
  1. Relax the privileges of sub list/show
  2. Add new option to sub list
And this version contains only 1).

>=20
> I wound find it quite unexpected if I did btrfs subvol list in or on the
> root directory of a BTRFS filesystem would not display any subvolumes
> on
> that filesystem no matter where they are.

Yes, I think output of -f option is more readable in such case.
If agreement has been made about how "sub list" should really work,
I could update/send patches again.

Thanks,
Misono
