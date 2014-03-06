Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.mystoragebox.com ([173.234.39.99]:46517 "EHLO
	mail.mystoragebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaCFQwm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Mar 2014 11:52:42 -0500
Message-ID: <5318A6C5.8040309@intellasoft.net>
Date: Thu, 06 Mar 2014 11:48:05 -0500
From: Mark Murawski <markm-lists@intellasoft.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: Task Hang
References: <5315E105.3000003@intellasoft.net> <5315EA04.5010303@fb.com>
In-Reply-To: <5315EA04.5010303@fb.com>
Content-Type: multipart/mixed;
 boundary="------------060604090200000707010005"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060604090200000707010005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Not the same problem, but I do have a lockup with another situation.

I tried adding some new devices... but accidentally screwed up the 
syntax (not sure if this had anything to do with the lockup)

btrfs device add / /dev/sdb
probe of / failed, cannot detect existing filesystem.
Use the -f option to force overwrite.

office-backup {~} root# btrfs device add /dev/sdb /dev/sdd
ERROR: error adding the device '/dev/sdb' - Inappropriate ioctl for device


D  1772 [btrfs-transacti]
D  6530 [btrfs-submit-2]
D  7301 /usr/bin/perl /usr/share/backuppc/bin/BackupPC_link demo3
D  7471 fdisk /dev/sdb
D  7523 [btrfs-submit-2]
D  7526 -bash
D  7527 -bash
D 28611 /usr/bin/perl /usr/share/backuppc/bin/BackupPC_trashClean

Attached is output from w to sysrq



On 03/04/2014 09:58 AM, Josef Bacik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 03/04/2014 09:19 AM, Mark Murawski wrote:
>> I have btrfs as the fs for a backuppc box.  updatedb was running at
>> the same time as a massive rsync.
>>
>> Mar  4 08:31:00 office-backup kernel: INFO: task
>> updatedb.mlocat:903 blocked for more than 120 seconds. Mar  4
>> 08:31:00 office-backup kernel:      Not tainted 3.13.2 #3 Mar  4
>> 08:31:00 office-backup kernel: "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message. Mar
>> 4 08:31:00 office-backup kernel: updatedb.mlocat D
>> 0000000000000000 0   903    899 0x00000000 Mar  4 08:31:00
>> office-backup kernel: ffff88007cad6270 0000000000000086
>> ffff88007c0ee900 0000000000004000 Mar  4 08:31:00 office-backup
>> kernel: ffff88005a705fd8 ffff88007cad6270 000000541a6be000
>> ffff88007b9ac000 Mar  4 08:31:00 office-backup kernel:
>> ffff88001ad2ef68 ffff880001f97000 ffff8800452d4480
>> ffffffff812c3e5c Mar  4 08:31:00 office-backup kernel: Call Trace:
>> Mar  4 08:31:00 office-backup kernel: [<ffffffff812c3e5c>] ?
>> btrfs_map_bio+0x4ac/0x5a0 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff812b79c0>] ? repair_io_failure+0x210/0x210 Mar  4
>> 08:31:00 office-backup kernel: [<ffffffff810d9a40>] ?
>> __lock_page+0x70/0x70 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff817b8177>] ? io_schedule+0x87/0xd0 Mar  4 08:31:00
>> office-backup kernel: [<ffffffff810d9a49>] ?
>> sleep_on_page+0x9/0x10 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff817b8742>] ? __wait_on_bit+0x52/0x80 Mar  4 08:31:00
>> office-backup kernel: [<ffffffff81294d21>] ?
>> btree_submit_bio_hook+0xe1/0x110 Mar  4 08:31:00 office-backup
>> kernel: [<ffffffff810d9cc3>] ? wait_on_page_bit+0x73/0x80 Mar  4
>> 08:31:00 office-backup kernel: [<ffffffff8109bdc0>] ?
>> wake_atomic_t_function+0x30/0x30 Mar  4 08:31:00 office-backup
>> kernel: [<ffffffff812bb2ba>] ?
>> read_extent_buffer_pages+0x2aa/0x2e0 Mar  4 08:31:00 office-backup
>> kernel: [<ffffffff810da355>] ? add_to_page_cache_lru+0x25/0x40 Mar
>> 4 08:31:00 office-backup kernel: [<ffffffff81344b21>] ?
>> radix_tree_insert+0x91/0x250 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff81292a10>] ? verify_parent_transid+0x170/0x170 Mar  4
>> 08:31:00 office-backup kernel: [<ffffffff812949a9>] ?
>> btree_read_extent_buffer_pages.constprop.126+0xa9/0x110 Mar  4
>> 08:31:00 office-backup kernel: [<ffffffff81294f23>] ?
>> read_tree_block+0x33/0x60 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff812775dc>] ? read_block_for_search.isra.45+0x18c/0x3b0
>> Mar  4 08:31:00 office-backup kernel: [<ffffffff81276d47>] ?
>> comp_keys+0x27/0x30 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff81279c8c>] ? btrfs_search_slot+0x41c/0x920 Mar  4
>> 08:31:00 office-backup kernel: [<ffffffff812b1641>] ?
>> btrfs_get_token_16+0x61/0xf0 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff812919f5>] ? btrfs_lookup_inode+0x25/0xa0 Mar  4 08:31:00
>> office-backup kernel: [<ffffffff81113ef0>] ?
>> kmem_cache_alloc+0xc0/0xe0 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff812a6313>] ? btrfs_iget+0x103/0x520 Mar  4 08:31:00
>> office-backup kernel: [<ffffffff8128eb1f>] ?
>> btrfs_lookup_dir_item+0x9f/0xd0 Mar  4 08:31:00 office-backup
>> kernel: [<ffffffff812a843b>] ? btrfs_lookup_dentry+0x3db/0x4c0 Mar
>> 4 08:31:00 office-backup kernel: [<ffffffff812a8529>] ?
>> btrfs_lookup+0x9/0x20 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff81120624>] ? lookup_real+0x14/0x50 Mar  4 08:31:00
>> office-backup kernel: [<ffffffff811211f2>] ?
>> __lookup_hash+0x32/0x50 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff81121b38>] ? lookup_slow+0x48/0xc0 Mar  4 08:31:00
>> office-backup kernel: [<ffffffff81123a91>] ?
>> path_lookupat+0x711/0x760 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff81123b0f>] ? filename_lookup+0x2f/0xd0 Mar  4 08:31:00
>> office-backup kernel: [<ffffffff81121d77>] ?
>> getname_flags+0xb7/0x190 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff811269ee>] ? user_path_at_empty+0x5e/0xb0 Mar  4 08:31:00
>> office-backup kernel: [<ffffffff8111bd6d>] ?
>> cp_new_stat+0x10d/0x120 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff8111bef1>] ? vfs_fstatat+0x41/0x90 Mar  4 08:31:00
>> office-backup kernel: [<ffffffff8111c0c2>] ?
>> SyS_newlstat+0x12/0x30 Mar  4 08:31:00 office-backup kernel:
>> [<ffffffff817bb7a2>] ? system_call_fastpath+0x16/0x1b Mar  4
>> 08:55:01 office-backup kernel: INFO: task updatedb.mlocat:903
>> blocked for more than 120 seconds. Mar  4 08:55:01 office-backup
>> kernel:      Not tainted 3.13.2 #3 Mar  4 08:55:01 office-backup
>> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
>> this message. Mar  4 08:55:01 office-backup kernel: updatedb.mlocat
>> D 0000000000000000 0   903    899 0x00000000 Mar  4 08:55:01
>> office-backup kernel: ffff88007cad6270 0000000000000086
>> ffff88007bb020d0 0000000000004000 Mar  4 08:55:01 office-backup
>> kernel: ffff88005a705fd8 ffff88007cad6270 00000055b6aee000
>> ffff88007b9ac000 Mar  4 08:55:01 office-backup kernel:
>> ffff8800048282e8 ffff880076f80000 ffff8800272a09c0
>> ffffffff812c3e5c Mar  4 08:55:01 office-backup kernel: Call Trace:
>> Mar  4 08:55:01 office-backup kernel: [<ffffffff812c3e5c>] ?
>> btrfs_map_bio+0x4ac/0x5a0 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff812b79c0>] ? repair_io_failure+0x210/0x210 Mar  4
>> 08:55:01 office-backup kernel: [<ffffffff810d9a40>] ?
>> __lock_page+0x70/0x70 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff817b8177>] ? io_schedule+0x87/0xd0 Mar  4 08:55:01
>> office-backup kernel: [<ffffffff810d9a49>] ?
>> sleep_on_page+0x9/0x10 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff817b8742>] ? __wait_on_bit+0x52/0x80 Mar  4 08:55:01
>> office-backup kernel: [<ffffffff81294d21>] ?
>> btree_submit_bio_hook+0xe1/0x110 Mar  4 08:55:01 office-backup
>> kernel: [<ffffffff810d9cc3>] ? wait_on_page_bit+0x73/0x80 Mar  4
>> 08:55:01 office-backup kernel: [<ffffffff8109bdc0>] ?
>> wake_atomic_t_function+0x30/0x30 Mar  4 08:55:01 office-backup
>> kernel: [<ffffffff812bb2ba>] ?
>> read_extent_buffer_pages+0x2aa/0x2e0 Mar  4 08:55:01 office-backup
>> kernel: [<ffffffff810da355>] ? add_to_page_cache_lru+0x25/0x40 Mar
>> 4 08:55:01 office-backup kernel: [<ffffffff81292a10>] ?
>> verify_parent_transid+0x170/0x170 Mar  4 08:55:01 office-backup
>> kernel: [<ffffffff812949a9>] ?
>> btree_read_extent_buffer_pages.constprop.126+0xa9/0x110 Mar  4
>> 08:55:01 office-backup kernel: [<ffffffff81294f23>] ?
>> read_tree_block+0x33/0x60 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff812775dc>] ? read_block_for_search.isra.45+0x18c/0x3b0
>> Mar  4 08:55:01 office-backup kernel: [<ffffffff81276d47>] ?
>> comp_keys+0x27/0x30 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff81279c8c>] ? btrfs_search_slot+0x41c/0x920 Mar  4
>> 08:55:01 office-backup kernel: [<ffffffff812b1641>] ?
>> btrfs_get_token_16+0x61/0xf0 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff812919f5>] ? btrfs_lookup_inode+0x25/0xa0 Mar  4 08:55:01
>> office-backup kernel: [<ffffffff81113ef0>] ?
>> kmem_cache_alloc+0xc0/0xe0 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff812a6313>] ? btrfs_iget+0x103/0x520 Mar  4 08:55:01
>> office-backup kernel: [<ffffffff8128eb1f>] ?
>> btrfs_lookup_dir_item+0x9f/0xd0 Mar  4 08:55:01 office-backup
>> kernel: [<ffffffff812a843b>] ? btrfs_lookup_dentry+0x3db/0x4c0 Mar
>> 4 08:55:01 office-backup kernel: [<ffffffff812a8529>] ?
>> btrfs_lookup+0x9/0x20 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff81120624>] ? lookup_real+0x14/0x50 Mar  4 08:55:01
>> office-backup kernel: [<ffffffff811211f2>] ?
>> __lookup_hash+0x32/0x50 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff81121b38>] ? lookup_slow+0x48/0xc0 Mar  4 08:55:01
>> office-backup kernel: [<ffffffff81123a91>] ?
>> path_lookupat+0x711/0x760 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff81123b0f>] ? filename_lookup+0x2f/0xd0 Mar  4 08:55:01
>> office-backup kernel: [<ffffffff81121d77>] ?
>> getname_flags+0xb7/0x190 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff811269ee>] ? user_path_at_empty+0x5e/0xb0 Mar  4 08:55:01
>> office-backup kernel: [<ffffffff8111bd6d>] ?
>> cp_new_stat+0x10d/0x120 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff8111bef1>] ? vfs_fstatat+0x41/0x90 Mar  4 08:55:01
>> office-backup kernel: [<ffffffff8111c0c2>] ?
>> SyS_newlstat+0x12/0x30 Mar  4 08:55:01 office-backup kernel:
>> [<ffffffff817bb7a2>] ? system_call_fastpath+0x16/0x1b
>>
> When this happens again do
>
> echo w > /proc/sysrq-trigger
>
> and then capture dmesg.  Thanks,
>
> Josef
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>
> iQIcBAEBAgAGBQJTFen4AAoJEANb+wAKly3Ba6IP/1msfu3BEPbr4WmX85WHcdL1
> MM+WHuDKCgt8hJwqiGZP3qjv+smjzDMMBeyRToAlm2f7MA9shmgE4gvwb1nMQQoG
> xfp7ZKPHAypRuYjiq1kmHanQf/vcv4iTCMba0PTBtg2VhMKxH9j9Cdp8/6nqrtRT
> QpZXh/1n8MLNBuaYkQ+SXGwqMT3Cgt2zC+NI2YuMtWJNvKpoqsF2IoFCcB8Uy7uX
> gG3zDeRyxJESVDMRGmzQOhNI+GW/vZ7EPSK8tjfqWwJJ0ilPhW+iAX7iqZPFr5iU
> WhpuQabw75bOcmEp06sk7RXz6EdLhuyTk1zeSZHmgFd9eqaAanfx93mdIk2VM/yC
> 7kOXrjq4k0QYSEvj11acB5pRB4WBwmELRpWmBa9Gqg31JTj4uScmkI4Gau9TKpwN
> qzx+xdNVdUE+W8vtdlvhL+UxEguqMrTLrvMS8wT2npgmylN9QT2jcVmeo+jdCm88
> 7XI2fP6sP2d7QHhkGpH9bTJouBpH8Rfb2Erow1B+q67DBIHT6x9/RApIiczldX3D
> N6/vkbL4Ype8mp4oFUo5Tk0D9sTwAtxRoSDzYpD49u8AwLuloC42ielG85kctaBR
> GUhRpEurGY/w0vNlRzJBmkZGvEpq6IWSJaRe9eiMivCh8wsGAGdSf2Jtgg9q4oMS
> hMZI04MgEEfMs+6pwfeR
> =7EiY
> -----END PGP SIGNATURE-----


