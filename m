Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B669CC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 03:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C5582086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 03:01:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fujitsu.onmicrosoft.com header.i=@fujitsu.onmicrosoft.com header.b="TBcTHpxm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C5582086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbeK0N5s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 08:57:48 -0500
Received: from esa11.fujitsucc.c3s2.iphmx.com ([216.71.156.121]:30441 "EHLO
        esa11.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728134AbeK0N5r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 08:57:47 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2018 08:57:45 EST
X-IronPort-AV: E=McAfee;i="5900,7806,9089"; a="1658734"
X-IronPort-AV: E=Sophos;i="5.56,285,1539615600"; 
   d="scan'208";a="1658734"
Received: from mail-hk2apc01lp0207.outbound.protection.outlook.com (HELO APC01-HK2-obe.outbound.protection.outlook.com) ([65.55.88.207])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Nov 2018 11:51:42 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector1-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFac1qYmr3qLaJ9XAmemN9r8FgtvulBsWlpu9qgzQ38=;
 b=TBcTHpxm1Fwf5HMhlsoJTWb9voJVaui1e7e5XWphVwMvYLyPTtj6gcgxyrURkTpF6D8UPGfncysdTDa3Cd3Z4pW+xaM6nj6OMYX1kfGksd9xBP2eFOID+Ikp8ZcbF4EX/9VHPRxbz4sp4T0jUOwtsDB4mbKAc+tjMYXgrGGfSF8=
Received: from TY2PR01MB3050.jpnprd01.prod.outlook.com (20.177.99.84) by
 TY2PR01MB3067.jpnprd01.prod.outlook.com (20.177.98.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1339.26; Tue, 27 Nov 2018 02:51:38 +0000
Received: from TY2PR01MB3050.jpnprd01.prod.outlook.com
 ([fe80::ec50:8330:3075:42b3]) by TY2PR01MB3050.jpnprd01.prod.outlook.com
 ([fe80::ec50:8330:3075:42b3%6]) with mapi id 15.20.1339.032; Tue, 27 Nov 2018
 02:51:37 +0000
From:   "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
To:     "'dsterba@suse.cz'" <dsterba@suse.cz>,
        Omar Sandoval <osandov@osandov.com>
CC:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: RE: [PATCH 00/10] btrfs-progs: my libbtrfsutil patch queue
Thread-Topic: [PATCH 00/10] btrfs-progs: my libbtrfsutil patch queue
Thread-Index: AQHUe+5Z2dDiNiF+JUyu84SZCxvJUqViT2QAgACsPIA=
Date:   Tue, 27 Nov 2018 02:51:37 +0000
Message-ID: <TY2PR01MB305068E71637C95DC501B6F1E5D00@TY2PR01MB3050.jpnprd01.prod.outlook.com>
References: <cover.1542181521.git.osandov@fb.com>
 <20181126161811.GH2842@twin.jikos.cz>
In-Reply-To: <20181126161811.GH2842@twin.jikos.cz>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckerpolicyversion: FJ-ISEC-20180424-NoSave-enc
x-shieldmailcheckermailid: b4c26742f86b41f5926db39e5b4ac102
x-securitypolicycheck: OK by SHieldMailChecker v2.5.7
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=misono.tomohiro@fujitsu.com; 
x-originating-ip: [180.43.167.189]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;TY2PR01MB3067;6:ck6bE8C+chSWp0SI+JGa/iEMO/BcFWbT7eGUXHG/uEmbZqIVZ5iN7vLdZpyWqCbXjNDZxXjtXJ72DopKY3hZAMzSW7MARhsJ2HXY8KNWvdDXI6aTU4amfy51UXCOwN3t1+S2OFef1uk1qnuoL4iWFWPM4e1D+SXbfGq5iC07JPWvSXLA6Hy1akMR7bZ/6LUneOnSEDox3KEJrOn5wLqAt+tbHFTsCYKDWClZ8EohwLdORKI/jij+rACVaClyddm0S/KzPTzvXbXGEjiF920ylm2dwfuXDgpgosCdv5lH1VnA3Iq2w1sw5UoJfUhMtZI+dVpEUTGs6leK3F7to55FanO59UA65MiWFaF8PQdLhoul7btw/CZeVogosGF0+AcrnPVFui2vUrjDMJRgOYaqZPiihEmoYSq44/02t6fvODhp4Ldlq8vnz+6DhheTmqn+1GHqrcUJs+6BYw5Cq7sL4g==;5:0HDbdosXHeMuOkav+uZI2chzS49JibHxsVL3Slh/VzD3XSgFkoDZyJr1PSYMbeEy7y0fOKldIFj7MlHwznKFTS4QahKkwSC9yTrJrd084JGx1rDxAkg7ANSYklWwY/ytUyHqquB7cvZTiMQeIyfRsB2wV26Dt+kaCOUEO3O5Dh8=;7:/fl4Q5O8ULINE9D5J6zRdUdMsPG1nUFh+m+TdQnw90Ah1dgcVjeb8t2MNGRNWfg7T8KSkp40vrVw6R3S0UWrUkqQO/Vb1Q9uM9n+YPhKkfF0aUyi9qxV9SFLTNjIwmQ6T1j6ySg4VZsDz5Wv8ffYeA==
x-ms-exchange-antispam-srfa-diagnostics: SOS;
x-ms-office365-filtering-correlation-id: f2370826-0a87-4394-74b8-08d65413404c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390098)(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:TY2PR01MB3067;
x-ms-traffictypediagnostic: TY2PR01MB3067:
x-microsoft-antispam-prvs: <TY2PR01MB3067C1994FC8C514D64FDF87E5D00@TY2PR01MB3067.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(10201501046)(3231443)(944501410)(52105112)(3002001)(93006095)(93001095)(6055026)(148016)(149066)(150057)(6041310)(20161123564045)(20161123558120)(20161123560045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:TY2PR01MB3067;BCL:0;PCL:0;RULEID:;SRVR:TY2PR01MB3067;
x-forefront-prvs: 086943A159
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(366004)(39860400002)(346002)(189003)(199004)(13464003)(446003)(486006)(33656002)(476003)(81156014)(6506007)(11346002)(14454004)(53546011)(6436002)(305945005)(8676002)(81166006)(8936002)(4326008)(76176011)(97736004)(7696005)(3846002)(478600001)(54906003)(102836004)(85182001)(25786009)(2906002)(106356001)(229853002)(9686003)(256004)(66066001)(68736007)(105586002)(6246003)(7736002)(55016002)(186003)(5660300001)(71200400001)(316002)(99286004)(74316002)(26005)(53936002)(14444005)(86362001)(71190400001)(110136005)(6116002)(777600001)(491001);DIR:OUT;SFP:1101;SCL:1;SRVR:TY2PR01MB3067;H:TY2PR01MB3050.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-microsoft-antispam-message-info: grCqpNj2q/kwypomSftvqjc7nq5c493tAYsRcPzdpgqv1p41I0BM5bo9LdJcH9fpauXdLVO4wNtLXPXBrGIKibZKhgv8PAA72xGK8BhqG24t2ELof/1mD7LLGUTWXHM/WKSUDQ1Hhy7Gc3iSiZ7b11W3x33U2zKaFZgQeSbjzoYZ5N+NQmrBsT629W4U9VINPkTZ3qdNJAz4ad6WxzU0w8uPkwWFNDClDSwG5qR2R+jb/DSB1cu7bv0puqLTt5dfzcXCW8ieRhBOqDkM3NAE+5p03bfhl8hxbk8PDGVzeb0MMfeLotnN5CY89J9MvPTaXRppRBcEz9NcAz9ca62xapZrfUYcRsLq419+fu4DPDQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2370826-0a87-4394-74b8-08d65413404c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2018 02:51:37.8899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB3067
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Tuesday, November 27, 2018 1:18 AM
> To: Omar Sandoval <osandov@osandov.com>
> Cc: linux-btrfs@vger.kernel.org; kernel-team@fb.com; Misono, Tomohiro
> <misono.tomohiro@fujitsu.com>
> Subject: Re: [PATCH 00/10] btrfs-progs: my libbtrfsutil patch queue
>=20
> On Tue, Nov 13, 2018 at 11:46:55PM -0800, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> >
> > Hi,
> >
> > This series contains my backlog of libbtrfsutil changes which I've been
> > collecting over the past few weeks.
> >
> > Patches 1-4 are fixes. Patches 5-6 add functionality to the unit tests
> > which is needed for patches 7-8. Patches 7-8 add support for the
> > unprivileged ioctls added in Linux 4.18; more on those below. Patch
> 9
> > bumps the library version. Patch 10 adds documentation for the availabl=
e
> > API along with examples.
> >
> > Patches 7-8 are based on Misono Tomohiro's previous patch series [1],
> > with a few important changes.
> >
> > - Both subvolume_info() and create_subvolume_iterator() now have unit
> >   tests for the unprivileged case.
> > - Both no longer explicitly check that top =3D=3D 0 in the unprivileged
> >   case, since that will already fail with a clear permission error.
> > - Unprivileged iteration is much simpler: it uses openat() instead of
> >   fchdir() and is based more closely on the original tree search
> >   variant. This fixes a bug in post-order iteration in Misono's version=
.
> > - Unprivileged iteration does _not_ support passing in a non-subvolume
> >   path; if this behavior is desired, I'd like it to be a separate chang=
e
> >   with an explicit flag.
>=20
> Series merged to devel, thanks. I've added link from the main README now
> that there's the API documentation.
>=20
> The test-libbtrfsutil is missing from the travis CI for some reason, I
> was about to add it.  So far the testing environment does not provide
> 'umount' that knows about '-R' so the tests fail. I'll have a look if
> there's a newer base image provided, otherwise a workaround would be
> necessary.
>=20
> As for the unprivileged subvolume listing ioctls, the functionality in
> the util library is self-contained and the interface is up to you to
> design properly, so this does not depend on the 'btrfs subvolume list'
> command. That one has unfortunately not bubbled high enough in my todo.

Hello,
I missed the mails and am sorry for late response.

As mentioned libbtrfsuitl and other progs are mostly independent,
the patches I submitted (once in devel with your review and some modificati=
on)
can be cleanly applied to this version of libbtrfsutil.

I will resend them for easier review/comment.

Thanks,
Misono
