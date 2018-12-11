Return-Path: <SRS0=yXFy=OU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319BBC07E85
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 09:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D09E82082F
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 09:19:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fujitsu.onmicrosoft.com header.i=@fujitsu.onmicrosoft.com header.b="LHvdwp/x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D09E82082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbeLKJTu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Dec 2018 04:19:50 -0500
Received: from esa13.fujitsucc.c3s2.iphmx.com ([68.232.156.96]:32253 "EHLO
        esa13.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbeLKJTu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Dec 2018 04:19:50 -0500
X-Greylist: delayed 769 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2018 04:19:47 EST
X-IronPort-AV: E=McAfee;i="5900,7806,9103"; a="1776028"
X-IronPort-AV: E=Sophos;i="5.56,341,1539615600"; 
   d="scan'208";a="1776028"
Received: from mail-pu1apc01lp2051.outbound.protection.outlook.com (HELO APC01-PU1-obe.outbound.protection.outlook.com) ([104.47.126.51])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Dec 2018 18:06:33 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector1-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QZS8ai87R0odIaE7IbKCcQgDy6qnH+X89bkgOAsL9E=;
 b=LHvdwp/xkPU6BP3cn3P9kM8I7BzHL0Qf8CcAormbhCwmsoEB/nDyaVeZAB+gddmfRtLywNYEv46LByrNq+U8y67queNg0MehoAVmnV+WMqgOGWtsLkoKCLUNmGdownp/11kVtHRxkP4dZPhW4xPYyO4YWUz7uUkeoqhXm+z0Wnc=
Received: from TY2PR01MB3050.jpnprd01.prod.outlook.com (20.177.99.84) by
 TY2PR01MB3419.jpnprd01.prod.outlook.com (20.178.142.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1404.20; Tue, 11 Dec 2018 09:06:28 +0000
Received: from TY2PR01MB3050.jpnprd01.prod.outlook.com
 ([fe80::17e:8560:6fc1:1947]) by TY2PR01MB3050.jpnprd01.prod.outlook.com
 ([fe80::17e:8560:6fc1:1947%2]) with mapi id 15.20.1404.026; Tue, 11 Dec 2018
 09:06:28 +0000
From:   "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
To:     'Omar Sandoval' <osandov@osandov.com>
CC:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH RESEND 0/8] btrfs-progs: sub: Relax the privileges of
 "subvolume list/show"
Thread-Topic: [PATCH RESEND 0/8] btrfs-progs: sub: Relax the privileges of
 "subvolume list/show"
Thread-Index: AQHUhg6SjyQ5gsYleEy/EzPIHoOfaKVyhOAAgAbLLcA=
Date:   Tue, 11 Dec 2018 09:06:28 +0000
Message-ID: <TY2PR01MB305076D9F8725B3DE1D36B4EE5A60@TY2PR01MB3050.jpnprd01.prod.outlook.com>
References: <cover.1543294426.git.misono.tomohiro@jp.fujitsu.com>
 <20181207010216.GH11220@vader>
In-Reply-To: <20181207010216.GH11220@vader>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckerpolicyversion: FJ-ISEC-20180424-NoSave-enc
x-shieldmailcheckermailid: e1667dd2544342c88a21ec5b93b9b648
x-securitypolicycheck: OK by SHieldMailChecker v2.5.7
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=misono.tomohiro@fujitsu.com; 
x-originating-ip: [180.43.167.187]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;TY2PR01MB3419;6:fiEqWQZA9KNYb2PpRBv0znAePYWOVN4wjZVdwfC+LtmsnllhKTy9laXqSx+PoNYXoaoBoYs5opS+bNNpT5m6cCKSjRnAhx/RloRb1c6Ta8LnX+AzGmd1a6HTqgCxANIfBjCnKDmLRcXdUkGNXXm2IiQ0JsFyiNsXXqRaVpS8LTEkrVCReSkkWqcsSKCt8u4CBlrCz+W+IdaPOiveRA03LJyQS4WHLcXUXVZV9h/IbVUPaNb08jZqI7FJaeTf3u9Jx0OTaJpxRIDgTTIwtr0xiEn53V8YGJ1jGq0qeaLFu6giH/UOl3XD/Bdh5xssqWEHjSsvOJPXyW7WmaInQPYKj1r9GfqRst31wVNiN3BZZZRrZ6vquGH+0XpypDzZhf7BKW1ZJMPwCjzwgistqhc7anJPjfbvHMIB/ZMYZZzNxJMY9QI90EpgCaYiCGHMEqsklLscrlTrRT/cGtFXLLFvBQ==;5:nZingr5VCSVHLRE1ne0TihAKloSHrH2ktMRBI6nDWYtjraR/3O3XxPKVdNnqc6lRwX3WVc5cipwa/UJ/duufsEKzflNIGyirSdgY+lpkaJDhWBpSrRNA1mf3d2/XTPlU2eMuoWEfJfGUxkQf8KdU8Ho8I3rMjg3qQtrVoCEogU8=;7:prP/cSYZE+MVFr5AAtWCTcrS6d7B3whmRgNNbdwmAhhzNAccGMc2ha58gI9jso0J2U9PdHzSesiaiN5dk7c0s9UW38U6JBjfGev70YFftTFYSBArR+KtkTNHkbOslLqDQtNj4i4Uoaq9WK0N1cYa7g==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: 14ec5648-96e2-4cbf-d91d-08d65f47efb5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7193020);SRVR:TY2PR01MB3419;
x-ms-traffictypediagnostic: TY2PR01MB3419:
x-microsoft-antispam-prvs: <TY2PR01MB3419DB7FCC941597804736BEE5A60@TY2PR01MB3419.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3231455)(999002)(944501520)(52105112)(93006095)(93001095)(3002001)(10201501046)(6055026)(148016)(149066)(150057)(6041310)(20161123560045)(20161123558120)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(201708071742011)(7699051)(76991095);SRVR:TY2PR01MB3419;BCL:0;PCL:0;RULEID:;SRVR:TY2PR01MB3419;
x-forefront-prvs: 08831F51DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(39860400002)(366004)(396003)(199004)(189003)(13464003)(105586002)(305945005)(256004)(86362001)(102836004)(6506007)(81166006)(186003)(53546011)(55016002)(478600001)(316002)(106356001)(14444005)(6916009)(53936002)(45080400002)(81156014)(6306002)(26005)(7696005)(2906002)(9686003)(68736007)(74316002)(33656002)(85182001)(966005)(486006)(99286004)(11346002)(229853002)(14454004)(71200400001)(25786009)(71190400001)(446003)(6116002)(6436002)(3846002)(76176011)(6246003)(4326008)(476003)(7736002)(97736004)(5660300001)(8936002)(66066001)(217873002)(8676002)(777600001);DIR:OUT;SFP:1101;SCL:1;SRVR:TY2PR01MB3419;H:TY2PR01MB3050.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-microsoft-antispam-message-info: 62o0C4a+PTtVdNWKz6nBGzGGKPvC52j+e4D0r5gU/0IPC3kzACFO/20oMRlKF2b8X2u1OWoebflgCVfgRNmVeG4aDDrXKcfalJLtvyK2ogk0sfrSImEbLOLv4qbSnqdiIQ1hYcZlZNjwEg761ua9HKEkMnTUQMnUoT0V/XFrbHC6zvQdTaN4evB0cBSEWaw/0x1Y0u91aqzP6ln1LDywPUMi/ke4gUiA8q0PWTOssJ3QjupVRBDtPCNSctmEiQ5IiZPmmvtRoHMEtjeGJz1VecmgrqOB/YYW4T0xgnAKDP4g7oyVNoBEaSXy2/Jc6i4H
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14ec5648-96e2-4cbf-d91d-08d65f47efb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2018 09:06:28.7711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB3419
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> -----Original Message-----
> From: Omar Sandoval [mailto:osandov@osandov.com]
> Sent: Friday, December 7, 2018 10:02 AM
> To: Misono, Tomohiro/=1B$BL#A>Ln=1B(B =1B$BCRNi=1B(B <misono.tomohiro@fuj=
itsu.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH RESEND 0/8] btrfs-progs: sub: Relax the privileges of
> "subvolume list/show"
>=20
> On Tue, Nov 27, 2018 at 02:24:41PM +0900, Misono Tomohiro wrote:
> > Hello,
> >
> > This is basically the resend of
> >   "[PATCH v2 00/20] btrfs-progs: Rework of "subvolume list/show" and re=
lax
> the
> > 	root privileges of them" [1]
> > which I submitted in June. The aim of this series is to allow non-privi=
leged
> user
> > to use basic subvolume functionality (create/list/snapshot/delete; this
> allows "list")
> >
> > They were once in devel branch with some whitespace/comment modificatio=
n by
> david.
> > I rebased them to current devel branch.
> >
> > github: https://github.com/t-msn/btrfs-progs/tree/rework-sub-list
> >
> > Basic logic/code is the same as before. Some differences are:
> >  - Use latest libbtrfsutil from Omar [2] (thus drop first part of patch=
es).
> >    As a result, "sub list" cannot accept an ordinary directry to be
> >    specified (which is allowed in previous version)
> >  - Drop patches which add new options to "sub list"
> >  - Use 'nobody' as non-privileged test user just like libbtrfsutil test
> >  - Update comments
> >
> > Importantly, in order to make output consistent for both root and non-p=
rivileged
> > user, this changes the behavior of "subvolume list":
> >  - (default) Only list in subvolume under the specified path.
> >    Path needs to be a subvolume.
> >  - (-a) filter is dropped. i.e. its output is the same as the
> >         default behavior of "sub list" in progs <=3D 4.19
> >
> > Therefore, existent scripts may need to update to add -a option
> > (I believe nobody uses current -a option).
> > If anyone thinks this is not good, please let me know.
>=20
> I think there are a few options in the case that the path isn't a
> subvolume:
>=20
> 1. List all subvolumes in the filesystem with randomly mangled paths,
>    which is what we currently do.
> 2. Error out, which is what this version of the series does.
> 3. List all subvolumes under the containing subvolume, which is what the
>    previous version does.
> 4. List all subvolumes under the containing subvolume that are
>    underneath the given path.
>=20
> Option 1 won't work well for unprivileged users. Option 2 (this series)
> is definitely going to break people's workflows/scripts. Option 3 is
> unintuitive. In my opinion, option 4 is the nicest, but it may also
> break scripts that expect all subvolumes to be printed.

