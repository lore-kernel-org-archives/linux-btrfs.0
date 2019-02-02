Return-Path: <SRS0=C6pa=QJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DE1C282D7
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Feb 2019 12:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAB1520869
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Feb 2019 12:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfBBMBw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Feb 2019 07:01:52 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:44583 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfBBMBw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2019 07:01:52 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gptzZ-0000jf-GM; Sat, 02 Feb 2019 12:01:49 +0000
Date:   Sat, 2 Feb 2019 12:01:49 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Alan Hardman <alanh@fastmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: RAID1 filesystem not mounting
Message-ID: <20190202120149.GE4461@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Alan Hardman <alanh@fastmail.com>, linux-btrfs@vger.kernel.org
References: <4ef8b545-efa8-43b0-8576-78c71bfb0e2c@www.fastmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="a1QUDc0q7S3U7/Jg"
Content-Disposition: inline
In-Reply-To: <4ef8b545-efa8-43b0-8576-78c71bfb0e2c@www.fastmail.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--a1QUDc0q7S3U7/Jg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 01, 2019 at 11:28:27PM -0500, Alan Hardman wrote:
> I have a Btrfs filesystem using 6 partitionless disks in RAID1 that's fai=
ling to mount. I've tried the common recommended safe check options, but I =
haven't gotten the disk to mount at all, even with -o ro,recovery. If neces=
sary, I can try to use the recovery to another filesystem, but I have aroun=
d 18 TB of data on the filesystem that won't mount, so I'd like to avoid th=
at if there's some other way of recovering it.
>=20
> Versions:
> btrfs-progs v4.19.1
> Linux localhost 4.20.6-arch1-1-ARCH #1 SMP PREEMPT Thu Jan 31 08:22:01 UT=
C 2019 x86_64 GNU/Linux
>=20
> Based on my understanding of how RAID1 works with Btrfs, I would expect a=
 single disk failure to not prevent the volume from mounting entirely, but =
I'm only seeing one disk with errors according to dmesg output, maybe I'm m=
isinterpreting it:
>=20
> [  534.519437] BTRFS warning (device sdd): 'recovery' is deprecated, use =
'usebackuproot' instead
> [  534.519441] BTRFS info (device sdd): trying to use backup root at moun=
t time
> [  534.519443] BTRFS info (device sdd): disk space caching is enabled
> [  534.519446] BTRFS info (device sdd): has skinny extents
> [  536.306194] BTRFS info (device sdd): bdev /dev/sdc errs: wr 23038942, =
rd 22208378, flush 1, corrupt 29486730, gen 2933
> [  556.126928] BTRFS critical (device sdd): corrupt leaf: root=3D2 block=
=3D25540634836992 slot=3D45, unexpected item end, have 13882 expect 13898

   It's worth noting that 13898-13882 =3D 16, which is a power of
two. This means that you most likely have a single-bit error in your
metadata. That, plus the checksum not being warned about, would
strongly suggest that you have bad RAM. I would recommend that you
check your RAM first before trying anything else that would write to
your filesystem (including btrfs check --repair).

   Hugo.

> [  556.134767] BTRFS critical (device sdd): corrupt leaf: root=3D2 block=
=3D25540634836992 slot=3D45, unexpected item end, have 13882 expect 13898
> [  556.150278] BTRFS critical (device sdd): corrupt leaf: root=3D2 block=
=3D25540634836992 slot=3D45, unexpected item end, have 13882 expect 13898
> [  556.150310] BTRFS error (device sdd): failed to read block groups: -5
> [  556.216418] BTRFS error (device sdd): open_ctree failed
>=20
> If helpful, here is some lsblk output:
>=20
> NAME   TYPE   SIZE FSTYPE MOUNTPOINT UUID
> sda    disk 111.8G                  =20
> =E2=94=9C=E2=94=80sda1 part   1.9M                  =20
> =E2=94=94=E2=94=80sda2 part 111.8G ext4   /          c598dfdf-d6e7-47d3-8=
88a-10f5f53fa338
> sdb    disk   7.3T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481b
> sdc    disk   7.3T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481b
> sdd    disk   7.3T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481b
> sde    disk   7.3T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481b
> sdf    disk   2.7T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481b
> sdh    disk   2.7T btrfs             8f26ae2d-84b5-47d7-8f19-64b0ef5a481b
>=20
> My main system partition on sda mounts fine and is usable to work with th=
e btrfs filesystem that's having issues.
>=20
> Running "btrfs check /dev/sdb" exits with this:
>=20
> Opening filesystem to check...
> Incorrect offsets 13898 13882
> ERROR: cannot open file system
>=20
> Also, "btrfs restore -Dv /dev/sdb /tmp" outputs some of the files on the =
filesystem but not all of them. I'm not sure if this is limited to the file=
s on that physical disk, or if there's a bigger issue with the filesystem. =
I'm not sure what the best approach from here is, so any advice would be gr=
eat.

--=20
Hugo Mills             | If it's December 1941 in Casablanca, what time is =
it
hugo@... carfax.org.uk | in New York?
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                               Rick Blaine, Casabla=
nca

--a1QUDc0q7S3U7/Jg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcVYatAAoJEFheFHXiqx3keqMQAKv4DjhWPfG9rFkAti+LxpW2
LnMflfWNF7c+5NACN2VuK5eKXDoUenXSQjyzbrhn4DV9yyzq7sc+02OxiOOV/aOB
BcwnpCSypkQIU2yShyZLPxCtGLqhktlDuC2JyktsbrAfGzWowuFV0ZRD6lNvFCBT
AssHw6PLSAO/zlK2UB1xxt1cqpS8jfOL/RxTVS8i/areUjX+9tCUH0yr77u3OVjG
hxojGey9tYFFlzngoKQbg5kpYjTTGPslzUi3TtdHvsemn0OOSn2JXJ38aJmUVf/0
YRMIfucV18bEuwyUIsz2rLKN53HLfBenP1hIBRmBYYJWYnSBSTatDFbznlSzFEfR
1UYg86zc93URgX7D/V/LUiankmbp53qkBQ1lOaUsMHmLE5Mxg/PJVWbJR1ytNSvF
/tok0Z57DNmjqgUVf8LuJiiWcO4BcwuHdESs9b0wm/1dZk7nm8MclmTpDSNz+Byg
q5YO3Y9iPlFjo++CykphTb3On13NU+WeDn08VesW/vX6ljEn/B+O0LtxYZ+3w7VY
O/I1Ft+vPZHCKiFRsKHzwTyxdiU7e9Rc7ZOt1Dlutk/eE5MIItVFO7lD0MrYGKKB
illkxgEVF/8f9Lt1AI1YkwypTWljkJOt96mbO+vZZnl7hHZ7SOBo6jXlpNTbjP4E
m8LCJjYZix0/bYvPVg0t
=BwPu
-----END PGP SIGNATURE-----

--a1QUDc0q7S3U7/Jg--