--------------060604090200000707010005
Content-Type: text/plain; charset=UTF-8;
 name="sysrq-w"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sysrq-w"

 [<ffffffff81279c8c>] ? btrfs_search_slot+0x41c/0x920
 [<ffffffff8129f2e0>] ? btrfs_readpage+0x20/0x20
 [<ffffffff812919f5>] ? btrfs_lookup_inode+0x25/0xa0
 [<ffffffff81113ef0>] ? kmem_cache_alloc+0xc0/0xe0
 [<ffffffff812a6313>] ? btrfs_iget+0x103/0x520
 [<ffffffff8128eb1f>] ? btrfs_lookup_dir_item+0x9f/0xd0
 [<ffffffff812a843b>] ? btrfs_lookup_dentry+0x3db/0x4c0
 [<ffffffff812a8529>] ? btrfs_lookup+0x9/0x20
 [<ffffffff81120624>] ? lookup_real+0x14/0x50
 [<ffffffff811211f2>] ? __lookup_hash+0x32/0x50
 [<ffffffff81121b38>] ? lookup_slow+0x48/0xc0
 [<ffffffff81123a91>] ? path_lookupat+0x711/0x760
 [<ffffffff81123b0f>] ? filename_lookup+0x2f/0xd0
 [<ffffffff81121d77>] ? getname_flags+0xb7/0x190
 [<ffffffff811269ee>] ? user_path_at_empty+0x5e/0xb0
 [<ffffffff812a9cd8>] ? btrfs_link+0x78/0x1d0
 [<ffffffff8111bd6d>] ? cp_new_stat+0x10d/0x120
 [<ffffffff8111bef1>] ? vfs_fstatat+0x41/0x90
 [<ffffffff8111c092>] ? SyS_newstat+0x12/0x30
 [<ffffffff817bb7a2>] ? system_call_fastpath+0x16/0x1b
