Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:36822 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754628AbdBVWBn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 17:01:43 -0500
Received: by mail-lf0-f48.google.com with SMTP id b80so8222121lfe.3
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 14:00:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKinxcUK5ESRJx1gm7m5HHvY_rUmq=-FVdva2-xLkkfw5jBc3A@mail.gmail.com>
References: <CAKinxcUt24bFWUAVesbLpZDifa3gxVTvKVbk9TAvHRWedkjLAg@mail.gmail.com>
 <6ea3b9a2-7e4c-f933-bf04-b24b1a62e996@cn.fujitsu.com> <CAKinxcXzf1p+PaTay+YsE87=BxDz_oNovudZAKJwb9keVVbZaw@mail.gmail.com>
 <CAKinxcXSox=y1WYK4TnyySaScKdGokGBtJu-Sa6V0RuU7ScsDg@mail.gmail.com>
 <4239f21c-5e37-eead-a83d-8027b277401d@cn.fujitsu.com> <CAKinxcXpE5RC4wyekwDA7vH5mFCtYdW2vOrg9RkVzUoz4wFrNg@mail.gmail.com>
 <415FDA88-FE72-48BE-8A1E-49A53224EF96@gmail.com> <90341500-c50f-1bdd-0bbd-b75ec95cdead@cn.fujitsu.com>
 <CAKinxcVzpcbR1=yeB4+tKjvKWucTifsPpDZB1BwHKqyphY3_3A@mail.gmail.com>
 <CAKinxcXVnE-G7AoKLLCu_rt_bkZkLG3oSW-ji7bjmyUbZ88BpA@mail.gmail.com> <CAKinxcUK5ESRJx1gm7m5HHvY_rUmq=-FVdva2-xLkkfw5jBc3A@mail.gmail.com>
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Wed, 22 Feb 2017 21:53:18 +0000
Message-ID: <CAKinxcXH1YsJwqY9=ec18UZ1L6YEw0NkGTqWoe+Yx8=1AAjMsw@mail.gmail.com>
Subject: Re: FS gives kernel UPS on attempt to create snapshot and after
 running balance it's unmountable.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when looking through log for old messages I can see that there are
kernel problems before with extent tree while trying to create
snapshots:


Jan 23 05:00:02 server kernel: #011#011tree block backref root 7
Jan 23 05:00:02 server kernel: #011item 108 key (12288467451904 169 0)
itemoff 12677 itemsize 33
Jan 23 05:00:02 server kernel: #011#011extent refs 1 gen 144462 flags 2
Jan 23 05:00:02 server kernel: #011#011tree block backref root 7
Jan 23 05:00:02 server kernel: #011item 109 key (12288467468288 169 0)
itemoff 12644 itemsize 33
Jan 23 05:00:02 server kernel: #011#011extent refs 1 gen 144462 flags 2
Jan 23 05:00:02 server kernel: #011#011tree block backref root 7
Jan 23 05:00:02 server kernel: #011item 110 key (12288467484672 169 0)
itemoff 12611 itemsize 33
Jan 23 05:00:02 server kernel: #011#011extent refs 1 gen 144462 flags 2
Jan 23 05:00:02 server kernel: #011#011tree block backref root 7
Jan 23 05:00:02 server kernel: #011item 111 key (12288467501056 169 0)
itemoff 12578 itemsize 33
Jan 23 05:00:02 server kernel: #011#011extent refs 1 gen 144462 flags 2
Jan 23 05:00:02 server kernel: #011#011tree block backref root 7
Jan 23 05:00:02 server kernel: #011item 112 key (12288467533824 169 0)
itemoff 12545 itemsize 33
Jan 23 05:00:02 server kernel: #011#011extent refs 1 gen 144462 flags 2
Jan 23 05:00:02 server kernel: #011#011tree block backref root 7
Jan 23 05:00:02 server kernel: BTRFS error (device sdc): unable to
find ref byte nr 12288404504576 parent 0 root 258  owner 2 offset 0
Jan 23 05:00:02 server kernel: ------------[ cut here ]------------
Jan 23 05:00:02 server kernel: WARNING: CPU: 8 PID: 28064 at
fs/btrfs/extent-tree.c:6951 __btrfs_free_extent.isra.69+0xbca/0xca0
[btrfs]
Jan 23 05:00:02 server kernel: Modules linked in: xt_nat veth
xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype
iptable_filter nf_nat nf_conntrack ipmi_devintf ext4 jbd2 mbcache
iTCO_wdt gpio_ich iTCO_vendor_support coretemp kvm_intel kvm irqbypass
intel_cstate input_leds pcspkr hpilo hpwdt lpc_ich mfd_core ioatdma
i7core_edac edac_core ses enclosure ipmi_si ipmi_msghandler sg
acpi_power_meter pcc_cpufreq shpchp acpi_cpufreq nfsd auth_rpcgss
nfs_acl lockd grace sunrpc ip_tables btrfs xor raid6_pq sd_mod amdkfd
amd_iommu_v2 radeon crc32c_intel drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops ttm serio_raw drm ahci libahci
libata fjes mpt3sas raid_class scsi_transport_sas igb ptp pps_core dca
i2c_algo_bit
Jan 23 05:00:02 server kernel: CPU: 8 PID: 28064 Comm: btrfs Tainted:
G        W I     4.8.7-1.el7.elrepo.x86_64 #1
Jan 23 05:00:02 server kernel: Hardware name: HP ProLiant SE326M1   ,
BIOS R02 12/07/2010
Jan 23 05:00:02 server kernel: 0000000000000286 0000000077bb5259
ffff8802bbf1f778 ffffffff8135406c
Jan 23 05:00:02 server kernel: ffff8802bbf1f7c8 0000000000000000
ffff8802bbf1f7b8 ffffffff810817b1
Jan 23 05:00:02 server kernel: 00001b2700000002 ffff8806f6120000
00000b2d1dfc4000 00000000fffffffe
Jan 23 05:00:02 server kernel: Call Trace:
Jan 23 05:00:02 server kernel: [<ffffffff8135406c>] dump_stack+0x63/0x87
Jan 23 05:00:02 server kernel: [<ffffffff810817b1>] __warn+0xd1/0xf0
Jan 23 05:00:02 server kernel: [<ffffffff8108182f>] warn_slowpath_fmt+0x5f/0x80
Jan 23 05:00:02 server kernel: [<ffffffffa045878a>]
__btrfs_free_extent.isra.69+0xbca/0xca0 [btrfs]
Jan 23 05:00:02 server kernel: [<ffffffffa045cd61>]
__btrfs_run_delayed_refs.constprop.78+0xa11/0x1250 [btrfs]
Jan 23 05:00:02 server kernel: [<ffffffffa046046e>]
btrfs_run_delayed_refs+0x8e/0x2c0 [btrfs]
Jan 23 05:00:02 server kernel: [<ffffffffa04769ed>]
create_pending_snapshot.isra.26+0x5cd/0xdd0 [btrfs]
Jan 23 05:00:02 server kernel: [<ffffffffa0477268>]
create_pending_snapshots+0x78/0xa0 [btrfs]
Jan 23 05:00:02 server kernel: [<ffffffffa0477935>]
btrfs_commit_transaction+0x435/0xa70 [btrfs]
Jan 23 05:00:02 server kernel: [<ffffffffa04b02d3>]
btrfs_mksubvol.isra.39+0x513/0x520 [btrfs]
Jan 23 05:00:02 server kernel: [<ffffffff810c6610>] ?
prepare_to_wait_event+0xf0/0xf0
Jan 23 05:00:02 server kernel: [<ffffffffa04b046f>]
btrfs_ioctl_snap_create_transid+0x18f/0x1a0 [btrfs]
Jan 23 05:00:02 server kernel: [<ffffffffa04b0635>]
btrfs_ioctl_snap_create_v2+0x125/0x180 [btrfs]
Jan 23 05:00:02 server kernel: [<ffffffffa04b4833>]
btrfs_ioctl+0x6b3/0x21e0 [btrfs]
Jan 23 05:00:02 server kernel: [<ffffffff8120d8d5>] ?
mem_cgroup_commit_charge+0x85/0x100
Jan 23 05:00:02 server kernel: [<ffffffff811d17d9>] ?
page_add_new_anon_rmap+0x89/0xc0
Jan 23 05:00:02 server kernel: [<ffffffff8119f5d5>] ?
lru_cache_add_active_or_unevictable+0x35/0xb0
Jan 23 05:00:02 server kernel: [<ffffffff811c6c60>] ?
handle_mm_fault+0xed0/0x1240
Jan 23 05:00:02 server kernel: [<ffffffff8122ffc7>] do_vfs_ioctl+0xa7/0x5f0
Jan 23 05:00:02 server kernel: [<ffffffff8112d3ff>] ?
__audit_syscall_entry+0xaf/0x100
Jan 23 05:00:02 server kernel: [<ffffffff8100365d>] ?
syscall_trace_enter+0x1dd/0x2c0
Jan 23 05:00:02 server kernel: [<ffffffff81230589>] SyS_ioctl+0x79/0x90
Jan 23 05:00:02 server kernel: [<ffffffff81003a47>] do_syscall_64+0x67/0x160
Jan 23 05:00:02 server kernel: [<ffffffff8173bbe1>]
entry_SYSCALL64_slow_path+0x25/0x25
Jan 23 05:00:02 server kernel: ---[ end trace eb863872ca3491b1 ]---
Jan 23 05:00:02 server kernel: BTRFS: error (device sdc) in
__btrfs_free_extent:6951: errno=-2 No such entry
Jan 23 05:00:02 server kernel: BTRFS info (device sdc): forced readonly
Jan 23 05:00:02 server kernel: BTRFS: error (device sdc) in
btrfs_run_delayed_refs:2960: errno=-2 No such entry
Jan 23 05:00:02 server kernel: BTRFS: error (device sdc) in
create_pending_snapshot:1604: errno=-2 No such entry
Jan 23 05:00:02 server kernel: BTRFS warning (device sdc): Skipping
commit of aborted transaction.
Jan 23 05:00:02 server kernel: BTRFS: error (device sdc) in
cleanup_transaction:1854: errno=-2 No such entry

