Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:55061 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaARAPW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 19:15:22 -0500
Date: Sat, 18 Jan 2014 01:15:15 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs@vger.kernel.org
Cc: lists@colorremedies.com
Subject: Re: why am  I getting "No space left on device" here?
Message-ID: <20140118011515.16eb12ac@virtall.com>
In-Reply-To: <20140115212208.5d9f3aa7@wpkg.org>
References: <20140115115543.790adafb@wpkg.org>
	<20140115212208.5d9f3aa7@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 15 Jan 2014 21:22:08 +0100
Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> > What kernel version? Can you:
> > 
> > umount
> > dmesg -n7
> > mount
> > 
> > And then try to reproduce the behavior and note any kernel messages
> > in dmesg?

Turns out it's reproducible, with 3.13-rc8.

After reboot, I've started balance with:

# time btrfs fi balance start /home
ERROR: error during balancing '/home' - Read-only file system
There may be more info in syslog - try dmesg | tail

real    2434m32.786s
user    0m0.000s
sys     122m1.070s


dmesg shows:

(...)
Jan 17 17:04:35 test-5 kernel: [147299.097715] btrfs: found 79279 extents
Jan 17 17:04:50 test-5 kernel: [147314.344600] btrfs: found 79279 extents
Jan 17 17:04:51 test-5 kernel: [147314.888856] btrfs: relocating block group 4787911262208 flags 17
Jan 17 17:05:00 test-5 kernel: [147324.159656] btrfs: found 103218 extents
Jan 17 17:05:17 test-5 kernel: [147341.085950] btrfs: found 103218 extents
Jan 17 17:05:18 test-5 kernel: [147341.810090] btrfs: relocating block group 4786837520384 flags 17
Jan 17 17:05:27 test-5 kernel: [147351.174785] btrfs: found 70313 extents
Jan 17 17:06:22 test-5 kernel: [147406.102437] btrfs: found 70313 extents
Jan 17 17:07:40 test-5 kernel: [147483.489962] btrfs: relocating block group 4785763778560 flags 20
Jan 17 17:08:31 test-5 kernel: [147534.927240] BTRFS debug (device sdb4): run_one_delayed_ref returned -28
Jan 17 17:08:31 test-5 kernel: [147534.927244] ------------[ cut here ]------------
Jan 17 17:08:31 test-5 kernel: [147534.927260] BTRFS debug (device sdb4): run_one_delayed_ref returned -28
Jan 17 17:08:31 test-5 kernel: [147534.927262] BTRFS error (device sdb4) in btrfs_run_delayed_refs:2730: errno=-28 No space left
Jan 17 17:08:31 test-5 kernel: [147534.927262] BTRFS info (device sdb4): forced readonly
Jan 17 17:08:31 test-5 kernel: [147534.927465] WARNING: CPU: 0 PID: 2248 at fs/btrfs/super.c:254 __btrfs_abort_transaction+0x4d/0xff [btrfs]()
Jan 17 17:08:31 test-5 kernel: [147534.927571] btrfs: Transaction aborted (error -28)
Jan 17 17:08:31 test-5 kernel: [147534.927572] Modules linked in: tun xt_tcpudp iptable_filter ip_tables x_tables cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats ipv6 btrfs zlib_deflate ext3 jbd loop i2c_i801 i2c_core pcspkr ehci_pci video button ehci_hcd lpc_ich mfd_core acpi_cpufreq ext4 crc16 jbd2 mbcache aacraid 3w_9xxx 3w_xxxx raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid0 sata_nv sata_sil sata_via sg sd_mod ahci libahci libata scsi_mod r8169 mii
Jan 17 17:08:31 test-5 kernel: [147534.927987] CPU: 0 PID: 2248 Comm: btrfs-transacti Not tainted 3.13.0-rc8 #2
Jan 17 17:08:31 test-5 kernel: [147534.928043] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 1106 10/17/2011
Jan 17 17:08:31 test-5 kernel: [147534.928146]  0000000000000009 ffff88080dbd1c48 ffffffff813898b7 0000000000000006
Jan 17 17:08:31 test-5 kernel: [147534.928249]  ffff88080dbd1c98 ffff88080dbd1c88 ffffffff810370a9 ffff88080dbd1d80
Jan 17 17:08:31 test-5 kernel: [147534.928351]  ffffffffa02d8524 00000000ffffffe4 ffff880813301000 ffff880036f5a960
Jan 17 17:08:31 test-5 kernel: [147534.928454] Call Trace:
Jan 17 17:08:31 test-5 kernel: [147534.928506]  [<ffffffff813898b7>] dump_stack+0x46/0x58
Jan 17 17:08:31 test-5 kernel: [147534.928561]  [<ffffffff810370a9>] warn_slowpath_common+0x77/0x91
Jan 17 17:08:31 test-5 kernel: [147534.928618]  [<ffffffffa02d8524>] ? __btrfs_abort_transaction+0x4d/0xff [btrfs]
Jan 17 17:08:31 test-5 kernel: [147534.928721]  [<ffffffff81037157>] warn_slowpath_fmt+0x41/0x43
Jan 17 17:08:31 test-5 kernel: [147534.928777]  [<ffffffffa02d8524>] __btrfs_abort_transaction+0x4d/0xff [btrfs]
Jan 17 17:08:31 test-5 kernel: [147534.928883]  [<ffffffffa02ed6ed>] btrfs_run_delayed_refs+0x253/0x46f [btrfs]
Jan 17 17:08:31 test-5 kernel: [147534.928945]  [<ffffffffa02faaef>] btrfs_commit_transaction+0x70/0x7df [btrfs]
Jan 17 17:08:31 test-5 kernel: [147534.929051]  [<ffffffffa02f9345>] transaction_kthread+0xef/0x1c2 [btrfs]
Jan 17 17:08:31 test-5 kernel: [147534.929112]  [<ffffffffa02f9256>] ? open_ctree+0x1ac7/0x1ac7 [btrfs]
Jan 17 17:08:31 test-5 kernel: [147534.929169]  [<ffffffff8104ee9a>] kthread+0xcd/0xd5
Jan 17 17:08:31 test-5 kernel: [147534.929221]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
Jan 17 17:08:31 test-5 kernel: [147534.929278]  [<ffffffff8138e6fc>] ret_from_fork+0x7c/0xb0
Jan 17 17:08:31 test-5 kernel: [147534.929333]  [<ffffffff8104edcd>] ? kthread_freezable_should_stop+0x43/0x43
Jan 17 17:08:31 test-5 kernel: [147534.929389] ---[ end trace 117a714822a6415b ]---
Jan 17 17:08:31 test-5 kernel: [147534.929442] BTRFS error (device sdb4) in btrfs_run_delayed_refs:2730: errno=-28 No space left