fdisk           D ffffffff817d1e60     0  7471   7325 0x00000000
 ffff88007ca08000 0000000000000086 ffff88007c85c1a0 0000000000004000
 ffff880070677fd8 ffff88007ca08000 000000000c360af4 ffffffff81094947
 0000000000000000 0000000000000001 0000000000000000 ffff880070676000
Call Trace:
 [<ffffffff81094947>] ? set_next_entity+0x37/0x80
 [<ffffffff810ada9d>] ? ktime_get_ts+0x3d/0xd0
 [<ffffffff810cc231>] ? delayacct_end+0x81/0xa0
 [<ffffffff810d9a40>] ? __lock_page+0x70/0x70
 [<ffffffff817b8177>] ? io_schedule+0x87/0xd0
 [<ffffffff810d9a49>] ? sleep_on_page+0x9/0x10
 [<ffffffff817b8742>] ? __wait_on_bit+0x52/0x80
 [<ffffffff810d9cc3>] ? wait_on_page_bit+0x73/0x80
 [<ffffffff8109bdc0>] ? wake_atomic_t_function+0x30/0x30
 [<ffffffff810d9e04>] ? filemap_fdatawait_range+0xd4/0x150
 [<ffffffff8113cabd>] ? sync_inodes_sb+0x14d/0x1c0
 [<ffffffff81141310>] ? fdatawrite_one_bdev+0x10/0x10
 [<ffffffff8111a989>] ? iterate_supers+0xd9/0xe0
 [<ffffffff8114146a>] ? sys_sync+0x3a/0xa0
 [<ffffffff817bb7a2>] ? system_call_fastpath+0x16/0x1b
