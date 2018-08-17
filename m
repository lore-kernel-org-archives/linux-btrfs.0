Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:46379 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbeHQHqk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 03:46:40 -0400
Subject: Re: BTRFS w/ quotas hangs on read-write mount using all available RAM
To: "Loren M. Lang" <lorenl@north-winds.org>, linux-btrfs@vger.kernel.org
References: <20180817034707.GB11938@alzatex.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3e5a3e4a-21dd-11d3-7f96-047715003c04@gmx.com>
Date: Fri, 17 Aug 2018 12:44:38 +0800
MIME-Version: 1.0
In-Reply-To: <20180817034707.GB11938@alzatex.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JFyPnByh99b6yhkWM6PLz2hTdofwkHzoe"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JFyPnByh99b6yhkWM6PLz2hTdofwkHzoe
Content-Type: multipart/mixed; boundary="puMq6yQXSMnuIDq3Th4zN4wYETmtnGnBi";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Loren M. Lang" <lorenl@north-winds.org>, linux-btrfs@vger.kernel.org
Message-ID: <3e5a3e4a-21dd-11d3-7f96-047715003c04@gmx.com>
Subject: Re: BTRFS w/ quotas hangs on read-write mount using all available RAM
References: <20180817034707.GB11938@alzatex.com>
In-Reply-To: <20180817034707.GB11938@alzatex.com>

--puMq6yQXSMnuIDq3Th4zN4wYETmtnGnBi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/17 =E4=B8=8A=E5=8D=8811:47, Loren M. Lang wrote:
> Hello,
>=20
> I am unable to mount my btrfs in read-write mode after enabling quotas =

> and running a full balance on it. My service is running Ubuntu 17.10=20
> with Linux kernel 4.13.0-17-generic and btrfs-progs 4.12. I am trying t=
o=20
> recover with a live CD of Ubuntu 18.04.1 running Linux 4.15.0-29-generi=
c=20
> with btrfs-progs 4.15.1. My system has two ~3 TB drives in the btrfs=20
> array with RAID1 for data and metadata and two sub volumes, / and /home=
=2E>
> I was attempting to track down where my free space was going when I=20
> discovered apt-btrfs-snapshot which was creating a snapshot for every=20
> package install I had done, some quite old. I had at least 20 snapshots=
=20
> created when I found it and told apt-btrfs-snapshot to delete all of=20
> them.

Since snapshot deletion is delayed, btrfs may be still deleting all
these snapshots.

And too many snapshots will bring performance impact to quota.

> Still not getting back the free space I was expecting, I found a=20
> script called btrfs-size.sh which can produce a report, but requires=20
> quotas to be enabled so I ran =E2=80=9Csudo btrfs quota enable /=E2=80=9C=
=2E After loosing=20
> some patience trying to figure it out, I decided to try and just run a =

> full balance across everything, something like =E2=80=9Csudo btrfs bala=
nce start=20
> -d -m -v /=E2=80=9C,

Then you're pushing the performance impact to maximum.
Balance with a lot of snapshots/reflinked file will make quota as slow
as hell.

> but I can=E2=80=99t remember the exact command. I then went to bed=20
> only to find my server was completely hung the next day. I couldn=E2=80=
=99t get=20
> the screen to wake or and other response so I was force to power cycle =

> it. However, on repeated attempts to get it to boot, it hangs at the=20
> point that it tries to mount read-write and starts slowly consuming mor=
e=20
> and more RAM until it the system starts to hang. Switching to my 18.04.=
1=20
> recovery disk, I find I can mount it read only and look around, but I=20
> can=E2=80=99t disable quotas in read-only mode. If I run "mount -o remo=
unt,rw=20
> /mnt=E2=80=9D to enable read-write, mount hangs in the D state forever =
and I can=20
> slowly see the RAM usage increasing. I added a massive 32 GB of swap=20
> partitions, but eventually the system hangs due to out of memory.
>=20
> Lastly, I=E2=80=99ve tried unmounting it and running btrfs check on the=
 drive. I=20