<---- unmounted, mounted with -o skip_balance here

Jan 18 01:00:47 test-5 kernel: [175855.856374] btrfs: device label crawler-btrfs devid 4 transid 401054 /dev/sda4
Jan 18 01:00:47 test-5 kernel: [175855.856616] btrfs: device label crawler-btrfs devid 3 transid 401054 /dev/sdb4
Jan 18 01:00:47 test-5 kernel: [175855.856905] btrfs: device label crawler-btrfs devid 3 transid 401054 /dev/sdb4
Jan 18 01:00:47 test-5 kernel: [175855.857613] btrfs: force zlib compression
Jan 18 01:00:47 test-5 kernel: [175855.857681] btrfs: disk space caching is enabled
Jan 18 01:01:07 test-5 kernel: [175876.239288] BTRFS debug (device sdb4): unlinked 1 orphans
Jan 18 01:01:07 test-5 kernel: [175876.281954] btrfs: force skipping balance


# btrfs fi show /home
Label: crawler-btrfs  uuid: 60f1759c-45f6-4484-9f60-66a4e9bbf2b6
        Total devices 2 FS bytes used 1.76TiB
        devid    3 size 2.56TiB used 1.76TiB path /dev/sdb4
        devid    4 size 2.56TiB used 1.76TiB path /dev/sda4

Btrfs v3.12

# btrfs fi df /home
Data, RAID1: total=1.71TiB, used=1.71TiB
System, RAID1: total=32.00MiB, used=260.00KiB
Metadata, RAID1: total=53.00GiB, used=51.97GiB


# df -h /home
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb4       5.2T  3.6T  1.6T  69% /home

# btrfs device stats /home
[/dev/sdb4].write_io_errs   0
[/dev/sdb4].read_io_errs    0
[/dev/sdb4].flush_io_errs   0
[/dev/sdb4].corruption_errs 0
[/dev/sdb4].generation_errs 0
[/dev/sda4].write_io_errs   0
[/dev/sda4].read_io_errs    0
[/dev/sda4].flush_io_errs   0
[/dev/sda4].corruption_errs 0
[/dev/sda4].generation_errs 0


-- 
Tomasz Chmielewski
http://wpkg.org
