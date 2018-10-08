Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B7DC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 16:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5932D20C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 16:10:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5932D20C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=carfax.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbeJHXXY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 19:23:24 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:59072 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbeJHXXY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 19:23:24 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1g9Y7T-0001lO-8L; Mon, 08 Oct 2018 16:10:55 +0000
Date:   Mon, 8 Oct 2018 16:10:55 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Pierre Couderc <pierre@couderc.eu>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Which device is missing ?
Message-ID: <20181008161055.GB25913@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Pierre Couderc <pierre@couderc.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <700c973f-7ac7-5416-6e15-9e5e4faf9f67@couderc.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <700c973f-7ac7-5416-6e15-9e5e4faf9f67@couderc.eu>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 08, 2018 at 03:49:53PM +0200, Pierre Couderc wrote:
> I ma trying to make a "RAID1" with /dev/sda2 ans /dev/sdb (or similar).
>=20
> But I have stranges status or errors=A0 about "missing devices" and I
> do not understand the current situation :
>=20
>=20
> root@server:~# btrfs fi show
> Label: none=A0 uuid: 28c2b7ab-631c-40a3-bab7-00dac5dd20eb
> =A0=A0=A0=A0=A0=A0=A0 Total devices 1 FS bytes used 190.91GiB
> =A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 1 size 1.82TiB used 196.02GiB path /=
dev/sda2
>=20
> warning, device 1 is missing
> Label: none=A0 uuid: 2d45149a-fb97-4c2a-bae2-4cfe4e01a8aa
> =A0=A0=A0=A0=A0=A0=A0 Total devices 2 FS bytes used 116.18GiB
> =A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 2 size 1.82TiB used 118.03GiB path /=
dev/sdb
> =A0=A0=A0=A0=A0=A0=A0 *** Some devices missing

   This looks like you've created a RAID-1 array with /dev/sda2 and
/dev/sdb, and then run mkfs.btrfs again on /dev/sda2, overwriting the
original [part of a] filesystem on /dev/sda2, and replacing it with a
wholly different filesystem. Since the new FS on /dev/sda2 (UUID
28c2...) doesn't have the same UUID as the original FS (UUID 2d45...),
and the original FS was made of two devices, btrfs fi show is telling
you that there's some devices missing -- /dev/sda2 is no longer part
of that FS, and is therefore a missing device.

   I note that you've got data on both filesystems, so they must both
have been mounted somewhere and had stuff put on them.

   I recommend doing something like this:

# mkfs /media/btrfs/myraid1 /media/btrfs/tmp
# mount /dev/sdb /media/btrfs/myraid1/
# mount /dev/sda2 /media/btrfs/tmp/              # mount both filesystems
# cp /media/btrfs/tmp/* /media/btrfs/myraid1     # put it where you want it
# umount /media/btrfs/tmp/
# wipefs /dev/sda2                               # destroy the FS on sda2
# btrfs replace start 1 /dev/sda2 /media/btrfs/myraid1/

   This will copy all the data from the filesystem on /dev/sda2 into
the filesystem on /dev/sdb, destroy the FS on sda2, and then use sda2
as the second device for the main FS.

*WARNING!*

   Note that, since the main FS is missing a device, it will probably
need to be mounted in degraded mode (-o degraded), and that on kernels
earlier than (IIRC) 4.14, this can only be done *once* without the FS
becoming more or less permanently read-only. On recent kernels, it
_should_ be OK.

*WARNING ENDS*

   Hugo.

[snip]

--=20
Hugo Mills             | UNIX: Japanese brand of food containers
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbu4GOAAoJEFheFHXiqx3kQHsQAJHLCjOvViyZw7RYNG/W49EK
i+ZeikbQOWatTUutImsfCyNNfU3iddRCZd/wdeVDRe3HD2IUUDmpuyWi3J6/LYc2
Ut5CcfMwmEbdPR/BbG8Pg67TYJGKJ1exKArR3ja04TTF20DCONkN4TLbX7tEAOEb
fOQ1djYPWxkYqG1lmmb1LgcknyQztQ/J+V8EqfJEZwu9b9KzuctXHZbVzkp7dnrS
5Z5xBdahzA9nXzXC91hRQK5TOosUieoR67yHwecH0EA23CCaWV8w1l/PV6SdsR6N
KJyj9ZZurk6Zyj/BiVTAkbEdG7gKbjcbrFfOByh4gSwP7LydCVZgtS9GV+ABy/fl
WKPTG2pdZH8NEJfeuXUAs7K1heDVl3nrSF/pbRKbDu7tQw57piOkTARekBwv5rSj
D+s/iSPQTcCze/xrgzza2qFy8QtNofg4M2BXCBa96p7KBzjRIw8/i5TXhjAHDyj1
sKXLgqOcs46nJ6ap0Z7Yb5uc/v+E4C06chYABiY1Jbq7RVqw75n2cdlv1w/2qqG+
8zA49nh/LXCuSnYH8Xgbe/mO8983Kp3Zsg+62uE1i2U+y5Fg9DcqDLwXiA9+zGYJ
DwNatM/G8MVG1a8a1f0BrXPpY4iCaz3hCZiih+KUrAd/hqTrZWGnxnPkT8lnUTQ2
lJXwQRdRgS+Xx7pmZHid
=f3V5
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
