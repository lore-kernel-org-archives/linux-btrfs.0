Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:37445 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750712AbdCRFls (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Mar 2017 01:41:48 -0400
Received: by mail-it0-f44.google.com with SMTP id g138so49088436itb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Mar 2017 22:41:47 -0700 (PDT)
Subject: Re: Thoughts on 'btrfs device stats' and security.
To: Eric Sandeen <sandeen@redhat.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <f0bd54bf-930b-c489-8bd3-e3b5a4cc965e@gmail.com>
 <feb89fc0-e7c6-53f5-5eaf-222b7a7a05b7@redhat.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4536836e-743a-cb21-4f2f-ebee5fc3c08d@gmail.com>
Date: Fri, 17 Mar 2017 15:45:10 -0400
MIME-Version: 1.0
In-Reply-To: <feb89fc0-e7c6-53f5-5eaf-222b7a7a05b7@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-17 15:01, Eric Sandeen wrote:
> On 3/17/17 11:25 AM, Austin S. Hemmelgarn wrote:
>> I'm currently working on a plugin for colllectd [1] to track per-device per-filesystem error rates for BTRFS volumes.  Overall, this is actually going quite well (I've got most of the secondary logic like matching filesystems to watch and parsing the data done already), but I've come across a rather nasty caveat on the actual data collection part.
>>
>> As of right now, there are only two ways I can see to get this data:
>> 1. Parse the output of `btrfs device stats` for the filesystem.
>> 2. Make the same ioctl() call that `btrfs device stats` does and compose the data yourself.
>>
>> In both cases, one of the following has to be the case:
>> 1. You're running as root.
>> 2. You're running SUID root.
>> 3. You're running with CAP_SYS_ADMIN (I'm not 100% certain that this is the correct capability, but it appears to be the case from my testing).
>>
>> In other words, you have to reduce the overall security of your system to be able to get this data which is itself not security sensitive for most intents and purposes.
>
> As one datapoint, xfs stats are ugo+r -
>
> see /proc/fs/xfs/stat or /sys/fs/xfs/<device>/stats/stats
>
> -r--r--r--. 1 root root 4096 Mar 17 13:58 stats
>
> However, the stats_clear file is only writable by root
>
> --w-------. 1 root root 4096 Mar 17 13:58 stats_clear
That pretty much matches what I was thinking, albeit having one data 
file and one clear file for each device in each filesystem since the 
error counters are per-device per-filesystem, and there are multiple 
reasons to reset the counters on only one (device, filesystem) pair at a 
time.

On that note, it would be kind of nice to get some more extended 
performance stats like you can get from XFS and ext4, and sysfs is 
probably the best place for those to go too, but that's obviously not as 
important as the error counters being easily accessible.
>
> Stats & other info for ext4 are also ugo+r, other than
> an error trigger which is only writable by root, and
> for which a read is meaningless.
>
> /sys/fs/ext4/sda1/
>
> -r--r--r--. 1 root root 4096 Mar 17 14:00 delayed_allocation_blocks
> -r--r--r--. 1 root root 4096 Mar 17 14:00 errors_count
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 err_ratelimit_burst
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 err_ratelimit_interval_ms
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 extent_max_zeroout_kb
> -r--r--r--. 1 root root 4096 Mar 17 14:00 first_error_time
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 inode_goal
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 inode_readahead_blks
> -r--r--r--. 1 root root 4096 Mar 17 14:00 last_error_time
> -r--r--r--. 1 root root 4096 Mar 17 14:00 lifetime_write_kbytes
> -r--r--r--. 1 root root 4096 Mar 17 14:00 max_writeback_mb_bump
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 mb_group_prealloc
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 mb_max_to_scan
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 mb_min_to_scan
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 mb_order2_req
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 mb_stats
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 mb_stream_req
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 msg_ratelimit_burst
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 msg_ratelimit_interval_ms
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 reserved_clusters
> -r--r--r--. 1 root root 4096 Mar 17 14:00 session_write_kbytes
> --w-------. 1 root root 4096 Mar 17 14:00 trigger_fs_error
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 warning_ratelimit_burst
> -rw-r--r--. 1 root root 4096 Mar 17 14:00 warning_ratelimit_interval_ms
>
>
> -Eric
>

