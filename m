From: Calvin Walton <calvin.walton@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3017!
Date: Mon, 27 Sep 2010 19:02:27 -0400
Message-ID: <1285628547.3724.3.camel@nayuki>
References: <AANLkTi=5uu+3_shYv9UGoJr7BQafBjZu48f8=_QNUCod@mail.gmail.com>
	 <AANLkTimOAKdHv5mpzH6kw-8_BvyViK_94EAXVPbWH-QG@mail.gmail.com>
	 <AANLkTi=MFLT37cPTKe_SdYpNJsDvm5s7iYLKo+OF0=Sa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: =?ISO-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Markus Suvanto <markus.suvanto@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=MFLT37cPTKe_SdYpNJsDvm5s7iYLKo+OF0=Sa@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2010-09-26 at 13:25 +0300, Markus Suvanto wrote:
> This time kernel is  2.6.36-rc5-00151-g32163f4
> no reverted commits no openafs module and
> hopefully  enough debug information....
> 
> There are multiple warning:
> 
> ---[ end trace bbbba72eccec168b ]---
> ------------[ cut here ]------------
> WARNING: at fs/fs-writeback.c:87 __mark_inode_dirty+0x1da/0x220()

I'm also seeing this warning, or something very much like it, as below:

[    7.382345] ------------[ cut here ]------------
[    7.382351] WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x5d/0x68()
[    7.382353] Hardware name: EX58-DS4
[    7.382354] Dirtiable inode bdi default != sb bdi btrfs
[    7.382355] Modules linked in: ir_lirc_codec lirc_dev ir_sony_decoder radeon ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder usblp ir_nec_decoder ttm mceusb ir_core drm_kms_helper cfbcopyarea cfbimgblt cfbfillrect
[    7.382366] Pid: 1245, comm: dbus-daemon Not tainted 2.6.36-rc5-00151-g32163f4 #88
[    7.382368] Call Trace:
[    7.382371]  [<ffffffff81056f4c>] warn_slowpath_common+0x80/0x98
[    7.382374]  [<ffffffff81056ff8>] warn_slowpath_fmt+0x41/0x43
[    7.382376]  [<ffffffff810dd952>] inode_to_bdi+0x5d/0x68
[    7.382379]  [<ffffffff810de435>] __mark_inode_dirty+0xcf/0x1a2
[    7.382382]  [<ffffffff811d6a56>] btrfs_setattr+0x1fc/0x22d
[    7.382385]  [<ffffffff810d65b1>] notify_change+0x1a1/0x2a1
[    7.382389]  [<ffffffff810c2aa8>] sys_fchmodat+0x81/0xc0
[    7.382391]  [<ffffffff810c49d8>] ? fput+0x1d/0x1a4
[    7.382393]  [<ffffffff810cfad1>] ? sys_fcntl+0x4ca/0x4dc
[    7.382395]  [<ffffffff810c2afa>] sys_chmod+0x13/0x15
[    7.382399]  [<ffffffff810229ab>] system_call_fastpath+0x16/0x1b
[    7.382400] ---[ end trace beeec739c7ec991e ]---

This happens repeatedly every couple of minutes after my computer has
booted. It looks like this is pretty recent; I don't recall seeing it on
2.6.36-rc4-00076-g9c03f16. If nobody has any ideas regarding the cause,
I can try bisecting it to narrow it down; let me know!

-- 
Calvin Walton <calvin.walton@gmail.com>