> see errors such as the following:
>=20
> $ sudo btrfs check -p /dev/sda4
> ...
> ref mismatch on [3994222952448 16384] extent item 0, found 1
> tree backref 3994222952448 parent 9688891392 root 9688891392 not found
> in extent tree
> backpointer mismatch on [3994222952448 16384]
> owner ref check failed [3994222952448 16384]
> ref mismatch on [3994223329280 16384] extent item 0, found 1
> tree backref 3994223329280 parent 9688891392 root 9688891392 not found
> in extent tree
> backpointer mismatch on [3994223329280 16384]
> owner ref check failed [3994223329280 16384]
> ref mismatch on [3994271203328 16384] extent item 0, found 1
> tree backref 3994271203328 parent 9688891392 root 9688891392 not found
> in extent tree
> backpointer mismatch on [3994271203328 16384]
> owner ref check failed [3994271203328 16384]
> ref mismatch on [3994276593664 16384] extent item 0, found 1
> tree backref 3994276593664 parent 9688891392 root 9688891392 not found
> in extent tree
> backpointer mismatch on [3994276593664 16384]
> owner ref check failed [3994276593664 16384]
> ref mismatch on [3994278756352 16384] extent item 0, found 1
> tree backref 3994278756352 parent 9688891392 root 9688891392 not found
> in extent tree
> backpointer mismatch on [3994278756352 16384]
> owner ref check failed [3994278756352 16384]
>=20
> ERROR: errors found in extent allocation tree or chunk allocation
> block group 3520760643584 has wrong amount of free space
> failed to load free space cache for block group 3520760643584
> checking free space cache [O]
> checking fs roots [.][o].][o]
> checking csums
> checking root refs
> checking quota groups
> ^C
> ubuntu@ubuntu:~$=20
>=20
> It hung at checking quota groups for 12 hours before I killed it.

Considering how many snapshots you have, btrfs-progs won't be any
quicker than kernel.

> The=20
> errors above are only a small snippet, but seem to keep repeating the=20
> same basic thing. I have not tried a repair yet.
>=20
> What=E2=80=99s the next step?

Disable quota first, of course.
(Only enable it when number of snapshots is kept pretty low and don't
try offline dedupe, and don't run balance until really needed)

You can disable quota using this branch of btrfs-progs:
https://github.com/adam900710/btrfs-progs/tree/quota_disable

Or apply this patch on btrfs-progs 4.17.1:
https://patchwork.kernel.org/patch/10563589/

Then compile btrfs-progs, use the following command to disable quota
unmounted:

# ./btrfs rescue disable-quota /dev/sda4

It should finish pretty quickly.

Then re-try btrfs check, rw mount (to let balance continue), and btrfs
check again after balance finished.

The reported error could be a false alert related to running balance.

Thanks,
Qu

>=20


--puMq6yQXSMnuIDq3Th4zN4wYETmtnGnBi--

--JFyPnByh99b6yhkWM6PLz2hTdofwkHzoe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt2UrYACgkQwj2R86El
/qig3Qf+IPBt6QP5JoG5QJCbK2DJ27iLNZgKTiTtHw8wWZsB1yihEgsX3mLOvUgK
ZVXBtelqtcMHfESvFgWFR0IlITK8qo+F1fIKIgwcn4A4+eM5T+rbZfHHAQQ6gps4
8o5BO7n0U0b+YUFP4QbchOnYCJjWYbbDHE5dLvbUzkSJH8KzYl4o5gdK9CmmT1Ck
HmUGCHQ0Bo67KuvDD8WSn414LzJt0DJhHZ1OfsRWLZ4TrXQVil+WaRKuCv5GIzNH
lrByjTftE6V6Cp78QCeZd6d1Y4G70Q1CDfI3MaGkFR/vhSPd/5tzyas8nRx/VwB+
ud64KuBF9W0OnNcciXS5VOQtpOlpxw==
=vocT
-----END PGP SIGNATURE-----

--JFyPnByh99b6yhkWM6PLz2hTdofwkHzoe--
