Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36003 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752386AbdJSN0Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 09:26:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 958B6AAEF
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 13:26:23 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] btrfs: Fix transaction abort during failure in
 btrfs_rm_dev_item
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <1506509327-18862-1-git-send-email-nborisov@suse.com>
 <1506588327-6616-1-git-send-email-nborisov@suse.com>
 <1506588327-6616-2-git-send-email-nborisov@suse.com>
 <20171019115457.GI3521@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <43400700-c74e-c6b0-0bdc-a777791edd09@suse.com>
Date: Thu, 19 Oct 2017 16:26:22 +0300
MIME-Version: 1.0
In-Reply-To: <20171019115457.GI3521@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.10.2017 14:54, David Sterba wrote:
> On Thu, Sep 28, 2017 at 11:45:27AM +0300, Nikolay Borisov wrote:
>> btrfs_rm_dev_item calls several function under an activa transaction, however
>> it fails to abort it if an error happens. Fix this by adding explicit
>> btrfs_abort_transaction/btrfs_end_transaction calls
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>
>> v2: 
>>  * Explicitly handle every failure case w.r.t transaction abort rather than 
>>  rely on final btrfs_commit_transaction() to do the right thing. 
>>
>>  * Also consider the -ENOENT case from btrfs_search_slot as a failure.
>>
>>  fs/btrfs/volumes.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 0e8f16c305df..4709c7919ef2 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1765,20 +1765,29 @@ static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
>>  	key.offset = device->devid;
>>  
>>  	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>> -	if (ret < 0)
>> +	if (ret < 0) {
>> +		btrfs_abort_transaction(trans, ret);
>> +		btrfs_end_transaction(trans);
>>  		goto out;
>> +	}
>>  
>>  	if (ret > 0) {
>>  		ret = -ENOENT;
>> +		btrfs_abort_transaction(trans, ret);
>> +		btrfs_end_transaction(trans);
>>  		goto out;
>>  	}
>>  
>>  	ret = btrfs_del_item(trans, root, path);
>> -	if (ret)
>> +	if (ret) {
>> +		btrfs_abort_transaction(trans, ret);
>> +		btrfs_end_transaction(trans);
>>  		goto out;
>> +	}
>> +
>> +	ret = btrfs_commit_transaction(trans);
>>  out:
>>  	btrfs_free_path(path);
>> -	btrfs_commit_transaction(trans);
>>  	return ret;
> 
> This is wrong and I don't know why. I've painfully bisected to this
> commit that causes a lockup of test btrfs/101. I'm going to remove it from
> misc-next.


Just had a call with Jeff and he suggested it might be due to the path
holding locks. Looking around the code it seems that indeed path is
first being freed everytime before a transaction is committed.

