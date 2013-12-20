Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:41584 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab3LTP7P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 10:59:15 -0500
Date: Sat, 21 Dec 2013 00:59:02 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Shilong Wang <wangshilong1991@gmail.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/relocation.c:1062
Message-ID: <20131221005902.0d795572@virtall.com>
In-Reply-To: <CAP9B-Qm+he3V-Oh2AgH+gUXgcSUbE-Az0YaW0gBgW03mmDN9EA@mail.gmail.com>
References: <20131219210941.1065d1b5@virtall.com>
	<52B2E319.4010706@cn.fujitsu.com>
	<20131219213019.1f1038f2@virtall.com>
	<52B2EB40.5090904@cn.fujitsu.com>
	<20131219220737.7b173f9a@virtall.com>
	<20131221000623.30148a5d@virtall.com>
	<CAP9B-Qm+he3V-Oh2AgH+gUXgcSUbE-Az0YaW0gBgW03mmDN9EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-o  skip_balance - didn't know this.

Actually, I was able to "skip" the balance, sort of, with this:

mount /mnt/btrfs ; btrfs fi balance cancel /mnt/btrfs


However, the fs is extremely unstable (will remount read only quite
fast, i.e. if I start removing snapshot).


I'm trying to run btrfsck without the --repair option to see if it
shows anything interesting.


-- 
Tomasz Chmielewski
http://wpkg.org


On Fri, 20 Dec 2013 23:52:08 +0800
Shilong Wang <wangshilong1991@gmail.com> wrote:

