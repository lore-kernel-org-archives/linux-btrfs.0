Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:34211 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbcA2U2S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 15:28:18 -0500
Received: by mail-ig0-f194.google.com with SMTP id ik10so5337933igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 12:28:18 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160129183422.GE31992@twin.jikos.cz>
References: <cover.1453400624.git.dsterba@suse.com>
	<444e75169872f668eb890f19ec1f32dfc632e704.1453400624.git.dsterba@suse.com>
	<CAL3q7H5W=Eo64kDY38-sm58ZyHVJ3efNJ3ypJ1w_d8B4nDi-Cg@mail.gmail.com>
	<20160129183422.GE31992@twin.jikos.cz>
Date: Fri, 29 Jan 2016 20:28:17 +0000
Message-ID: <CAL3q7H40=VOvFj0wYH0r+Qm+0BWuzyqCjaNfg=gTuyyFiLF1Pg@mail.gmail.com>
Subject: Re: [PATCH 3/4] btrfs: sysfs: introduce helper for syncing bits with
 sysfs files
From: Filipe Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>, Filipe Manana <fdmanana@gmail.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2016 at 6:34 PM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Jan 29, 2016 at 01:55:31PM +0000, Filipe Manana wrote:
>> Did you try to run all xfstests with this?
>>
>> I'm getting very often lots of warnings in btrfs tests 060 to 074:
>
> Could you please test the attached patch in your testing setup? I was
> not able to trigger the crashes with btrfs/060 062 063, running hundreds
> of times with concurrent "find /sys/fs/btrfs -exec cat '{}' \;" in a
> tight loop.

Just bump the number of fsstress operation for 063 for example, makes
the issue easier to hit.

>
> Out of all approaches how update the sysfs files, the one based on
> workques looks best to me. The allocation context is safe wrt internal
> sysfs allocations with GFP_KERNEL.

I don't think the problem has anything to do with memory
allocations... Just concurrent calls to that new function or
concurrent remounts will trigger the warning in the new sysfs
functions - we're updating the sysfs group non-atomically - a remove +
add. So when a task attempts to remove it, some other has removed it
already, triggering one of the warnings. Same about the add operation.

So yes, the new patch triggers exactly the same warnings:

[41676.531816] BTRFS info (device sdg): disk space caching is enabled
[41676.535301] ------------[ cut here ]------------
[41676.544911] WARNING: CPU: 5 PID: 4499 at fs/sysfs/dir.c:31
sysfs_warn_dup+0x64/0x73()
[41676.546552] sysfs: cannot create duplicate filename
'/fs/btrfs/8024a413-cc1a-4e9b-a09a-255bd60a23da/features'
[41676.550614] Modules linked in: btrfs dm_flakey dm_mod ppdev
sha256_generic hmac xor drbg ansi_cprng aesni_intel raid6_pq
aes_x86_64 ablk_helper cryptd lrw gf128mul
 acpi_cpufreq glue_helper parport_pc sg evdev tpm_tis parport
i2c_piix4 tpm psmouse i2c_core pcspkr processor serio_raw button loop
autofs4 ext4 crc16 mbcache jbd2 sd
_mod sr_mod cdrom ata_generic virtio_scsi ata_piix virtio_pci libata
virtio_ring virtio e1000 crc32c_intel scsi_mod floppy [last unloaded:
btrfs]
[41676.570670] CPU: 5 PID: 4499 Comm: kworker/5:2 Tainted: G        W
     4.4.0-rc6-btrfs-next-18+ #1
