Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:37087 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752162AbeCMMZc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 08:25:32 -0400
Subject: Re: FS unmountable after RAID/LVM problems
To: Dirk Gouders <dirk@gouders.net>,
        Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
References: <ghlgew5pbq.fsf@lena.gouders.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
Date: Tue, 13 Mar 2018 20:25:08 +0800
MIME-Version: 1.0
In-Reply-To: <ghlgew5pbq.fsf@lena.gouders.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Y41jz16B3V4z1MkVlJAeuOcSE6wTWhbU1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Y41jz16B3V4z1MkVlJAeuOcSE6wTWhbU1
Content-Type: multipart/mixed; boundary="ylYkhswW7lKOJusrWLkForgjuOTdwJnXq";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dirk Gouders <dirk@gouders.net>,
 Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <005e24f2-2638-74c3-5034-92c094671d80@gmx.com>
Subject: Re: FS unmountable after RAID/LVM problems
References: <ghlgew5pbq.fsf@lena.gouders.net>
In-Reply-To: <ghlgew5pbq.fsf@lena.gouders.net>

--ylYkhswW7lKOJusrWLkForgjuOTdwJnXq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8813=E6=97=A5 16:53, Dirk Gouders wrote:
> Hello all,
>=20
> a somewhat aged RAID array (16 Disks) got into trouble after it has
> been powered off because of facility management maintenance tasks.
>=20
> It then went through some rebuilds loosing three disks on the way and
> the whole procedure ended with corrupted volumes.  Volumes with
> ext{2,4} filesystems could be fsck'ed and corresponding VMs then
> started but a volume with a (probably) BTRFS partition I am not able
> to get very far with.  I got no information what filesystems were used
> on the corresponding VM but I knew it was an opensSUSE system and
> file(1) told me:
>=20
> # file -s /dev/loop0p1
> /dev/loop0p1: BTRFS Filesystem sectorsize 4096, nodesize 16384, leafsiz=
e 16384, UUID=3Da6459a90-ebe3-4c75-97f4-5496eadcc96f, 9141452800/10741612=
544 bytes used, 1 devices
>=20
> so I am somewhat sure that it was a BTRFS.
>=20
> I tried to use some tools on copies of the Volume data and see messages=

> concerning invalid checksums as well as ones of bad tree block starts
> and I'd like to understand what the main issue of that FS might be.
>=20
> I'll try to present some information and because I worked only on copie=
s
> of the corrupted data, I can provide more information or tests on
> request. The kernel on the machine I use for diagnosis is
> 4.16.0-rc5-00004-gfc6eabbbf8ef.
>=20
> Mounting:
>=20
> # mount /dev/loop0p1 /mnt/
> mount: /mnt: wrong fs type, bad option, bad superblock on /dev/loop0p1,=
 missing codepage or helper program, or other error.
>=20
> dmesg(1) says:
>=20
> [  176.479080] BTRFS: device fsid a6459a90-ebe3-4c75-97f4-5496eadcc96f =
devid 1 transid 9858294 /dev/loop0p1
> [  186.909100] BTRFS info (device loop0p1): disk space caching is enabl=
ed
> [  186.990090] BTRFS error (device loop0p1): bad tree block start 21637=
88338953595011 212353024
> [  186.996331] BTRFS error (device loop0p1): bad tree block start 86191=
12249313723677 212353024

Logical tree block 212353024 is corrupted.
No copy has correct bytenr.

> [  187.044482] BTRFS error (device loop0p1): open_ctree failed

Some corruption happened without corresponding kernel message.

>=20
> find-root:
>=20
> # btrfs-find-root /dev/loop0p1
> Superblock thinks the generation is 9858294
> Superblock thinks the level is 1
> Found tree root at 848773120 gen 9858294 level 1

Tree root is found, find-root won't help much here.
And if it's really tree root corruption, we should have some kernel
message for it.

> Well block 832045056(gen: 9858272 level: 1) seems good, but generation/=
level doesn't match, want gen: 9858294 level: 1

Especially when the next tree block is 22 generation older.

Would you please try to call "btrfs inspect dump-tree <device>" and
paste the result with *stderr*?

At least we could know which tree block is corrupted.

Thanks,
Qu

> Well block 831799296(gen: 9858271 level: 1) seems good, but generation/=
level doesn't match, want gen: 9858294 level: 1
> Well block 831520768(gen: 9858270 level: 1) seems good, but generation/=
level doesn't match, want gen: 9858294 level: 1
>=20
> ...several similar lines that differ only in the block and gen, the
> last two lines differ a bit more:
>=20
> Well block 72089600(gen: 9728190 level: 0) seems good, but generation/l=
evel doesn't match, want gen: 9858294 level: 1
> Well block 4243456(gen: 3 level: 0) seems good, but generation/level do=
esn't match, want gen: 9858294 level: 1
> Well block 4194304(gen: 2 level: 0) seems good, but generation/level do=
esn't match, want gen: 9858294 level: 1
>=20
> When I then try a restore with the first block # of the previous comman=
d:
>=20
> # btrfs restore -t 832045056 -D /dev/loop0p1 /mnt/btrfs/
> parent transid verify failed on 832045056 wanted 9858294 found 9858272
> parent transid verify failed on 832045056 wanted 9858294 found 9858272
> parent transid verify failed on 832045056 wanted 9858294 found 9858272
> parent transid verify failed on 832045056 wanted 9858294 found 9858272
> Ignoring transid failure
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found DC09290B wanted C630FD61
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
> Could not open root, trying backup super
> parent transid verify failed on 832045056 wanted 9858294 found 9858272
> parent transid verify failed on 832045056 wanted 9858294 found 9858272
> parent transid verify failed on 832045056 wanted 9858294 found 9858272
> parent transid verify failed on 832045056 wanted 9858294 found 9858272
> Ignoring transid failure
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> checksum verify failed on 363069440 found DC09290B wanted C630FD61
> checksum verify failed on 363069440 found 296FB15A wanted F0AFE59D
> bytenr mismatch, want=3D363069440, have=3D17552567724568668829
> Could not open root, trying backup super
> ERROR: superblock bytenr 274877906944 is larger than device size 107416=
12544
> Could not open root, trying backup super
>=20
> Dirk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--ylYkhswW7lKOJusrWLkForgjuOTdwJnXq--

--Y41jz16B3V4z1MkVlJAeuOcSE6wTWhbU1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqnwyQXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhI+Af/bEScF4bV6WohilW1xPMTfcS+
PN8LmoIMdt432AN+TstAUOGW0ACuR5NS57qlwn02xtbKHUJiGuNgAvRjolDpNtT7
UukoO/z8/a9KvOD4O6xCCf+23zB3QtQ56BgNsZDXv+v5p0Z0w05H03d6UbuOdsPs
TvosU5R+O8XzXITSvq8qHxd8kBo7p46yAPHQvcgLENrh3WyMk0wMmiG7YegdcsPq
l3DKl2+IPc74rKQnyIux1V/diuD1JJQ47hiSTETk6OsdYej5R4g19177jQKkSeYk
J9vFmHgCWI6BNI6CuydnbmG9juh7btNnLgk5LpricpoSUCRGox2L5wDhbk7U2A==
=GFIc
-----END PGP SIGNATURE-----

--Y41jz16B3V4z1MkVlJAeuOcSE6wTWhbU1--
