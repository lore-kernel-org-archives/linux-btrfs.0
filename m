Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751813AbdLNNkZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 08:40:25 -0500
Date: Thu, 14 Dec 2017 14:38:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Dmitrii Tcvetkov <demfloro@demfloro.ru>, linux-btrfs@vger.kernel.org,
        jbacik@fb.com
Subject: Re: WARN_ON in __writeback_inodes_sb_nr when btrfs mounted with
 flushoncommit
Message-ID: <20171214133822.GG3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171214140230.589485d8@job>
 <ebc37379-1271-1c03-f740-2e88cfb315b2@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ebc37379-1271-1c03-f740-2e88cfb315b2@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 14, 2017 at 03:21:52PM +0200, Nikolay Borisov wrote:
> 
> 
> On 14.12.2017 13:02, Dmitrii Tcvetkov wrote:
> > Since 4.15-rc1 if btrfs filesystem is mounted with flushoncommit mount option
> > then during fsync this trace appears in dmesg:
> > 
> > [   17.323092] WARNING: CPU: 0 PID: 364 at fs/fs-writeback.c:2339 __writeback_inodes_sb_nr+0xbf/0xd0
> > [   17.323925] Modules linked in:
> > [   17.324697] CPU: 0 PID: 364 Comm: systemd-journal Not tainted 4.15.0-rc3 #2
> > [   17.325424] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2901 05/04/2016
> > [   17.326177] RIP: 0010:__writeback_inodes_sb_nr+0xbf/0xd0
> > [   17.326875] RSP: 0018:ffff8bcd40a77d08 EFLAGS: 00010246
> > [   17.327598] RAX: 0000000000000000 RBX: ffff8a3fa9764488 RCX: 0000000000000000
> > [   17.328321] RDX: 0000000000000002 RSI: 00000000000018ae RDI: ffff8a3fa96c7070
> > [   17.329012] RBP: ffff8bcd40a77d0c R08: ffffffffffffff80 R09: 00000000000000ff
> > [   17.329740] R10: ffff8bcd40a77c10 R11: 0000000000001000 R12: 0000000000000000
> > [   17.330439] R13: ffff8a3fa915e698 R14: ffff8a3fb04ed780 R15: ffff8a3fa9a16610
> > [   17.331169] FS:  00007f72d53338c0(0000) GS:ffff8a3fbec00000(0000) knlGS:0000000000000000
> > [   17.331880] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   17.332624] CR2: 00007f72d09a5000 CR3: 0000000329334000 CR4: 00000000000406f0
> > [   17.333383] Call Trace:
> > [   17.334113]  btrfs_commit_transaction+0x857/0x920
> > [   17.334874]  btrfs_sync_file+0x30c/0x3e0
> > [   17.335622]  do_fsync+0x33/0x60
> > [   17.336332]  SyS_fsync+0x7/0x10
> > [   17.337069]  do_syscall_64+0x63/0x360
> > [   17.337776]  entry_SYSCALL64_slow_path+0x25/0x25
> > [   17.338513] RIP: 0033:0x7f72d4f29094
> > [   17.339244] RSP: 002b:00007ffd71b078f8 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
> > [   17.339962] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f72d4f29094
> > [   17.340718] RDX: 0000000000090000 RSI: 00005630b6f8b090 RDI: 0000000000000010
> > [   17.341431] RBP: 00005630b6f8b090 R08: 00000000000fffff R09: 0000000000000000
> > [   17.342169] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000010
> > [   17.342902] R13: 00005630b6f88f60 R14: 0000000000000001 R15: 0000000000000001
> > [   17.343604] Code: df 0f b6 d1 e8 a3 fc ff ff 48 89 ee 48 89 df e8 78 f5 ff
> > ff 48 8b 44 24 48 65 48 33 04 25 28 00 00 00 75 0b 48 83 c4 50 5b 5d c3 <0f> ff
> > eb ca e8 38 1e ec ff 0f 1f 84 00 00 00 00 00 41 54 55 48
> > [   17.344408] ---[ end trace ff4cf41ec70ec0a7 ]---
> 
> So this is due to writeback_inodes_sb being called without holding
> s_umount. So 4.15-rc1 the first kernel that started exhibiting this or
> did you also see it with earlier kernel

This is new in 4.15, there was an earlier report
https://marc.info/?l=linux-btrfs&m=151315564008773
