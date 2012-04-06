From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 0/3] btrfs: extended inode refs
Date: Fri, 06 Apr 2012 10:12:27 +0800
Message-ID: <4F7E510B.6070207@cn.fujitsu.com>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <4F7E45C5.5090306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F7E45C5.5090306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/06/2012 09:24 AM, Liu Bo wrote:
> On 04/06/2012 04:09 AM, Mark Fasheh wrote:
>> Currently btrfs has a limitation on the maximum number of hard links an
>> inode can have. Specifically, links are stored in an array of ref
>> items:
>>
>> struct btrfs_inode_ref {
>> 	__le64 index;
>> 	__le16 name_len;
>> 	/* name goes here */
>> } __attribute__ ((__packed__));
>>
>> The ref arrays are found via key triple:
>>
>> (inode objectid, BTRFS_INODE_EXTREF_KEY, parent dir objectid)
>>
>> Since items can not exceed the size of a leaf, the total number of links
>> that can be stored for a given inode / parent dir pair is limited to under
>> 4k. This works fine for the most common case of few to only a handful of
>> links. Once the link count gets higher however, we begin to return EMLINK.
>>
>>
>> The following patches fix this situation by introducing a new ref item:
>>
>> struct btrfs_inode_extref {
>> 	__le64 parent_objectid;
>> 	__le64 index;
>> 	__le16 name_len;
>> 	__u8   name[0];
>> 	/* name goes here */
>> } __attribute__ ((__packed__));
>>
>> Extended refs behave differently from ref arrays in several key areas.
>>
>> Each extended refs is it's own item so there is no ref array (and
>> therefore no limit on size).
>>
>> As a result, we must use a different addressing scheme. Extended ref keys
>> look like:
>>
>> (inode objectid, BTRFS_INODE_EXTREF_KEY, hash)
>>
>> Where hash is defined as a function of the parent objectid and link name.
>>
>> This effectively fixes the limitation, though we have a slightly less
>> efficient packing of link data. To keep the best of both worlds then, I
>> implemented the following behavior:
>>
>> Extended refs don't replace the existing ref array. An inode gets an
>> extended ref for a given link _only_ after the ref array has been filled.  So
>> the most common cases shouldn't actually see any difference in performance
>> or disk usage as they'll never get to the point where we're using an
>> extended ref.
>>
>> It's important while reading the patches however that there's still the
>> possibility that we can have a set of operations that grow out an inode ref
>> array (adding some extended refs) and then remove only the refs in the
>> array.  I don't really see this being common but it's a case we always have
>> to consider when coding these changes.
>>
>> Right now there is a limitation for extrefs in that we're not handling the
>> possibility of a hash collision. There are two ways I see we can deal with
>> this:
>>
>> We can use a 56-bit hash and keep a generation counter in the lower 8
>> bits of the offset field.  The cost would be an additional tree search
>> (between offset <hash>00 and <hash>FF) if we don't find exactly the name we
>> were looking for.
>>
>> An alternative solution to dealing with collisions could be to emulate the
>> dir-item insertion code - specifically something like insert_with_overflow()
>> which will stuff multiple items under one key. I tend to prefer the idea of
>> simply including a generation in the key offset however since it maintains
>> the 1:1 relationship of keys to names which turns out to be much nicer to
>> code for in my honest opinion. Also none of the code which iterates the tree
>> looking for refs would have to change as the only difference is in the key
>> offset and not in the actual item structure.
>>
>>
>> Testing wise, the patches are in an intermediate state. I've debugged a fair
>> bit but I'm certain there's gremlins lurking in there.  The basic namespace
>> operations work well enough (link, unlink, etc).  I've done light testing of
>> my changes in backref.c by exercising BTRFS_IOC_INO_PATHS.  The changes in
>> tree-log.c need the most review and testing - I haven't really figured out a
>> great way to exercise the code in tree-log yet (suggestions would be
>> great!).
>>
> 
> For the log recover test, I used to sysrq+b to make sure our log remains on disk.
> 
> Will also test this patchset sooner or later.
> 

It Works fine in normal mode except we need to note people to modify their btrfs-progs with
that incompat flag at the first step ;)

However, for log recover, I use the following script:

