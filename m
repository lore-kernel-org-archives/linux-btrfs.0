From: Alexey Shvetsov <alexxy@gentoo.org>
Subject: WARNING: at fs/btrfs/extent-tree.c:6170 btrfs_alloc_free_block+0x354/0x360()
Date: Tue, 03 Apr 2012 00:14:26 +0400
Message-ID: <9614443.xYNqcOt5CV@x201>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1806658.smCkESvK93"; micalg="pgp-sha256"; protocol="application/pgp-signature"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1806658.smCkESvK93
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi!

I get this traces under high parallel io load on btrfs

btrfs: block rsv returned -28
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:6170 btrfs_alloc_free_block+0x354/0x360()
Hardware name: EP45-DS4
Modules linked in: tun ath5k ath i2c_i801
Pid: 20480, comm: btrfs-endio-wri Not tainted 3.3.0-gentoo #2
Call Trace:
 [<ffffffff81046b6a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81046bb5>] warn_slowpath_null+0x15/0x20
 [<ffffffff8132cf34>] btrfs_alloc_free_block+0x354/0x360
 [<ffffffff8106fdb1>] ? get_parent_ip+0x11/0x50
 [<ffffffff81333f00>] ? verify_parent_transid+0x160/0x160
 [<ffffffff8135bf18>] ? read_extent_buffer+0xa8/0x180
 [<ffffffff8131be0a>] __btrfs_cow_block+0x12a/0x440
 [<ffffffff8131c211>] btrfs_cow_block+0xf1/0x1b0
 [<ffffffff8131fc9e>] btrfs_search_slot+0x18e/0x8a0
 [<ffffffff81378453>] ? tree_insert+0x83/0x210
 [<ffffffff8133132f>] btrfs_lookup_csum+0x6f/0x170
 [<ffffffff8110f7c7>] ? kmem_cache_alloc+0x97/0xb0
 [<ffffffff8133237c>] btrfs_csum_file_blocks+0xac/0x670
 [<ffffffff813412d0>] ? insert_reserved_file_extent.constprop.58+0x210/0x260
 [<ffffffff8133f9bd>] add_pending_csums.isra.44+0x3d/0x60
 [<ffffffff81342272>] btrfs_finish_ordered_io+0x242/0x320
 [<ffffffff81342365>] btrfs_writepage_end_io_hook+0x15/0x20
 [<ffffffff81359178>] end_extent_writepage+0x58/0x100
 [<ffffffff81359284>] end_bio_extent_writepage+0x64/0x90
 [<ffffffff8114f888>] bio_endio+0x18/0x30
 [<ffffffff813356d1>] end_workqueue_fn+0x51/0x130
 [<ffffffff81365d98>] worker_loop+0x148/0x560
 [<ffffffff81a66a36>] ? preempt_schedule+0x46/0x60
 [<ffffffff81365c50>] ? btrfs_queue_worker+0x300/0x300
 [<ffffffff8106308e>] kthread+0x8e/0xa0
 [<ffffffff81a69de4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81063000>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff81a69de0>] ? gs_change+0x13/0x13
