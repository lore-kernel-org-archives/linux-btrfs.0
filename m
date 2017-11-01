Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52913 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752019AbdKAKjY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 06:39:24 -0400
Subject: Re: Machine died with OOM after (re)moving lots of data and snapshot
To: Lars Noschinski <noschinl@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAM4geavt2usykGhGdUznBY_gY9tLWerEjDZWWYzqZJF825Se1Q@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <17810b71-997d-54a8-d458-e4cf31497d2c@gmx.com>
Date: Wed, 1 Nov 2017 18:39:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAM4geavt2usykGhGdUznBY_gY9tLWerEjDZWWYzqZJF825Se1Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cngeAdUhiEvSQFkihU2wTG9LsijrkQb96"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cngeAdUhiEvSQFkihU2wTG9LsijrkQb96
Content-Type: multipart/mixed; boundary="sQGR6v51Mebxujb7rjAgNpj7eSWFoA482";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lars Noschinski <noschinl@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <17810b71-997d-54a8-d458-e4cf31497d2c@gmx.com>
Subject: Re: Machine died with OOM after (re)moving lots of data and snapshot
References: <CAM4geavt2usykGhGdUznBY_gY9tLWerEjDZWWYzqZJF825Se1Q@mail.gmail.com>
In-Reply-To: <CAM4geavt2usykGhGdUznBY_gY9tLWerEjDZWWYzqZJF825Se1Q@mail.gmail.com>

--sQGR6v51Mebxujb7rjAgNpj7eSWFoA482
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8801=E6=97=A5 18:22, Lars Noschinski wrote:
> Hi everyone,
>=20
> I have a machine which had an almost full 4TB btrfs partition on a
> SATA harddisk. I added another 4TB harddisk, put a btrfs partition on
> it and moved 1TB of data to the new partition.
>=20
> After that, I moved another part of the data (probably around 500GB)
> to the new partition and deleted all the snapshots taken during the
> last year -- probably around 300.
>=20
> The machine was slow during this (which did not surprise me due to
> heavy disk I/O). I left the machine working for the rest of the day
> and found it totally dead the next morning (no ping, not even the VGA
> console coming up after pressing a key).

Did you enabled quota?
It's known that quota will consume a lot of memory for backref walk.
(With the heaviest overhead, compared to the remaining factors)

If not, did you use a lot of reflink or offline dedupe?
Which both will cause a lot of stress for backref walk, and may consume
all your memory.

If still not, then the number of snapshots is the cause.
By design, btrfs is fast doing snapshot, with all the overhead moved to
backref walk.

It's OK if you only do normal read/write or creating snapshots, but when
you do the following things, the problem will begin to show:
1) Snapshot remove
2) Balance
3) Qgroup

And, unless we have backgroup thread to solve shared (using parent)
backref to unshared backref, such problem can't really be solved.

(Or even more, change how btrfs create snapshot at all).

So in conclusion, btrfs snapshot is fast, but don't abuse it.
Keeping snapshot and subvolumes to a reasonable number (<20 seems good
enough) is a good idea.

Thanks,
Qu
>=20
>=20
> After a restart, I found the following messages in the kernel log. For
> a few minutes, there where a few messages like:
>=20
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.623818] INFO: task
> rm:4456 blocked for more than 120 seconds.
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.623952]       Not
> tainted 4.9.0-4-amd64 #1 Debian 4.9.51-1
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624058] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624200] rm
> D    0  4456   4453 0x00000000
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624209]
> ffff94060f2ee800 0000000000000000 ffff94060e8ed080 ffff94061fc98240
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624216]
> ffff9406102d3140 ffffb807818bfd90 ffffffff82c038e3 000000020b0f4000
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624222]
> 00ffffffc03c17ee ffff94061fc98240 ffff940611e36288 ffff94060e8ed080
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624228] Call Trace:
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624242]
> [<ffffffff82c038e3>] ? __schedule+0x233/0x6d0
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624248]
> [<ffffffff82c03db2>] ? schedule+0x32/0x80
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624315]
> [<ffffffffc03d40f1>] ? wait_current_trans.isra.20+0xc1/0x110 [btrfs]
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624323]
> [<ffffffff826b8e80>] ? prepare_to_wait_event+0xf0/0xf0
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624374]
> [<ffffffffc03d675b>] ? start_transaction+0x25b/0x480 [btrfs]
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624425]
> [<ffffffffc03e2f2f>] ? btrfs_evict_inode+0x45f/0x5d0 [btrfs]
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624432]
> [<ffffffff8281f806>] ? evict+0xb6/0x180
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624439]
> [<ffffffff82813778>] ? do_unlinkat+0x148/0x330
> Oct 31 15:48:44 wuerfelzucker kernel: [107426.624447]
> [<ffffffff82c085bb>] ? system_call_fast_compare_end+0xc/0x9b
>=20
> 9h later, the OOM killer kicked in and kept killing processes for
> another 30 minutes, before the logs end. The full log file is found at
>=20
> https://bugzilla.kernel.org/attachment.cgi?id=3D260455
>=20
> The last few invocations of the OOM killer where by a process kalled
> "btrfs-transacti".
>=20
> As far as I can tell from the logs, moving the data was finished by
> then (at least, I don't see an instance of "mv" in the process list
> from the OOM killer). Otherwise, the machine was idle.
>=20
> If you need any more data for investigating this problem, I might be
> able to provide that; I haven't touched the affected disks yet.
>=20
> The machine is a HP Microserver N54L with 10GB of ECC ram running a
> current Debian stretch:
> * kernel: Linux version 4.9.0-4-amd64 (debian-kernel@lists.debian.org)
> (gcc version 6.3.0 20170516 (Debian 6.3.0-18) ) #1 SMP Debian 4.9.51-1
> (2017-09-28)
> * btrfs-tools: 4.7.3-1
>=20
> I also reported this as #197627 in the kernel bugzilla.
>=20
> Best regards, Lars Noschinski
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--sQGR6v51Mebxujb7rjAgNpj7eSWFoA482--

--cngeAdUhiEvSQFkihU2wTG9LsijrkQb96
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAln5pFUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qh00ggAok4gMgNASn99GZZZ4CWzoi1i
cDg4XST57bgCFP3kTrMzB/OezUaDdGn04xEm7df56B9f59YjQjqDeoJS0ui5pv21
DTkpdF7U/6Y+6Jt5YYxIPUxRXIoMEjXsCFEm4KmC5fWfA0HSCcJRZhfJ0ZQyPjtE
XBv2s4zixmE0dAJYHHvr+YgS2Kyt1NXfw5sE9zkZ7sxbEYkrNZMsfjqEb62JVTgM
CuVAM4GjNQpvvSH1MqkCDmEKmnSYEIps5RQPQBH/okHsZT0ncVcj+GBa5o8gzYnG
3Q1qdexAdU3kb1D/xZiuRKWqQ0A8r0QZ4emxPAgyUyoOaN/P0xPLzmlKlF4OfA==
=RpFS
-----END PGP SIGNATURE-----

--cngeAdUhiEvSQFkihU2wTG9LsijrkQb96--
