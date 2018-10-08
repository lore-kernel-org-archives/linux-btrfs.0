Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF68BC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 16:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 991B1213A2
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 16:14:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 991B1213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=carfax.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbeJHX1Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 19:27:16 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:59088 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbeJHX1Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 19:27:16 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1g9YBD-0001mn-3u; Mon, 08 Oct 2018 16:14:47 +0000
Date:   Mon, 8 Oct 2018 16:14:47 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Pierre Couderc <pierre@couderc.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Which device is missing ?
Message-ID: <20181008161447.GC25913@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Pierre Couderc <pierre@couderc.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <700c973f-7ac7-5416-6e15-9e5e4faf9f67@couderc.eu>
 <20181008161055.GB25913@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="t0UkRYy7tHLRMCai"
Content-Disposition: inline
In-Reply-To: <20181008161055.GB25913@carfax.org.uk>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--t0UkRYy7tHLRMCai
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 08, 2018 at 04:10:55PM +0000, Hugo Mills wrote:
> On Mon, Oct 08, 2018 at 03:49:53PM +0200, Pierre Couderc wrote:
> > I ma trying to make a "RAID1" with /dev/sda2 ans /dev/sdb (or similar).
> >=20
> > But I have stranges status or errors=A0 about "missing devices" and I
> > do not understand the current situation :
> >=20
> >=20
> > root@server:~# btrfs fi show
> > Label: none=A0 uuid: 28c2b7ab-631c-40a3-bab7-00dac5dd20eb
> > =A0=A0=A0=A0=A0=A0=A0 Total devices 1 FS bytes used 190.91GiB
> > =A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 1 size 1.82TiB used 196.02GiB path=
 /dev/sda2
> >=20
> > warning, device 1 is missing
> > Label: none=A0 uuid: 2d45149a-fb97-4c2a-bae2-4cfe4e01a8aa
> > =A0=A0=A0=A0=A0=A0=A0 Total devices 2 FS bytes used 116.18GiB
> > =A0=A0=A0=A0=A0=A0=A0 devid=A0=A0=A0 2 size 1.82TiB used 118.03GiB path=
 /dev/sdb
> > =A0=A0=A0=A0=A0=A0=A0 *** Some devices missing
>=20
>    This looks like you've created a RAID-1 array with /dev/sda2 and
> /dev/sdb, and then run mkfs.btrfs again on /dev/sda2, overwriting the
> original [part of a] filesystem on /dev/sda2, and replacing it with a
> wholly different filesystem. Since the new FS on /dev/sda2 (UUID
> 28c2...) doesn't have the same UUID as the original FS (UUID 2d45...),
> and the original FS was made of two devices, btrfs fi show is telling
> you that there's some devices missing -- /dev/sda2 is no longer part
> of that FS, and is therefore a missing device.
>=20
>    I note that you've got data on both filesystems, so they must both
> have been mounted somewhere and had stuff put on them.
>=20
>    I recommend doing something like this:
>=20
> # mkfs /media/btrfs/myraid1 /media/btrfs/tmp
> # mount /dev/sdb /media/btrfs/myraid1/
> # mount /dev/sda2 /media/btrfs/tmp/              # mount both filesystems
> # cp /media/btrfs/tmp/* /media/btrfs/myraid1     # put it where you want =
it
> # umount /media/btrfs/tmp/
> # wipefs /dev/sda2                               # destroy the FS on sda2
> # btrfs replace start 1 /dev/sda2 /media/btrfs/myraid1/
>=20
>    This will copy all the data from the filesystem on /dev/sda2 into
> the filesystem on /dev/sdb, destroy the FS on sda2, and then use sda2
> as the second device for the main FS.
>=20
> *WARNING!*
>=20
>    Note that, since the main FS is missing a device, it will probably
> need to be mounted in degraded mode (-o degraded), and that on kernels
> earlier than (IIRC) 4.14, this can only be done *once* without the FS
> becoming more or less permanently read-only. On recent kernels, it
> _should_ be OK.
>=20
> *WARNING ENDS*

   Oh, and for the record, to make a RAID-1 filesystem from scratch,
you simply need this:

# mkfs.btrfs -m raid1 -d raid1 /dev/sda2 /dev/sdb

   You do not need to run mkfs.btrfs on each device separately.

   Hugo.

--=20
Hugo Mills             | Welcome to Rivendell, Mr Anderson...
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                            Machinae Supremacy, Hyb=
rid

--t0UkRYy7tHLRMCai
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJbu4J2AAoJEFheFHXiqx3kMyIP/iQjZAsmw/49iUJOdAzeNCQE
JdD4gCncmTdicDSq/t9BX62rCWp17nwOev2c9qRbfsblc45Tjr3Us04ef6br6rs1
p1WSltq6Ee21enBSU11OTKrP8GMyTodF14UE0+oPABw9YSotf70GcEgDa3pWETxo
wGTSA05iI62nE3PCb1w/8rNzN2uVZiZAUQ0aoB7+UGjUy2ZAk52PLI7899F0bfom
M0hOCiJsa5B6oJ+8qJxbIMe7uyOELt+5sreM3gXlFfKQBy6mQHbcnl8ybFI/I+eU
tDGULFzb5lEDNs94LdH6YsQ0An6MqceB8UR9otcup0/cCWApgXRHdut3+c1dm1NC
mIdds040jOC+J4pIT772ESgJuCXTGQ4Y+IFigSI8kGkR0ZTj1HS+47KIAD2SZwe0
g61NfeKNn4jixiC6hQ9MkLmtUVcLBG4BATYVfScUspzjEMk6aPX9hgj+BBe71+YQ
gkXMyRqmC1FaJiOufxC1qVPkrPqyZzRnEkPYKS7xOo/R37AASaVmYAwIoJsYT83j
15wvu3EUj40gJSjAaILOVMY1ySX4HSyNVfBDeN66+XWYWPsKrMNMnKfazgjUotXL
fJB+5ZVXgzxpXxxpcXnhdgdqvh8v8NGsI56nee8G1gYFyfaQa9co4MBT8i4iNv3o
FBwx6FrJVaE8AAhxI9y7
=Ujoq
-----END PGP SIGNATURE-----

--t0UkRYy7tHLRMCai--
