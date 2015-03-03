Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38248 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755270AbbCCP5l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Mar 2015 10:57:41 -0500
Date: Tue, 3 Mar 2015 10:57:38 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: extent-same ioctl hangs holding locks (v3.18.8)
Message-ID: <20150303155738.GB26622@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The extent-same ioctl seems to have a locking bug.  My test machines
will run between 0 and 3 days before something gets locked and stays
locked forever.

In the dumps and logs below, 'btrsame' calls the btrfs extent-same ioctl
on its arguments.  As you can see from the trace, it is stuck in this
very ioctl.

'rsync' is famous already and needs no introduction.  It seems
to be stuck just trying to read the file extent-same is reading.

All of these processes are stuck on the same file.  There are lots of
rsyncs because the sender keeps timing out and starting a new rsync,
and the new rsync promptly locks up as soon as it touches the same file
the old ones did.

The rsync processes (and also 'cat' from the command line just now) lock
up when they try to read the same byte range currently being processed by
extent-same.  They are able to read earlier bytes in the file just fine.

Here is /proc/version:

	Linux version 3.18.8-zb64+ (root@sneezy) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP PREEMPT Fri Feb 27 01:09:08 EST 2015

Here are the kernel stacks from currently stuck processes:

	USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
	root       583  0.5  0.2 193664 38812 ?        DNs  02:36   2:36 rsync --server -vlHogDtprSze.iLsf --timeout=3600 --delete-during --delete-excluded --partial --numeric-ids --fuzzy --
	[<ffffffff81181412>] __lock_page_killable+0xa2/0xb0
	[<ffffffff81182f30>] generic_file_read_iter+0x440/0x600
	[<ffffffff811fbbfe>] new_sync_read+0x7e/0xb0
	[<ffffffff811fc394>] vfs_read+0x94/0x180
	[<ffffffff811fcf46>] SyS_read+0x46/0xc0
	[<ffffffff818711ad>] system_call_fastpath+0x16/0x1b
	[<ffffffffffffffff>] 0xffffffffffffffff

	USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
	root      4241  1.3  0.2 148064 36516 ?        DNs  07:11   2:27 rsync --server -vlHogDtprSze.iLsf --timeout=3600 --delete-during --delete-excluded --partial --numeric-ids --fuzzy --
	[<ffffffff81181412>] __lock_page_killable+0xa2/0xb0
	[<ffffffff81182f30>] generic_file_read_iter+0x440/0x600
	[<ffffffff811fbbfe>] new_sync_read+0x7e/0xb0
	[<ffffffff811fc394>] vfs_read+0x94/0x180
	[<ffffffff811fcf46>] SyS_read+0x46/0xc0
	[<ffffffff818711ad>] system_call_fastpath+0x16/0x1b
	[<ffffffffffffffff>] 0xffffffffffffffff

	USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
	root     10091  0.3  0.2 184208 40416 ?        DNs  Mar02   2:25 rsync --server -vlHogDtprSze.iLsf --timeout=3600 --delete-during --delete-excluded --partial --numeric-ids --fuzzy --
	[<ffffffff81392d9d>] lock_extent_bits+0x1ad/0x200
	[<ffffffff81392e03>] lock_extent+0x13/0x20
	[<ffffffff81395d3c>] __extent_readpages.constprop.38+0x21c/0x2c0
	[<ffffffff81397109>] extent_readpages+0x179/0x1c0
	[<ffffffff813777bf>] btrfs_readpages+0x1f/0x30
	[<ffffffff8118f606>] __do_page_cache_readahead+0x1b6/0x250
	[<ffffffff8118f77f>] ondemand_readahead+0xdf/0x280
	[<ffffffff8118fa4e>] page_cache_sync_readahead+0x2e/0x50
	[<ffffffff81182fdc>] generic_file_read_iter+0x4ec/0x600
	[<ffffffff811fbbfe>] new_sync_read+0x7e/0xb0
	[<ffffffff811fc394>] vfs_read+0x94/0x180
	[<ffffffff811fcf46>] SyS_read+0x46/0xc0
	[<ffffffff818711ad>] system_call_fastpath+0x16/0x1b
	[<ffffffffffffffff>] 0xffffffffffffffff

	USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
	root     19705  0.8  0.2 192260 34888 ?        DNs  05:11   2:29 rsync --server -vlHogDtprSze.iLsf --timeout=3600 --delete-during --delete-excluded --partial --numeric-ids --fuzzy --
	[<ffffffff81181412>] __lock_page_killable+0xa2/0xb0
	[<ffffffff81182f30>] generic_file_read_iter+0x440/0x600
	[<ffffffff811fbbfe>] new_sync_read+0x7e/0xb0
	[<ffffffff811fc394>] vfs_read+0x94/0x180
	[<ffffffff811fcf46>] SyS_read+0x46/0xc0
	[<ffffffff818711ad>] system_call_fastpath+0x16/0x1b
	[<ffffffffffffffff>] 0xffffffffffffffff

	USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
	root     21950  0.1  0.0  14800  1452 pts/43   D<+  01:17   0:44 btrsame [paths redacted]
	[<ffffffff81181362>] __lock_page+0xa2/0xb0
	[<ffffffff81181dc8>] pagecache_get_page+0x168/0x1a0
	[<ffffffff813a805d>] extent_same_get_page+0x2d/0xc0
	[<ffffffff813aef8f>] btrfs_ioctl+0x26bf/0x28c0
	[<ffffffff8120fa10>] do_vfs_ioctl+0x2f0/0x4f0
	[<ffffffff8120fc91>] SyS_ioctl+0x81/0xa0
	[<ffffffff818711ad>] system_call_fastpath+0x16/0x1b
	[<ffffffffffffffff>] 0xffffffffffffffff

	USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
	root     22535 13.4  0.1  75392 16716 ?        DNs  10:02   1:41 rsync --server -vlHogDtprSze.iLsf --timeout=3600 --delete-during --delete-excluded --partial --numeric-ids --fuzzy --
	[<ffffffffffffffff>] 0xffffffffffffffff

