From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [patch 11/11] btrfs: The file argument for fsync() is never null
Date: Mon, 14 Jun 2010 22:07:23 +0200
Message-ID: <201006142207.25930.johannes.hirte@fem.tu-ilmenau.de>
References: <20100529094907.GL5483@bicker>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <josef@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100529094907.GL5483@bicker>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag 29 Mai 2010, 11:49:07 schrieb Dan Carpenter:
> The "file" argument for fsync is never null so we can remove this check.
> 
> What drew my attention here is that 7ea8085910e: "drop unused dentry
> argument to ->fsync" introduced an unconditional dereference at the
> start of the function and that generated a smatch warning.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 787b50a..e252d23 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1140,7 +1140,7 @@ int btrfs_sync_file(struct file *file, int datasync)
>  	/*
>  	 * ok we haven't committed the transaction yet, lets do a commit
>  	 */
> -	if (file && file->private_data)
> +	if (file->private_data)
>  		btrfs_ioctl_trans_end(file);
> 
>  	trans = btrfs_start_transaction(root, 0);

I think you're wrong here. I've run into a kernel null pointer dereference at 
this point with a NFS exported btrfs filesystem:


BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
IP: [<ffffffff8115d7b3>] btrfs_sync_file+0xa7/0x15a
PGD 2a72e067 PUD 1c29f067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/power_method
CPU 1 
Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth 
snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_seq 
snd_pcm_oss snd_mixer_oss radeon ttm drm_kms_helper drm i2c_algo_bit 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm snd_seq_device 
snd_timer snd_page_alloc snd_util_mem snd_hwdep snd amd64_edac_mod edac_core 
uhci_hcd ohci_hcd sata_sil edac_mce_amd sg sr_mod k8temp i2c_amd756 
i2c_amd8111 hwmon

Pid: 2330, comm: nfsd Not tainted 2.6.34-btrfs-2-drm #1 TYAN Tiger K8W Dual 
AMD Opteron, S2875/To Be Filled By O.E.M.
RIP: 0010:[<ffffffff8115d7b3>]  [<ffffffff8115d7b3>] btrfs_sync_file+0xa7/0x15a
RSP: 0000:ffff880119e9bcf0  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88011e4da000 RCX: 0000000000000020
RDX: 0000000000000df8 RSI: 0000000000000000 RDI: ffff88011e495b28
RBP: ffff88011c30eb78 R08: ffffffff8141bab0 R09: 0000000000000000
R10: ffff880119e9bc50 R11: ffff88011c30eb78 R12: ffff88011c305240
R13: 0000000000000000 R14: ffffffff8141bab0 R15: ffff880119d1d040
FS:  00002ac4c0279180(0000) GS:ffff880001880000(0000) knlGS:00000000f74726d0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000098 CR3: 0000000015c84000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process nfsd (pid: 2330, threadinfo ffff880119e9a000, task ffff880119e185e0)
Stack:
 ffff8800273da3d8 0000000200000000 0000000000000003 0000000000000000
<0> ffff88011c305240 0000000000000000 ffff88011c30ec90 ffffffff810b1a99
<0> ffff880119d1d040 ffff880000000000 0000000000000000 ffff880023e63240
Call Trace:
 [<ffffffff810b1a99>] ? vfs_fsync_range+0x7a/0xa7
 [<ffffffff8112e055>] ? nfsd4_create_clid_dir+0x12d/0x15d
 [<ffffffff81129e64>] ? nfsd4_open_confirm+0xec/0x118
 [<ffffffff8111dcb1>] ? nfsd4_proc_compound+0x1fd/0x3b5
 [<ffffffff8110f1cb>] ? nfsd_dispatch+0xdf/0x1b5
 [<ffffffff8132e89a>] ? svc_process+0x41d/0x703
 [<ffffffff8102bcc3>] ? default_wake_function+0x0/0xf
 [<ffffffff8110f6dd>] ? nfsd+0xe1/0x125
 [<ffffffff8110f5fc>] ? nfsd+0x0/0x125
 [<ffffffff81041fcd>] ? kthread+0x75/0x7d
 [<ffffffff81002b54>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81041f58>] ? kthread+0x0/0x7d
 [<ffffffff81002b50>] ? kernel_thread_helper+0x0/0x10
Code: 8b bb 28 01 00 00 89 44 24 08 48 81 c7 28 1b 00 00 e8 1e 79 1f 00 8b 44 
24 08 e9 b4 00 00 00 48 81 c7 28 1b 00 00 e8 09 79 1f 00 <49> 83 bd 98 00 00 
00 00 74 08 4c 89 ef e8 06 75 01 00 31 f6 48 
RIP  [<ffffffff8115d7b3>] btrfs_sync_file+0xa7/0x15a
 RSP <ffff880119e9bcf0>
CR2: 0000000000000098
---[ end trace 5c7989eaf4eda923 ]---

addr2line showed me exact this change you made.

It happend with a linux-2.6.34 with the latest btrfs-changes on top.

regards,
  Johannes