> Hello Tomasz,
> 
> There should be some bugs flying on, unitil now, you can try to
> remount: something like:
> 
> # mount  /dev/sda /mnt -o  skip_balance
> 
> It will skip unfinshed balance, hopley it can help you before we give
> a bug fix.
> 
> Thanks,
> Wang
> 2013/12/20 Tomasz Chmielewski <tch@virtall.com>:
> > On Thu, 19 Dec 2013 22:07:37 +0900
> > Tomasz Chmielewski <tch@virtall.com> wrote:
> >
> >> If it matters, I had to hard reboot after that bug; the balance
> >> continued after the system booted again and I got this a while
> >> later (filesystem was remounted read only):
> >
> > Actually, looks like the fs is quite hosed now :(
> >
> > If I want to do an operation like removing a snapshot (btrfs sub
> > del ...), the command returns, there is IO for a few minutes, but
> > then, the kernel complains and fs is remounted readonly:
> >
> > [ 5111.773900] BTRFS debug (device sdb5): run_one_delayed_ref
> > returned -17 [ 5111.773902] ------------[ cut here ]------------
> > [ 5111.773957] WARNING: CPU: 0 PID: 15042 at fs/btrfs/super.c:254
> > __btrfs_abort_transaction+0x4d/0xff [btrfs]() [ 5111.774047] btrfs:
> > Transaction aborted (error -17) [ 5111.774048] Modules linked in:
> > ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
> > nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand
> > cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc
> > ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video
> > ehci_pci ehci_hcd acpi_cpufreq i2c_i801 i2c_core lpc_ich mfd_core
> > ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata
> > scsi_mod r8169 mii [ 5111.774355] CPU: 0 PID: 15042 Comm:
> > btrfs-transacti Tainted: G        W    3.13.0-rc4 #1 [ 5111.774443]
> > Hardware name: System manufacturer System Product Name/P8H77-M PRO,
> > BIOS 1101 02/04/2013 [ 5111.774533]  0000000000000009
> > ffff8800374ddc48 ffffffff8138a37d 0000000000000006 [ 5111.774622]
> > ffff8800374ddc98 ffff8800374ddc88 ffffffff810370a9 ffff8800374ddd80
> > [ 5111.774711]  ffffffffa020d524 00000000ffffffef ffff8807ead7d800
> > ffff8807ff0cc8c0 [ 5111.774800] Call Trace: [ 5111.774846]
> > [<ffffffff8138a37d>] dump_stack+0x46/0x58 [ 5111.774894]
> > [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91 [ 5111.774944]
> > [<ffffffffa020d524>] ? __btrfs_abort_transaction+0x4d/0xff [btrfs]
> > [ 5111.775032]  [<ffffffff81037157>] warn_slowpath_fmt+0x41/0x43
> > [ 5111.775081]  [<ffffffffa020d524>]
> > __btrfs_abort_transaction+0x4d/0xff [btrfs] [ 5111.775135]
> > [<ffffffffa02226ed>] btrfs_run_delayed_refs+0x253/0x46f [btrfs]
> > [ 5111.775189]  [<ffffffffa022fdec>]
> > btrfs_commit_transaction+0x36d/0x7df [btrfs] [ 5111.775281]
> > [<ffffffffa022e345>] transaction_kthread+0xef/0x1c2 [btrfs]
> > [ 5111.775333]  [<ffffffffa022e256>] ? open_ctree+0x1ac7/0x1ac7
> > [btrfs] [ 5111.775382]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
> > [ 5111.775428]  [<ffffffff8104edcd>] ?
> > kthread_freezable_should_stop+0x43/0x43 [ 5111.775477]
> > [<ffffffff8138f17c>] ret_from_fork+0x7c/0xb0 [ 5111.775524]
> > [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> > [ 5111.775572] ---[ end trace b552aca9a0cff3cb ]--- [ 5111.775618]
> > BTRFS error (device sdb5) in btrfs_run_delayed_refs:2730: errno=-17
> > Object already exists [ 5111.775707] BTRFS info (device sdb5):
> > forced readonly [ 5111.775754] BTRFS warning (device sdb5):
> > Skipping commit of aborted transaction. [ 5111.775841] BTRFS error
> > (device sdb5) in cleanup_transaction:1553: errno=-17 Object already
> > exists
> >
> >
> >
> > If I run balance (after unmounting and mounting the filesystem), it
> > ends in a similar way:
> >
> > [ 5927.338989] btrfs: relocating block group 4647284637696 flags 17
> > [ 6184.333629] btrfs: found 983 extents
> > [ 6269.512577] BTRFS debug (device sdb5): run_one_delayed_ref
> > returned -17 [ 6269.512579] ------------[ cut here ]------------
> > [ 6269.512636] WARNING: CPU: 7 PID: 17836 at fs/btrfs/super.c:254
> > __btrfs_abort_transaction+0x4d/0xff [btrfs]() [ 6269.512727] btrfs:
> > Transaction aborted (error -17) [ 6269.512727] Modules linked in:
> > ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
> > nf_nat_ipv4 nf_nat nf_conntrack ip_tables x_tables cpufreq_ondemand
> > cpufreq_conservative cpufreq_powersave cpufreq_stats bridge stp llc
> > ipv6 btrfs xor raid6_pq zlib_deflate loop pcspkr button video
> > ehci_pci ehci_hcd acpi_cpufreq i2c_i801 i2c_core lpc_ich mfd_core
> > ext4 crc16 jbd2 mbcache raid1 sg sd_mod ahci libahci libata
> > scsi_mod r8169 mii [ 6269.513036] CPU: 7 PID: 17836 Comm:
> > btrfs-transacti Tainted: G        W    3.13.0-rc4 #1 [ 6269.513124]
> > Hardware name: System manufacturer System Product Name/P8H77-M PRO,
> > BIOS 1101 02/04/2013 [ 6269.513214]  0000000000000009
> > ffff8807c5b07c48 ffffffff8138a37d 0000000000000006 [ 6269.513304]
> > ffff8807c5b07c98 ffff8807c5b07c88 ffffffff810370a9 ffff8807c5b07d80
> > [ 6269.513393]  ffffffffa020d524 00000000ffffffef ffff8807ead7e800
> > ffff8800371eedc0 [ 6269.513483] Call Trace: [ 6269.513529]
> > [<ffffffff8138a37d>] dump_stack+0x46/0x58 [ 6269.513577]
> > [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91 [ 6269.513627]
> > [<ffffffffa020d524>] ? __btrfs_abort_transaction+0x4d/0xff [btrfs]
> > [ 6269.513716]  [<ffffffff81037157>] warn_slowpath_fmt+0x41/0x43
> > [ 6269.513766]  [<ffffffffa020d524>]
> > __btrfs_abort_transaction+0x4d/0xff [btrfs] [ 6269.513820]
> > [<ffffffffa02226ed>] btrfs_run_delayed_refs+0x253/0x46f [btrfs]
> > [ 6269.513874]  [<ffffffffa022faef>]
> > btrfs_commit_transaction+0x70/0x7df [btrfs] [ 6269.513927]
> > [<ffffffffa022e345>] transaction_kthread+0xef/0x1c2 [btrfs]
> > [ 6269.513980]  [<ffffffffa022e256>] ? open_ctree+0x1ac7/0x1ac7
> > [btrfs] [ 6269.514029]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
> > [ 6269.514076]  [<ffffffff8104edcd>] ?
> > kthread_freezable_should_stop+0x43/0x43 [ 6269.514125]
> > [<ffffffff8138f17c>] ret_from_fork+0x7c/0xb0 [ 6269.514172]
> > [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
> > [ 6269.514220] ---[ end trace b552aca9a0cff3cc ]--- [ 6269.514266]
> > BTRFS error (device sdb5) in btrfs_run_delayed_refs:2730: errno=-17
> > Object already exists [ 6269.514356] BTRFS info (device sdb5):
> > forced readonly [ 6269.514430] BTRFS warning (device sdb5):
> > Skipping commit of aborted transaction. [ 6269.514559] BTRFS error
> > (device sdb5) in cleanup_transaction:1553: errno=-17 Object already
> > exists [ 6269.527034] btrfs: found 983 extents
> >
> >
> > Is there any fix I can try?
> >
> >
> > --
> > Tomasz Chmielewski
> > http://wpkg.org
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