Sched Debug Version: v0.11, 3.13.2 #3
ktime                                   : 508982199.307298
sched_clk                               : 508427276.572591
cpu_clk                                 : 508982199.306817
jiffies                                 : 4422137845
sched_clock_stable                      : 0

sysctl_sched
  .sysctl_sched_latency                    : 12.000000
  .sysctl_sched_min_granularity            : 1.500000
  .sysctl_sched_wakeup_granularity         : 2.000000
  .sysctl_sched_child_runs_first           : 0
  .sysctl_sched_features                   : 11899
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 2999.512 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 806708173
  .nr_load_updates               : 91319048
  .nr_uninterruptible            : -1991
  .next_balance                  : 4422.137803
  .curr->pid                     : 0
  .clock                         : 508982198.845919
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0

cfs_rq[0]:
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 106067366.199195
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 52

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
        kthreadd     2 106065720.264234     28395   120               0               0               0.000000               0.000000               0.000000
     ksoftirqd/0     3 106067326.319773   2229871   120               0               0               0.000000               0.000000               0.000000
    kworker/0:0H     5      4255.763080         5   100               0               0               0.000000               0.000000               0.000000
     rcu_preempt     7 106067359.558999  48845682   120               0               0               0.000000               0.000000               0.000000
       rcu_sched     8 106052870.535465        11   120               0               0               0.000000               0.000000               0.000000
          rcu_bh     9        58.079246         2   120               0               0               0.000000               0.000000               0.000000
     migration/0    10         0.000000     10396     0               0               0               0.000000               0.000000               0.000000
       writeback   329  52957239.726106       210   100               0               0               0.000000               0.000000               0.000000
          rpciod   519      1823.046895         2   100               0               0               0.000000               0.000000               0.000000
      khungtaskd   533 106065609.416409      4244   120               0               0               0.000000               0.000000               0.000000
         kswapd0   538 106065787.305395  15971098   120               0               0               0.000000               0.000000               0.000000
   fsnotify_mark   603 106060217.814748        42   120               0               0               0.000000               0.000000               0.000000
       scsi_eh_1  1288      4157.663402        36   120               0               0               0.000000               0.000000               0.000000
    kworker/0:1H  1546 106067359.551737  37138288   100               0               0               0.000000               0.000000               0.000000
 btrfs-delalloc-  1754 106065783.411522      5789   120               0               0               0.000000               0.000000               0.000000
   btrfs-fixup-1  1755 106065783.410980      5602   120               0               0               0.000000               0.000000               0.000000
 btrfs-readahead  1765 106065783.409275      6101   120               0               0               0.000000               0.000000               0.000000
 btrfs-flush_del  1766 106065619.503072      4964   120               0               0               0.000000               0.000000               0.000000
 btrfs-transacti  1772 106067357.826303  38384212   120               0               0               0.000000               0.000000               0.000000
          bioset  2223      5696.173269         2   100               0               0               0.000000               0.000000               0.000000
       md4_raid1  2247 106060689.775366     85220   120               0               0               0.000000               0.000000               0.000000
      jbd2/md3-8  3362  11963097.870380        66   120               0               0               0.000000               0.000000               0.000000
      rpc.idmapd  3700     10065.368966         1   120               0               0               0.000000               0.000000               0.000000
        rsyslogd  4052 106054722.847681       140   120               0               0               0.000000               0.000000               0.000000
            nmbd  4109 106067152.862928    135237   120               0               0               0.000000               0.000000               0.000000
           mdadm  4195 106054722.788895      2228   120               0               0               0.000000               0.000000               0.000000
             atd  4232 105990182.832356       321   120               0               0               0.000000               0.000000               0.000000
           inetd  4276     11755.234666         4   120               0               0               0.000000               0.000000               0.000000
        winbindd  4655 106054922.302233      4110   120               0               0               0.000000               0.000000               0.000000
           getty  4701     12881.132692        42   120               0               0               0.000000               0.000000               0.000000
        dhclient  4738 104667541.981289       121   120               0               0               0.000000               0.000000               0.000000
            sshd  4783 106064772.148377       427   120               0               0               0.000000               0.000000               0.000000
            sshd 19939 106054722.862192      2409   120               0               0               0.000000               0.000000               0.000000
            bash 19943  25784313.058374      1091   120               0               0               0.000000               0.000000               0.000000
           emacs 19969    161695.741081       837   120               0               0               0.000000               0.000000               0.000000
        BackupPC 28608 106048914.803118      9022   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach   883 106051583.697117        43   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach  1147 105989485.801024        27   120               0               0               0.000000               0.000000               0.000000
            tail  1866 106054722.841108        29   120               0               0               0.000000               0.000000               0.000000
            bash  1875  25802073.317152        57   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach  1896 105988991.040804        22   120               0               0               0.000000               0.000000               0.000000
            bash  2158  25973599.481294        15   120               0               0               0.000000               0.000000               0.000000
     kworker/0:0  2251 106067360.203454   1725696   120               0               0               0.000000               0.000000               0.000000
            bash  2286  26703960.784196        44   120               0               0               0.000000               0.000000               0.000000
             ssh  2293  26708000.933931       132   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach  2302 105989142.941250        13   120               0               0               0.000000               0.000000               0.000000
           getty  2303  26733602.922728        10   120               0               0               0.000000               0.000000               0.000000
    kworker/u8:2  4459 106061322.853210     37329   120               0               0               0.000000               0.000000               0.000000
    kworker/u8:0  4483 106067299.631838      2397   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach  6958 105991594.009868         4   120               0               0               0.000000               0.000000               0.000000
 btrfs-endio-wri  7279 106065283.760895       171   120               0               0               0.000000               0.000000               0.000000
   BackupPC_link  7301 106067366.199195     63952   130               0               0               0.000000               0.000000               0.000000
   btrfs-endio-2  7307 106066839.668081      1056   120               0               0               0.000000               0.000000               0.000000
     kworker/0:1  7324 106054722.818290         8   120               0               0               0.000000               0.000000               0.000000
   btrfs-endio-2  7379 106064769.918796       407   120               0               0               0.000000               0.000000               0.000000
            tail  7393 106054722.849560        18   120               0               0               0.000000               0.000000               0.000000
  btrfs-worker-2  7420 106065784.963486      2600   120               0               0               0.000000               0.000000               0.000000
     kworker/0:2  7434 106061247.516207        30   120               0               0               0.000000               0.000000               0.000000
    kworker/u8:1  7472 106061328.846268         2   120               0               0               0.000000               0.000000               0.000000
            sshd  7473 106067360.235381       573   120               0               0               0.000000               0.000000               0.000000
  btrfs-submit-2  7490 106065819.440317       710   120               0               0               0.000000               0.000000               0.000000

