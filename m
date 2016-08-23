Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:37726 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbcHWQHQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 12:07:16 -0400
Date: Tue, 23 Aug 2016 21:06:15 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Malte Westerhoff <MWesterhoff@visageimaging.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs partition fails to mount after power outage
Message-ID: <20160823210615.06e30854@natsu>
In-Reply-To: <FBA93BA3BE574649A3C97265F3CE0D54013A625685@ber-vi4.ad.vi>
References: <FBA93BA3BE574649A3C97265F3CE0D54013A625685@ber-vi4.ad.vi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/G2WY+r1WOg7/qGuTFHasDNi"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/G2WY+r1WOg7/qGuTFHasDNi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Aug 2016 12:30:35 +0000
Malte Westerhoff <MWesterhoff@visageimaging.com> wrote:

> parent transid verify failed on 7375567323136 wanted 52059 found 52045
> parent transid verify failed on 7375567323136 wanted 52059 found 52045
> Error: could not find btree root extent for root 12974
>=20
> This is kernel 4.1.27 and btrfs-progs 4.1.2. We also tried the btrfs chec=
k --repair with btrfs-progs 4.7 with the same result.
>=20
> The partition with the problem is /dev/mapper/VGBIGRAID6-DATA1
> (The partition is an LVM logical volume that is on top of an md raid6.)
>=20
> Anything else that we can try in order to recover the volume?

In my experience the last resort solution to this is to simply kill the
problematic block with the "btrfs-corrupt-block" tool (compile from
btrfs-progs source), then run "btrfs check --repair" again, and this time it
should quite trivially set things right. See my success story about that:
http://www.spinics.net/lists/linux-btrfs/msg53061.html
and especially note the part about making COW snapshots of the entire block
device (should be easier since you already run LVM), which will allow you to
experiment while having an ability to undo.

Some files will be lost or corrupted (likely only an extremely tiny portion,
but not knowing which -- sucks), so ideally you should always have means to
verify the integrity of user data on any FS. At least for those which change
infrequently, e.g. media file libraries, always keep '*.sfv' files produced=
 by
the 'cfv' tool beside everything. Also something along the lines of

  cd /mnt/mydata && find > /somewhereelse/mydata-`date -Iseconds`.lst

in crontab.

Before starting you can also try checking what kind of data the problematic
block contains, IIRC it would be (but not guaranteed to be helpful):

  btrfs-debug-tree -b 7375567323136 /dev/mapper/VGBIGRAID6-DATA1

--=20
With respect,
Roman

--Sig_/G2WY+r1WOg7/qGuTFHasDNi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAle8dH8ACgkQTLKSvz+PZwhnHgCfR2XrkMkHjAC1lZTTg2UchOfD
WXMAn0HeaxKcMuaoia9oeRnVTybs0qBl
=G5wF
-----END PGP SIGNATURE-----

--Sig_/G2WY+r1WOg7/qGuTFHasDNi--