$ touch /mnt/btrfs/foobar; 
$ ./fsync_self /mnt/btrfs/foobar; (fsync_self is a wrapper of fsync() written by myself)
$ for i in `seq 1 1 300`; do ln /mnt/btrfs/foobar /mnt/btrfs/foobar$i; ./fsync_self /mnt/btrfs/foobar$i; done;
$ echo b > /proc/sysrq-trigger

when we come back,
$ mount disk /mnt/btrfs

and it hits a warning and a hang, the dmesg log shows:

Btrfs loaded
device fsid 85811dec-dd03-44f1-a8e2-005a67c6b7f5 devid 1 transid 5 /dev/sdb7
btrfs: disk space caching is enabled
Btrfs detected SSD devices, enabling SSD mode
------------[ cut here ]------------
WARNING: at fs/btrfs/ctree.c:1677 btrfs_search_slot+0x941/0x960 [btrfs]()
Hardware name: QiTianM7150
Modules linked in: btrfs(O) zlib_deflate libcrc32c ip6table_filter ip6_tables iptable_filter ebtable_nat ebtables ipt_REJECT ip_tables bridge stp llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm ppdev sg parport_pc parport coretemp hwmon pcspkr i2c_i801 iTCO_wdt iTCO_vendor_support sky2 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_generic ata_piix i915 drm_kms_
 helper drm i2c_algo_bit i2c_core video [last unloaded: btrfs]