Here are the kernel messages:

	Mar  3 04:29:29 sneezy kernel: [113471.296017] INFO: task rsync:10091 blocked for more than 1800 seconds.
	Mar  3 04:29:29 sneezy kernel: [113471.296067]       Tainted: G        W      3.18.8-zb64+ #1
	Mar  3 04:29:29 sneezy kernel: [113471.296109] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
	Mar  3 04:29:29 sneezy kernel: [113471.296184] rsync           D 0000000000000001     0 10091      1 0x00000004
	Mar  3 04:29:29 sneezy kernel: [113471.296193]  ffff8800088c79a8 0000000000000086 ffff880069696000 000000000001fc00
	Mar  3 04:29:29 sneezy kernel: [113471.296200]  ffff8800088c7fd8 000000000001fc00 ffff88040a648000 ffff880069696000
	Mar  3 04:29:29 sneezy kernel: [113471.296207]  ffffffff81391f2c ffff880131b509d0 ffff8800088c7908 ffffffff8139152a
	Mar  3 04:29:29 sneezy kernel: [113471.296214] Call Trace:
	Mar  3 04:29:29 sneezy kernel: [113471.296230]  [<ffffffff81391f2c>] ? __set_extent_bit+0x44c/0x540
	Mar  3 04:29:29 sneezy kernel: [113471.296238]  [<ffffffff8139152a>] ? free_extent_state+0x4a/0xd0
	Mar  3 04:29:29 sneezy kernel: [113471.296245]  [<ffffffff81391f2c>] ? __set_extent_bit+0x44c/0x540
	Mar  3 04:29:29 sneezy kernel: [113471.296252]  [<ffffffff81871ea8>] ? retint_restore_args+0x13/0x13
	Mar  3 04:29:29 sneezy kernel: [113471.296261]  [<ffffffff8186ca79>] schedule+0x29/0x70
	Mar  3 04:29:29 sneezy kernel: [113471.296266]  [<ffffffff81392d9d>] lock_extent_bits+0x1ad/0x200
	Mar  3 04:29:29 sneezy kernel: [113471.296274]  [<ffffffff810b78c0>] ? __wake_up_sync+0x20/0x20
	Mar  3 04:29:29 sneezy kernel: [113471.296280]  [<ffffffff81392e03>] lock_extent+0x13/0x20
	Mar  3 04:29:29 sneezy kernel: [113471.296286]  [<ffffffff81395d3c>] __extent_readpages.constprop.38+0x21c/0x2c0
	Mar  3 04:29:29 sneezy kernel: [113471.296293]  [<ffffffff81379130>] ? btrfs_direct_IO+0x360/0x360
	Mar  3 04:29:29 sneezy kernel: [113471.296299]  [<ffffffff81397109>] extent_readpages+0x179/0x1c0
	Mar  3 04:29:29 sneezy kernel: [113471.296304]  [<ffffffff81379130>] ? btrfs_direct_IO+0x360/0x360
	Mar  3 04:29:29 sneezy kernel: [113471.296314]  [<ffffffff813777bf>] btrfs_readpages+0x1f/0x30
	Mar  3 04:29:29 sneezy kernel: [113471.296321]  [<ffffffff8118f606>] __do_page_cache_readahead+0x1b6/0x250
	Mar  3 04:29:29 sneezy kernel: [113471.296329]  [<ffffffff8118f77f>] ondemand_readahead+0xdf/0x280
	Mar  3 04:29:29 sneezy kernel: [113471.296336]  [<ffffffff8118fa4e>] page_cache_sync_readahead+0x2e/0x50
	Mar  3 04:29:29 sneezy kernel: [113471.296342]  [<ffffffff81182fdc>] generic_file_read_iter+0x4ec/0x600
	Mar  3 04:29:29 sneezy kernel: [113471.296350]  [<ffffffff810136cb>] ? __switch_to+0x1fb/0x620
	Mar  3 04:29:29 sneezy kernel: [113471.296358]  [<ffffffff811fbbfe>] new_sync_read+0x7e/0xb0
	Mar  3 04:29:29 sneezy kernel: [113471.296367]  [<ffffffff811fc394>] vfs_read+0x94/0x180
	Mar  3 04:29:29 sneezy kernel: [113471.296373]  [<ffffffff811fcf46>] SyS_read+0x46/0xc0
	Mar  3 04:29:29 sneezy kernel: [113471.296379]  [<ffffffff818711ad>] system_call_fastpath+0x16/0x1b
	Mar  3 04:29:29 sneezy kernel: [113471.296386] INFO: task btrsame:21950 blocked for more than 1800 seconds.
	Mar  3 04:29:29 sneezy kernel: [113471.296428]       Tainted: G        W      3.18.8-zb64+ #1
	Mar  3 04:29:29 sneezy kernel: [113471.296469] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
	Mar  3 04:29:29 sneezy kernel: [113471.296542] btrsame         D 0000000000000000     0 21950  30469 0x00000000
	Mar  3 04:29:29 sneezy kernel: [113471.296549]  ffff880003a9bc18 0000000000000086 ffff880003ff6000 000000000001fc00
	Mar  3 04:29:29 sneezy kernel: [113471.296556]  ffff880003a9bfd8 000000000001fc00 ffff88005c172000 ffff880003ff6000
	Mar  3 04:29:29 sneezy kernel: [113471.296563]  ffff8801d11de000 ffff88009cd5d000 ffff880003a9bc68 ffffffff8186c432
	Mar  3 04:29:29 sneezy kernel: [113471.296570] Call Trace:
	Mar  3 04:29:29 sneezy kernel: [113471.296578]  [<ffffffff8186c432>] ? __schedule+0x442/0xa60
	Mar  3 04:29:29 sneezy kernel: [113471.296586]  [<ffffffff8186d470>] ? bit_wait+0x60/0x60
	Mar  3 04:29:29 sneezy kernel: [113471.296592]  [<ffffffff8101e999>] ? read_tsc+0x9/0x10
	Mar  3 04:29:29 sneezy kernel: [113471.296599]  [<ffffffff8186d470>] ? bit_wait+0x60/0x60
	Mar  3 04:29:29 sneezy kernel: [113471.296604]  [<ffffffff8186ca79>] schedule+0x29/0x70
	Mar  3 04:29:29 sneezy kernel: [113471.296610]  [<ffffffff8186cd98>] io_schedule+0x98/0x100
	Mar  3 04:29:29 sneezy kernel: [113471.296616]  [<ffffffff8186d4a4>] bit_wait_io+0x34/0x60
	Mar  3 04:29:29 sneezy kernel: [113471.296622]  [<ffffffff8186d32b>] __wait_on_bit_lock+0x4b/0xb0
	Mar  3 04:29:29 sneezy kernel: [113471.296628]  [<ffffffff811361a0>] ? __delayacct_blkio_end+0x60/0xa0
	Mar  3 04:29:29 sneezy kernel: [113471.296635]  [<ffffffff81181362>] __lock_page+0xa2/0xb0
	Mar  3 04:29:29 sneezy kernel: [113471.296642]  [<ffffffff810b7900>] ? autoremove_wake_function+0x40/0x40
	Mar  3 04:29:29 sneezy kernel: [113471.296648]  [<ffffffff81181dc8>] pagecache_get_page+0x168/0x1a0
	Mar  3 04:29:29 sneezy kernel: [113471.296656]  [<ffffffff813a805d>] extent_same_get_page+0x2d/0xc0
	Mar  3 04:29:29 sneezy kernel: [113471.296663]  [<ffffffff813aef8f>] btrfs_ioctl+0x26bf/0x28c0
	Mar  3 04:29:29 sneezy kernel: [113471.296669]  [<ffffffff8147321f>] ? queue_unplugged+0x3f/0xc0
	Mar  3 04:29:29 sneezy kernel: [113471.296678]  [<ffffffff81476578>] ? blk_finish_plug+0x18/0x60
	Mar  3 04:29:29 sneezy kernel: [113471.296684]  [<ffffffff8118f618>] ? __do_page_cache_readahead+0x1c8/0x250
	Mar  3 04:29:29 sneezy kernel: [113471.296692]  [<ffffffff8120fa10>] do_vfs_ioctl+0x2f0/0x4f0
	Mar  3 04:29:29 sneezy kernel: [113471.296699]  [<ffffffff814b35ba>] ? trace_hardirqs_off_thunk+0x3a/0x3c
	Mar  3 04:29:29 sneezy kernel: [113471.296705]  [<ffffffff8120fc91>] SyS_ioctl+0x81/0xa0
	Mar  3 04:29:29 sneezy kernel: [113471.296711]  [<ffffffff818711ad>] system_call_fastpath+0x16/0x1b


--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlT12fIACgkQgfmLGlazG5wnqgCgy6HxQSUTk54l5qQKwpxPsBAX
2w8AoOjvBCwUC/G3S200RR2YJoQB+VNs
=Tow2
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
