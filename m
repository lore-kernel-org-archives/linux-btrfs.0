Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59739 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753692AbcHaXDW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 19:03:22 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Chris Murphy <lists@colorremedies.com>
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
Cc: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
Date: Wed, 31 Aug 2016 19:03:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="glCm0IP0MKW1TNBFtoGukPPVvgBBhPPkJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--glCm0IP0MKW1TNBFtoGukPPVvgBBhPPkJ
Content-Type: multipart/mixed; boundary="gSEVqLaDIiwcgTpUb8WAOlCHuAJIKHctg";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
In-Reply-To: <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>

--gSEVqLaDIiwcgTpUb8WAOlCHuAJIKHctg
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/31/16 6:58 PM, Chris Murphy wrote:
> On Wed, Aug 31, 2016 at 4:47 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 8/31/16 5:48 PM, Chris Murphy wrote:
>>> OK it looks like with -w flag I can get a reliable indication of
>>> whether quota is enabled or not:
>>>
>>> [root@f24s ~]# btrfs quota enable /mnt/0
>>> [root@f24s ~]# btrfs quota rescan -w /mnt/0
>>> quota rescan started
>>> [root@f24s ~]# btrfs quota disable /mnt/0
>>> [root@f24s ~]# btrfs quota rescan -w /mnt/0
>>> ERROR: quota rescan failed: Invalid argument
>>>
>>>
>>> So if you did not enable quota support, and aren't sure if it's
>>> enabled you can try 'btrfs quota rescan -w <mp>' but this might
>>> actually be a bad idea, a rescan could take a while if you're actuall=
y
>>> using quotas, I have no idea because I don't use them.
>>
>> It can take a while, but the code is smart enough not to get too much =
in
>> the way of other activity.  It maintains a progress marker and only do=
es
>> live accounting on extents that have already been scanned.
>>
>>> Perhaps someone can point out an easier way to determine whether
>>> quotas are enabled?
>>
>> btrfs qgroup show <path>
>=20
> Wow, thanks but that's not obvious at all. man btrfs quota is
> described as "btrfs-quota - control the global quota status of a btrfs
> filesystem" so it stands to reason the state command for whether it's
> enabled or disabled would be in that subcommand not in some other
> subcommand.

Agreed.  The tools interface has some warts.

> But this is sidetracking. Does Ronan's call trace showing
> /fs/btrfs/qgroup.c:2667
>> btrfs_qgroup_free_meta implicate qgroups as a possible source of his p=
roblem? That trace would only happen if quotas were enabled, right?
>=20

Yeah.  That warning doesn't get checked unless they're enabled.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--gSEVqLaDIiwcgTpUb8WAOlCHuAJIKHctg--

--glCm0IP0MKW1TNBFtoGukPPVvgBBhPPkJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXx2I0AAoJEB57S2MheeWySn8P/2bLStClhxLZZXqcVroDYGVm
l3nrsgluCAdGFgyHPuI9eJig09wOjkWEELMvfZ3T9HVd3uPNjWjZVhvaOjHOblbe
uFzhdMW0JzlkCm22btD2me03gYcVUXGWy1u11Sn8MmaGKu1LhnYaqyaH0MsO2XAT
jPUgH41T2ZTRMC23yyOEustS/68utCJQrpnJV3XYEWn18SzBCQA1qfpNp4MLe+wD
gmv8mat+BlZ8PqtA+MTfmQElkntrWJrqxa6o741UBygx3nKstIeOJ1HG/nkTud49
GJ85v2l4RBlsEM9buFDjSyIWb/si3tDsM+XtIFqCD8PULCCMRLdFkM7ZhZV86P3g
uQSYwh3K9id9e0qTdMKWg2BkJ6OQsEWRyw/f4aV+pTCgQjDMoh8Il/laZjMdn+HR
nJDy5IVAvVKJJT5DWFfoCjzQ10Uwk1f3iw570QCWapBJhYH94CU4MIf7GwZhfxWD
OKBT5lFnAozDopICPMXIR9IGNFg5RXUbaaDi/DLEG0u/aqOsHH2s5OLWKOCt9J/D
gRan76rNYi8WTYpFkGg/Akqznp0Py0m/kcS3//y8yCQlfCGBxpj6QSkeJPDIUu92
k4SDhZVwA82Ws3sbrnOegy6Br37Uzt0nu2pCrbLW8UJ1YyzxFqfwgC48LCosyKmi
azsj/i7dht28vJ3GujVO
=B4wP
-----END PGP SIGNATURE-----

--glCm0IP0MKW1TNBFtoGukPPVvgBBhPPkJ--