cpu#1, 2999.512 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 787632773
  .nr_load_updates               : 91735997
  .nr_uninterruptible            : 1997
  .next_balance                  : 4422.137805
  .curr->pid                     : 7479
  .clock                         : 508982198.854931
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0

cfs_rq[1]:
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 107974897.404600
  .min_vruntime                  : 107974903.398641
  .max_vruntime                  : 107974897.404600
  .spread                        : 0.000000
  .spread0                       : 1907537.199446
  .nr_spread_over                : 0
  .nr_running                    : 2
  .load                          : 2048
  .runnable_load_avg             : 27
  .blocked_load_avg              : 18

rt_rq[1]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            init     1 107974866.289357    103576   120               0               0               0.000000               0.000000               0.000000
     migration/1    11         0.000000     10314     0               0               0               0.000000               0.000000               0.000000
     ksoftirqd/1    12 107974869.523860   2311601   120               0               0               0.000000               0.000000               0.000000
    kworker/1:0H    14      5306.318956         6   100               0               0               0.000000               0.000000               0.000000
         khelper    15         2.953601         2   100               0               0               0.000000               0.000000               0.000000
          bioset   331       956.953124         2   100               0               0               0.000000               0.000000               0.000000
         kblockd   333       962.953121         2   100               0               0               0.000000               0.000000               0.000000
         ata_sff   400      1168.153353         2   100               0               0               0.000000               0.000000               0.000000
           khubd   410  26692676.081180       213   120               0               0               0.000000               0.000000               0.000000
              md   418      1222.153326         2   100               0               0               0.000000               0.000000               0.000000
          nfsiod   623      1896.198422         2   100               0               0               0.000000               0.000000               0.000000
         cifsiod   629      1914.296406         2   100               0               0               0.000000               0.000000               0.000000
          bioset   644      1960.482888         2   100               0               0               0.000000               0.000000               0.000000
          crypto   650      1978.558065         2   100               0               0               0.000000               0.000000               0.000000
       scsi_eh_0  1285      5196.004498        36   120               0               0               0.000000               0.000000               0.000000
         cnic_wq  1367      5018.282414         2   100               0               0               0.000000               0.000000               0.000000
       kpsmoused  1463      5155.131897         2   100               0               0               0.000000               0.000000               0.000000
         raid5wq  1465      5161.136986         2   100               0               0               0.000000               0.000000               0.000000
         kmpathd  1469      5167.140474         2   100               0               0               0.000000               0.000000               0.000000
 kmpath_handlerd  1470      5173.145454         2   100               0               0               0.000000               0.000000               0.000000
         deferwq  1502      5179.149234         2   100               0               0               0.000000               0.000000               0.000000
       scsi_eh_2  1507      5195.172654         2   120               0               0               0.000000               0.000000               0.000000
     usb-storage  1508      5195.201826         6   120               0               0               0.000000               0.000000               0.000000
    kworker/1:1H  1547 107974897.401958  37131472   100               0               0               0.000000               0.000000               0.000000
 btrfs-genwork-1  1752 107971711.930532     14391   120               0               0               0.000000               0.000000               0.000000
     btrfs-rmw-1  1758 107973494.313066      5675   120               0               0               0.000000               0.000000               0.000000
 btrfs-endio-rai  1759 107973494.315275      5038   120               0               0               0.000000               0.000000               0.000000
 btrfs-endio-met  1760 107973494.314681      6045   120               0               0               0.000000               0.000000               0.000000
 btrfs-freespace  1762 107973351.334636    157332   120               0               0               0.000000               0.000000               0.000000
   btrfs-cache-1  1764 107973646.240323     20761   120               0               0               0.000000               0.000000               0.000000
 btrfs-qgroup-re  1767 107973494.314504      5293   120               0               0               0.000000               0.000000               0.000000
   btrfs-cleaner  1771 107956569.190035     15955   120               0               0               0.000000               0.000000               0.000000
           udevd  1892 107967715.015955       579   120               0               0               0.000000               0.000000               0.000000
       md3_raid1  2224 107968112.584460       851   120               0               0               0.000000               0.000000               0.000000
          bioset  2246      6746.340440         2   100               0               0               0.000000               0.000000               0.000000
 ext4-rsv-conver  3363     10141.473764         2   100               0               0               0.000000               0.000000               0.000000
         rpcbind  3650 107974426.761815     16965   120               0               0               0.000000               0.000000               0.000000
       rpc.statd  3684     11035.952111         7   120               0               0               0.000000               0.000000               0.000000
        rsyslogd  4018 104549491.370333        55   120               0               0               0.000000               0.000000               0.000000
   rs:main Q:Reg  4049 107973567.071607      3100   120               0               0               0.000000               0.000000               0.000000
        rsyslogd  4051 107973589.511506      2778   120               0               0               0.000000               0.000000               0.000000
           acpid  4091  26692686.688044        18   120               0               0               0.000000               0.000000               0.000000
            smbd  4112 107974856.991500     12645   120               0               0               0.000000               0.000000               0.000000
            smbd  4144     12270.238966         1   120               0               0               0.000000               0.000000               0.000000
            cron  4328 107974897.438430     10571   120               0               0               0.000000               0.000000               0.000000
     dbus-daemon  4590     13573.288119         1   120               0               0               0.000000               0.000000               0.000000
        winbindd  4651 107961916.906312      6143   120               0               0               0.000000               0.000000               0.000000
           login  4699  26697302.681663       123   120               0               0               0.000000               0.000000               0.000000
           getty  4700     13780.087754         9   120               0               0               0.000000               0.000000               0.000000
           getty  4702     13780.557850       104   120               0               0               0.000000               0.000000               0.000000
           getty  4703     13783.860790       107   120               0               0               0.000000               0.000000               0.000000
            sshd  5807  26959666.738330   2389492   120               0               0               0.000000               0.000000               0.000000
            bash  5811  26959667.187477      1755   120               0               0               0.000000               0.000000               0.000000
            sshd 22572 107973987.188900   1097058   120               0               0               0.000000               0.000000               0.000000
            bash 22576 106580337.258431       199   120               0               0               0.000000               0.000000               0.000000
 BackupPC_trashC 28611 107974901.741897    814417   130               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach 30481 107974896.399165    238013   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach   873 107974869.530031     63979   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach   880 107897168.964503        29   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach   882 107939810.759452        34   120               0               0               0.000000               0.000000               0.000000
            sshd  1871  25776606.214109       243   120               0               0               0.000000               0.000000               0.000000
            sshd  2154  25953578.946638       100   120               0               0               0.000000               0.000000               0.000000
     kworker/1:1  2325 107967714.982244    537923   120               0               0               0.000000               0.000000               0.000000
     kworker/1:0  2344 107967662.185874    248340   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach  2563 107941617.726394        11   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach  2564 107954370.658767        11   120               0               0               0.000000               0.000000               0.000000
 /usr/sbin/apach  2565 107955241.494417         7   120               0               0               0.000000               0.000000               0.000000
  btrfs-submit-2  6530 107974897.490477     78829   120               0               0               0.000000               0.000000               0.000000
 btrfs-endio-met  6823 107974897.802363    250816   120               0               0               0.000000               0.000000               0.000000
  btrfs-worker-4  6922 107973518.691594     11738   120               0               0               0.000000               0.000000               0.000000
            sshd  6964 107973775.536827     11705   120               0               0               0.000000               0.000000               0.000000
            bash  6968 107950323.903460      1635   120               0               0               0.000000               0.000000               0.000000
 btrfs-delayed-m  7303 107974898.028760      5820   120               0               0               0.000000               0.000000               0.000000
 btrfs-endio-met  7305 107974770.779408     30439   120               0               0               0.000000               0.000000               0.000000
            sshd  7320 107974559.374227      1537   120               0               0               0.000000               0.000000               0.000000
            bash  7325 107968862.746764      1152   120               0               0               0.000000               0.000000               0.000000
  btrfs-worker-4  7422 107973467.310087     10277   120               0               0               0.000000               0.000000               0.000000
     kworker/1:2  7430 107967668.444881        18   120               0               0               0.000000               0.000000               0.000000
           udevd  7431 107967715.335907        49   120               0               0               0.000000               0.000000               0.000000
           udevd  7433 107967688.718157        22   120               0               0               0.000000               0.000000               0.000000
     kworker/1:3  7466 107974897.404600       316   120               0               0               0.000000               0.000000               0.000000
           fdisk  7471 107974897.456319     18718   120               0               0               0.000000               0.000000               0.000000
   btrfs-endio-3  7477 107974848.906759       513   120               0               0               0.000000               0.000000               0.000000
   btrfs-endio-4  7478 107972758.682593        13   120               0               0               0.000000               0.000000               0.000000
R           bash  7479 107974897.408741        38   120               0               0               0.000000               0.000000               0.000000


--------------060604090200000707010005--