[41676.573490] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS by qemu-project.org 04/01/2014
[41676.574947] Workqueue: events btrfs_sysfs_feature_update_callback [btrfs]
[41676.575944]  0000000000000000 ffff8803c5073c60 ffffffff8125d4fd
ffff8803c5073ca8
[41676.578680]  ffff8803c5073c98 ffffffff8105055e ffffffff811d9e55
ffff88037d669000
[41676.580851]  ffffffffa04d504c ffff8803e3e259d8 ffff8800b89841c8
ffff8803c5073d00
[41676.582641] Call Trace:
[41676.583059]  [<ffffffff8125d4fd>] dump_stack+0x4e/0x79
[41676.583814]  [<ffffffff8105055e>] warn_slowpath_common+0x9f/0xb8
[41676.585975]  [<ffffffff811d9e55>] ? sysfs_warn_dup+0x64/0x73
[41676.588266]  [<ffffffff810505bf>] warn_slowpath_fmt+0x48/0x50
[41676.589556]  [<ffffffff811d6ab9>] ? kernfs_path+0x4d/0x58
[41676.590323]  [<ffffffff811d9e55>] sysfs_warn_dup+0x64/0x73
[41676.591103]  [<ffffffff811da4b0>] internal_create_group+0xc7/0x26f
[41676.592134]  [<ffffffff811da66b>] sysfs_create_group+0x13/0x15
[41676.594360]  [<ffffffffa046c79f>]
btrfs_sysfs_feature_update_callback+0x7f/0x8c [btrfs]
[41676.594420] BTRFS info (device sdg): use no compression
[41676.594477] BTRFS info (device sdg): disk space caching is enabled
[41676.599794]  [<ffffffff81066d52>] process_one_work+0x24a/0x4ac
[41676.601319]  [<ffffffff810674b4>] worker_thread+0x206/0x2c2
[41676.602441]  [<ffffffff810672ae>] ? rescuer_thread+0x2cb/0x2cb
[41676.603364]  [<ffffffff8106c24d>] kthread+0xef/0xf7
[41676.605520]  [<ffffffff8106c15e>] ? kthread_parkme+0x24/0x24
[41676.606352]  [<ffffffff8148763f>] ret_from_fork+0x3f/0x70
[41676.607128]  [<ffffffff8106c15e>] ? kthread_parkme+0x24/0x24
[41676.607926] ---[ end trace 60f318fdba512bc7 ]---


>
> ----------------------------8<-------------------------------
> From: David Sterba <dsterba@suse.com>
> Subject: [PATCH] btrfs: sysfs: update features from a workqueue
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/sysfs.c | 37 +++++++++++++++++++++++++++++++------
>  fs/btrfs/sysfs.h |  7 +++++++
>  2 files changed, 38 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 539e7b5e3f86..ced2570fdf6a 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -782,12 +782,7 @@ failure:
>         return error;
>  }
>
> -
> -/*
> - * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
> - * values in superblock. Call after any changes to incompat/compat_ro flags
> - */
> -void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
> +static void btrfs_sysfs_do_feature_update(struct btrfs_fs_info *fs_info,
>                 u64 bit, enum btrfs_feature_set set)
>  {
>         struct btrfs_fs_devices *fs_devs;
> @@ -815,6 +810,36 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
>         ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
>  }
>
> +static void btrfs_sysfs_feature_update_callback(struct work_struct *work)
> +{
> +       struct btrfs_feature_update *bfu = container_of(work,
> +                       struct btrfs_feature_update, work);
> +
> +       btrfs_sysfs_do_feature_update(bfu->fs_info, bfu->bit, bfu->set);
> +       kfree(bfu);
> +}
> +
> +/*
> + * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
> + * values in superblock. Call after any changes to incompat/compat_ro flags
> + */
> +void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
> +               u64 bit, enum btrfs_feature_set set)
> +{
> +       struct btrfs_feature_update *bfu;
> +
> +       bfu = kmalloc(sizeof(*bfu), GFP_NOFS);
> +       if (!bfu)
> +               return;
> +
> +       INIT_WORK(&bfu->work, btrfs_sysfs_feature_update_callback);
> +       bfu->fs_info = fs_info;
> +       bfu->bit = bit;
> +       bfu->set = set;
> +
> +       schedule_work(&bfu->work);
> +}
> +
>  static int btrfs_init_debugfs(void)
>  {
>  #ifdef CONFIG_DEBUG_FS
> diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
> index d7da1a4c2f6c..d9772f2e5c9a 100644
> --- a/fs/btrfs/sysfs.h
> +++ b/fs/btrfs/sysfs.h
> @@ -93,4 +93,11 @@ void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
>  void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
>                 u64 bit, enum btrfs_feature_set set);
>
> +struct btrfs_feature_update {
> +       struct work_struct work;
> +       struct btrfs_fs_info *fs_info;
> +       u64 bit;
> +       enum btrfs_feature_set set;
> +};
> +
>  #endif /* _BTRFS_SYSFS_H_ */
> --
> 1.8.4.5
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