I think my previous version is 4, or am I misunderstanding?
In previous version, output could be:
 $ mkfs.btrfs -f $DEV
 $ mount $DEV /mnt

 $ btrfs subvolume create /mnt/sub1
 $ btrfs subvolume create /mnt/sub1/sub2
 $ mkdir /mnt/sub1/dir
 $ btrfs subvolume create /mnt/sub1/dir/sub3

 $ btrfs subvolume list /mnt
  ID 256 gen 8 top level 5 path sub1
  ID 258 gen 7 top level 256 path sub1/sub2
  ID 259 gen 8 top level 256 path sub1/dir/sub3
=20
 $ btrfs subvolume list /mnt/sub1
  ID 256 gen 8 top level 5 path .
  ID 258 gen 7 top level 256 path sub2
  ID 259 gen 8 top level 256 path dir/sub3

 $ btrfs subvolume list /mnt/sub1/dir
  ID 259 gen 8 top level 256 path sub3

https://lore.kernel.org/linux-btrfs/6af6dac8829d3ba405e3c53baffd828c9c428ef=
6.1529310485.git.misono.tomohiro@jp.fujitsu.com/

>=20
> There's also an option 5, which is to keep the behavior the same for
> root (like what my previous patch [1] did) and implement option 4 for
> unprivileged users.
>=20
> I think 4 and 5 are the two main choices: do we want to preserve
> backwards compatibility as carefully as possible (at the cost of
> consistency), or do we want to risk it and improve the interface?
>=20
> 1:
> https://github.com/osandov/btrfs-progs/commit/fb61c21aeb998b12c1d02532639=
08
> 3d7f40c41e0

