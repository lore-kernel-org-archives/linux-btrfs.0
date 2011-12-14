From: Samuel Just <sam.just@dreamhost.com>
Subject: Re: btrfs: open_ctree failed
Date: Wed, 14 Dec 2011 14:43:21 -0800
Message-ID: <CACLRD_1-NyKMX_+YB3wpO+CZc1zOoQ7mukYo5ST5FPaXBzRdXA@mail.gmail.com>
References: <4EE6C49A.5070600@genome.wustl.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: ceph-devel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4EE6C49A.5070600@genome.wustl.edu>
List-ID: <linux-btrfs.vger.kernel.org>

Looks like it, cross posting to linux-btrfs.
-Sam

On Mon, Dec 12, 2011 at 7:20 PM, Matt Weil <mweil@genome.wustl.edu> wro=
te:
>
> another butter bug?
>
>> btrfs: open_ctree failed
>> ------------[ cut here ]------------
>> WARNING: at fs/btrfs/inode.c:2194 btrfs_orphan_commit_root+0xb0/0xc0
>> [btrfs]()
>> Hardware name: ProLiant DL380 G5
>> Modules linked in: btrfs zlib_deflate nfsd exportfs autofs4 nfs lock=
d
>> fscache auth_rpcgss nfs_acl sunrpc bonding ipv6 dm_mirror dm_region_=
hash
>> dm_log ipmi_si ipmi_msghandler hpilo pcspkr serio_raw sg iTCO_wdt
>> iTCO_vendor_support i5k_amb i5000_edac edac_core bnx2 shpchp ext4 mb=
cache
>> jbd2 sr_mod cdrom pata_acpi ata_generic ata_piix hpsa cciss radeon t=
tm
>> drm_kms_helper drm hwmon i2c_algo_bit i2c_core dm_mod [last unloaded=
:
>> speedstep_lib]
>> Pid: 42, comm: kworker/4:1 Not tainted 3.0.8 #3
>> Call Trace:
>> =C2=A0[<ffffffff8105ff5f>] warn_slowpath_common+0x7f/0xc0
>> =C2=A0[<ffffffff8105ffba>] warn_slowpath_null+0x1a/0x20
>> =C2=A0[<ffffffffa04c8250>] btrfs_orphan_commit_root+0xb0/0xc0 [btrfs=
]
>> =C2=A0[<ffffffffa04c3845>] commit_fs_roots+0xc5/0x1b0 [btrfs]
>> =C2=A0[<ffffffffa04c48fe>] btrfs_commit_transaction+0x40e/0x850 [btr=
fs]
>> =C2=A0[<ffffffff8104cd80>] ? __dequeue_entity+0x30/0x50
>> =C2=A0[<ffffffff81082670>] ? wake_up_bit+0x40/0x40
>> =C2=A0[<ffffffffa04c5010>] ? btrfs_end_transaction+0x20/0x20 [btrfs]
>> =C2=A0[<ffffffffa04c502f>] do_async_commit+0x1f/0x30 [btrfs]
>> =C2=A0[<ffffffff8107b9d1>] process_one_work+0x131/0x450
>> =C2=A0[<ffffffff8107d57c>] worker_thread+0x17c/0x3c0
>> =C2=A0[<ffffffff8107d400>] ? manage_workers+0x220/0x220
>> =C2=A0[<ffffffff81081ff6>] kthread+0x96/0xa0
>> =C2=A0[<ffffffff814e3f04>] kernel_thread_helper+0x4/0x10
>> =C2=A0[<ffffffff81081f60>] ? kthread_worker_fn+0x1a0/0x1a0
>> =C2=A0[<ffffffff814e3f00>] ? gs_change+0x13/0x13
>> ---[ end trace ed99a1a191db74aa ]---
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
