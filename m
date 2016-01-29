Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205AbcA2Ocp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 09:32:45 -0500
Date: Fri, 29 Jan 2016 15:32:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] btrfs: sysfs: introduce helper for syncing bits with
 sysfs files
Message-ID: <20160129143231.GD31992@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1453400624.git.dsterba@suse.com>
 <444e75169872f668eb890f19ec1f32dfc632e704.1453400624.git.dsterba@suse.com>
 <CAL3q7H5W=Eo64kDY38-sm58ZyHVJ3efNJ3ypJ1w_d8B4nDi-Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5W=Eo64kDY38-sm58ZyHVJ3efNJ3ypJ1w_d8B4nDi-Cg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2016 at 01:55:31PM +0000, Filipe Manana wrote:
> On Thu, Jan 21, 2016 at 6:32 PM, David Sterba <dsterba@suse.com> wrote:
> > The files under /sys/fs/UUID/features get out of sync with the actual
> > incompat bits set for the filesystem if they change after mount. We're
> > going to sync them and need a helper to do that.
> >
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/sysfs.c | 30 ++++++++++++++++++++++++++++++
> >  fs/btrfs/sysfs.h |  3 +++
> >  2 files changed, 33 insertions(+)
> >
> > diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> > index 906f7ed6fc80..6986886243bf 100644
> > --- a/fs/btrfs/sysfs.c
> > +++ b/fs/btrfs/sysfs.c
> > @@ -782,6 +782,36 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
> >         return error;
> >  }
> >
> > +
> > +/*
> > + * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
> > + * values in superblock. Call after any changes to incompat/compat_ro flags
> > + */
> > +void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
> > +               u64 bit, enum btrfs_feature_set set)
> > +{
> > +       struct btrfs_fs_devices *fs_devs;
> > +       struct kobject *fsid_kobj;
> > +       u64 features;
> > +       int ret;
> > +
> > +       if (!fs_info)
> > +               return;
> > +
> > +       features = get_features(fs_info, set);
> > +       ASSERT(bit & supported_feature_masks[set]);
> > +
> > +       fs_devs = fs_info->fs_devices;
> > +       fsid_kobj = &fs_devs->fsid_kobj;
> > +
> > +       /*
> > +        * FIXME: this is too heavy to update just one value, ideally we'd like
> > +        * to use sysfs_update_group but some refactoring is needed first.
> > +        */
> > +       sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
> > +       ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
> 
> 
> Did you try to run all xfstests with this?
> 
> I'm getting very often lots of warnings in btrfs tests 060 to 074:

I did a few rounds. After an overnight test I saw the warning as well,
during test btrfs/063. Running it standalone did not reproduce it
immediatelly, but it triggered while the sysfs files were accessed.

> [16283.551143] WARNING: CPU: 2 PID: 734 at fs/sysfs/group.c:237
> sysfs_remove_group+0x53/0x86()
> [16283.554774] sysfs group ffffffffa03e20e0 not found for kobject
> 'f849fa25-50d1-491b-a7eb-aea06667b62b'
> [16283.556232] Modules linked in: btrfs dm_flakey dm_mod ppdev
> sha256_generic hmac xor drbg ansi_cprng aesni_intel raid6_pq
> aes_x86_64 ablk_helper cryptd lrw gf128mul acpi_cpufreq glue_helper
> parport_pc sg evdev tpm_tis parport i2c_piix4 tpm psmouse i2c_core
> pcspkr processor serio_raw button loop autofs4 ext4 crc16 mbcache jbd2
> sd_mod sr_mod cdrom ata_generic virtio_scsi ata_piix virtio_pci libata
> virtio_ring virtio e1000 crc32c_intel scsi_mod floppy [last unloaded:
> btrfs]
> [16283.563564] CPU: 2 PID: 734 Comm: btrfs Tainted: G        W
> 4.4.0-rc6-btrfs-next-18+ #1
> [16283.564994] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS by qemu-project.org 04/01/2014
> [16283.566609]  0000000000000000 ffff8803178df9d0 ffffffff8125d4fd
> ffff8803178dfa18
> [16283.567832]  ffff8803178dfa08 ffffffff8105055e ffffffff811da7ee
> 0000000000000000
> [16283.569315]  ffffffffa03e20e0 ffff8803dcd4af28 ffff88018c6bc220
> ffff8803178dfa70
> [16283.571227] Call Trace:
> [16283.571663]  [<ffffffff8125d4fd>] dump_stack+0x4e/0x79
> [16283.572549]  [<ffffffff8105055e>] warn_slowpath_common+0x9f/0xb8
> [16283.573501]  [<ffffffff811da7ee>] ? sysfs_remove_group+0x53/0x86
> [16283.574420]  [<ffffffff810505bf>] warn_slowpath_fmt+0x48/0x50
> [16283.575272]  [<ffffffff81485330>] ? mutex_unlock+0xe/0x10
> [16283.576122]  [<ffffffff811da7ee>] sysfs_remove_group+0x53/0x86
> [16283.577124]  [<ffffffffa037ff55>]
> btrfs_sysfs_feature_update+0x62/0x74 [btrfs]
> [16283.578292]  [<ffffffffa038d4d3>] __btrfs_alloc_chunk+0x6ed/0x7be [btrfs]
> [16283.579458]  [<ffffffffa038fef6>] btrfs_alloc_chunk+0x50/0x56 [btrfs]
> [16283.580502]  [<ffffffffa0358f86>] do_chunk_alloc+0x1e9/0x279 [btrfs]
> [16283.581584]  [<ffffffffa035bb81>] btrfs_force_chunk_alloc+0x30/0x35 [btrfs]
> [16283.582589]  [<ffffffffa038f885>] btrfs_balance+0xda1/0xe4a [btrfs]
> [16283.583502]  [<ffffffff81276712>] ? debug_smp_processor_id+0x17/0x19
> [16283.584499]  [<ffffffffa03992b4>] btrfs_ioctl_balance+0x255/0x2d3 [btrfs]
> [16283.585624]  [<ffffffffa039c349>] btrfs_ioctl+0x136d/0x27a9 [btrfs]
> [16283.586536]  [<ffffffff8108a8b0>] ? arch_local_irq_save+0x9/0xc
> [16283.587398]  [<ffffffff81276727>] ? __this_cpu_preempt_check+0x13/0x15
> [16283.588423]  [<ffffffff81143aea>] ? handle_mm_fault+0x44f/0xd40
> [16283.589587]  [<ffffffff81486ab7>] ? _raw_spin_unlock+0x31/0x44
> [16283.590428]  [<ffffffff8108a8b0>] ? arch_local_irq_save+0x9/0xc
> [16283.591282]  [<ffffffff811822f8>] do_vfs_ioctl+0x42b/0x4ea
> [16283.592122]  [<ffffffff810fc6b0>] ? time_hardirqs_on+0x15/0x28
> [16283.593247]  [<ffffffff81001017>] ? trace_hardirqs_on_thunk+0x17/0x19
> [16283.594177]  [<ffffffff8118b4de>] ? __fget_light+0x4d/0x71
> [16283.603702]  [<ffffffff8118240e>] SyS_ioctl+0x57/0x79
> [16283.604649]  [<ffffffff814872d7>] entry_SYSCALL_64_fastpath+0x12/0x6f
> [16283.605670] ---[ end trace 60f318fdba512bac ]---
> [16283.606384] ------------[ cut here ]------------
> [16283.607082] WARNING: CPU: 2 PID: 734 at fs/sysfs/dir.c:31
> sysfs_warn_dup+0x64/0x73()
> [16283.608305] sysfs: cannot create duplicate filename
> '/fs/btrfs/f849fa25-50d1-491b-a7eb-aea06667b62b/features'
> [16283.609835] Modules linked in: btrfs dm_flakey dm_mod ppdev
> sha256_generic hmac xor drbg ansi_cprng aesni_intel raid6_pq
> aes_x86_64 ablk_helper cryptd lrw gf128mul acpi_cpufreq glue_helper
> parport_pc sg evdev tpm_tis parport i2c_piix4 tpm psmouse i2c_core
> pcspkr processor serio_raw button loop autofs4 ext4 crc16 mbcache jbd2
> sd_mod sr_mod cdrom ata_generic virtio_scsi ata_piix virtio_pci libata
> virtio_ring virtio e1000 crc32c_intel scsi_mod floppy [last unloaded:
> btrfs]
> [16283.616694] CPU: 2 PID: 734 Comm: btrfs Tainted: G        W
> 4.4.0-rc6-btrfs-next-18+ #1
> [16283.617974] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS by qemu-project.org 04/01/2014
> [16283.619343]  0000000000000000 ffff8803178df978 ffffffff8125d4fd
> ffff8803178df9c0
> [16283.620627]  ffff8803178df9b0 ffffffff8105055e ffffffff811d9e55
> ffff8802f6c4f000
> [16283.621838]  ffffffffa03e7fd5 ffff88040246df58 ffff88018c6bc220
> ffff8803178dfa18
> [16283.623040] Call Trace:
> [16283.623459]  [<ffffffff8125d4fd>] dump_stack+0x4e/0x79
> [16283.624257]  [<ffffffff8105055e>] warn_slowpath_common+0x9f/0xb8
> [16283.625366]  [<ffffffff811d9e55>] ? sysfs_warn_dup+0x64/0x73
> [16283.626202]  [<ffffffff810505bf>] warn_slowpath_fmt+0x48/0x50
> [16283.627045]  [<ffffffff811d6ab9>] ? kernfs_path+0x4d/0x58
> [16283.627844]  [<ffffffff811d9e55>] sysfs_warn_dup+0x64/0x73
> [16283.628701]  [<ffffffff811da4b0>] internal_create_group+0xc7/0x26f
> [16283.629924]  [<ffffffff811da66b>] sysfs_create_group+0x13/0x15
> [16283.631466]  [<ffffffffa037ff64>]
> btrfs_sysfs_feature_update+0x71/0x74 [btrfs]
> [16283.632659]  [<ffffffffa038d4d3>] __btrfs_alloc_chunk+0x6ed/0x7be [btrfs]
> [16283.633763]  [<ffffffffa038fef6>] btrfs_alloc_chunk+0x50/0x56 [btrfs]
> [16283.634710]  [<ffffffffa0358f86>] do_chunk_alloc+0x1e9/0x279 [btrfs]
> [16283.635644]  [<ffffffffa035bb81>] btrfs_force_chunk_alloc+0x30/0x35 [btrfs]
> [16283.636704]  [<ffffffffa038f885>] btrfs_balance+0xda1/0xe4a [btrfs]
> [16283.637766]  [<ffffffff81276712>] ? debug_smp_processor_id+0x17/0x19
> [16283.638697]  [<ffffffffa03992b4>] btrfs_ioctl_balance+0x255/0x2d3 [btrfs]
> [16283.639675]  [<ffffffffa039c349>] btrfs_ioctl+0x136d/0x27a9 [btrfs]
> [16283.640801]  [<ffffffff8108a8b0>] ? arch_local_irq_save+0x9/0xc
> [16283.642074]  [<ffffffff81276727>] ? __this_cpu_preempt_check+0x13/0x15
> [16283.643015]  [<ffffffff81143aea>] ? handle_mm_fault+0x44f/0xd40
> [16283.643879]  [<ffffffff81486ab7>] ? _raw_spin_unlock+0x31/0x44
> [16283.644819]  [<ffffffff8108a8b0>] ? arch_local_irq_save+0x9/0xc
> [16283.645981]  [<ffffffff811822f8>] do_vfs_ioctl+0x42b/0x4ea
> [16283.646799]  [<ffffffff810fc6b0>] ? time_hardirqs_on+0x15/0x28
> [16283.647660]  [<ffffffff81001017>] ? trace_hardirqs_on_thunk+0x17/0x19
> [16283.648643]  [<ffffffff8118b4de>] ? __fget_light+0x4d/0x71
> [16283.649601]  [<ffffffff8118240e>] SyS_ioctl+0x57/0x79
> (...)
> 
> I'm getting really many of these, about 10+ per test when it happens
> (which makes the tests fail).

Sorry about that, I hoped I could get away with minimum of new sysfs
code to cover the missing feature bits. I'll get to fix it.
