Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48006 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbbDBLqK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Apr 2015 07:46:10 -0400
Date: Thu, 2 Apr 2015 11:46:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs hangs 3.19-10
Message-ID: <20150402114608.GG32078@carfax.org.uk>
References: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tvOENZuN7d6HfOWU"
In-Reply-To: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tvOENZuN7d6HfOWU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 02, 2015 at 02:38:24PM +0300, Timofey Titovets wrote:
> I've get it several times, after rebooting or unclean shutdown system.
> 
> This is very strange bug, because if i reboot, and mount it from live
> cd, all that okay, and after reboot in system, system successful mount
> all and working good.
> i did try to found any previous issues on it, and found nothing.

   Try 4.0-rc6, which should have the fix for the problem in it. This
was introduced in the stable series, and is now fixed in mainline. It
should also be fixed in the next stable release, I believe.

   Hugo.

> [  240.100043] INFO: task mount:485 blocked for more than 120 seconds.
> [  240.100156]       Not tainted 3.19.0-10-generic #10-Ubuntu
> [  240.100244] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  240.100359] mount           D ffff88009e907818     0   485      1 0x00000004
> [  240.100364]  ffff88009e907818 ffff8804473ac4b0 0000000000014200
> ffff88009e907fd8
> [  240.100368]  0000000000014200 ffff88044ae3f5c0 ffff8804473ac4b0
> ffff88009e907828
> [  240.100371]  ffff88045d073c70 ffff88045d073cd8 ffff88045d073cf0
> ffff88009e907858
> [  240.100374] Call Trace:
> [  240.100386]  [<ffffffff817c38e9>] schedule+0x29/0x70
> [  240.100427]  [<ffffffffc050a7e5>] btrfs_tree_lock+0x55/0x1f0 [btrfs]
> [  240.100432]  [<ffffffff810b6200>] ? wait_woken+0x90/0x90
> [  240.100444]  [<ffffffffc04acc69>] btrfs_search_slot+0x709/0xa60 [btrfs]
> [  240.100457]  [<ffffffffc04ae8ad>] btrfs_insert_empty_items+0x7d/0xd0 [btrfs]
> [  240.100469]  [<ffffffffc04a78aa>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [  240.100487]  [<ffffffffc050aab8>] btrfs_insert_orphan_item+0x58/0x80 [btrfs]
> [  240.100509]  [<ffffffffc050c04e>] insert_orphan_item+0x5e/0x90 [btrfs]
> [  240.100529]  [<ffffffffc0510d11>] replay_one_buffer+0x351/0x370 [btrfs]
> [  240.100547]  [<ffffffffc050b991>] walk_up_log_tree+0xd1/0x240 [btrfs]
> [  240.100558]  [<ffffffffc04a78aa>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [  240.100577]  [<ffffffffc050bb9b>] walk_log_tree+0x9b/0x1a0 [btrfs]
> [  240.100596]  [<ffffffffc0513214>] btrfs_recover_log_trees+0x1d4/0x470 [btrfs]
> [  240.100614]  [<ffffffffc05109c0>] ? replay_one_extent+0x6b0/0x6b0 [btrfs]
> [  240.100630]  [<ffffffffc04ceb23>] open_ctree+0x1813/0x2090 [btrfs]
> [  240.100642]  [<ffffffffc04a4b00>] btrfs_mount+0x850/0x920 [btrfs]
> [  240.100649]  [<ffffffff811f7208>] mount_fs+0x38/0x1c0
> [  240.100653]  [<ffffffff8119b5e5>] ? __alloc_percpu+0x15/0x20
> [  240.100658]  [<ffffffff812138fb>] vfs_kern_mount+0x6b/0x120
> [  240.100662]  [<ffffffff81216754>] do_mount+0x204/0xb20
> [  240.100665]  [<ffffffff8121738b>] SyS_mount+0x8b/0xd0
> [  240.100669]  [<ffffffff817c824d>] system_call_fastpath+0x16/0x1b
> [  240.100676] INFO: task btrfs-transacti:506 blocked for more than 120 seconds.
> [  240.100780]       Not tainted 3.19.0-10-generic #10-Ubuntu
> [  240.100869] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  240.100982] btrfs-transacti D ffff8804474abdc8     0   506      2 0x00000000
> [  240.100986]  ffff8804474abdc8 ffff88009ef83ae0 0000000000014200
> ffff8804474abfd8
> [  240.100989]  0000000000014200 ffffffff81c1a580 ffff88009ef83ae0
> ffff8804474abdd8
> [  240.100992]  ffff880448695000 ffff88045d396000 ffff88045d33afc0
> ffff8804474abe00
> [  240.100995] Call Trace:
> [  240.100998]  [<ffffffff817c38e9>] schedule+0x29/0x70
> [  240.101018]  [<ffffffffc04d14c5>]
> btrfs_commit_transaction+0x375/0xa40 [btrfs]
> [  240.101021]  [<ffffffff810b6200>] ? wait_woken+0x90/0x90
> [  240.101037]  [<ffffffffc04ccf5d>] transaction_kthread+0x1dd/0x250 [btrfs]
> [  240.101052]  [<ffffffffc04ccd80>] ?
> btrfs_cleanup_transaction+0x550/0x550 [btrfs]
> [  240.101057]  [<ffffffff81094679>] kthread+0xc9/0xe0
> [  240.101061]  [<ffffffff810945b0>] ? kthread_create_on_node+0x1c0/0x1c0
> [  240.101064]  [<ffffffff817c8198>] ret_from_fork+0x58/0x90
> [  240.101067]  [<ffffffff810945b0>] ? kthread_create_on_node+0x1c0/0x1c0
> 

-- 
Hugo Mills             | Great oxymorons of the world, no. 10:
hugo@... carfax.org.uk | Business Ethics
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--tvOENZuN7d6HfOWU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVHSwAAAoJEFheFHXiqx3k2tgP/jgRwSSYoGkUs/KF1/JPCtPh
GfaFNXWnBnbQTiRD7qG2YMQoXrE0AY2vLuHdwkK3mFsB/aqfImCELW850rqXBz9p
egjF8m4+PTdFyQ2InFuxu867hN2pUQIXllO5cRH5VOLyNRk9tGLqPIHtUKPsKTR2
+8VFMLhqy/zcchNvlc5anxHvFJFBuK4MS0q4GR5LRECYtIfUU42bTGoeXu+Wrh3v
uCY5cuCEFJasL8lpBOQE4VfVwJxUUixscwmS+8Tcz3TWGoKZtvjHHNqOTV7VF6UU
KHI6jDQiku7+cxsU8Ejx73tIyFAbrEvuql8tgYVXXMvFuSjEEfpKdQcobbsmvrFO
HxrCb89l0sKSdF6jgo41vxjX6IRLMzJPqXGbxgDn0yoiUue6nutKSlaff6a6RR6o
gQYYM73LW7ZinvU6LwhCKJysW1Z2AHt09Ew7ESsQDGGEBHEZ23nkJqCVOaY+5wxr
9DlWGr6WVGThW6VyMLN5VZ/PsqxJrI66E6ix2tL+sudEfUwmHWybCgvyVLGeEsdN
kYoZhyfIh8H4ZHY+fa+W9lwrYLWHDO2YDW9uW7Hx2CJ9i79sZQSi+/iJzGFTpG7W
n/1ukObJvwmyagutxffWxzdHL8pxhn8uRaZH4pG1GOD8IOsTTVKWCkvAuZSIeEw2
BMDfzPvpEAJFHC6XQFvJ
=2eth
-----END PGP SIGNATURE-----

--tvOENZuN7d6HfOWU--
