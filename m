Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:49582 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab2HTRGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 13:06:07 -0400
Date: Mon, 20 Aug 2012 23:06:03 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Curtis Jones <curtis.jones@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and mdadm raid 6
Message-ID: <20120820230603.1ba1afca@natsu>
In-Reply-To: <8AE790DA-04B5-4407-A5FE-D0AC4560B415@gmail.com>
References: <8AE790DA-04B5-4407-A5FE-D0AC4560B415@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fqlbpTWAqkBFFQfhgNC4e8I"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fqlbpTWAqkBFFQfhgNC4e8I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Aug 2012 12:22:31 -0400
Curtis Jones <curtis.jones@gmail.com> wrote:

> 	1. is btrfs-convert on /dev/md0 stable/reliable/tested/not-a-stupid-thin=
g-to-do?

btrfs-convert does not care on what kind of block device an FS resides, so =
it's OK.

> 	2. based on the reading I've done, resizing btrfs is supported. can you =
confirm?

Yes, both growing and shrinking.

> 	3. there aren't any known compatibility or other issues with running btr=
fs on top of mdadm (raid 6)

Not that I know of.

But... if we were a year into the future and there was working btrfs RAID6,
then that configuration (btrfs native RAID6 rather than single-device btrfs=
 on
top of mdadm) would provide more resilience, as blocks with failed checksums
could be automatically reconstructed from 'good' data on other devices in t=
he
array.

In the current situation though, btrfs checksums will only tell you that you
lost data due to some corruption underneath, in (unlikely)case that it
happens and mdadm lets it through.

>	4. any other caveats I might want to consider?

1) AFAIK the patch [1] is still not in the mainline, so you'll either have =
to
include it into your kernels yourself, or you will end up with a truly and
enormous metadata allocation size, if I'm counting correctly on your array =
with
42 TB of usable space you will have 840GB * 2 =3D 1700 GB reserved for meta=
data.

[1] http://comments.gmane.org/gmane.comp.file-systems.btrfs/19200

2) On filesystem converted with btrfs-convert the metadata allocation is
unnecessarily large due to some other, conversion-related reasons; but this
can be fixed with "btrfs filesystem balance -musage=3D5 /mount/point" (do
several runs increasing the value from 5 to 10, 20 or more, if it fails to
free up a sufficient amount of space). This will defragment metadata and fr=
ee
up chunks which end up being completely unused (which will be a lot of them=
),
but only down to the kernel's desired minimum allocation, see point #1.

3) Due to the point #1 and in general for performance reasons, considering
also that you're already running on top of a parity-protected RAID, you mig=
ht
want to consider switching the metadata profile from DUP to single (i.e. ju=
st
one copy of metadata on the device, not two).
"btrfs fi balance start -mconvert=3Dsingle /mnt/point"

Regarding balance, see https://btrfs.wiki.kernel.org/index.php/Balance_Filt=
ers

> I just upgraded from kernel v3.5.1 to v3.5.2 and I have the btrfs-tools (=
v0.19) compiled straight from git.

You're doing great :)

Also, btw, I hope you have a full backup of everything you care about.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/fqlbpTWAqkBFFQfhgNC4e8I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAybnsACgkQTLKSvz+PZwjKEwCdGjp0NZxPpU8kdaQ9WDETcpQ4
Y5gAn2RHkI7DbFeFPcwKXALA7r88qn1c
=dhmf
-----END PGP SIGNATURE-----

--Sig_/fqlbpTWAqkBFFQfhgNC4e8I--
