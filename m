Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52769 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727346AbeHWIvq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 04:51:46 -0400
Subject: Re: My Filesystem is Broken
To: Zirconium Hacker <jared.e.vb@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CALsQ4_xPLoX7YErmAjV45g=ifD0UTJN-NwTrZFNqPCcaaPYZAA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6bede0c5-d374-d9b1-76df-85c92968d409@gmx.com>
Date: Thu, 23 Aug 2018 13:23:25 +0800
MIME-Version: 1.0
In-Reply-To: <CALsQ4_xPLoX7YErmAjV45g=ifD0UTJN-NwTrZFNqPCcaaPYZAA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GO8CdeHfKqn0FX8uPtiCxjdHWVpxqhooN"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GO8CdeHfKqn0FX8uPtiCxjdHWVpxqhooN
Content-Type: multipart/mixed; boundary="OOZCEo3ug0ToTUbEporq4OEyLEFQ6mqAi";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Zirconium Hacker <jared.e.vb@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <6bede0c5-d374-d9b1-76df-85c92968d409@gmx.com>
Subject: Re: My Filesystem is Broken
References: <CALsQ4_xPLoX7YErmAjV45g=ifD0UTJN-NwTrZFNqPCcaaPYZAA@mail.gmail.com>
In-Reply-To: <CALsQ4_xPLoX7YErmAjV45g=ifD0UTJN-NwTrZFNqPCcaaPYZAA@mail.gmail.com>

--OOZCEo3ug0ToTUbEporq4OEyLEFQ6mqAi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/23 =E4=B8=8A=E5=8D=8811:25, Zirconium Hacker wrote:
> Hi.
> My primary (boot) filesystem is broken, due to an interrupted resize op=
eration.
> I'm hoping that I can get help either fixing the filesystem or
> recovering some of my data, but I'd also like to know why btrfs and
> its tools acted the way they did.
> I think I've also found a bug in GParted.
>=20
> Output of uname -a on the recovery medium: Linux ArchUSB
> 4.18.3-arch1-1-ARCH #1 SMP PREEMPT Sat Aug 18 09:22:54 UTC 2018 x86_64
> GNU/Linux
> Kernel on the affected system: Liquorix Linux 4.17.14
> Output of btrfs --version: btrfs-progs v4.17.1
> Relevant dmesg log is attached.
>=20
> I currently use a single btrfs filesystem (fs A) with subvolumes for
> root, home, and var.  It's ~140 GiB in size, with ~130GiB used.
> I also have a second btrfs filesystem (fs B) from a previous
> installation of Arch Linux.  It's ~40 GiB in size, with less than 30
> GiB used.
>=20
> First of all, how I got into this situation:
>=20
> Yesterday, I wanted to reclaim some space, so I decided to shrink fs B.=

> I opened up GParted, and resized it.  I got an error from btrfs, like
> "no space left on device".
> I was a little confused.  This was seemingly solved by unmounting fs B.=

> I re-ran the reisze.  Some process was using 100% CPU on one core, and
> I didn't see much (if any) I/O activity.
> After a few minutes I noticed that GParted was attempting to resize
> the mount point of fs B ('/mnt/oldsys' on fs A), even though it wasn't
> mounted!
> I'm not sure what this does, but I figure that it's not good (even
> though fs A shouldn't fit in 32 GiB).
> So I press cancel... nothing.  I try force cancel, still no effect.  I
> try to kill the resize process, first with SIGTERM, then with
> SIGKILL... nothing.
> I figure that I have to reboot at this point.  During reboot, systemd
> waits really long for a stop job on some user session thing.
> Then, strangely, I see output _during shutdown_ about btrfs
> _beginning_ to resize fs A (referring to it by its block device,
> /dev/sda2)...
> I choose to reset my computer.  When I try to boot again (bad idea in
> retrospect) systemd takes a long time to "re-mount the root
> filesystem".
> Start jobs begin to timeout and fail, so I reset my computer again to
> boot into a recovery medium.
>=20
> Part 2, the attempted recovery:
>=20
> I run btrfsck on sda2, and seeing lots of errors (see
> btrfsck.readonly.log) I choose to make an image of the entire block
> device.

At least for the readonly run, it only detects extent tree error without
fs tree corruption (v4.17.1 continue checking fs tree even when extent
tree is corrupted).

Even for extent tree errors, I doubt if it's some false alerts.

So at that point, you should be able to mount your fs RO with
skip_balance mount option and copy out all your data.

> After that, I attempt a btrfsck --repair (btrfsck.repair.log).
> It seems alright until it reaches "Deleting bad dir index" and then
> hangs.  IIRC at some point it segfaulted.
> Desperately, I try to run another repair... and I encounter a BUG_ON
> (btrfsck.repair.2.log).  Ouch.

It looks like the repair makes the problem worse, that why we call
repair dangerous.

Does the fs still mounts with -o ro,skip_balance ?

Thanks,
Qu

>=20
>=20
> Well, at this point I'm stuck.  I have no backups.
> I've already restored the image of fs A from before any repair attempts=
=2E
>=20
> Thanks in advance,
> Jared
>=20
>=20
> Some big files that I couldn't attach:
> btrfsck.readonly.log:
> https://drive.google.com/open?id=3D1CZP67uCs7zCyi1CfPv6tt9DxnIfU967u
> btrfsck.repair.log:
> https://drive.google.com/open?id=3D1l2Nj8n9CzmxRZznbbIYEMrQc6c5plMDm
>=20
>=20
> P.S. Sorry if this gets sent twice -- Gmail failed to deliver it the fi=
rst time.
>=20


--OOZCEo3ug0ToTUbEporq4OEyLEFQ6mqAi--

--GO8CdeHfKqn0FX8uPtiCxjdHWVpxqhooN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlt+RM0ACgkQwj2R86El
/qgBbAf/eFb4IH6nsbfrK8MpcEOT0Wqt87fU9iJJNqu4SBn65r42q5VGpVGhyNi8
zbLGZ9UAnAZNGQWUvEvXHo3Aru9P+DGghiFVS0O8mZhwDgw5YNxK82qWdr1+Pxdw
O928JAPgb99AXnCbGRwP9CGpd41J4z+nDL8OYjNd31MQ66VCw6abfr0k6vN6i/wy
PqYz+zbl28gSDRkZFLsc9htAiD6DAiW+BSanOaAH5sjpSCVHxXlotph5igSvmlan
0rHbIl7mxo3f3jzJzYE6+AdE0kQMF3NBN9rTe3GI8xjs0/7uNqIZ/0EmDLhu5N9N
YN3TAPIjMRdKZrolD9eE8ZV2iHShSg==
=Kvwv
-----END PGP SIGNATURE-----

--GO8CdeHfKqn0FX8uPtiCxjdHWVpxqhooN--