> 
> [ 3845.295346] run fstests btrfs/101 at 2017-10-19 02:51:17
> [ 3864.988027] BTRFS: device fsid 9c721da4-271d-4499-8c1d-77ccb5e611a3 devid 1 transid 5 /dev/sda5
> [ 3864.997284] BTRFS: device fsid 9c721da4-271d-4499-8c1d-77ccb5e611a3 devid 2 transid 5 /dev/sdb7
> [ 3865.007986] BTRFS: device fsid 9c721da4-271d-4499-8c1d-77ccb5e611a3 devid 3 transid 5 /dev/mapper/error-test
> [ 3865.040554] BTRFS info (device dm-0): disk space caching is enabled
> [ 3865.040559] BTRFS info (device dm-0): has skinny extents
> [ 3865.040563] BTRFS info (device dm-0): flagging fs with big metadata feature
> [ 3865.053175] BTRFS info (device dm-0): creating UUID tree
> [ 3910.214683] BTRFS info (device dm-0): relocating block group 29360128 flags metadata|raid1
> [ 3910.252405] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
> [ 3910.263339] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
> [ 3910.273859] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
> [ 3910.274053] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
> [ 3910.274178] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
> [ 3910.326212] BTRFS warning (device dm-0): lost page write due to IO error on /dev/mapper/error-test
> [ 3910.335684] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
> [ 3910.346135] BTRFS warning (device dm-0): lost page write due to IO error on /dev/mapper/error-test
> [ 3910.355378] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
> [ 3912.082763] BTRFS warning (device dm-0): lost page write due to IO error on /dev/mapper/error-test
> [ 3912.092300] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
> [ 3912.102690] BTRFS warning (device dm-0): lost page write due to IO error on /dev/mapper/error-test
> [ 3912.112326] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
> [ 3913.778330] BTRFS warning (device dm-0): lost page write due to IO error on /dev/mapper/error-test
> [ 3913.787814] BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
> [ 3913.798292] BTRFS warning (device dm-0): lost page write due to IO error on /dev/mapper/error-test
> [ 3913.990997] BTRFS info (device dm-0): found 1675 extents
> [ 3914.048231] BTRFS warning (device dm-0): lost page write due to IO error on /dev/mapper/error-test
> [ 3914.059503] BTRFS warning (device dm-0): lost page write due to IO error on /dev/mapper/error-test
> [ 3914.191222] BTRFS warning (device dm-0): lost page write due to IO error on /dev/mapper/error-test
> [ 3914.200609] BTRFS warning (device dm-0): lost page write due to IO error on /dev/mapper/error-test
> [ 3914.303028] BTRFS info (device dm-0): relocating block group 20971520 flags system|raid1
> [ 3914.599728] BTRFS info (device dm-0): found 1 extents
> [ 3914.896900] ------------[ cut here ]------------
> [ 3914.902180] WARNING: CPU: 7 PID: 7055 at fs/btrfs/locking.c:251 btrfs_tree_lock+0x227/0x240 [btrfs]
> [ 3914.911509] Modules linked in: btrfs rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc fscache af_packet br_netfilter bridge
>  stp llc iscsi_ibft iscsi_boot_sysfs i2c_algo_bit drm_kms_helper xor zstd_decompress zstd_compress syscopyarea sysfillrect sysimgblt xxhash zlib_de
> flate fb_sys_fops raid6_pq ttm drm dm_mod dax kvm_amd tg3 ptp tpm_infineon pps_core kvm libphy mptctl shpchp i2c_piix4 k10temp irqbypass tpm_tis tp
> m_tis_core button tpm acpi_cpufreq pcspkr ext4 mbcache jbd2 sr_mod cdrom ohci_pci ehci_pci ohci_hcd mptsas ehci_hcd scsi_transport_sas mptscsih ata
> _generic serio_raw mptbase sata_svw usbcore pata_serverworks sg scsi_dh_rdac scsi_dh_emc scsi_dh_alua [last unloaded: btrfs]
> [ 3914.911678] CPU: 7 PID: 7055 Comm: btrfs Not tainted 4.14.0-rc5-1.ge195904-vanilla+ #76
> [ 3914.911680] Hardware name: empty empty/S3993, BIOS PAQEX0-3 02/24/2008
> [ 3914.911683] task: ffff8df45686c740 task.stack: ffffbaf18229c000
> [ 3914.911716] RIP: 0010:btrfs_tree_lock+0x227/0x240 [btrfs]
> [ 3914.911718] RSP: 0018:ffffbaf18229f998 EFLAGS: 00010246
> [ 3914.911722] RAX: 0000000000001b8f RBX: ffff8df43daa4000 RCX: ffffbaf18229f9dc
> [ 3914.911724] RDX: 0000000000000001 RSI: ffff8df456488000 RDI: ffff8df43daa4000
> [ 3914.911726] RBP: ffffbaf18229f9e0 R08: 0000000000000000 R09: 0000000000000000
> [ 3914.911728] R10: 000000005cf6aada R11: 0000000000000000 R12: ffff8df456488000
> [ 3914.911729] R13: ffff8df43daa4000 R14: ffffbaf18229faa8 R15: 0000000000000001
> [ 3914.911732] FS:  00007f83102308c0(0000) GS:ffff8df46fdc0000(0000) knlGS:0000000000000000
> [ 3914.911741] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3914.911743] CR2: 00007fe34f6b2078 CR3: 0000000154682000 CR4: 00000000000006e0
> [ 3914.911745] Call Trace:
> [ 3914.911782]  ? btree_write_cache_pages+0x241/0x430 [btrfs]
> [ 3914.911831]  lock_extent_buffer_for_io+0x1f9/0x220 [btrfs]
> [ 3914.911891]  btree_write_cache_pages+0x257/0x430 [btrfs]
> [ 3914.911923]  ? wbc_attach_and_unlock_inode+0x198/0x2a0
> [ 3914.911966]  btree_writepages+0x5d/0x70 [btrfs]
> [ 3914.911982]  do_writepages+0x1c/0x80
> [ 3914.911987]  __filemap_fdatawrite_range+0xaa/0xe0
> [ 3914.911998]  filemap_fdatawrite_range+0x13/0x20
> [ 3914.912034]  btrfs_write_marked_extents+0x107/0x140 [btrfs]
> [ 3914.912076]  btrfs_write_and_wait_transaction.isra.19+0x3d/0x80 [btrfs]
> [ 3914.912109]  btrfs_commit_transaction+0x66e/0xa30 [btrfs]
> [ 3914.912156]  btrfs_rm_device+0x37f/0x660 [btrfs]
> [ 3914.912307]  ? btrfs_ioctl+0x1571/0x22b0 [btrfs]
> [ 3914.912341]  btrfs_ioctl+0x1571/0x22b0 [btrfs]
> [ 3914.912348]  ? find_held_lock+0x35/0xa0
> [ 3914.912357]  ? __audit_syscall_entry+0xb5/0x110
> [ 3914.912363]  ? current_kernel_time64+0x69/0xd0
> [ 3914.912369]  ? trace_hardirqs_on_caller+0xf9/0x190
> [ 3914.912378]  do_vfs_ioctl+0x96/0x680
> [ 3914.912383]  ? __audit_syscall_entry+0xb5/0x110
> [ 3914.912390]  ? syscall_trace_enter+0x1b6/0x370
> [ 3914.912397]  SyS_ioctl+0x79/0x90
> [ 3914.912404]  do_syscall_64+0x69/0x180
> [ 3914.912412]  entry_SYSCALL64_slow_path+0x25/0x25
> [ 3914.912417] RIP: 0033:0x7f830f2ca4b7
> [ 3914.912420] RSP: 002b:00007ffec1bb12a8 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
> [ 3914.912428] RAX: ffffffffffffffda RBX: 00007ffec1bb3450 RCX: 00007f830f2ca4b7
> [ 3914.912431] RDX: 00007ffec1bb22e0 RSI: 000000005000943a RDI: 0000000000000004
> [ 3914.912435] RBP: 00007ffec1bb22e0 R08: 00007f830f585f20 R09: 00007ffec1bb5504
> [ 3914.912439] R10: 000000000fa99fa0 R11: 0000000000000202 R12: 0000000000000001
> [ 3914.912442] R13: 0000000000000000 R14: 0000000000000004 R15: 00007ffec1bb3458
> [ 3914.912537] ---[ end trace fe16d3a2b91aff39 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
