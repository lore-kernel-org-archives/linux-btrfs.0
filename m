Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A531C10F03
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 02:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA06F208E4
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 02:57:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=oakvillepondscapes.onmicrosoft.com header.i=@oakvillepondscapes.onmicrosoft.com header.b="UUQxPNub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfDXC5w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 22:57:52 -0400
Received: from mail-eopbgr1370047.outbound.protection.outlook.com ([40.107.137.47]:22432
        "EHLO AUS01-SY3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726474AbfDXC5w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 22:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oakvillepondscapes.onmicrosoft.com; s=selector1-pauljones-id-au;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjME6PJnJRe2tyUZ/c7vtgGsbR2i+wljrd4wo3O6pYQ=;
 b=UUQxPNub09vAzictxRhb/5a83iNOsXabrSPwR4y6yTjppvZavJ8XA6qm6HYJ/ixhLvrJm3iIfNH6I+HaObfk2YCRmCozFbQNGbmHJ/JFmYoBSvQc+PwPbf6VG1csg0uMFhpcOlh9vLtUwewXMr9Nfm0QEF++FVEtWsa6kAWeQ/A=
Received: from SYCPR01MB5086.ausprd01.prod.outlook.com (20.178.187.213) by
 SYCPR01MB3664.ausprd01.prod.outlook.com (20.177.141.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.16; Wed, 24 Apr 2019 02:57:47 +0000
Received: from SYCPR01MB5086.ausprd01.prod.outlook.com
 ([fe80::f967:e175:8c5:dbd2]) by SYCPR01MB5086.ausprd01.prod.outlook.com
 ([fe80::f967:e175:8c5:dbd2%2]) with mapi id 15.20.1835.010; Wed, 24 Apr 2019
 02:57:47 +0000
From:   Paul Jones <paul@pauljones.id.au>
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Global reserve and ENOSPC while deleting snapshots on 5.0.9
Thread-Topic: Global reserve and ENOSPC while deleting snapshots on 5.0.9
Thread-Index: AQHU+ilGVotsEiVp/U+WcmmZ1ddAeaZKnMeQ
Date:   Wed, 24 Apr 2019 02:57:47 +0000
Message-ID: <SYCPR01MB508619DDF149E56FAAC7C9D29E3C0@SYCPR01MB5086.ausprd01.prod.outlook.com>
References: <20190423230649.GB11530@hungrycats.org>
In-Reply-To: <20190423230649.GB11530@hungrycats.org>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paul@pauljones.id.au; 
x-originating-ip: [203.213.84.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1d252e5-12aa-4131-59c5-08d6c860a187
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:SYCPR01MB3664;
x-ms-traffictypediagnostic: SYCPR01MB3664:
x-microsoft-antispam-prvs: <SYCPR01MB3664E8CC24116C7067630D609E3C0@SYCPR01MB3664.ausprd01.prod.outlook.com>
x-forefront-prvs: 00179089FD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39830400003)(346002)(136003)(376002)(366004)(13464003)(199004)(189003)(55016002)(110136005)(71200400001)(102836004)(53936002)(6116002)(26005)(476003)(6506007)(53546011)(2906002)(11346002)(6246003)(25786009)(3846002)(33656002)(5660300002)(76176011)(6436002)(229853002)(446003)(99286004)(71190400001)(486006)(7696005)(186003)(74482002)(316002)(14444005)(66476007)(66946007)(86362001)(7736002)(73956011)(66556008)(305945005)(68736007)(256004)(9686003)(74316002)(97736004)(14454004)(66446008)(66066001)(64756008)(76116006)(508600001)(81166006)(81156014)(8936002)(52536014)(8676002)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:SYCPR01MB3664;H:SYCPR01MB5086.ausprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: pauljones.id.au does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SrJSHzfkgYfImSeabMdOs87p4GvTF7wE4/De7u/htPJ4UohdccAWyTTtutl2uOnp8CPThYhCK2Mh4tAn1e4wUBXkoSnRmAN2+w4woacwESJMGtS4lLgm53HuJaQrDhp4VKXupLRL9Li09CRtpzj6aVk7v8LNKoc+1xAVdaAFKjIdFBujm98M4uQhYlej18ohL6773r0iJe037iZ9wuppP21Zp+ZChDQkqAuEWDxeZO7uNpJJAWKfjsWDA6LMSriaVa6KWR/Ds60AD4JfsA7wj2OcJ8uGb5UDFCpscWPZeD/01qnBNS4djbHnF/ZxqB5agKMl/YJIR5iBqvaYElh6GBKxT14EGL+u8sr1BZh7tnHjek6ilWzYUPqkxx369gCD022rb5PMadCP7okzwRjGhKicE8q4BFCm6WAmM9J0bK4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: pauljones.id.au
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d252e5-12aa-4131-59c5-08d6c860a187
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2019 02:57:47.0570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8f216723-e13f-4cce-b84c-58d8f16a0082
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYCPR01MB3664
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org <linux-btrfs-
> owner@vger.kernel.org> On Behalf Of Zygo Blaxell
> Sent: Wednesday, 24 April 2019 9:07 AM
> To: linux-btrfs@vger.kernel.org
> Subject: Global reserve and ENOSPC while deleting snapshots on 5.0.9
>=20
> I had a test filesystem that ran out of unallocated space, then ran out o=
f
> metadata space during a snapshot delete, and forced readonly.
> The workload before the failure was a lot of rsync and bees dedupe
> combined with random snapshot creates and deletes.
>=20
> I tried the usual fix strategies:
>=20
> 	1.  Immediately after mount, try to balance to free space for
> 	metadata
>=20
> 	2.  Immediately after mount, add additional disks to provide
> 	unallocated space for metadata
>=20
> 	3.  Mount -o nossd to increase metadata density
>=20
> #3 had no effect.  #1 failed consistently.
>=20
> #2 was successful, but the additional space was not used because btrfs
> couldn't allocate chunks for metadata because it ran out of metadata spac=
e
> for new metadata chunks.
>=20
> When btrfs-cleaner tried to remove the first pending deleted snapshot, it
> started a transaction that failed due to lack of metadata space.
> Since the transaction failed, the filesystem reverts to its earlier state=
, and
> exactly the same thing happens on the next mount.  The 'btrfs dev add' in=
 #2
> is successful only if it is executed immediately after mount, before the =
btrfs-
> cleaner thread wakes up.

I had a similar problem on iirc 4.20, except that I couldn't get the new de=
vices to add (raid1) before the cleaner thread ran, no matter how fast I ad=
ded them after mount.
I ended up just commenting out the part that forces the fs to go read only.=
 The cleaner thread exits gracefully (I think?) so then it was no trouble t=
o add the devices.

Is it still necessary to have the fs go read only like that when it's out o=
f space?

Paul.
