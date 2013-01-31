Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32469 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab3AaHnw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 02:43:52 -0500
Message-ID: <510A20E0.30601@cn.fujitsu.com>
Date: Thu, 31 Jan 2013 15:44:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at fs/btrfs/async-thread.c:605!
References: <5109E70D.3010005@jp.fujitsu.com> <510A0756.40206@redhat.com>
In-Reply-To: <510A0756.40206@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 30 Jan 2013 23:55:34 -0600, Eric Sandeen wrote:
>> ===================================================================================
>>
>> [ 7913.075890] btrfs: allowing degraded mounts
>> [ 7913.075893] btrfs: disk space caching is enabled
>> [ 7913.092031] Btrfs: too many missing devices, writeable mount is not allowed
> 
> so this was supposed to fail the mount in open_ctree; it jumps to shutting down
> the worker threads.  Which might result in no threads available.
> 
>> [ 7913.092297] ------------[ cut here ]------------
>> [ 7913.092313] kernel BUG at fs/btrfs/async-thread.c:605!
>> [ 7913.092326] invalid opcode: 0000 [#1] SMP
>> [ 7913.092342] Modules linked in: btrfs zlib_deflate crc32c libcrc32c nfsd lockd nfs_acl auth_rpcgss sunrpc 8021q garp stp llc cpufreq_ondemand cachefiles fscache ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod uinput ppdev iTCO_wdt iTCO_vendor_support parport_pc parport sg acpi_cpufreq freq_table mperf coretemp kvm pcspkr i2c_i801 i2c_core lpc_ich mfd_core tg3 ptp pps_core shpchp pci_hotplug i3000_edac edac_core ext4 mbcache jbd2 crc16 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_piix libata megaraid_sas scsi_mod floppy [last unloaded: microcode]
>> [ 7913.092575] CPU 0
>> [ 7913.092584] Pid: 3673, comm: btrfs-endio-wri Not tainted 3.8.0-rc5 #1 FUJITSU-SV      PRIMERGY            /D2399
>> [ 7913.092608] RIP: 0010:[<ffffffffa04670ef>]  [<ffffffffa04670ef>] btrfs_queue_worker+0x10e/0x236 [btrfs]
> 
> but this is already trying to do work, and has no workers to handle it.
> 
> The place we jump to is fail_block_groups, and before it is this comment:
> 
>         /*      
>          * make sure we're done with the btree inode before we stop our
>          * kthreads
>          */
>         filemap_write_and_wait(fs_info->btree_inode->i_mapping);
>         invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>                                                
> fail_block_groups:
>         btrfs_free_block_groups(fs_info);
> 
> if you move the fail_block_groups: target above the comment, does that fix it?
> (although I don't know yet what started IO . . . )

Reading the metadata of the tree root and Reading block group information started IO.
so, I think this patch can fix the problem.

> like this:
> 
> From: Eric Sandeen <sandeen@redhat.com>
> 
> Make sure that we are always done with the btree_inode's mapping
> before we shut down the worker threads in open_ctree() error
> cases.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com> 
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index d89da40..1e2abda 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2689,6 +2689,7 @@ fail_trans_kthread:
>  fail_cleaner:
>  	kthread_stop(fs_info->cleaner_kthread);
>  
> +fail_block_groups:
>  	/*
>  	 * make sure we're done with the btree inode before we stop our
>  	 * kthreads
> @@ -2696,7 +2697,6 @@ fail_cleaner:
>  	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
>  	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>  
> -fail_block_groups:
>  	btrfs_free_block_groups(fs_info);
>  
>  fail_tree_roots:
> 
> Just a guess; but I don't know what would have started writes already...

I don't think it was write IO. It was just a soft interrupt caused by a metadata read IO,
and this soft interrupt happened while btrfs-endio-write-workers was going to stop.

Thanks
Miao