---[ end trace fd916ccd8369970e ]---
btrfs: block rsv returned -28
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:6170 btrfs_alloc_free_block+0x354/0x360()
Hardware name: EP45-DS4
Modules linked in: tun ath5k ath i2c_i801
Pid: 20480, comm: btrfs-endio-wri Tainted: G        W    3.3.0-gentoo #2
Call Trace:
 [<ffffffff81046b6a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff81046bb5>] warn_slowpath_null+0x15/0x20
 [<ffffffff8132cf34>] btrfs_alloc_free_block+0x354/0x360
 [<ffffffff8135bf18>] ? read_extent_buffer+0xa8/0x180
 [<ffffffff8131d387>] ? comp_keys+0x27/0x30
 [<ffffffff8131be0a>] __btrfs_cow_block+0x12a/0x440
 [<ffffffff8131c211>] btrfs_cow_block+0xf1/0x1b0
 [<ffffffff8131fc9e>] btrfs_search_slot+0x18e/0x8a0
 [<ffffffff81378453>] ? tree_insert+0x83/0x210
 [<ffffffff8133132f>] btrfs_lookup_csum+0x6f/0x170
 [<ffffffff8110f7c7>] ? kmem_cache_alloc+0x97/0xb0
 [<ffffffff8133237c>] btrfs_csum_file_blocks+0xac/0x670
 [<ffffffff813412d0>] ? insert_reserved_file_extent.constprop.58+0x210/0x260
 [<ffffffff8133f9bd>] add_pending_csums.isra.44+0x3d/0x60
 [<ffffffff81342272>] btrfs_finish_ordered_io+0x242/0x320
 [<ffffffff81342365>] btrfs_writepage_end_io_hook+0x15/0x20
 [<ffffffff81359178>] end_extent_writepage+0x58/0x100
 [<ffffffff81359284>] end_bio_extent_writepage+0x64/0x90
 [<ffffffff8114f888>] bio_endio+0x18/0x30
 [<ffffffff813356d1>] end_workqueue_fn+0x51/0x130
 [<ffffffff81365d98>] worker_loop+0x148/0x560
 [<ffffffff81a66a36>] ? preempt_schedule+0x46/0x60
 [<ffffffff81365c50>] ? btrfs_queue_worker+0x300/0x300
 [<ffffffff8106308e>] kthread+0x8e/0xa0
 [<ffffffff81a69de4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81063000>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff81a69de0>] ? gs_change+0x13/0x13
---[ end trace fd916ccd8369970f ]---

-- 
Best Regards,
 Alexey 'Alexxy' Shvetsov
 Petersburg Nuclear Physics Institute, Russia
 Department of Molecular and Radiation Biophysics
 Gentoo Team Ru
 Gentoo Linux Dev
 mailto:alexxyum@gmail.com
 mailto:alexxy@gentoo.org
 mailto:alexxy@omrb.pnpi.spb.ru
--nextPart1806658.smCkESvK93
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABCAAGBQJPegioAAoJEOf+E+/4L5Lm5XYP/3ZvtnZi9uhrh3ZnnUsDVlur
5JoMKUdW+A2YWDLrjhgtu7zOWL/9CV+voMN6Xu7lo+HgGjZnW1edvWbvtqE7ioyV
IBxZqb7qeAHBAEkfZb0b/bmoVhsX/p5QxJ2uJpIvheubBGwjtak3Uz7f+hbVoI3k
YV0yVHQEP9mHQKNhx5axE8TTZIFh4y8b+aYpZjVyTJdBT+Ydo0rgCxSxaZ+pnLKQ
GuOFYMdeyNrjCqbSyZmReqAEmDnpX5tbPhA8uFP5yJ7ZHCwTjcRbho/pbRRG8op/
uGXG5KL8zTJOOS6XGCMFYzGvB3p3F2InLVZIfB/vp1+wJlMM6lGA4wkl2niXzAWM
RyU8UQjnArUuhY/X7mh8cLZRlPyfPKZ+k3Q57eSpOl4ogquMqbO/YuQOTLimBMiP
1Qk8KeOkmxJ1NBZv3ClxaaNgsokP9sKzjRygKGhyIwNfstC32AQdWS9ZAH06DOxv
skIeHc/F/Ei9SBUNqdUCKjIkvuEaneJYyS1LldxBgmf1Fc1HeAG3ifZcqXy/Yuzh
OvEXw5StmDIpnZw4vYEw4jgyoQOXLFYwm4cYTAe+sU0WpJhV0Nw/KGQsHHKDQfn4
x2CBq0GDDClVr6mphwA7db7RRAGdBi4kJ25wh+JSTQ9CwbjsA/EAXQiNOwRWZLmy
ecCqCksBMAtaqMx7NHZR
=5ZKn
-----END PGP SIGNATURE-----

--nextPart1806658.smCkESvK93--

