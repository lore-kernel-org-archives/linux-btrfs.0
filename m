Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62506 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2EWMeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 08:34:44 -0400
Received: by ghrr11 with SMTP id r11so1213581ghr.19
        for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2012 05:34:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120522173344.GB1890@localhost.localdomain>
References: <20120517144306.GA3011@dhcp231-144.rdu.redhat.com>
	<4FB51577.5090100@tuxadero.com>
	<20120517194358.GA9846@dhcp231-144.rdu.redhat.com>
	<CAJafhzTQJchdd600DiEnooUH-P9ZcLvW+oEczCMNskd+Ud4BmQ@mail.gmail.com>
	<4FB56B21.7070800@tuxadero.com>
	<20120518144759.GA1892@localhost.localdomain>
	<4FB685C9.2050607@tuxadero.com>
	<20120518190105.GB1892@localhost.localdomain>
	<4FB9BDBA.2030806@cn.fujitsu.com>
	<CAJafhzSmLC9yUwrxsJEz5vKYnfP0DSWdMnA0oXmLT_4CQFc1oQ@mail.gmail.com>
	<20120522173344.GB1890@localhost.localdomain>
Date: Wed, 23 May 2012 14:34:43 +0200
Message-ID: <CAJafhzQGHsSA6dUwOqTJERj7SgVmKFuVDHk5R+i7n0FuhUAj_g@mail.gmail.com>
Subject: Re: Ceph on btrfs 3.4rc
From: Christian Brunner <christian@brunner-muc.de>
To: Josef Bacik <josef@redhat.com>
Cc: miaox@cn.fujitsu.com, Martin Mailand <martin@tuxadero.com>,
        Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2012/5/22 Josef Bacik <josef@redhat.com>:
>>
>
> Yeah you would also need to change orphan_meta_reserved.  I fixed this by just
> taking the BTRFS_I(inode)->lock when messing with these since we don't want to
> take up all that space in the inode just for a marker.  I ran this patch for 3
> hours with no issues, let me know if it works for you.  Thanks,

Compared to the last runs, I had to run it much longer, but somehow I
managed to hit a BUG_ON again:

[448281.002087] couldn't find orphan item for 2027, nlink 1, root 308,
root being deleted no
[448281.011339] ------------[ cut here ]------------
[448281.016590] kernel BUG at fs/btrfs/inode.c:2230!
[448281.021837] invalid opcode: 0000 [#1] SMP
[448281.026525] CPU 4
[448281.028670] Modules linked in: btrfs zlib_deflate libcrc32c xfs
exportfs sunrpc bonding ipv6 sg serio_raw pcspkr iTCO_wdt
iTCO_vendor_support ixgbe dca mdio i7core_edac edac_core
iomemory_vsl(PO) hpsa squashfs [last unloaded: btrfs]
[448281.052215]
[448281.053977] Pid: 16018, comm: ceph-osd Tainted: P        W  O
3.3.5-1.fits.1.el6.x86_64 #1 HP ProLiant DL180 G6
[448281.065555] RIP: 0010:[<ffffffffa04a17ab>]  [<ffffffffa04a17ab>]
btrfs_orphan_del+0x19b/0x1b0 [btrfs]
[448281.075965] RSP: 0018:ffff880458257d18  EFLAGS: 00010292
[448281.081987] RAX: 0000000000000063 RBX: ffff8803a28ebc48 RCX:
0000000000002fdb
[448281.090042] RDX: 0000000000000000 RSI: 0000000000000046 RDI:
0000000000000246
[448281.098093] RBP: ffff880458257d58 R08: ffffffff81af6100 R09:
0000000000000000
[448281.106146] R10: 0000000000000004 R11: 0000000000000000 R12:
0000000000000001
[448281.114202] R13: ffff88052e130400 R14: 0000000000000001 R15:
ffff8805beae9e10
[448281.122262] FS:  00007fa2e772f700(0000) GS:ffff880627280000(0000)
knlGS:0000000000000000
[448281.131386] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[448281.137879] CR2: ffffffffff600400 CR3: 00000005015a5000 CR4:
00000000000006e0
[448281.145929] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[448281.153974] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[448281.162043] Process ceph-osd (pid: 16018, threadinfo
ffff880458256000, task ffff88055b711940)
[448281.171646] Stack:
[448281.173987]  ffff880458257dff ffff8803a28eba98 ffff880458257d58
ffff8805beae9e10
[448281.182377]  0000000000000000 ffff88052e130400 ffff88029ff33380
ffff8803a28ebc48
[448281.190766]  ffff880458257e08 ffffffffa04ab4e6 0000000000000000
ffff8803a28ebc48
[448281.199155] Call Trace:
[448281.202005]  [<ffffffffa04ab4e6>] btrfs_truncate+0x5f6/0x660 [btrfs]
[448281.209203]  [<ffffffffa04ab646>] btrfs_setattr+0xf6/0x1a0 [btrfs]
[448281.216202]  [<ffffffff811816fb>] notify_change+0x18b/0x2b0
[448281.222517]  [<ffffffff81276541>] ? selinux_inode_permission+0xd1/0x130
[448281.229990]  [<ffffffff81165f44>] do_truncate+0x64/0xa0
[448281.235919]  [<ffffffff81172669>] ? inode_permission+0x49/0x100
[448281.242617]  [<ffffffff81166197>] sys_truncate+0x137/0x150
[448281.248838]  [<ffffffff8158b1e9>] system_call_fastpath+0x16/0x1b
[448281.255631] Code: a0 49 8b 8d f0 02 00 00 8b 53 48 4c 0f 45 c0 48
85 f6 74 1b 80 bb 60 fe ff ff 84 74 12 48 c7 c7 e8 1d 50 a0 31 c0 e8
9d ea 0d e1 <0f> 0b eb fe 48 8b 73 40 eb e8 66 66 2e 0f 1f 84 00 00 00
00 00
[448281.277435] RIP  [<ffffffffa04a17ab>] btrfs_orphan_del+0x19b/0x1b0 [btrfs]
[448281.285229]  RSP <ffff880458257d18>
[448281.289667] ---[ end trace 9adc7b36a3e66872 ]---

Sorry,
Christian
