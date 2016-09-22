Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35564 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934016AbcIVV4m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 17:56:42 -0400
Received: by mail-oi0-f44.google.com with SMTP id w11so114186334oia.2
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 14:56:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB1rxdYVCgnneJuCTe308RVOppvy5cMYzPtG-YnL7UEDdJYGtw@mail.gmail.com>
References: <CAB1rxdbJX7rgv-NrHyGD7wMMcFf1EDR_aJ8yaTs7r=O-iXTo7w@mail.gmail.com>
 <CAJCQCtSz15HC99QetsSzJRtbLgZU+iohej9Mf6qE4q39MmZfKA@mail.gmail.com>
 <CAB1rxdYdOZvgymnpzkURVxP7J2UQ=W4ANZpte+r8Z=9XAOuBQw@mail.gmail.com>
 <CAJCQCtSEVaxj9bwKyb57tM3eZ946oHOUZX7AHQV_5aXWfjZ2gw@mail.gmail.com> <CAB1rxdYVCgnneJuCTe308RVOppvy5cMYzPtG-YnL7UEDdJYGtw@mail.gmail.com>
From: Mirak M <mirak63@gmail.com>
Date: Thu, 22 Sep 2016 17:56:40 -0400
Message-ID: <CAB1rxdYrBO4i0yJRKU6XJgQrofFy6JVjAS8TeDvv8XU8C_z3MQ@mail.gmail.com>
Subject: Fwd: Can't mount btrfs raid1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Same error when mouting with this fedora iso, with mount, mount -o
recovery and mount -o ro,recovery

