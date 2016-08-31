Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58473 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753280AbcHaWrq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 18:47:46 -0400
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
Cc: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
Date: Wed, 31 Aug 2016 18:47:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LgxWgpao4tXNWXJ9GkL9rwBdfEgKTju3u"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LgxWgpao4tXNWXJ9GkL9rwBdfEgKTju3u
Content-Type: multipart/mixed; boundary="s70k9JhNRUXqsHoqSnxAejmqIgHRmXjXr";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
 Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
 Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
In-Reply-To: <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>

--s70k9JhNRUXqsHoqSnxAejmqIgHRmXjXr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/31/16 5:48 PM, Chris Murphy wrote:
> OK it looks like with -w flag I can get a reliable indication of
> whether quota is enabled or not:
>=20
> [root@f24s ~]# btrfs quota enable /mnt/0
> [root@f24s ~]# btrfs quota rescan -w /mnt/0
> quota rescan started
> [root@f24s ~]# btrfs quota disable /mnt/0
> [root@f24s ~]# btrfs quota rescan -w /mnt/0
> ERROR: quota rescan failed: Invalid argument
>=20
>=20
> So if you did not enable quota support, and aren't sure if it's
> enabled you can try 'btrfs quota rescan -w <mp>' but this might
> actually be a bad idea, a rescan could take a while if you're actually
> using quotas, I have no idea because I don't use them.

It can take a while, but the code is smart enough not to get too much in
the way of other activity.  It maintains a progress marker and only does
live accounting on extents that have already been scanned.

> Perhaps someone can point out an easier way to determine whether
> quotas are enabled?

btrfs qgroup show <path>

If you get a message like:
ERROR: can't perform the search - No such file or directory
ERROR: can't list qgroups: No such file or directory

=2E.. it means there's no quota root and thus quotas aren't enabled.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--s70k9JhNRUXqsHoqSnxAejmqIgHRmXjXr--

--LgxWgpao4tXNWXJ9GkL9rwBdfEgKTju3u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXx16NAAoJEB57S2MheeWy6FsP/RbXVZNV7Xusj+HWsE7q7cLF
cQ6k/bk2HZG2w8atwV3pcyik8l2Fn9FzSe+1tlORXy1r52ZhtEbqGDD6XkUu53J/
J0irYZ/VBB3FQD/rH51+6BRIE6icZ4Vw0++8IHSclKc4Io4XXQohhzVAfzb1J0O2
aEXFXFkbfQ5paQjOojlUDBmrsBD+0OUpRWiFE6AHIFKBma8r42n+cSgkQAoutfJV
J212iCYjR9uSCurCOX5UvIkWYjIDbman6Y3TfOcUTRp+lv3371t4Le4R4Kiq4bYo
O+TjVK40ry1E1A0dvDWEyJ5PHI0h+J94aUBma/aFlaPecR+ZgdSZCVIsM8K+rU82
pOONvsuKu3V1hH0oICcVDlhDx2iINVyTEDHAe3He1PlAy9mO3kd/NTc+g/L42/7T
4ctgS7xjhiURRbJHH6/Qs/YIInl/mFTWxEwRdI0km9x+rs6530bZNMVgWhpTd5T9
QHjyUobhuF8mJ+LTB5c+OwJQBahCwItGtzBqJxAHve1g2pSV4m1qRN7199oZOnZP
L0ki+11lawhc7zdupyBMCOHen0Plv2UsB8rEhgesjtOhGX1jnu6P3yDS7a/3GyrM
foTz7nwQWPyHLwPhyIUUv8SxdcUMbEHytcT5jTZpFhmSMZObwjrdSDAMCRlMye/O
U2142tfQgM2oYfwjErtN
=4I0i
-----END PGP SIGNATURE-----

--LgxWgpao4tXNWXJ9GkL9rwBdfEgKTju3u--