On 21 February 2017 at 22:18, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
> Anyone ?
>
> On 18 Feb 2017, at 16:44, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
>
> So Qu,
>
> currently my situation is that:
> I've tried to go btrfs scan --repair, and it did relair some stuff is
> qgroup's ... then tried to mont it and, surprise surpeire system
> locked out in 20 seconds.
>
> Reboot, again scan --repair = a lot of missing back pointers were
> repaired and system is supposedly "OK" .... attempted to mount it and
> within 20 seconds system locked out so hard it wold no even reboot
> from acpi.
>
> installed "ellrepo kernel-lm" and installed 4.9.10
>
> another scan --repair = same problem with lot's of back pointer
> missing, fixed .... system again seems "OK" ... another attempt to
> mount /dev/sdc /mnt2/main_pool and again after 20 seconds system locks
> up hard.
>
> There is nothing in messages, nothing in dmesg ... I think that system
> lock up so hard that master btrfs filesystem does not get time those
> logs pushed to disk.
>
>
>
>
>
>
> On 16 February 2017 at 23:46, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
>
> Thanks Qu,
>
> Just before I’ll go and accidentally mess up this FS more - I’ve
> mentioned originally that this problem started with FS not being able
> to create a snapshot ( it would get remounted RO automatically ) for
> about a month, and when I’ve realised that there is a problem like
> that I’ve attempted a full FS balance that caused this FS to be
> unmountable. Is there any other debug you would require before I
> proceed (I’ve got a lot i
>
> On 16 Feb 2017, at 01:26, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
>
> At 02/15/2017 10:11 PM, Tomasz Kusmierz wrote:
>
> So guys, any help here ? I’m kinda stuck now with system just idling
> and doing nothing while I wait for some feedback ...
>
>
> Sorry for the late reply.
>
> Busying debugging a kernel bug.
>
> On 14 Feb 2017, at 19:38, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
>
> [root@server ~]#  btrfs-show-super -af /dev/sdc
> superblock: bytenr=65536, device=/dev/sdc
> ---------------------------------------------------------
> csum_type               0 (crc32c)
> csum_size               4
> csum                    0x17d56ce0 [match]
>
>
> This superblock is good.
>
> bytenr                  65536
> flags                   0x1
>                      ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    0576d577-8954-4a60-a02b-9492b3c29318
> label                   main_pool
> generation              150682
> root                    5223857717248
> sys_array_size          321
> chunk_root_generation   150678
> root_level              1
> chunk_root              8669488005120
> chunk_root_level        1
> log_root                0
> log_root_transid        0
> log_root_level          0
> total_bytes             16003191472128
> bytes_used              6411278503936
> sectorsize              4096
> nodesize                16384
> leafsize                16384
> stripesize              4096
> root_dir                6
> num_devices             8
> compat_flags            0x0
> compat_ro_flags         0x0
> incompat_flags          0x161
>                      ( MIXED_BACKREF |
>                        BIG_METADATA |
>                        EXTENDED_IREF |
>                        SKINNY_METADATA )
> cache_generation        150682
> uuid_tree_generation    150679
> dev_item.uuid           46abffa8-7afe-451f-93c6-abb8e589c4e8
> dev_item.fsid           0576d577-8954-4a60-a02b-9492b3c29318 [match]
> dev_item.type           0
> dev_item.total_bytes    2000398934016
> dev_item.bytes_used     1647136735232
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
> sys_chunk_array[2048]:
>      item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 8669487824896)
>              length 67108864 owner 2 stripe_len 65536 type SYSTEM|RAID10
>              io_align 65536 io_width 65536 sector_size 4096
>              num_stripes 8 sub_stripes 2
>                      stripe 0 devid 7 offset 1083674984448
>                      dev_uuid 566fb8a3-d6de-4230-8b70-a5fda0a120f6
>                      stripe 1 devid 8 offset 1083674984448
>                      dev_uuid 845aefb2-e0a6-479a-957b-a82fb7207d6c
>                      stripe 2 devid 1 offset 1365901312
>                      dev_uuid 46abffa8-7afe-451f-93c6-abb8e589c4e8
>                      stripe 3 devid 3 offset 1345978368
>                      dev_uuid 95921633-2fc1-479f-a3ba-e6e5a1989755
>                      stripe 4 devid 4 offset 1345978368
>                      dev_uuid 20828f0e-4661-4987-ac11-72814c1e423a
>                      stripe 5 devid 5 offset 1345978368
>                      dev_uuid 2c3cd71f-5178-48e7-8032-6b6eec023197
>                      stripe 6 devid 6 offset 1345978368
>                      dev_uuid 806a47e5-cac4-41c9-abb9-5c49506459e1
>                      stripe 7 devid 2 offset 1345978368
>                      dev_uuid e1358e0e-edaf-4505-9c71-ed0862c45841
>
>
> And I didn't see anything wrong in sys_chunk_array.
>
>
> Would you please try to mount the fs with latest kernel?
> Better later than v4.9, as in that version extra kernel messages are
> introduced to give more details about what's going wrong.
>
> Thanks,
> Qu
>
> backup_roots[4]:
>      backup 0:
>              backup_tree_root:       5223857717248   gen: 150680     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     5223867383808   gen: 150680     level: 2
>              backup_fs_root:         0       gen: 0  level: 0
>              backup_dev_root:        5224791523328   gen: 150680     level: 1
>              backup_csum_root:       5224802140160   gen: 150680     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>      backup 1:
>              backup_tree_root:       5224155807744   gen: 150681     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     5224156233728   gen: 150681     level: 2
>              backup_fs_root:         0       gen: 0  level: 0
>              backup_dev_root:        5224633155584   gen: 150681     level: 1
>              backup_csum_root:       5224634941440   gen: 150681     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>      backup 2:
>              backup_tree_root:       5223857717248   gen: 150682     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     5223867383808   gen: 150682     level: 2
>              backup_fs_root:         0       gen: 0  level: 0
>              backup_dev_root:        5224622358528   gen: 150682     level: 1
>              backup_csum_root:       5224675344384   gen: 150682     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>      backup 3:
>              backup_tree_root:       11179477942272  gen: 150679     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     11179488018432  gen: 150679     level: 2
>              backup_fs_root:         6217817456640   gen: 150497     level: 0
>              backup_dev_root:        5224337244160   gen: 150679     level: 1
>              backup_csum_root:       11179492540416  gen: 150679     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>
> superblock: bytenr=67108864, device=/dev/sdc
> ---------------------------------------------------------
> csum_type               0 (crc32c)
> csum_size               4
> csum                    0xb7b4442e [match]
> bytenr                  67108864
> flags                   0x1
>                      ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    0576d577-8954-4a60-a02b-9492b3c29318
> label                   main_pool
> generation              150682
> root                    5223857717248
> sys_array_size          321
> chunk_root_generation   150678
> root_level              1
> chunk_root              8669488005120
> chunk_root_level        1
> log_root                0
> log_root_transid        0
> log_root_level          0
> total_bytes             16003191472128
> bytes_used              6411278503936
> sectorsize              4096
> nodesize                16384
> leafsize                16384
> stripesize              4096
> root_dir                6
> num_devices             8
> compat_flags            0x0
> compat_ro_flags         0x0
> incompat_flags          0x161
>                      ( MIXED_BACKREF |
>                        BIG_METADATA |
>                        EXTENDED_IREF |
>                        SKINNY_METADATA )
> cache_generation        150682
> uuid_tree_generation    150679
> dev_item.uuid           46abffa8-7afe-451f-93c6-abb8e589c4e8
> dev_item.fsid           0576d577-8954-4a60-a02b-9492b3c29318 [match]
> dev_item.type           0
> dev_item.total_bytes    2000398934016
> dev_item.bytes_used     1647136735232
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
> sys_chunk_array[2048]:
>      item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 8669487824896)
>              length 67108864 owner 2 stripe_len 65536 type SYSTEM|RAID10
>              io_align 65536 io_width 65536 sector_size 4096
>              num_stripes 8 sub_stripes 2
>                      stripe 0 devid 7 offset 1083674984448
>                      dev_uuid 566fb8a3-d6de-4230-8b70-a5fda0a120f6
>                      stripe 1 devid 8 offset 1083674984448
>                      dev_uuid 845aefb2-e0a6-479a-957b-a82fb7207d6c
>                      stripe 2 devid 1 offset 1365901312
>                      dev_uuid 46abffa8-7afe-451f-93c6-abb8e589c4e8
>                      stripe 3 devid 3 offset 1345978368
>                      dev_uuid 95921633-2fc1-479f-a3ba-e6e5a1989755
>                      stripe 4 devid 4 offset 1345978368
>                      dev_uuid 20828f0e-4661-4987-ac11-72814c1e423a
>                      stripe 5 devid 5 offset 1345978368
>                      dev_uuid 2c3cd71f-5178-48e7-8032-6b6eec023197
>                      stripe 6 devid 6 offset 1345978368
>                      dev_uuid 806a47e5-cac4-41c9-abb9-5c49506459e1
>                      stripe 7 devid 2 offset 1345978368
>                      dev_uuid e1358e0e-edaf-4505-9c71-ed0862c45841
> backup_roots[4]:
>      backup 0:
>              backup_tree_root:       5223857717248   gen: 150680     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     5223867383808   gen: 150680     level: 2
>              backup_fs_root:         0       gen: 0  level: 0
>              backup_dev_root:        5224791523328   gen: 150680     level: 1
>              backup_csum_root:       5224802140160   gen: 150680     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>      backup 1:
>              backup_tree_root:       5224155807744   gen: 150681     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     5224156233728   gen: 150681     level: 2
>              backup_fs_root:         0       gen: 0  level: 0
>              backup_dev_root:        5224633155584   gen: 150681     level: 1
>              backup_csum_root:       5224634941440   gen: 150681     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>      backup 2:
>              backup_tree_root:       5223857717248   gen: 150682     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     5223867383808   gen: 150682     level: 2
>              backup_fs_root:         0       gen: 0  level: 0
>              backup_dev_root:        5224622358528   gen: 150682     level: 1
>              backup_csum_root:       5224675344384   gen: 150682     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>      backup 3:
>              backup_tree_root:       11179477942272  gen: 150679     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     11179488018432  gen: 150679     level: 2
>              backup_fs_root:         6217817456640   gen: 150497     level: 0
>              backup_dev_root:        5224337244160   gen: 150679     level: 1
>              backup_csum_root:       11179492540416  gen: 150679     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>
> superblock: bytenr=274877906944, device=/dev/sdc
> ---------------------------------------------------------
> csum_type               0 (crc32c)
> csum_size               4
> csum                    0x4a33121f [match]
> bytenr                  274877906944
> flags                   0x1
>                      ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    0576d577-8954-4a60-a02b-9492b3c29318
> label                   main_pool
> generation              150682
> root                    5223857717248
> sys_array_size          321
> chunk_root_generation   150678
> root_level              1
> chunk_root              8669488005120
> chunk_root_level        1
> log_root                0
> log_root_transid        0
> log_root_level          0
> total_bytes             16003191472128
> bytes_used              6411278503936
> sectorsize              4096
> nodesize                16384
> leafsize                16384
> stripesize              4096
> root_dir                6
> num_devices             8
> compat_flags            0x0
> compat_ro_flags         0x0
> incompat_flags          0x161
>                      ( MIXED_BACKREF |
>                        BIG_METADATA |
>                        EXTENDED_IREF |
>                        SKINNY_METADATA )
> cache_generation        150682
> uuid_tree_generation    150679
> dev_item.uuid           46abffa8-7afe-451f-93c6-abb8e589c4e8
> dev_item.fsid           0576d577-8954-4a60-a02b-9492b3c29318 [match]
> dev_item.type           0
> dev_item.total_bytes    2000398934016
> dev_item.bytes_used     1647136735232
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
> sys_chunk_array[2048]:
>      item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 8669487824896)
>              length 67108864 owner 2 stripe_len 65536 type SYSTEM|RAID10
>              io_align 65536 io_width 65536 sector_size 4096
>              num_stripes 8 sub_stripes 2
>                      stripe 0 devid 7 offset 1083674984448
>                      dev_uuid 566fb8a3-d6de-4230-8b70-a5fda0a120f6
>                      stripe 1 devid 8 offset 1083674984448
>                      dev_uuid 845aefb2-e0a6-479a-957b-a82fb7207d6c
>                      stripe 2 devid 1 offset 1365901312
>                      dev_uuid 46abffa8-7afe-451f-93c6-abb8e589c4e8
>                      stripe 3 devid 3 offset 1345978368
>                      dev_uuid 95921633-2fc1-479f-a3ba-e6e5a1989755
>                      stripe 4 devid 4 offset 1345978368
>                      dev_uuid 20828f0e-4661-4987-ac11-72814c1e423a
>                      stripe 5 devid 5 offset 1345978368
>                      dev_uuid 2c3cd71f-5178-48e7-8032-6b6eec023197
>                      stripe 6 devid 6 offset 1345978368
>                      dev_uuid 806a47e5-cac4-41c9-abb9-5c49506459e1
>                      stripe 7 devid 2 offset 1345978368
>                      dev_uuid e1358e0e-edaf-4505-9c71-ed0862c45841
> backup_roots[4]:
>      backup 0:
>              backup_tree_root:       5223857717248   gen: 150680     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     5223867383808   gen: 150680     level: 2
>              backup_fs_root:         0       gen: 0  level: 0
>              backup_dev_root:        5224791523328   gen: 150680     level: 1
>              backup_csum_root:       5224802140160   gen: 150680     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>      backup 1:
>              backup_tree_root:       5224155807744   gen: 150681     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     5224156233728   gen: 150681     level: 2
>              backup_fs_root:         0       gen: 0  level: 0
>              backup_dev_root:        5224633155584   gen: 150681     level: 1
>              backup_csum_root:       5224634941440   gen: 150681     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>      backup 2:
>              backup_tree_root:       5223857717248   gen: 150682     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     5223867383808   gen: 150682     level: 2
>              backup_fs_root:         0       gen: 0  level: 0
>              backup_dev_root:        5224622358528   gen: 150682     level: 1
>              backup_csum_root:       5224675344384   gen: 150682     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>      backup 3:
>              backup_tree_root:       11179477942272  gen: 150679     level: 1
>              backup_chunk_root:      8669488005120   gen: 150678     level: 1
>              backup_extent_root:     11179488018432  gen: 150679     level: 2
>              backup_fs_root:         6217817456640   gen: 150497     level: 0
>              backup_dev_root:        5224337244160   gen: 150679     level: 1
>              backup_csum_root:       11179492540416  gen: 150679     level: 3
>              backup_total_bytes:     16003191472128
>              backup_bytes_used:      6411278503936
>              backup_num_devices:     8
>
>
>
> On 14 February 2017 at 00:25, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
>
> At 02/14/2017 08:23 AM, Tomasz Kusmierz wrote:
>
>
> Forgot to mention:
>
> btrfs inspect-internal dump-super -af /dev/sdc
>
>
>
> Your btrfs-progs is somewhat old, which doesn't integrate dump super into
> inspect-internal.
>
> In that case, you can use btrfs-show-super -af instead.
>
> Thanks,
> Qu
>
>
> btrfs inspect-internal: unknown token 'dump-super'
> usage: btrfs inspect-internal <command> <args>
>
>  btrfs inspect-internal inode-resolve [-v] <inode> <path>
>      Get file system paths for the given inode
>  btrfs inspect-internal logical-resolve [-Pv] [-s bufsize] <logical>
> <path>
>      Get file system paths for the given logical address
>  btrfs inspect-internal subvolid-resolve <subvolid> <path>
>      Get file system paths for the given subvolume ID.
>  btrfs inspect-internal rootid <path>
>      Get tree ID of the containing subvolume of path.
>  btrfs inspect-internal min-dev-size [options] <path>
>      Get the minimum size the device can be shrunk to. The
>
> query various internal information
>
> On 13 February 2017 at 14:58, Tomasz Kusmierz <tom.kusmierz@gmail.com>
> wrote:
>
>
> Problem is to send a larger log into this mailing list :/
>
> Anyway: uname -a
> Linux tevva-server 4.8.7-1.el7.elrepo.x86_64 #1 SMP Thu Nov 10
> 20:47:24 EST 2016 x86_64 x86_64 x86_64 GNU/Linux
>
>
> cut from messages (bear in mind that this is a single cut with a bit
> cut from inside of it to fit it in the email)
>
> Feb 10 00:17:14 server journal: ==>
> /var/log/gitlab/gitlab-shell/gitlab-shell.log <==
> Feb 10 00:17:30 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:17:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:18:00 server kernel: BTRFS info (device sdc): found 22 extents
> Feb 10 00:18:01 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:17:59 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:18:05 server kernel: BTRFS info (device sdc): found 22 extents
> Feb 10 00:18:06 server kernel: BTRFS info (device sdc): relocating
> block group 12353563131904 flags 65
> Feb 10 00:18:06 server journal:
> Feb 10 00:18:06 server journal: ==> /var/log/gitlab/sidekiq/current <==
> Feb 10 00:18:06 server journal: 2017-02-10_00:18:06.99341
> 2017-02-10T00:18:06.993Z 382 TID-otrr6ws48 PruneOldEventsWorker
> JID-99d3a4fb69be748c8674b5e1 INFO: start
> Feb 10 00:18:06 server journal: 2017-02-10_00:18:06.99571
> 2017-02-10T00:18:06.995Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:18:07 server journal: 2017-02-10_00:18:07.00454
> 2017-02-10T00:18:07.004Z 382 TID-otrr6ws48 PruneOldEventsWorker
> JID-99d3a4fb69be748c8674b5e1 INFO: done: 0.011 sec
> Feb 10 00:18:30 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:18:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:18:43 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:18:48 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:18:49 server kernel: BTRFS info (device sdc): relocating
> block group 12349268164608 flags 65
> Feb 10 00:19:01 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:19:00 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:19:02 server journal: 2017-02-10_00:19:02.51409
> 2017-02-10T00:19:02.513Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:19:02 server journal: 2017-02-10_00:19:02.51449
> 2017-02-10T00:19:02.514Z 382 TID-otrspth10 PruneOldEventsWorker
> JID-4a162ace334771baf4befbb7 INFO: start
> Feb 10 00:19:02 server journal: 2017-02-10_00:19:02.52994
> 2017-02-10T00:19:02.529Z 382 TID-otrspth10 PruneOldEventsWorker
> JID-4a162ace334771baf4befbb7 INFO: done: 0.015 sec
> Feb 10 00:19:26 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:19:31 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:19:31 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:19:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:19:32 server kernel: BTRFS info (device sdc): relocating
> block group 12344973197312 flags 65
> Feb 10 00:19:51 server kernel: perf: interrupt took too long (2513 >
> 2500), lowering kernel.perf_event_max_sample_rate to 79000
> Feb 10 00:20:00 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:19:59 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:20:10 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:20:10 server journal: 2017-02-10_00:20:10.15695
> 2017-02-10T00:20:10.156Z 382 TID-otrsptg48
> RepositoryCheck::BatchWorker JID-a315de601bca406340583585 INFO: start
> Feb 10 00:20:10 server journal: 2017-02-10_00:20:10.15968
> 2017-02-10T00:20:10.159Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: repository_check_worker
> Feb 10 00:20:10 server journal: 2017-02-10_00:20:10.17180
> 2017-02-10T00:20:10.171Z 382 TID-otrsptilo PruneOldEventsWorker
> JID-4fa75dc5a3d36957d1034f56 INFO: start
> Feb 10 00:20:10 server journal: 2017-02-10_00:20:10.17430
> 2017-02-10T00:20:10.174Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:20:10 server journal: 2017-02-10_00:20:10.18948
> 2017-02-10T00:20:10.189Z 382 TID-otrsptilo PruneOldEventsWorker
> JID-4fa75dc5a3d36957d1034f56 INFO: done: 0.018 sec
> Feb 10 00:20:11 server journal: 2017-02-10_00:20:11.00073
> 2017-02-10T00:20:11.000Z 382 TID-otrsptg48
> RepositoryCheck::BatchWorker JID-a315de601bca406340583585 INFO: done:
> 0.844 sec
> Feb 10 00:20:14 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:20:15 server kernel: BTRFS info (device sdc): relocating
> block group 12340678230016 flags 65
> Feb 10 00:20:30 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:20:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:20:41 server kernel: systemd-tmpfile: 127 output lines
> suppressed due to ratelimiting
> Feb 10 00:20:49 server kernel: BTRFS info (device sdc): found 34 extents
> Feb 10 00:20:54 server kernel: BTRFS info (device sdc): found 34 extents
> Feb 10 00:20:54 server kernel: BTRFS info (device sdc): relocating
> block group 12336383262720 flags 65
> Feb 10 00:21:01 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:20:59 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:21:04 server journal: 2017-02-10_00:21:04.95882
> 2017-02-10T00:21:04.958Z 382 TID-otrsptep4 PruneOldEventsWorker
> JID-4bfca965ac38fafae6d9f88e INFO: start
> Feb 10 00:21:04 server journal: 2017-02-10_00:21:04.96159
> 2017-02-10T00:21:04.961Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:21:04 server journal: 2017-02-10_00:21:04.97151
> 2017-02-10T00:21:04.971Z 382 TID-otrsptep4 PruneOldEventsWorker
> JID-4bfca965ac38fafae6d9f88e INFO: done: 0.013 sec
> Feb 10 00:21:07 server ntpd[3349]: 0.0.0.0 c612 02 freq_set kernel
> -21.061 PPM
> Feb 10 00:21:07 server ntpd[3349]: 0.0.0.0 c615 05 clock_sync
> Feb 10 00:21:30 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:21:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:21:31 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:21:35 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:21:36 server kernel: BTRFS info (device sdc): relocating
> block group 12332088295424 flags 65
> Feb 10 00:22:00 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:21:59 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:22:04 server journal:
> Feb 10 00:22:04 server journal: ==> /var/log/gitlab/redis/current <==
> Feb 10 00:22:04 server journal: 2017-02-10_00:22:04.03365 378:M 10 Feb
> 00:22:04.033 * 10 changes in 300 seconds. Saving...
> Feb 10 00:22:04 server journal: 2017-02-10_00:22:04.03514 378:M 10 Feb
> 00:22:04.034 * Background saving started by pid 1480
> Feb 10 00:22:04 server journal: 2017-02-10_00:22:04.48684 1480:C 10
> Feb 00:22:04.486 * DB saved on disk
> Feb 10 00:22:04 server journal: 2017-02-10_00:22:04.48789 1480:C 10
> Feb 00:22:04.487 * RDB: 8 MB of memory used by copy-on-write
> Feb 10 00:22:04 server journal: 2017-02-10_00:22:04.53761 378:M 10 Feb
> 00:22:04.537 * Background saving terminated with success
> Feb 10 00:22:11 server journal:
> Feb 10 00:22:11 server journal: ==> /var/log/gitlab/sidekiq/current <==
> Feb 10 00:22:11 server journal: 2017-02-10_00:22:11.58099
> 2017-02-10T00:22:11.580Z 382 TID-otrsptep4 PruneOldEventsWorker
> JID-2b322e11d397491e806fdf9a INFO: start
> Feb 10 00:22:11 server journal: 2017-02-10_00:22:11.58323
> 2017-02-10T00:22:11.583Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:22:11 server journal: 2017-02-10_00:22:11.59561
> 2017-02-10T00:22:11.595Z 382 TID-otrsptep4 PruneOldEventsWorker
> JID-2b322e11d397491e806fdf9a INFO: done: 0.015 sec
> Feb 10 00:22:14 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:22:19 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:22:20 server kernel: BTRFS info (device sdc): relocating
> block group 12327793328128 flags 65
> Feb 10 00:22:31 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:22:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:22:54 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:22:59 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:22:59 server kernel: BTRFS info (device sdc): relocating
> block group 12323498360832 flags 65
> Feb 10 00:23:01 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:22:59 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:23:05 server journal: 2017-02-10_00:23:05.86133
> 2017-02-10T00:23:05.861Z 382 TID-otrsptep4 PruneOldEventsWorker
> JID-95691f21edd3bd28b116508f INFO: start
> Feb 10 00:23:05 server journal: 2017-02-10_00:23:05.86497
> 2017-02-10T00:23:05.864Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:23:05 server journal: 2017-02-10_00:23:05.87282
> 2017-02-10T00:23:05.872Z 382 TID-otrsptep4 PruneOldEventsWorker
> JID-95691f21edd3bd28b116508f INFO: done: 0.011 sec
> Feb 10 00:23:30 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:23:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:23:34 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:23:39 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:23:40 server kernel: BTRFS info (device sdc): relocating
> block group 12319203393536 flags 65
> Feb 10 00:24:01 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:23:59 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:24:09 server journal: 2017-02-10_00:24:09.25079
> 2017-02-10T00:24:09.250Z 382 TID-otrr6wsw0 PruneOldEventsWorker
> JID-9f8cf009d88fd3ba6b5c41c8 INFO: start
> Feb 10 00:24:09 server journal: 2017-02-10_00:24:09.25230
> 2017-02-10T00:24:09.252Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:24:09 server journal: 2017-02-10_00:24:09.26504
> 2017-02-10T00:24:09.264Z 382 TID-otrr6wsw0 PruneOldEventsWorker
> JID-9f8cf009d88fd3ba6b5c41c8 INFO: done: 0.014 sec
> Feb 10 00:24:15 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:24:19 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:24:20 server kernel: BTRFS info (device sdc): relocating
> block group 12314908426240 flags 65
> Feb 10 00:24:30 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:24:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:24:54 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:24:59 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:24:59 server kernel: BTRFS info (device sdc): relocating
> block group 12310613458944 flags 65
> Feb 10 00:25:00 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:24:59 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:25:13 server journal: 2017-02-10_00:25:13.43533
> 2017-02-10T00:25:13.435Z 382 TID-otrsptep4 PruneOldEventsWorker
> JID-0bafb305f0549fbfaedd0f21 INFO: start
> Feb 10 00:25:13 server journal: 2017-02-10_00:25:13.43790
> 2017-02-10T00:25:13.437Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:25:13 server journal: 2017-02-10_00:25:13.44842
> 2017-02-10T00:25:13.448Z 382 TID-otrsptep4 PruneOldEventsWorker
> JID-0bafb305f0549fbfaedd0f21 INFO: done: 0.013 sec
> Feb 10 00:25:34 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:25:32 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:25:34 server kernel: BTRFS info (device sdc): found 37 extents
> Feb 10 00:25:39 server kernel: BTRFS info (device sdc): found 37 extents
> Feb 10 00:25:40 server kernel: BTRFS info (device sdc): relocating
> block group 12306318491648 flags 65
> Feb 10 00:26:00 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:25:59 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:26:14 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:26:18 server journal: 2017-02-10_00:26:18.73291
> 2017-02-10T00:26:18.732Z 382 TID-otrr6wry4 PruneOldEventsWorker
> JID-444ab4e6f7b42090f23cfca2 INFO: start
> Feb 10 00:26:18 server journal: 2017-02-10_00:26:18.73405
> 2017-02-10T00:26:18.734Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:26:18 server journal: 2017-02-10_00:26:18.74593
> 2017-02-10T00:26:18.745Z 382 TID-otrr6wry4 PruneOldEventsWorker
> JID-444ab4e6f7b42090f23cfca2 INFO: done: 0.013 sec
> Feb 10 00:26:18 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:26:19 server kernel: BTRFS info (device sdc): relocating
> block group 12302023524352 flags 65
> Feb 10 00:26:30 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:26:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:26:54 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:26:58 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:26:59 server kernel: BTRFS info (device sdc): relocating
> block group 12297728557056 flags 65
> Feb 10 00:27:05 server journal:
> Feb 10 00:27:05 server journal: ==> /var/log/gitlab/redis/current <==
> Feb 10 00:27:05 server journal: 2017-02-10_00:27:05.05277 378:M 10 Feb
> 00:27:05.052 * 10 changes in 300 seconds. Saving...
> Feb 10 00:27:05 server journal: 2017-02-10_00:27:05.05399 378:M 10 Feb
> 00:27:05.053 * Background saving started by pid 1796
> Feb 10 00:27:05 server journal: 2017-02-10_00:27:05.75682 1796:C 10
> Feb 00:27:05.756 * DB saved on disk
> Feb 10 00:27:05 server journal: 2017-02-10_00:27:05.75733 1796:C 10
> Feb 00:27:05.757 * RDB: 8 MB of memory used by copy-on-write
> Feb 10 00:27:05 server journal: 2017-02-10_00:27:05.85460 378:M 10 Feb
> 00:27:05.854 * Background saving terminated with success
> Feb 10 00:27:08 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:27:06 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:27:11 server journal:
> Feb 10 00:27:11 server journal: ==> /var/log/gitlab/sidekiq/current <==
> Feb 10 00:27:11 server journal: 2017-02-10_00:27:11.01598
> 2017-02-10T00:27:11.015Z 382 TID-otrsptskk PruneOldEventsWorker
> JID-9c0a9bd8da1b04e7fec41b09 INFO: start
> Feb 10 00:27:11 server journal: 2017-02-10_00:27:11.01854
> 2017-02-10T00:27:11.018Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:27:11 server journal: 2017-02-10_00:27:11.02791
> 2017-02-10T00:27:11.027Z 382 TID-otrsptskk PruneOldEventsWorker
> JID-9c0a9bd8da1b04e7fec41b09 INFO: done: 0.012 sec
> Feb 10 00:27:30 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:27:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:27:35 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:27:40 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:27:40 server kernel: BTRFS info (device sdc): relocating
> block group 12293433589760 flags 65
> Feb 10 00:28:01 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:27:59 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:28:02 server journal: 2017-02-10_00:28:02.23927
> 2017-02-10T00:28:02.239Z 382 TID-otrsptep4 PruneOldEventsWorker
> JID-59ab152a8efd6e7386e82f5a INFO: start
> Feb 10 00:28:02 server journal: 2017-02-10_00:28:02.24045
> 2017-02-10T00:28:02.240Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:28:02 server journal: 2017-02-10_00:28:02.25251
> 2017-02-10T00:28:02.252Z 382 TID-otrsptep4 PruneOldEventsWorker
> JID-59ab152a8efd6e7386e82f5a INFO: done: 0.013 sec
> Feb 10 00:28:16 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:28:21 server kernel: BTRFS info (device sdc): found 32 extents
> Feb 10 00:28:21 server kernel: BTRFS info (device sdc): relocating
> block group 12289138622464 flags 65
> Feb 10 00:28:32 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:28:29 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:28:58 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:29:00 server journal: 192.168.1.253 - wally_tm
> [10/Feb/2017:00:28:59 +0000] "PROPFIND /remote.php/webdav/Pictures
> HTTP/1.1" 207 1024 "-" "Mozilla/5.0 (Linux) mirall/2.1.1"
> Feb 10 00:29:02 server kernel: BTRFS info (device sdc): found 33 extents
> Feb 10 00:29:03 server kernel: BTRFS info (device sdc): relocating
> block group 12288064880640 flags 68
> Feb 10 00:29:10 server journal: 2017-02-10_00:29:10.54068
> 2017-02-10T00:29:10.540Z 382 TID-otrsptsws PruneOldEventsWorker
> JID-3da257e9bdbdb05b1966f9b6 INFO: start
> Feb 10 00:29:10 server journal: 2017-02-10_00:29:10.54251
> 2017-02-10T00:29:10.542Z 382 TID-otrr6wqok INFO: Cron Jobs - add job
> with name: prune_old_events_worker
> Feb 10 00:29:10 server journal: 2017-02-10_00:29:10.55457
> 2017-02-10T00:29:10.554Z 382 TID-otrsptsws PruneOldEventsWorker
> JID-3da257e9bdbdb05b1966f9b6 INFO: done: 0.014 sec
> Feb 10 00:29:11 server kernel: ------------[ cut here ]------------
> Feb 10 00:29:11 server kernel: WARNING: CPU: 7 PID: 27932 at
> fs/btrfs/extent-tree.c:6945 __btrfs_free_extent.isra.69+0xb62/0xca0
> [btrfs]
> Feb 10 00:29:11 server kernel: Modules linked in: xt_nat veth
> xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
> nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype
> iptable_filter nf_nat nf_conntrack ext4 jbd2 mbcache ipmi_devintf
> coretemp iTCO_wdt iTCO_vendor_support gpio_ich kvm_intel kvm irqbypass
> intel_cstate input_leds pcspkr hpwdt hpilo lpc_ich mfd_core
> i7core_edac edac_core ses ioatdma enclosure sg ipmi_si ipmi_msghandler
> acpi_power_meter shpchp pcc_cpufreq acpi_cpufreq nfsd auth_rpcgss
> nfs_acl lockd grace sunrpc ip_tables btrfs xor raid6_pq sd_mod
> crc32c_intel amdkfd amd_iommu_v2 serio_raw radeon drm_kms_helper
> syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm ahci libahci
> fjes libata mpt3sas raid_class scsi_transport_sas igb ptp pps_core dca
> i2c_algo_bit
> Feb 10 00:29:11 server kernel: CPU: 7 PID: 27932 Comm: btrfs Tainted:
> G          I     4.8.7-1.el7.elrepo.x86_64 #1
> Feb 10 00:29:11 server kernel: Hardware name: HP ProLiant SE326M1   ,
> BIOS R02 12/07/2010
> Feb 10 00:29:11 server kernel: 0000000000000286 00000000e89bd9a3
> ffff8805c9b67720 ffffffff8135406c
> Feb 10 00:29:11 server kernel: 0000000000000000 0000000000000000
> ffff8805c9b67760 ffffffff810817b1
> Feb 10 00:29:11 server kernel: 00001b21fffffffe ffff8804d6f47850
> 00000b2d1dfc4000 00000000fffffffe
> Feb 10 00:29:11 server kernel: Call Trace:
> Feb 10 00:29:11 server kernel: [<ffffffff8135406c>] dump_stack+0x63/0x87
> Feb 10 00:29:11 server kernel: [<ffffffff810817b1>] __warn+0xd1/0xf0
> Feb 10 00:29:11 server kernel: [<ffffffff810818ed>]
> warn_slowpath_null+0x1d/0x20
> Feb 10 00:29:11 server kernel: [<ffffffffa0467722>]
> __btrfs_free_extent.isra.69+0xb62/0xca0 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa046bd61>]
> __btrfs_run_delayed_refs.constprop.78+0xa11/0x1250 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa046f46e>]
> btrfs_run_delayed_refs+0x8e/0x2c0 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa04abddb>] ?
> free_extent_buffer+0x4b/0x90 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa0485079>]
> btrfs_should_end_transaction+0x49/0x60 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa046db87>]
> btrfs_drop_snapshot+0x3f7/0x7f0 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa04e0a0a>]
> merge_reloc_roots+0x10a/0x260 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa04e0f34>]
> relocate_block_group+0x3d4/0x670 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa04e137b>]
> btrfs_relocate_block_group+0x1ab/0x290 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa04b1df6>]
> btrfs_relocate_chunk.isra.40+0x46/0xd0 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa04b369e>]
> __btrfs_balance+0x85e/0xc50 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffff810ac538>] ?
> try_to_wake_up+0x58/0x3c0
> Feb 10 00:29:11 server kernel: [<ffffffffa04b3d4c>]
> btrfs_balance+0x2bc/0x630 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa04bfa81>]
> btrfs_ioctl_balance+0x3f1/0x540 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffffa04c3c38>]
> btrfs_ioctl+0xab8/0x21e0 [btrfs]
> Feb 10 00:29:11 server kernel: [<ffffffff8120d8d5>] ?
> mem_cgroup_commit_charge+0x85/0x100
> Feb 10 00:29:11 server kernel: [<ffffffff811d17d9>] ?
> page_add_new_anon_rmap+0x89/0xc0
> Feb 10 00:29:11 server kernel: [<ffffffff8119f5d5>] ?
> lru_cache_add_active_or_unevictable+0x35/0xb0
> Feb 10 00:29:11 server kernel: [<ffffffff811c6c60>] ?
> handle_mm_fault+0xed0/0x1240
> Feb 10 00:29:11 server kernel: [<ffffffff811f4407>] ?
> kmem_cache_alloc+0xd7/0x1a0
> Feb 10 00:29:11 server kernel: [<ffffffff8122ffc7>]
> do_vfs_ioctl+0xa7/0x5f0
> Feb 10 00:29:11 server kernel: [<ffffffff8112d3ff>] ?
> __audit_syscall_entry+0xaf/0x100
> Feb 10 00:29:11 server kernel: [<ffffffff8100365d>] ?
> syscall_trace_enter+0x1dd/0x2c0
> Feb 10 00:29:11 server kernel: [<ffffffff81230589>] SyS_ioctl+0x79/0x90
> Feb 10 00:29:11 server kernel: [<ffffffff81003a47>]
> do_syscall_64+0x67/0x160
> Feb 10 00:29:11 server kernel: [<ffffffff8173bbe1>]
> entry_SYSCALL64_slow_path+0x25/0x25
> Feb 10 00:29:11 server kernel: ---[ end trace 9b04f696ec89affd ]---
> Feb 10 00:29:11 server kernel: BTRFS info (device sdc): leaf
> 5224642887680 total ptrs 280 free space 43
> Feb 10 00:29:11 server kernel: #011item 0 key (12288253624320 169 0)
> itemoff 16250 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 1 key (12288253640704 169 0)
> itemoff 16217 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 2 key (12288253804544 169 0)
> itemoff 16184 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 3 key (12288253919232 169 0)
> itemoff 16151 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 4 key (12288253935616 169 0)
> itemoff 16118 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 5 key (12288253952000 169 0)
> itemoff 16085 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 6 key (12288254050304 169 0)
> itemoff 16052 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 7 key (12288254115840 169 0)
> itemoff 16019 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 8 key (12288254361600 169 0)
> itemoff 15986 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 9 key (12288254640128 169 0)
> itemoff 15953 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 10 key (12288255098880 169 0)
> itemoff 15920 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142939 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 11 key (12288258097152 169 0)
> itemoff 15887 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142940 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 12 key (12288258162688 169 0)
> itemoff 15854 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142940 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 13 key (12288258179072 169 0)
> itemoff 15821 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142940 flags 258
> Feb 10 00:29:11 server kernel: #011#011shared block backref parent
> 5224641380352
> Feb 10 00:29:11 server kernel: #011item 14 key (12288258375680 169 0)
> itemoff 15788 itemsize 33
> Feb 10 00:29:11 server kernel: #011#011extent refs 1 gen 142940 flags 258
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
>
> On 13 Feb 2017, at 00:49, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
>
> At 02/12/2017 09:17 AM, Tomasz Kusmierz wrote:
>
> Hi all,
>
> So my main storage filesystem got some sort of veird corruption (that
> I can gather). Everything seems to work OK, but when I try to create a
> snapshot or run balance (no filters) it will get remounted read only.
>
>
> Kernel version please.
>
>
> Fun part is that balance seems to be running even on read only FS, and
> I continuously get kernel traces in /var/log/messages .... so it might
> as well in the back ground silently eat my data away :/
>
>
> Kernel backtrace please.
>
> It would be better if you could paste the *first* kernel backtrace, as
> that could be the cause, and following kernel backtrace is just
> warning from btrfs_abort_transaction() without meaningful output.
>
> I just see some normal messages, but no kernel backtrace.
>
>
>
> UPDATE:
>
> Yeah, after rebooting the system it does not even mount the FS,
> mount.btrfs sits in some sort of spinlock and consumes 100% of singe
> core.
>
>
>
> UPDATE 2:
>
> System is completelly cooked :/
>
> [root@server ~]# btrfs fi show
> Label: 'rockstor_server'  uuid: 5581a647-40ef-4a7a-9d73-847bf35a142b
> Total devices 1 FS bytes used 5.72GiB
> devid    1 size 53.17GiB used 7.03GiB path /dev/sda2
>
> Label: 'broken_pool'  uuid: 26095277-a234-455b-8c97-8dac8ad934c8
> Total devices 2 FS bytes used 193.52GiB
> devid    1 size 1.82TiB used 196.03GiB path /dev/sdb
> devid    2 size 1.82TiB used 196.03GiB path /dev/sdi
>
> Label: 'main_pool'  uuid: 0576d577-8954-4a60-a02b-9492b3c29318
> Total devices 8 FS bytes used 5.83TiB
> devid    1 size 1.82TiB used 1.50TiB path /dev/sdc
> devid    2 size 1.82TiB used 1.50TiB path /dev/sdd
> devid    3 size 1.82TiB used 1.50TiB path /dev/sde
> devid    4 size 1.82TiB used 1.50TiB path /dev/sdf
> devid    5 size 1.82TiB used 1.50TiB path /dev/sdg
> devid    6 size 1.82TiB used 1.50TiB path /dev/sdh
> devid    7 size 1.82TiB used 1.50TiB path /dev/sdj
> devid    8 size 1.82TiB used 1.50TiB path /dev/sdk
>
> [root@server ~]# mount /dev/sdc /mnt2/main_pool/
> mount: wrong fs type, bad option, bad superblock on /dev/sdc,
>    missing codepage or helper program, or other error
>
>    In some cases useful info is found in syslog - try
>    dmesg | tail or so.
> [root@server ~]# mount /dev/sdd /mnt2/main_pool/
> mount: wrong fs type, bad option, bad superblock on /dev/sdd,
>    missing codepage or helper program, or other error
>
>    In some cases useful info is found in syslog - try
>    dmesg | tail or so.
> [root@server ~]# mount /dev/sde /mnt2/main_pool/
> mount: wrong fs type, bad option, bad superblock on /dev/sde,
>    missing codepage or helper program, or other error
>
>    In some cases useful info is found in syslog - try
>    dmesg | tail or so.
>
>
> dmesg tail retuns:
> [ 9507.835629] systemd-udevd[1873]: Validate module index
> [ 9507.835656] systemd-udevd[1873]: Check if link configuration needs
> reloading.
> [ 9507.835690] systemd-udevd[1873]: seq 3698 queued, 'add' 'bdi'
> [ 9507.835873] systemd-udevd[1873]: seq 3698 forked new worker [13858]
> [ 9507.836202] BTRFS info (device sdd): disk space caching is enabled
> [ 9507.836204] BTRFS info (device sdd): has skinny extents
> [ 9507.836322] systemd-udevd[13858]: seq 3698 running
> [ 9507.836443] systemd-udevd[13858]: no db file to read
> /run/udev/data/+bdi:btrfs-4: No such file or directory
> [ 9507.836474] systemd-udevd[13858]: RUN '/bin/mknod
> /dev/btrfs-control c 10 234' /etc/udev/rules.d/64-btrfs.rules:1
> [ 9507.837366] systemd-udevd[13861]: starting '/bin/mknod
> /dev/btrfs-control c 10 234'
> [ 9507.837833] BTRFS error (device sdd): failed to read the system array:
> -5
> [ 9507.838231] systemd-udevd[13858]: '/bin/mknod /dev/btrfs-control c
> 10 234'(err) '/bin/mknod: '/dev/btrfs-control': File exists'
> [ 9507.838262] systemd-udevd[13858]: '/bin/mknod /dev/btrfs-control c
> 10 234' [13861] exit with return code 1
> [ 9507.854757] BTRFS: open_ctree failed
> [ 9511.370878] BTRFS info (device sdd): disk space caching is enabled
> [ 9511.370881] BTRFS info (device sdd): has skinny extents
> [ 9511.375097] BTRFS error (device sdd): failed to read the system array:
> -5
>
>
> Btrfs failed to read system chunk array from super block.
> Normally this means your primary super block is cooked up.
> There may still be chance to recover your fs using backup superblocks.
>
> Please paste the output of "btrfs inspect-internal dump-super -af <your
> fs>"
>
>
> Thanks,
> Qu
>
> [ 9511.392792] BTRFS: open_ctree failed
> [ 9514.233627] BTRFS: device label main_pool devid 3 transid 150680
> /dev/sde
> [ 9514.234399] systemd-udevd[1873]: Validate module index
> [ 9514.234431] systemd-udevd[1873]: Check if link configuration needs
> reloading.
> [ 9514.234465] systemd-udevd[1873]: seq 3702 queued, 'add' 'bdi'
> [ 9514.234522] systemd-udevd[1873]: passed 142 bytes to netlink
> monitor 0x5628f65d40d0
> [ 9514.234554] systemd-udevd[13882]: seq 3702 running
> [ 9514.234780] systemd-udevd[13882]: no db file to read
> /run/udev/data/+bdi:btrfs-6: No such file or directory
> [ 9514.234790] BTRFS info (device sde): disk space caching is enabled
> [ 9514.234792] BTRFS info (device sde): has skinny extents
> [ 9514.234798] systemd-udevd[13882]: RUN '/bin/mknod
> /dev/btrfs-control c 10 234' /etc/udev/rules.d/64-btrfs.rules:1
> [ 9514.235181] systemd-udevd[13906]: starting '/bin/mknod
> /dev/btrfs-control c 10 234'
> [ 9514.236448] systemd-udevd[13882]: '/bin/mknod /dev/btrfs-control c
> 10 234'(err) '/bin/mknod: '/dev/btrfs-control': File exists'
> [ 9514.236514] systemd-udevd[13882]: '/bin/mknod /dev/btrfs-control c
> 10 234' [13906] exit with return code 1
> [ 9514.238726] BTRFS error (device sde): failed to read the system array:
> -5
> [ 9514.255472] BTRFS: open_ctree failed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
