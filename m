Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:45656 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbcCQIcL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 04:32:11 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
	by meiko.romanrm.net (Postfix) with SMTP id A95E31268C2
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 08:32:07 +0000 (UTC)
Date: Thu, 17 Mar 2016 13:32:04 +0500
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: "Fixed", Re: parent transid verify failed on snapshot deletion
Message-ID: <20160317133204.4413a88b@natsu>
In-Reply-To: <20160312204847.2092f3f3@natsu>
References: <20160312204847.2092f3f3@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/y.t=lBV.1mU4WZllenoaMm8"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/y.t=lBV.1mU4WZllenoaMm8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 12 Mar 2016 20:48:47 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> The system was seemingly running just fine for days or weeks, then I
> routinely deleted a bunch of old snapshots, and suddenly got hit with:
>=20
> [Sat Mar 12 20:17:10 2016] BTRFS error (device dm-0): parent transid veri=
fy failed on 7483566862336 wanted 410578 found 404133
> [Sat Mar 12 20:17:10 2016] BTRFS error (device dm-0): parent transid veri=
fy failed on 7483566862336 wanted 410578 found 404133

As I mentioned, the initial run of btrfsck --repair did not do anything to =
fix
this problem; I started btrfsck --repair --init-extent-tree, but it still n=
ot
finished after 5 days, so I looked for other options.

While reviewing the btrfs-progs source for some attempts to make btrfsck do
something about these transid-failures, I spotted the tool called
btrfs-corrupt-block. At this point I was ready to accept some loss of data,
which I'd expect to be minor if even user-visible at all (after all the
original backtrace is happening in "btrfs_clean_one_deleted_snapshot" so
perhaps all that the "bad" block was storing was only related to a snapshot
that's already been deleted).

I ran:

  /root/btrfs-corrupt-block -l 7483566862336 /dev/nbd8

Btrfsck then finally reported something inspiring some hope:

checking extents
checksum verify failed on 7483566862336 found 295F0086 wanted 00000000
checksum verify failed on 7483566862336 found 295F0086 wanted 00000000
checksum verify failed on 7483566862336 found 295F0086 wanted 00000000
checksum verify failed on 7483566862336 found 295F0086 wanted 00000000
bytenr mismatch, want=3D7483566862336, have=3D0
deleting pointer to block 7483566862336
ref mismatch on [6504947712 118784] extent item 0, found 1
adding new data backref on 6504947712 parent 4311306919936 owner 0 offset 0=
 found 1
Backref 6504947712 parent 4311306919936 owner 0 offset 0 num_refs 0 not fou=
nd in extent tree
Incorrect local backref count on 6504947712 parent 4311306919936 owner 0 of=
fset 0 found 1 wanted 0 back 0x57cfdff0
backpointer mismatch on [6504947712 118784]
...etc

After a few passes it settled into a state with no new errors reported (only
a few of "bad metadata crossing stripe boundary", but those seem to be also
commonly reported in connection with filesystems otherwise exhibiting no is=
sues).

Finally I was able to mount the FS with no backtrace occurring anymore -- t=
he
btrfs-cleaner process then finished all the remaining snapshot deletion wor=
k,
freeing up 20GB or so. All data seems to be present, and selective checksum
verifications showed no corruption. Well, this machine is primarily a backup
server using rsync, so it should catch and fix-up any losses.

As a side note, for experiments with 'btrfsck --repair', 'btrfs-corrupt-blo=
ck'
and my own patched versions of btrfsck, the technique of making writable CoW
snapshots of the whole block device has proved invaluable:

At first I used the nbd-server '-c' mode, but quickly discovered it to be
flaky: it seems to crash if the amount of changes gets over 150 MB or so, a=
nd
anyways the RAM usage of it seems to match "block device size / 1000", i.e.=
 it
used 6GB of RAM for a 6TB filesystem. So in the end I changed to using the
dm-snapshot target as described in [1]. One just has to remember to never h=
ave
the snapshot and the original device visible and trying to mount one of them
on the same machine (this will confuse Btrfs with duplicate UUIDs); for tha=
t,
I used the same nbd-server (not using its built-in CoW anymore), exporting
writable snapshots via network and mounting them on a different server or V=
M.

[1]http://stackoverflow.com/questions/7582019/lvm-like-snapshot-on-a-normal=
-block-device

--=20
With respect,
Roman

--Sig_/y.t=lBV.1mU4WZllenoaMm8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbqa4cACgkQTLKSvz+PZwjnGACfdPwsEl7DDJL1rkKbRj5GPoK+
v0wAnA/xNose9QpzZMGwTMLGr7sk3pjk
=ao8/
-----END PGP SIGNATURE-----

--Sig_/y.t=lBV.1mU4WZllenoaMm8--
