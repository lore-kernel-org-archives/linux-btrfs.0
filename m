Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55331 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752913AbeCRCYC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Mar 2018 22:24:02 -0400
Subject: Re: Crashes running btrfs scrub
To: Mike Stevens <michael.stevens@bayer.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CAJCQCtTUsH5ynMCjRRcnGZHAccOcUL4os3GriBb+mwwtR8SC2w@mail.gmail.com>
 <6b4f2b33edb44f1ea8cef47ae68960af@MOXDE7.na.bayer.cnb>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <18c79400-86f4-8598-7c1d-905d69823cd5@gmx.com>
Date: Sun, 18 Mar 2018 10:23:54 +0800
MIME-Version: 1.0
In-Reply-To: <6b4f2b33edb44f1ea8cef47ae68960af@MOXDE7.na.bayer.cnb>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="COuIhL21YXxeZmJ4EvnC81ruIN6QSpMeC"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--COuIhL21YXxeZmJ4EvnC81ruIN6QSpMeC
Content-Type: multipart/mixed; boundary="66Uc0rbgUUjcw931jmvIzQgs2Zk00DkQE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Mike Stevens <michael.stevens@bayer.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <18c79400-86f4-8598-7c1d-905d69823cd5@gmx.com>
Subject: Re: Crashes running btrfs scrub
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CAJCQCtTUsH5ynMCjRRcnGZHAccOcUL4os3GriBb+mwwtR8SC2w@mail.gmail.com>
 <6b4f2b33edb44f1ea8cef47ae68960af@MOXDE7.na.bayer.cnb>
In-Reply-To: <6b4f2b33edb44f1ea8cef47ae68960af@MOXDE7.na.bayer.cnb>

--66Uc0rbgUUjcw931jmvIzQgs2Zk00DkQE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8816=E6=97=A5 23:03, Mike Stevens wrote:
>> Can you post a more complete dmesg rather than snipping it? Is there
>> anything device or Btrfs related in the 5 minutes before this trace
>> happens? And is it still going read only?
>=20
> It's still going read only after the 4.15.10 update.  Here's a lot more=
 log:
>=20

> Mar 15 14:01:14 auswscs9903 MR_MONITOR[1821]: <MRMON243> Controller ID:=
  0   Fan speed changed on enclosure:   1  Fan#012      1
> Mar 15 14:03:06 auswscs9903 kernel: ------------[ cut here ]-----------=
-
> Mar 15 14:03:06 auswscs9903 kernel: WARNING: CPU: 6 PID: 2720 at fs/btr=
fs/extent-tree.c:10192 btrfs_create_pending_block_groups+0x1f3/0x260 [btr=
fs]
> Mar 15 14:03:06 auswscs9903 kernel: BTRFS: error (device sdag) in btrfs=
_create_pending_block_groups:10192: errno=3D-27 unknown

-27 is EFBIG.

And in the call trace of btrfs_create_pending_block_groups, I think it's
triggered by btrfs_add_system_chunk(), which will return -EFBIG if a
superblock can't contain that much system chunk entries.


Furthermore, you have too many disks which dramatically increase the
superblock system chunk array usage.

If you're putting too many devices into one single btrfs and uses
profile that utilize all disks like RAID0/10/5/6, then it will easily
take up all space of superblock.

Since even raid6 can only tolerant 2 disks failure, for so many disks it
won't help much.

It's recommended to use RAID10 for metadata and system chunk profiles,
and reduce device number to a reasonable number.

Thanks,
Qu


--66Uc0rbgUUjcw931jmvIzQgs2Zk00DkQE--

--COuIhL21YXxeZmJ4EvnC81ruIN6QSpMeC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqtzboXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjKPgf/R9fpX+6/XWQigHwu8VG7LfbY
wzUBN+gGJayVRoxsYpKpw12nDjfkHdMyZoR8JXTwISbfLvIVa6/hCJz8FjlCYZhc
A3qhLi1OxPRTlvgwnAsAyDFcPTfbe0K8XgRyrW34OGU7g+OK71RRigr9o5SIJ7L5
3pfqGXXseTW3+hdVSQ7J0MX9eJ3EASe8oqoqSxkUBlFK4xlwbv0LrQEGveNRQMQU
gqVKO4VjYXNupsjISzYbHrdj/HzhWsNvLmhk53h3eCpvbhKZym/4YR0Snc3ArE3h
SawtP5TjMSp2CwSs9HGM9DGlCj3WK1hF6R8HSR+KxJ9sHMRqryFG/qzbKqVrew==
=h/44
-----END PGP SIGNATURE-----

--COuIhL21YXxeZmJ4EvnC81ruIN6QSpMeC--
