Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C284C65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 21:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DF232054F
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 21:21:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DF232054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=carfax.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbeJIEfc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 00:35:32 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:60018 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbeJIEfc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 00:35:32 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1g9cyJ-00037b-F7; Mon, 08 Oct 2018 21:21:47 +0000
Date:   Mon, 8 Oct 2018 21:21:47 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Pierre Couderc <pierre@couderc.eu>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Which device is missing ?
Message-ID: <20181008212147.GA9538@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Pierre Couderc <pierre@couderc.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <700c973f-7ac7-5416-6e15-9e5e4faf9f67@couderc.eu>
 <20181008161055.GB25913@carfax.org.uk>
 <20181008161447.GC25913@carfax.org.uk>
 <b93e52ee-7bc5-db85-b634-d8aa5ed80ced@couderc.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <b93e52ee-7bc5-db85-b634-d8aa5ed80ced@couderc.eu>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 08, 2018 at 11:01:35PM +0200, Pierre Couderc wrote:
> On 10/08/2018 06:14 PM, Hugo Mills wrote:
> >On Mon, Oct 08, 2018 at 04:10:55PM +0000, Hugo Mills wrote:
> >>On Mon, Oct 08, 2018 at 03:49:53PM +0200, Pierre Couderc wrote:
> >>>I ma trying to make a "RAID1" with /dev/sda2 ans /dev/sdb (or similar).
> >>>
> >>>But I have stranges status or errors=A0 about "missing devices" and I
> >>>do not understand the current situation :
> >>>
> >>>
> >>>root@server:~# btrfs fi show
> >>>Label: none=A0 uuid: 28c2b7ab-631c-40a3-bab7-00dac5dd20eb
> >>> =A0=A0=A0=A0=A0=A0=A0 Total devices 1 FS bytes used 190.91GiB
> >>> =A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 1 size 1.82TiB used 196.02GiB pa=
th /dev/sda2
> >>>
> >>>warning, device 1 is missing
> >>>Label: none=A0 uuid: 2d45149a-fb97-4c2a-bae2-4cfe4e01a8aa
> >>> =A0=A0=A0=A0=A0=A0=A0 Total devices 2 FS bytes used 116.18GiB
> >>> =A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 2 size 1.82TiB used 118.03GiB pa=
th /dev/sdb
> >>> =A0=A0=A0=A0=A0=A0=A0 *** Some devices missing
> >>    This looks like you've created a RAID-1 array with /dev/sda2 and
> >>/dev/sdb, and then run mkfs.btrfs again on /dev/sda2, overwriting the
> >>original [part of a] filesystem on /dev/sda2, and replacing it with a
> >>wholly different filesystem. Since the new FS on /dev/sda2 (UUID
> >>28c2...) doesn't have the same UUID as the original FS (UUID 2d45...),
> >>and the original FS was made of two devices, btrfs fi show is telling
> >>you that there's some devices missing -- /dev/sda2 is no longer part
> >>of that FS, and is therefore a missing device.
> >>
> >>    I note that you've got data on both filesystems, so they must both
> >>have been mounted somewhere and had stuff put on them.
> >>
> >>    I recommend doing something like this:
> >>
> >># mkfs /media/btrfs/myraid1 /media/btrfs/tmp
> >># mount /dev/sdb /media/btrfs/myraid1/
> >># mount /dev/sda2 /media/btrfs/tmp/              # mount both filesyste=
ms
> >># cp /media/btrfs/tmp/* /media/btrfs/myraid1     # put it where you wan=
t it
> >># umount /media/btrfs/tmp/
> >># wipefs /dev/sda2                               # destroy the FS on sd=
a2
> >># btrfs replace start 1 /dev/sda2 /media/btrfs/myraid1/
> >>
> >>    This will copy all the data from the filesystem on /dev/sda2 into
> >>the filesystem on /dev/sdb, destroy the FS on sda2, and then use sda2
> >>as the second device for the main FS.
> >>
> >>*WARNING!*
> >>
> >>    Note that, since the main FS is missing a device, it will probably
> >>need to be mounted in degraded mode (-o degraded), and that on kernels
> >>earlier than (IIRC) 4.14, this can only be done *once* without the FS
> >>becoming more or less permanently read-only. On recent kernels, it
> >>_should_ be OK.
> >>
> >>*WARNING ENDS*
> >    Oh, and for the record, to make a RAID-1 filesystem from scratch,
> >you simply need this:
> >
> ># mkfs.btrfs -m raid1 -d raid1 /dev/sda2 /dev/sdb
> >
> >    You do not need to run mkfs.btrfs on each device separately.
> >
> >    Hugo.
> Thnk you very much. I understand a bit better. I think=A0 that I have
> nothing of interest on /dev/sdb and that its contents is the result
> of previous trials.
> And that my system is on /dev/dsda2 as :
>=20
> root@server:~# df -h
> Filesystem=A0=A0=A0=A0=A0 Size=A0 Used Avail Use% Mounted on
> udev=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.9G=A0=A0=A0=A0 0=A0 3.9G=A0=A0 0%=
 /dev
> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 787M=A0 8.8M=A0 778M=A0=A0 2% /run
> /dev/sda2=A0=A0=A0=A0=A0=A0 1.9T=A0 193G=A0 1.7T=A0 11% /
> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.9G=A0=A0=A0=A0 0=A0 3.9G=A0=A0 0% /=
dev/shm
> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 5.0M=A0=A0=A0=A0 0=A0 5.0M=A0=A0 0% /=
run/lock
> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 3.9G=A0=A0=A0=A0 0=A0 3.9G=A0=A0 0% /=
sys/fs/cgroup
> /dev/sda1=A0=A0=A0=A0=A0=A0 511M=A0 5.7M=A0 506M=A0=A0 2% /boot/efi
> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 100K=A0=A0=A0=A0 0=A0 100K=A0=A0 0% /=
var/lib/lxd/shmounts
> tmpfs=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 100K=A0=A0=A0=A0 0=A0 100K=A0=A0 0% /=
var/lib/lxd/devlxd
> root@server:~#
>=20
> Is it exact ?

   Yes, it looks like you're running / from the FS on /dev/sda2.

> If yes, I suppose I should wipe data on /dev/sdb, then build the
> RAID by expanding /dev/sda2.

   Correct.

   I would recommend putting a partition table on /dev/sdb, because it
doesn't take up much space, and it's always easier to have one already
there when you need it (and there's a few things that can get confused
if there isn't a partition table).

> So I should :
>=20
> wipefs /dev/sdb
> btrfs device add /dev/sdb /
> btrfs balance start -v -mconvert=3Draid1 -dconvert=3Draid1 /

> Does it sound correct ? (my kernel is boot/vmlinuz-4.18.0-1-amd64)

   Yes, exactly.

   Hugo.

--=20
Hugo Mills             | Yes, this is an example of something that becomes
hugo@... carfax.org.uk | less explosive as a one-to-one cocrystal with TNT.
http://carfax.org.uk/  | (Hexanitrohexaazaisowurtzitane)
PGP: E2AB1DE4          |                                            Derek L=
owe

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbu8prAAoJEFheFHXiqx3kjhEP/0h9myDrSZj3wFVy7bP9fAgK
AO6hae14bWnmJAlP0+H9OV5Y6IprG+WuVsAmo7OVacqQbmSaAbwRhYOjvtRjAHNm
VGBD86luaslndFMX1PQgbcYJJUrb+WZARfY2OBULvTsVVJ3ojArDTUvlNfizA1Z9
DMg9yThGxjHYCzs05bNvk5GaMTYlGPW7rY2YdlpPnMyINJarK5uv2MnqmES34xVP
108Jfs+SQD1XCqC45oBZroOCzqQCr2Dx2kAJSPUnhFpjmpmw0EHI3wGg1JqvTW7D
oZRPFU4a2nbPsuX+sAB6QrqR5Yyy6AexZICCSEWXeOlTIYId80SbVp0BtYskkkDd
svI4nTw1opwnjlNza1mYG5sfni0a8LxG3fjTL3uBWhIcEsJ6yGtLWq/umbY5o4Js
8B/QnCfZZD7gA/wM3HR4zhxl2vqJq1thXNzuJ09crIjCna7Tl42qsbf6ptDDtCmg
vOQeGPFbKPdclVq15aH80LaUm/g5hD/L06Wrpjj0r2aHRqY9LMACeRXGKcw6AoCc
AoIBYRNcJraBRDAD9D6nDCCqwE88cbb2EbtYamnxxr5vlMJLw/5Obp34QJ/Pq+U/
s1t1luv8QiZSiBEPIrLOw8tn5Q3+UGmodbg66acXHqGk8d9nBo+f/Yr0zsVQODqo
4XAK5KYdDBfvyxpSvlX3
=OR1u
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