#############################################################################
[  682.954511] BTRFS info (device sdc2): disk space caching is enabled
[  682.954518] BTRFS info (device sdc2): has skinny extents
[  691.321125] BTRFS critical (device sdc2): corrupt leaf, bad key
order: block=1957998690304,root=1, slot=29
[  691.321156] ------------[ cut here ]------------
[  691.321203] WARNING: CPU: 3 PID: 3502 at
fs/btrfs/extent-tree.c:6957 __btrfs_free_extent.isra.68+0x79c/0xca0
[btrfs]
[  691.321204] BTRFS: Transaction aborted (error -5)
[  691.321206] Modules linked in: fuse nf_conntrack_netbios_ns
nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT nf_reject_ipv6
xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge
ip6table_raw ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6
ip6table_security ip6table_mangle iptable_raw iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
iptable_security iptable_mangle ebtable_filter ebtables
ip6table_filter ip6_tables ir_lirc_codec snd_hda_codec_realtek
lirc_dev snd_hda_codec_generic rc_rc6_mce snd_hda_codec_hdmi coretemp
mceusb snd_hda_intel rc_core i2c_algo_bit kvm_intel snd_hda_codec ttm
ppdev joydev kvm snd_hda_core drm_kms_helper snd_hwdep irqbypass drm
snd_seq snd_seq_device snd_pcm snd_timer snd soundcore parport_pc
shpchp wmi parport video nv_tco
[  691.321276]  acpi_cpufreq i2c_nforce2 tpm_tis tpm_tis_core tpm nfsd
auth_rpcgss nfs_acl lockd grace nls_utf8 isofs squashfs btrfs
ata_generic pata_acpi xor raid6_pq serio_raw 8021q garp stp llc mrp
firewire_ohci forcedeth firewire_core pata_jmicron crc_itu_t fjes
hid_logitech_hidpp hid_logitech ff_memless hid_logitech_dj sunrpc
scsi_transport_iscsi loop
[  691.321310] CPU: 3 PID: 3502 Comm: mount Not tainted
4.8.0-0.rc7.git1.1.fc26.x86_64 #1
[  691.321311] Hardware name: Gigabyte Technology Co., Ltd.
GA-E7AUM-DS2H/GA-E7AUM-DS2H, BIOS F2 12/17/2008
[  691.321314]  0000000000000286 000000002c34a0c3 ffffa37a76593688
ffffffff8f466ff3
[  691.321318]  ffffa37a765936d8 0000000000000000 ffffa37a765936c8
ffffffff8f0ae7ab
[  691.321322]  00001b2d00000246 000001c81f860000 00000000fffffffb
ffffa379a9209000
[  691.321326] Call Trace:
[  691.321331]  [<ffffffff8f466ff3>] dump_stack+0x86/0xc3
[  691.321333]  [<ffffffff8f0ae7ab>] __warn+0xcb/0xf0
[  691.321335]  [<ffffffff8f0ae82f>] warn_slowpath_fmt+0x5f/0x80
[  691.321351]  [<ffffffffc052da4c>]
__btrfs_free_extent.isra.68+0x79c/0xca0 [btrfs]
[  691.321366]  [<ffffffffc0532245>] ?
__btrfs_run_delayed_refs+0x195/0x1780 [btrfs]
[  691.321383]  [<ffffffffc0532d12>]
__btrfs_run_delayed_refs+0xc62/0x1780 [btrfs]
[  691.321399]  [<ffffffffc05369b1>] btrfs_run_delayed_refs+0xa1/0x2d0 [btrfs]
[  691.321417]  [<ffffffffc054ebb2>] btrfs_commit_transaction+0x52/0xb40 [btrfs]
[  691.321420]  [<ffffffff8f12e495>] ? rcu_read_lock_sched_held+0x45/0x80
[  691.321423]  [<ffffffff8f271d19>] ? kmem_cache_free+0x2f9/0x340
[  691.321442]  [<ffffffffc059ce18>] btrfs_recover_log_trees+0x3e8/0x480 [btrfs]
[  691.321462]  [<ffffffffc0598390>] ? replay_one_extent+0x710/0x710 [btrfs]
[  691.321480]  [<ffffffffc054bc9f>] open_ctree+0x237f/0x2660 [btrfs]
[  691.321494]  [<ffffffffc051b9d3>] btrfs_mount+0xda3/0xef0 [btrfs]
[  691.321498]  [<ffffffff8f2a7828>] mount_fs+0x38/0x160
[  691.321500]  [<ffffffff8f2c96be>] ? alloc_vfsmnt+0x19e/0x230
[  691.321502]  [<ffffffff8f2c9c4b>] vfs_kern_mount+0x6b/0x150
[  691.321516]  [<ffffffffc051add3>] btrfs_mount+0x1a3/0xef0 [btrfs]
[  691.321520]  [<ffffffff8f10b8d1>] ? lockdep_init_map+0x61/0x210
[  691.321522]  [<ffffffff8f2a7828>] mount_fs+0x38/0x160
[  691.321523]  [<ffffffff8f2c96be>] ? alloc_vfsmnt+0x19e/0x230
[  691.321525]  [<ffffffff8f2c9c4b>] vfs_kern_mount+0x6b/0x150
[  691.321527]  [<ffffffff8f2ccb3d>] do_mount+0x1dd/0xcf0
[  691.321529]  [<ffffffff8f29e1a3>] ? __check_object_size+0xd3/0x214
[  691.321531]  [<ffffffff8f2224a0>] ? memdup_user+0x60/0x90
[  691.321534]  [<ffffffff8f2cd963>] SyS_mount+0x83/0xd0
[  691.321537]  [<ffffffff8f8f78fc>] entry_SYSCALL_64_fastpath+0x1f/0xbd
[  691.321539] ---[ end trace 8e57b3f7e61b4de9 ]---
[  691.321740] BTRFS: error (device sdc2) in __btrfs_free_extent:6957:
errno=-5 IO failure
[  691.321752] BTRFS: error (device sdc2) in
btrfs_run_delayed_refs:2960: errno=-5 IO failure
[  691.324478] BTRFS: error (device sdc2) in btrfs_replay_log:2470:
errno=-5 IO failure (Failed to recover log tree)
[  691.326725] pending csums is 4096
[  691.327863] BTRFS error (device sdc2): cleaner transaction attach
returned -30
[  691.407116] BTRFS: open_ctree failed
[  691.408577] mount (3502) used greatest stack depth: 9880 bytes left

