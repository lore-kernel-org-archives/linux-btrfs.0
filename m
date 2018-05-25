Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbeEYDKi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 23:10:38 -0400
Subject: Re: [PATCH v3 1/3] btrfs: Move btrfs_check_super_valid() to avoid
 forward declaration
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
References: <20180511053527.28378-1-wqu@suse.com>
 <20180511053527.28378-2-wqu@suse.com>
 <72a2ebde-6aa3-297a-dcf8-a78a7760f8d1@oracle.com>
 <53341d88-597b-7617-ef2d-61effeba1802@gmx.com>
 <4e1024d1-9eed-31e4-f684-1a2cfa661c90@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <1fe28627-9f37-6e0c-e838-b1bd6ab7949d@oracle.com>
Date: Fri, 25 May 2018 11:13:05 +0800
MIME-Version: 1.0
In-Reply-To: <4e1024d1-9eed-31e4-f684-1a2cfa661c90@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/25/2018 10:59 AM, Qu Wenruo wrote:
> 
> 
> On 2018年05月25日 08:54, Qu Wenruo wrote:
>>
>>
>> On 2018年05月25日 00:24, Anand Jain wrote:
>>>
>>>
>>> On misc-next this patch is causing regression, the seed sprout
>>> functionality test [1] (in the mailing list) fails.
>>>
>>>   [1]
>>>   [PATCH] fstests: btrfs: add seed sprout functionality test
>>>
>>> more below..
>>>
>>> On 05/11/2018 01:35 PM, Qu Wenruo wrote:
>>>> Just move btrfs_check_super_valid() before its single caller to avoid
>>>> forward declaration.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>    fs/btrfs/disk-io.c | 299 ++++++++++++++++++++++-----------------------
>>>>    1 file changed, 149 insertions(+), 150 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index 932ed61d9554..13c5f90995aa 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -55,7 +55,6 @@
>>>>    static const struct extent_io_ops btree_extent_io_ops;
>>>>    static void end_workqueue_fn(struct btrfs_work *work);
>>>>    static void free_fs_root(struct btrfs_root *root);
>>>> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
>>>>    static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
>>>>    static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
>>>>                          struct btrfs_fs_info *fs_info);
>>>> @@ -2441,6 +2440,155 @@ static int btrfs_read_roots(struct
>>>> btrfs_fs_info *fs_info)
>>>>        return ret;
>>>>    }
>>>>    +static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>>>> +{
>>>> +    struct btrfs_super_block *sb = fs_info->super_copy;
>>>> +    u64 nodesize = btrfs_super_nodesize(sb);
>>>> +    u64 sectorsize = btrfs_super_sectorsize(sb);
>>>> +    int ret = 0;
>>>> +
>>>> +    if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
>>>> +        btrfs_err(fs_info, "no valid FS found");
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP) {
>>>> +        btrfs_err(fs_info, "unrecognized or unsupported super flag:
>>>> %llu",
>>>> +                btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
>>>> +        btrfs_err(fs_info, "tree_root level too big: %d >= %d",
>>>> +                btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (btrfs_super_chunk_root_level(sb) >= BTRFS_MAX_LEVEL) {
>>>> +        btrfs_err(fs_info, "chunk_root level too big: %d >= %d",
>>>> +                btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (btrfs_super_log_root_level(sb) >= BTRFS_MAX_LEVEL) {
>>>> +        btrfs_err(fs_info, "log_root level too big: %d >= %d",
>>>> +                btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +
>>>> +    /*
>>>> +     * Check sectorsize and nodesize first, other check will need it.
>>>> +     * Check all possible sectorsize(4K, 8K, 16K, 32K, 64K) here.
>>>> +     */
>>>> +    if (!is_power_of_2(sectorsize) || sectorsize < 4096 ||
>>>> +        sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE) {
>>>> +        btrfs_err(fs_info, "invalid sectorsize %llu", sectorsize);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    /* Only PAGE SIZE is supported yet */
>>>> +    if (sectorsize != PAGE_SIZE) {
>>>> +        btrfs_err(fs_info,
>>>> +            "sectorsize %llu not supported yet, only support %lu",
>>>> +            sectorsize, PAGE_SIZE);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (!is_power_of_2(nodesize) || nodesize < sectorsize ||
>>>> +        nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
>>>> +        btrfs_err(fs_info, "invalid nodesize %llu", nodesize);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (nodesize != le32_to_cpu(sb->__unused_leafsize)) {
>>>> +        btrfs_err(fs_info, "invalid leafsize %u, should be %llu",
>>>> +              le32_to_cpu(sb->__unused_leafsize), nodesize);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +
>>>> +    /* Root alignment check */
>>>> +    if (!IS_ALIGNED(btrfs_super_root(sb), sectorsize)) {
>>>> +        btrfs_warn(fs_info, "tree_root block unaligned: %llu",
>>>> +               btrfs_super_root(sb));
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (!IS_ALIGNED(btrfs_super_chunk_root(sb), sectorsize)) {
>>>> +        btrfs_warn(fs_info, "chunk_root block unaligned: %llu",
>>>> +               btrfs_super_chunk_root(sb));
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (!IS_ALIGNED(btrfs_super_log_root(sb), sectorsize)) {
>>>> +        btrfs_warn(fs_info, "log_root block unaligned: %llu",
>>>> +               btrfs_super_log_root(sb));
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +
>>>> +    if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_FSID_SIZE) !=
>>>> 0) {
>>>> +        btrfs_err(fs_info,
>>>> +               "dev_item UUID does not match fsid: %pU != %pU",
>>>> +               fs_info->fsid, sb->dev_item.fsid);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>
>>>
>>> No. Not all devices will have the same fsid in case of seed-sprout
>>> mounted devices.
>>
>> Yes, for seed device it's possible that seed device has different fsid.
>>
>> But the problem here is, for seed device, it shouldn't get modified.
>> Thus its super block shouldn't get updated and written.
>>
>> Or did I miss something?
> 
> OK, the problem is that we're using the old super block copy from seed
> device.
> 
> The timming of checking superblock should be called after we have set
> dev_item/fsid correct.


  Yep further below. We don't write superblock at all to the seed device
  as its readonly device.
----------------
write_all_supers()

::
         list_for_each_entry(dev, head, dev_list) {
                 if (!dev->bdev) {
                         total_errors++;
                         continue;
                 }
                 if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, 
&dev->dev_state) ||
                     !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
                         continue;

::
                 ret = write_dev_supers(dev, sb, max_mirrors);
                 if (ret)
                         total_errors++;
----------------


Thanks, Anand

> I'll update the patchset to handle it.
> 
> Thanks,
> Qu
> 
>>
>> Thanks,
>> Qu
>>
>>>
>>> [55090.664841] BTRFS error (device sdc): dev_item UUID does not match
>>> fsid: 994fd365-9baf-4cbc-bcb2-ac65cba6a183 !=
>>> 2f459b44-def5-45d6-aa39-60d7d2350a6e
>>> [55090.698052] BTRFS error (device sdc): super block corruption detected
>>> before writing it to disk
>>> [55090.700661] BTRFS warning (device sdc): Skipping commit of aborted
>>> transaction.
>>> [55090.701914] ------------[ cut here ]------------
>>> [55090.702751] BTRFS: Transaction aborted (error -22)
>>> [55090.703644] WARNING: CPU: 1 PID: 14960 at fs/btrfs/transaction.c:1836
>>> cleanup_transaction+0x8a/0x270 [btrfs]
>>> [55090.704597] Modules linked in: btrfs xor zstd_decompress
>>> zstd_compress xxhash raid6_pq [last unloaded: xor]
>>> [55090.704597] CPU: 1 PID: 14960 Comm: btrfs Tainted: G        W
>>> 4.17.0-rc6+ #52
>>> [55090.704597] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
>>> VirtualBox 12/01/2006
>>> [55090.704597] RIP: 0010:cleanup_transaction+0x8a/0x270 [btrfs]
>>> [55090.704597] RSP: 0000:ffffa94a0155bb88 EFLAGS: 00010286
>>> [55090.704597] RAX: 0000000000000000 RBX: ffff9ec4d7ad4000 RCX:
>>> 0000000000000000
>>> [55090.704597] RDX: ffff9ec4dfd1d1f0 RSI: ffff9ec4dfd154b8 RDI:
>>> ffff9ec4dfd154b8
>>> [55090.704597] RBP: ffff9ec4da2dfe00 R08: 00000000000008af R09:
>>> 0000000000000000
>>> [55090.704597] R10: ffffa94a0155bc10 R11: ffffffff92d977ad R12:
>>> ffff9ec4d2c58410
>>> [55090.704597] R13: 00000000ffffffea R14: 00000000ffffffea R15:
>>> ffff9ec4d7ad4778
>>> [55090.704597] FS:  00007f7ead00d8c0(0000) GS:ffff9ec4dfd00000(0000)
>>> knlGS:0000000000000000
>>> [55090.704597] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [55090.704597] CR2: 00005565919f7ab0 CR3: 0000000117b12004 CR4:
>>> 00000000000606e0
>>> [55090.704597] Call Trace:
>>> [55090.704597]  ? wait_woken+0x80/0x80
>>> [55090.704597]  btrfs_commit_transaction+0x71a/0x8b0 [btrfs]
>>> [55090.704597]  ? kobject_rename+0x112/0x150
>>> [55090.704597]  btrfs_init_new_device+0xa64/0xf60 [btrfs]
>>> [55090.704597]  ? unlazy_walk+0x32/0xa0
>>> [55090.704597]  ? btrfs_ioctl+0xde2/0x25d0 [btrfs]
>>> [55090.704597]  btrfs_ioctl+0xde2/0x25d0 [btrfs]
>>> [55090.704597]  ? selinux_inode_getattr+0x71/0x90
>>> [55090.704597]  ? _copy_to_user+0x22/0x30
>>> [55090.704597]  ? cp_new_stat+0x12c/0x160
>>> [55090.704597]  ? do_vfs_ioctl+0xa1/0x600
>>> [55090.704597]  ? proc_kprobes_optimization_handler+0x17a/0x1a0
>>> [55090.704597]  do_vfs_ioctl+0xa1/0x600
>>> [55090.704597]  ksys_ioctl+0x70/0x80
>>> [55090.704597]  __x64_sys_ioctl+0x16/0x20
>>> [55090.704597]  do_syscall_64+0x42/0xf0
>>> [55090.704597]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> [55090.704597] RIP: 0033:0x7f7eac0ae277
>>> [55090.704597] RSP: 002b:00007ffd85a76958 EFLAGS: 00000206 ORIG_RAX:
>>> 0000000000000010
>>> [55090.704597] RAX: ffffffffffffffda RBX: 00007ffd85a77b38 RCX:
>>> 00007f7eac0ae277
>>> [55090.704597] RDX: 00007ffd85a769a0 RSI: 000000005000940a RDI:
>>> 0000000000000003
>>> [55090.704597] RBP: 0000000000000001 R08: 0000000000000000 R09:
>>> 0000000000001011
>>> [55090.704597] R10: 000000000000018f R11: 0000000000000206 R12:
>>> 0000000000000000
>>> [55090.704597] R13: 0000000000000002 R14: 000000000209e290 R15:
>>> 00007ffd85a77b40
>>> [55090.704597] Code: 38 83 f8 01 0f 87 f5 01 00 00 f0 48 0f ba ab 88 0c
>>> 00 00 02 72 17 41 83 fd fb 74 11 44 89 ee 48 c7 c7 18 7b 1e c0 e8 e6 e6
>>> 10 d1 <0f> 0b 44 89 e9 4c 8d ab 70 07 00 00 ba 2c 07 00 00 48 c7 c6 f0
>>> [55090.704597] ---[ end trace 09b3c3dd4f060772 ]---
>>> [55090.753144] BTRFS: error (device sdc) in cleanup_transaction:1836:
>>> errno=-22 unknown
>>> [55090.761076] BTRFS info (device sdc): forced readonly
>>> [55090.767639] BTRFS info (device sdc): delayed_refs has NO entry
>>> [55090.854114] umount btrfs dev=sdb s_active=2 dir=runner
>>> [55090.875108] umount btrfs dev=sdc s_active=2 dir=scratch
>>> [55090.892160] BTRFS error (device sdc): cleaner transaction attach
>>> returned -30
>>>
>>>
>>> Thanks, Anand
>>>
>>>
>>>> +    /*
>>>> +     * Hint to catch really bogus numbers, bitflips or so, more exact
>>>> checks are
>>>> +     * done later
>>>> +     */
>>>> +    if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
>>>> +        btrfs_err(fs_info, "bytes_used is too small %llu",
>>>> +              btrfs_super_bytes_used(sb));
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (!is_power_of_2(btrfs_super_stripesize(sb))) {
>>>> +        btrfs_err(fs_info, "invalid stripesize %u",
>>>> +              btrfs_super_stripesize(sb));
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (btrfs_super_num_devices(sb) > (1UL << 31))
>>>> +        btrfs_warn(fs_info, "suspicious number of devices: %llu",
>>>> +               btrfs_super_num_devices(sb));
>>>> +    if (btrfs_super_num_devices(sb) == 0) {
>>>> +        btrfs_err(fs_info, "number of devices is 0");
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +
>>>> +    if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
>>>> +        btrfs_err(fs_info, "super offset mismatch %llu != %u",
>>>> +              btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +
>>>> +    /*
>>>> +     * Obvious sys_chunk_array corruptions, it must hold at least one
>>>> key
>>>> +     * and one chunk
>>>> +     */
>>>> +    if (btrfs_super_sys_array_size(sb) >
>>>> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
>>>> +        btrfs_err(fs_info, "system chunk array too big %u > %u",
>>>> +              btrfs_super_sys_array_size(sb),
>>>> +              BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +    if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
>>>> +            + sizeof(struct btrfs_chunk)) {
>>>> +        btrfs_err(fs_info, "system chunk array too small %u < %zu",
>>>> +              btrfs_super_sys_array_size(sb),
>>>> +              sizeof(struct btrfs_disk_key)
>>>> +              + sizeof(struct btrfs_chunk));
>>>> +        ret = -EINVAL;
>>>> +    }
>>>> +
>>>> +    /*
>>>> +     * The generation is a global counter, we'll trust it more than
>>>> the others
>>>> +     * but it's still possible that it's the one that's wrong.
>>>> +     */
>>>> +    if (btrfs_super_generation(sb) <
>>>> btrfs_super_chunk_root_generation(sb))
>>>> +        btrfs_warn(fs_info,
>>>> +            "suspicious: generation < chunk_root_generation: %llu <
>>>> %llu",
>>>> +            btrfs_super_generation(sb),
>>>> +            btrfs_super_chunk_root_generation(sb));
>>>> +    if (btrfs_super_generation(sb) < btrfs_super_cache_generation(sb)
>>>> +        && btrfs_super_cache_generation(sb) != (u64)-1)
>>>> +        btrfs_warn(fs_info,
>>>> +            "suspicious: generation < cache_generation: %llu < %llu",
>>>> +            btrfs_super_generation(sb),
>>>> +            btrfs_super_cache_generation(sb));
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>>    int open_ctree(struct super_block *sb,
>>>>               struct btrfs_fs_devices *fs_devices,
>>>>               char *options)
>>>> @@ -3972,155 +4120,6 @@ int btrfs_read_buffer(struct extent_buffer
>>>> *buf, u64 parent_transid, int level,
>>>>                              level, first_key);
>>>>    }
>>>>    -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
>>>> -{
>>>> -    struct btrfs_super_block *sb = fs_info->super_copy;
>>>> -    u64 nodesize = btrfs_super_nodesize(sb);
>>>> -    u64 sectorsize = btrfs_super_sectorsize(sb);
>>>> -    int ret = 0;
>>>> -
>>>> -    if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
>>>> -        btrfs_err(fs_info, "no valid FS found");
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP) {
>>>> -        btrfs_err(fs_info, "unrecognized or unsupported super flag:
>>>> %llu",
>>>> -                btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
>>>> -        btrfs_err(fs_info, "tree_root level too big: %d >= %d",
>>>> -                btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (btrfs_super_chunk_root_level(sb) >= BTRFS_MAX_LEVEL) {
>>>> -        btrfs_err(fs_info, "chunk_root level too big: %d >= %d",
>>>> -                btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (btrfs_super_log_root_level(sb) >= BTRFS_MAX_LEVEL) {
>>>> -        btrfs_err(fs_info, "log_root level too big: %d >= %d",
>>>> -                btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -
>>>> -    /*
>>>> -     * Check sectorsize and nodesize first, other check will need it.
>>>> -     * Check all possible sectorsize(4K, 8K, 16K, 32K, 64K) here.
>>>> -     */
>>>> -    if (!is_power_of_2(sectorsize) || sectorsize < 4096 ||
>>>> -        sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE) {
>>>> -        btrfs_err(fs_info, "invalid sectorsize %llu", sectorsize);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    /* Only PAGE SIZE is supported yet */
>>>> -    if (sectorsize != PAGE_SIZE) {
>>>> -        btrfs_err(fs_info,
>>>> -            "sectorsize %llu not supported yet, only support %lu",
>>>> -            sectorsize, PAGE_SIZE);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (!is_power_of_2(nodesize) || nodesize < sectorsize ||
>>>> -        nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
>>>> -        btrfs_err(fs_info, "invalid nodesize %llu", nodesize);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (nodesize != le32_to_cpu(sb->__unused_leafsize)) {
>>>> -        btrfs_err(fs_info, "invalid leafsize %u, should be %llu",
>>>> -              le32_to_cpu(sb->__unused_leafsize), nodesize);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -
>>>> -    /* Root alignment check */
>>>> -    if (!IS_ALIGNED(btrfs_super_root(sb), sectorsize)) {
>>>> -        btrfs_warn(fs_info, "tree_root block unaligned: %llu",
>>>> -               btrfs_super_root(sb));
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (!IS_ALIGNED(btrfs_super_chunk_root(sb), sectorsize)) {
>>>> -        btrfs_warn(fs_info, "chunk_root block unaligned: %llu",
>>>> -               btrfs_super_chunk_root(sb));
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (!IS_ALIGNED(btrfs_super_log_root(sb), sectorsize)) {
>>>> -        btrfs_warn(fs_info, "log_root block unaligned: %llu",
>>>> -               btrfs_super_log_root(sb));
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -
>>>> -    if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_FSID_SIZE) !=
>>>> 0) {
>>>> -        btrfs_err(fs_info,
>>>> -               "dev_item UUID does not match fsid: %pU != %pU",
>>>> -               fs_info->fsid, sb->dev_item.fsid);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -
>>>> -    /*
>>>> -     * Hint to catch really bogus numbers, bitflips or so, more exact
>>>> checks are
>>>> -     * done later
>>>> -     */
>>>> -    if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_nodesize(sb)) {
>>>> -        btrfs_err(fs_info, "bytes_used is too small %llu",
>>>> -              btrfs_super_bytes_used(sb));
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (!is_power_of_2(btrfs_super_stripesize(sb))) {
>>>> -        btrfs_err(fs_info, "invalid stripesize %u",
>>>> -              btrfs_super_stripesize(sb));
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (btrfs_super_num_devices(sb) > (1UL << 31))
>>>> -        btrfs_warn(fs_info, "suspicious number of devices: %llu",
>>>> -               btrfs_super_num_devices(sb));
>>>> -    if (btrfs_super_num_devices(sb) == 0) {
>>>> -        btrfs_err(fs_info, "number of devices is 0");
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -
>>>> -    if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
>>>> -        btrfs_err(fs_info, "super offset mismatch %llu != %u",
>>>> -              btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -
>>>> -    /*
>>>> -     * Obvious sys_chunk_array corruptions, it must hold at least one
>>>> key
>>>> -     * and one chunk
>>>> -     */
>>>> -    if (btrfs_super_sys_array_size(sb) >
>>>> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
>>>> -        btrfs_err(fs_info, "system chunk array too big %u > %u",
>>>> -              btrfs_super_sys_array_size(sb),
>>>> -              BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -    if (btrfs_super_sys_array_size(sb) < sizeof(struct btrfs_disk_key)
>>>> -            + sizeof(struct btrfs_chunk)) {
>>>> -        btrfs_err(fs_info, "system chunk array too small %u < %zu",
>>>> -              btrfs_super_sys_array_size(sb),
>>>> -              sizeof(struct btrfs_disk_key)
>>>> -              + sizeof(struct btrfs_chunk));
>>>> -        ret = -EINVAL;
>>>> -    }
>>>> -
>>>> -    /*
>>>> -     * The generation is a global counter, we'll trust it more than
>>>> the others
>>>> -     * but it's still possible that it's the one that's wrong.
>>>> -     */
>>>> -    if (btrfs_super_generation(sb) <
>>>> btrfs_super_chunk_root_generation(sb))
>>>> -        btrfs_warn(fs_info,
>>>> -            "suspicious: generation < chunk_root_generation: %llu <
>>>> %llu",
>>>> -            btrfs_super_generation(sb),
>>>> -            btrfs_super_chunk_root_generation(sb));
>>>> -    if (btrfs_super_generation(sb) < btrfs_super_cache_generation(sb)
>>>> -        && btrfs_super_cache_generation(sb) != (u64)-1)
>>>> -        btrfs_warn(fs_info,
>>>> -            "suspicious: generation < cache_generation: %llu < %llu",
>>>> -            btrfs_super_generation(sb),
>>>> -            btrfs_super_cache_generation(sb));
>>>> -
>>>> -    return ret;
>>>> -}
>>>> -
>>>>    static void btrfs_error_commit_super(struct btrfs_fs_info *fs_info)
>>>>    {
>>>>        mutex_lock(&fs_info->cleaner_mutex);
>>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
