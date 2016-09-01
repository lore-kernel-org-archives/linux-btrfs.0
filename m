Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45814 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754500AbcIAVNn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Sep 2016 17:13:43 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
Date: Thu, 1 Sep 2016 13:12:34 -0400
MIME-Version: 1.0
In-Reply-To: <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tdImtoupxGXTsjAtckErMhdJfGFOSsnR4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tdImtoupxGXTsjAtckErMhdJfGFOSsnR4
Content-Type: multipart/mixed; boundary="S4c5CCaplMBhciGITx7tfTCf0a8D6EdKM";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
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
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
In-Reply-To: <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>

--S4c5CCaplMBhciGITx7tfTCf0a8D6EdKM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/1/16 1:04 PM, Austin S. Hemmelgarn wrote:
> On 2016-09-01 12:34, Ronan Arraes Jardim Chagas wrote:
>> Em Qui, 2016-09-01 =C3=A0s 09:21 -0400, Austin S. Hemmelgarn escreveu:=

>>> Yes, you can just run `btrfs quota disable /` and it should
>>> work.  This
>>> ironically reiterates that one of the bigger problems with BTRFS is
>>> that
>>> distros are enabling unstable and known broken features by default
>>> on
>>> install.  I was pretty much dumbfounded when I first learned that
>>> OpenSUSE is enabling BTRFS qgroups by default since they are known
>>> to
>>> not work reliably and cause all kinds of issues.
>>
>> Thanks Austin! I executed the command and now I get:
>>
>> btrfs qgroup show /
>> ERROR: can't perform the search - No such file or directory
>> ERROR: can't list qgroups: No such file or directory
>>
>> as expected. Now I will wait for +- 1 week to see if the problem will
>> occur and, if not, I will send an e-mail to openSUSE factory mailing
>> list to start a discussion if it is better to not enable qgroups by
>> default.
> I have a feeling that you'll probably have no issues.
>=20
> As far as having qgroups enabled by default, I think the reasoning is t=
o
> emulate having separate filesystems with their own space limits.  I can=


It's not.  We use qgroups because that's the only way we can track how
much space each subvolume is using, regardless of whether anyone wants
to do enforcement.  When it's working properly, snapper can make use of
that information to make informed decisions on how much space will
actually be released when removing old snapshots.

> entirely understand this use case, and TBH it's about the only use case=

> I'd consider quota groups for (per-user subvolumes for home directories=

> are great, but there are numerous perfectly legitimate reasons to have
> very large amounts of data in your home directory for very short period=
s
> of time, so I wouldn't personally use qgroups there).  The problem
> arises from the fact that it doesn't _look_ like separate filesystems
> (single entry in df, all the mounts point at the same device, etc), and=


On SUSE-based kernels, the inodes on different subvolumes report the
anonymous device associated with the subvolume.

That said, I have a WIP that creates (and auto-tears down) vfsmounts for
each subvolume.  It's not all the way to a working df that would use the
qgroup information to report space usage, but it's a start.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--S4c5CCaplMBhciGITx7tfTCf0a8D6EdKM--

--tdImtoupxGXTsjAtckErMhdJfGFOSsnR4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXyGGGAAoJEB57S2MheeWyuBwQALUtECd9woeZWBfN+cKFdLCh
yWoCAm6X/7u6AQzr7G3nmHWm1R7OjS6JbgB+erm4ALR3jovyKJJL9R6Z51q/tVul
ed147d3vRhP06BUM376NceRZ/YKFT3i3aGGUB0CtRnXO8sNzJvFKgePIBZu0xbZw
F8eyc4NiypxkU+jku6OQGMocrHr6e1fcvWtD7WYApKGaAEV3EILP2o0fSxeyrEFD
o2G7KsBL6Kx17p45mRNkFat/1+DSDlsLGryZlx7pTCGB1r4bA8+S9qPbBklJV/sn
bIBLAu0ZI4y+o17jif8MKmFfW1l5V2A2OaDdPmmAQHvbHQ7lPQeCmR3cAERCr+ON
yWx/21HxRlp8xnale7Npa4/Cbb2lpVhSNzZc7kIaOFddaf4FzGKuJNjAyASucfuB
wfb2/xMZNLJQr0wlkGfNl/+BF8NHLRL0fCb8dTE7+lythc4Y1jMSSxq7FYJdzXbR
i1pPQ2ne+ATRlm8AYkYiXNp13XqGcQ08DNTonBAvkUA1Ac9h4/K8P2nWcvtftSJI
+OcQsWUpEIAytBUFJVnPWu0289AaNs8aCzAYd1SKG1GYhjgo5czxCvbHHX237jd3
N1z5kAgMsKF67c7q4Kkvli8/+Xe1EAMtkZQ7ftuGW73fAZy4OU85rNt/ROsPC5vU
3H6XehtYmbQUzy+p2pnd
=4cBu
-----END PGP SIGNATURE-----

--tdImtoupxGXTsjAtckErMhdJfGFOSsnR4--