Pid: 2323, comm: mount Tainted: G           O 3.4.0-rc1 #8
Call Trace:
 [<ffffffff8104d59f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104d5fa>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa0715071>] btrfs_search_slot+0x941/0x960 [btrfs]
 [<ffffffffa07264de>] btrfs_lookup_dir_index_item+0x4e/0x90 [btrfs]
 [<ffffffffa076f139>] add_inode_ref+0x4b9/0x880 [btrfs]
 [<ffffffffa0771fc7>] replay_one_buffer+0x2a7/0x3b0 [btrfs]
 [<ffffffffa074700d>] ? btrfs_token_key_generation+0x5d/0xe0 [btrfs]
 [<ffffffffa076c31a>] walk_down_log_tree+0x23a/0x410 [btrfs]
 [<ffffffffa076c825>] walk_log_tree+0xb5/0x210 [btrfs]
 [<ffffffffa0770669>] btrfs_recover_log_trees+0x229/0x3e0 [btrfs]
 [<ffffffffa0771d20>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
 [<ffffffffa0730b08>] open_ctree+0x1598/0x1ae0 [btrfs]
 [<ffffffffa070bc94>] btrfs_mount+0x474/0x560 [btrfs]
 [<ffffffff811278be>] ? pcpu_next_pop+0x4e/0x70
 [<ffffffff81169ab3>] mount_fs+0x43/0x1a0
 [<ffffffff81129050>] ? __alloc_percpu+0x10/0x20
 [<ffffffff8118406a>] vfs_kern_mount+0x6a/0xf0
 [<ffffffff81184462>] do_kern_mount+0x52/0x110
 [<ffffffff811f3f98>] ? security_capable+0x18/0x20
 [<ffffffff81186355>] do_mount+0x255/0x7c0
 [<ffffffff8112390b>] ? memdup_user+0x4b/0x90
 [<ffffffff811239ab>] ? strndup_user+0x5b/0x80
 [<ffffffff81186950>] sys_mount+0x90/0xe0
 [<ffffffff814fab69>] system_call_fastpath+0x16/0x1b
---[ end trace d5fe92190ef227d6 ]---
SysRq : Show Blocked State
  task                        PC stack   pid father
mount           D ffffffff81610340     0  2323   2254 0x00000080
 ffff880075989408 0000000000000082 ffff880076c454a0 0000000000013440
 ffff880075989fd8 ffff880075988010 0000000000013440 0000000000013440
 ffff880075989fd8 0000000000013440 ffff88007a45cb30 ffff880076c454a0
Call Trace:
 [<ffffffff814f2029>] schedule+0x29/0x70
 [<ffffffffa076af25>] btrfs_tree_lock+0xc5/0x2a0 [btrfs]
 [<ffffffff8106f850>] ? wake_up_bit+0x40/0x40
 [<ffffffffa070e16b>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
 [<ffffffffa0714e88>] btrfs_search_slot+0x758/0x960 [btrfs]
 [<ffffffffa0715b4d>] btrfs_insert_empty_items+0x8d/0xf0 [btrfs]
 [<ffffffffa07268a3>] insert_with_overflow+0x43/0x110 [btrfs]
 [<ffffffffa0726a4a>] btrfs_insert_dir_item+0xda/0x210 [btrfs]
 [<ffffffff8121f02b>] ? chksum_update+0x1b/0x30
 [<ffffffffa0737f74>] btrfs_add_link+0xe4/0x2f0 [btrfs]
 [<ffffffffa0755bb4>] ? free_extent_buffer+0x34/0x80 [btrfs]
 [<ffffffffa076f22d>] add_inode_ref+0x5ad/0x880 [btrfs]
 [<ffffffffa0771fc7>] replay_one_buffer+0x2a7/0x3b0 [btrfs]
 [<ffffffffa074700d>] ? btrfs_token_key_generation+0x5d/0xe0 [btrfs]
 [<ffffffffa076c31a>] walk_down_log_tree+0x23a/0x410 [btrfs]
 [<ffffffffa076c825>] walk_log_tree+0xb5/0x210 [btrfs]
 [<ffffffffa0770669>] btrfs_recover_log_trees+0x229/0x3e0 [btrfs]
 [<ffffffffa0771d20>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
 [<ffffffffa0730b08>] open_ctree+0x1598/0x1ae0 [btrfs]
 [<ffffffffa070bc94>] btrfs_mount+0x474/0x560 [btrfs]
 [<ffffffff811278be>] ? pcpu_next_pop+0x4e/0x70
 [<ffffffff81169ab3>] mount_fs+0x43/0x1a0
 [<ffffffff81129050>] ? __alloc_percpu+0x10/0x20
 [<ffffffff8118406a>] vfs_kern_mount+0x6a/0xf0
 [<ffffffff81184462>] do_kern_mount+0x52/0x110
 [<ffffffff811f3f98>] ? security_capable+0x18/0x20
 [<ffffffff81186355>] do_mount+0x255/0x7c0
 [<ffffffff8112390b>] ? memdup_user+0x4b/0x90
 [<ffffffff811239ab>] ? strndup_user+0x5b/0x80
 [<ffffffff81186950>] sys_mount+0x90/0xe0
 [<ffffffff814fab69>] system_call_fastpath+0x16/0x1b
btrfs-transacti D ffffffff81610340     0  2338      2 0x00000080
 ffff880079df1ae0 0000000000000046 ffff8800372ca100 0000000000013440
 ffff880079df1fd8 ffff880079df0010 0000000000013440 0000000000013440
 ffff880079df1fd8 0000000000013440 ffffffff81a13020 ffff8800372ca100
Call Trace:
 [<ffffffff814f2029>] schedule+0x29/0x70
 [<ffffffffa076af25>] btrfs_tree_lock+0xc5/0x2a0 [btrfs]
 [<ffffffff8106f850>] ? wake_up_bit+0x40/0x40
 [<ffffffffa070e16b>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
 [<ffffffffa0714e88>] btrfs_search_slot+0x758/0x960 [btrfs]
 [<ffffffffa072884f>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
 [<ffffffff814f08ce>] ? mutex_lock+0x1e/0x50
 [<ffffffffa0784931>] btrfs_update_delayed_inode+0x71/0x140 [btrfs]
 [<ffffffffa0784e0a>] btrfs_run_delayed_items+0x12a/0x160 [btrfs]
 [<ffffffffa0732aef>] btrfs_commit_transaction+0x36f/0xa70 [btrfs]
 [<ffffffffa0733592>] ? start_transaction+0x92/0x320 [btrfs]
 [<ffffffff8106f850>] ? wake_up_bit+0x40/0x40
 [<ffffffffa072e0fb>] transaction_kthread+0x26b/0x2e0 [btrfs]
 [<ffffffffa072de90>] ? btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
 [<ffffffffa072de90>] ? btrfs_destroy_marked_extents.clone.0+0x1f0/0x1f0 [btrfs]
 [<ffffffff8106f1ae>] kthread+0x9e/0xb0
 [<ffffffff814fbe64>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106f110>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff814fbe60>] ? gs_change+0x13/0x13

> thanks,
> liubo
> 
>> Finally, these patches are based off Linux v3.3.
>> 	--Mark
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

