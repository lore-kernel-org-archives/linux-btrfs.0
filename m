Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:48581 "EHLO
        mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbeGFInk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jul 2018 04:43:40 -0400
Received: from [192.168.11.16] (statdsl-085-016-075-093.ewe-ip-backbone.de [85.16.75.93])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jojo@automatix.de)
        by mail.automatix.de (Postfix) with ESMTPSA id 1C0A06006A
        for <linux-btrfs@vger.kernel.org>; Fri,  6 Jul 2018 10:38:03 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Juergen Sauer <juergen.sauer@automatix.de>
Subject: Issue on BTRFS/copy of really huge files
Message-ID: <918a550f-2782-7549-6a75-3e1c6dd7fab9@automatix.de>
Date: Fri, 6 Jul 2018 10:37:57 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RyNCvMc3swbq5N3JZEzhohjzStzKixaTc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RyNCvMc3swbq5N3JZEzhohjzStzKixaTc
Content-Type: multipart/mixed; boundary="5AiiHslJaiHnBtJYpQu4ffrXgi8BAWkdY";
 protected-headers="v1"
From: Juergen Sauer <juergen.sauer@automatix.de>
To: linux-btrfs@vger.kernel.org
Message-ID: <918a550f-2782-7549-6a75-3e1c6dd7fab9@automatix.de>
Subject: Issue on BTRFS/copy of really huge files

--5AiiHslJaiHnBtJYpQu4ffrXgi8BAWkdY
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

Hi!

I found an issue since kernel 4.1.17.x.
My setup for dealing with virtual machines is:
btrfs SSD/raid1 	[sda, sdb] ca. 250 GiB as OS Root [Arch Linux]
btrfs Rotational/Raid5 	[sdc, sdd, sde] ca. 12 GiB as virt. Machie store

My Work flow:
If a very I/O intensive operation on a virtual machine is to be done I
move this onto a subvol on the rootfs wich has a fast raid1 sdd setup.

Working on the ssd and rotational btrfs stack is fine and performant
(nowcow used).

But now the little issue.

Moving a virtual machine from ssd/raid1 subvolume (nocow) into the
rotational big store (noocow) fails.
After filling up the cachememory (ram) the data flow cuts down to zero
0 kb/sec.
In fatal result the copy of an huge file hangs does not proceed any
more, load raises infinite, iops falling to zero. In kernel log I find:

[  491.151952] INFO: task kworker/u16:28:1027 blocked for more than 120
seconds.
[  491.151953]       Tainted: P           O      4.17.3-1-ARCH #1
[  491.151953] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  491.151953] kworker/u16:28  D    0  1027      2 0x80000000
[  491.151965] Workqueue: btrfs-endio-raid56 btrfs_endio_raid56_helper
[btrfs]
[  491.151965] Call Trace:
[  491.151967]  ? __schedule+0x282/0x890
[  491.151969]  schedule+0x32/0x90
[  491.151970]  io_schedule+0x12/0x40
[  491.151971]  blk_mq_get_tag+0x146/0x2a0
[  491.151972]  ? wait_woken+0x80/0x80
[  491.151974]  blk_mq_get_request+0x342/0x420
[  491.151975]  blk_mq_make_request+0x121/0x670
[  491.151976]  generic_make_request+0x187/0x370
[  491.151977]  submit_bio+0x45/0x140
[  491.151988]  ? rbio_orig_end_io+0xd0/0xd0 [btrfs]
[  491.151998]  finish_rmw+0x392/0x530 [btrfs]
[  491.152009]  normal_work_helper+0xbd/0x350 [btrfs]
[  491.152010]  process_one_work+0x1d1/0x3b0
[  491.152011]  worker_thread+0x2b/0x3d0
[  491.152012]  ? process_one_work+0x3b0/0x3b0
[  491.152014]  kthread+0x112/0x130
[  491.152015]  ? kthread_flush_work_fn+0x10/0x10
[  491.152016]  ret_from_fork+0x35/0x40
[root@pc6 ~]#

Scheduler was on ssd disc deadline, on rotational bfq.

After this "copy data flow Zero Rate" event copying to the big raid
fails, sync never ccomes back. The machine load raises up to 50 .. 60 ..
80 .. (seen in top).
I/O Load seen in iotop is zero.

Rebooting via SysReq Key works, system comes back and is working fine.

After I switched the scheduler to "kyber" on all discs (including the
rotational discs) the issue does not occour. ?!?

with kind regards
J=C3=BCrgen Sauer
--=20
J=C3=BCrgen Sauer - automatiX GmbH,
+49-4209-4699, juergen.sauer@automatix.de
Gesch=C3=A4ftsf=C3=BChrer: J=C3=BCrgen Sauer,
Gerichtstand: Amtsgericht Walsrode =E2=80=A2 HRB 120986
Ust-Id: DE191468481 =E2=80=A2 St.Nr.: 36/211/08000
GPG Public Key zur Signaturpr=C3=BCfung:
http://www.automatix.de/juergen_sauer_publickey.gpg


--5AiiHslJaiHnBtJYpQu4ffrXgi8BAWkdY--

--RyNCvMc3swbq5N3JZEzhohjzStzKixaTc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXnJOAsmrKYVtqq/xbtQoj0SpqsQUCWz8qagAKCRBbtQoj0Spq
sWEoAJ9g3gZDGmSh6crAQTxGrWGxHZtLHwCfcrD9POkaLfNRw5y5+EZJ/OXXBvY=
=tiMB
-----END PGP SIGNATURE-----

--RyNCvMc3swbq5N3JZEzhohjzStzKixaTc--