############################################################################################

btrfs check --repair crashes :

[root@new-host mnt]# btrfs check --repair /dev/sda2
enabling repair mode
repair mode will force to clear out log tree, Are you sure? [y/N]: y
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs(+0x514da)[0x555c5edee4da]
btrfs(btrfs_reserve_extent+0xa3f)[0x555c5edf34cf]
btrfs(btrfs_alloc_free_block+0x5f)[0x555c5edf359f]
btrfs(__btrfs_cow_block+0xc4)[0x555c5ede43d4]
btrfs(btrfs_cow_block+0x35)[0x555c5ede49d5]
btrfs(+0x4cf26)[0x555c5ede9f26]
btrfs(btrfs_commit_transaction+0x95)[0x555c5edebd65]
btrfs(cmd_check+0x843)[0x555c5edd1723]
btrfs(main+0x7b)[0x555c5edad03b]
/lib64/libc.so.6(__libc_start_main+0xf1)[0x7ff7aae8e421]
btrfs(_start+0x2a)[0x555c5edad14a]

############################################################################################



2016-09-21 17:02 GMT-04:00 Chris Murphy <lists@colorremedies.com>:
> On Wed, Sep 21, 2016 at 1:01 PM, Mirak M <mirak63@gmail.com> wrote:
>> 2016-09-21 3:00 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
>>> On Tue, Sep 20, 2016 at 5:16 PM, Mirak M <mirak63@gmail.com> wrote:
>>>> Hello,
>>>>
>>>> I have a failure when mounting btrfs.
>>>>
>>>>> mount -oro,recovery /dev/sda2 sda2_btrfs
>>>>> mount: /dev/sda2: can't read superblock
>>>
>>> What do you get for 'btrfs rescue super-recover -v <dev>' and 'btrfs check <dev>'
>>
>> I get this :
>> ###################################################
>> All Devices:
>>     Device: id = 1, name = /dev/sdc2
>>     Device: id = 2, name = /dev/sda2
>>
>> Before Recovering:
>>     [All good supers]:
>>         device name = /dev/sdc2
>>         superblock bytenr = 65536
>>
>>         device name = /dev/sdc2
>>         superblock bytenr = 67108864
>>
>>         device name = /dev/sdc2
>>         superblock bytenr = 274877906944
>>
>>         device name = /dev/sda2
>>         superblock bytenr = 65536
>>
>>         device name = /dev/sda2
>>         superblock bytenr = 67108864
>>
>>         device name = /dev/sda2
>>         superblock bytenr = 274877906944
>>
>>     [All bad supers]:
>>
>> All supers are valid, no need to recover
>
>
> I think you've found a bug. 'super-recover' and 'check' don't complain
> about any supers but the kernel fails with can't read superblock.
> Either the kernel is wrong or the user space tools are wrong. There's
> an inconsistency here.
>
> So you need to change kernel and/or btrfs-progs versions and see if it
> still happens. I just tested this, it has kernel 4.8.rc7 and
> btrfs-progs 4.7.2, Fedora live OS, so you can capture stuff with
> Terminal.
>
> https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-20160921.n.0/compose/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-Rawhide-20160921.n.0.iso
>
> I would first try normal mount and see if you get the same superblock
> message or something else. Then also -o recovery as well as -o
> ro,recovery.
>
> But also, eventually you'll need to do 'btrfs check --repair' and see
> if it can fix the problem, if there's no additional corruption
> happening when you run repair it might be able to fix it.
>
> As for hardware induced corruptions there are lots of threads in the
> archive, quick search:
>
> http://www.spinics.net/lists/linux-btrfs/msg56954.html
> http://www.spinics.net/lists/linux-btrfs/msg57008.html
>
> I've not used stress.sh or stres.sh or whatever it's called, haven't
> found it. But could be useful.
>
>
> --
> Chris Murphy
