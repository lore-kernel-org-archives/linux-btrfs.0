From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: btrfs crash with 3.1.5
Date: Tue, 20 Dec 2011 10:28:11 +0000
Message-ID: <jcpnvs$k71$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi - this crash occured with Fedora 16 kernel 3.1.5-6.fc16.x86_64. The  
message below appeared and the machine locked up with the hard drive on and 
the keyboard lights blinking. Btrfs was running with compress-force=zlib on 
a software raid md linear array (~5GB), around 50% full.

------------[ cut here ]------------
WARNING: at mm/page-writeback.c:1370 
__set_page_dirty_nobuffers+0x11a/0x150()
Hardware name: C51GM03
Modules linked in: btrfs zlib_deflate libcrc32c nfs fscache it87 hwmon_vid 
xfs snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm 
raid456 async_raid6_recov async_pq snd_timer nfsd snd raid6_pq forcedeth 
async_xor uinput ppdev parport_pc parport nv_tco i2c_nforce2 xor 
async_memcpy async_tx edac_core edac_mce_amd lockd nfs_acl auth_rpcgss 
linear soundcore k8temp i2c_core serio_raw sunrpc snd_page_alloc 
firewire_ohci firewire_core pata_acpi crc_itu_t ata_generic pata_amd sata_nv 
3w_9xxx [last unloaded: btrfs]
Pid: 9378, comm: btrfs-delalloc- Not tainted 3.1.5-6.fc16.x86_64 #1
Call Trace:
 [<ffffffff8106b6ef>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8106b74a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8111ea5a>] __set_page_dirty_nobuffers+0x11a/0x150
 [<ffffffffa04d3173>] compress_file_range+0x5a3/0x610 [btrfs]
 [<ffffffffa04d3215>] async_cow_start+0x35/0x50 [btrfs]
 [<ffffffffa04f2472>] worker_loop+0x142/0x520 [btrfs]
 [<ffffffffa04f2330>] ? btrfs_queue_worker+0x2b0/0x2b0 [btrfs]
 [<ffffffff8108ddbc>] kthread+0x8c/0xa0
 [<ffffffff815de934>] kernel_thread_helper+0x4/0x10
 [<ffffffff8108dd30>] ? kthread_worker_fn+0x190/0x190
 [<ffffffff815de930>] ? gs_change+0x13/0x13
---[ end trace 5aee123eeca0621f ]---

There are some log messages around 10 minutes after this, but is the last 
significant thing in them and is what was shown on the terminal.

The lockup occured while writing to the array with a tar-to-tar pipe from an 
XFS file system. The command is

tar -b 2048 -cpf - -C $indir ./ | tar -b 2048 -xpf - -C $outdir

Jeremy



