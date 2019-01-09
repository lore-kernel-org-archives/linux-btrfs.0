Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE17C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 09:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8F0420821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 09:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbfAIJQN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 04:16:13 -0500
Received: from gfuc.org ([88.99.83.187]:40428 "EHLO gfuc.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbfAIJQN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Jan 2019 04:16:13 -0500
Received: from [147.142.68.43] (dhcp568-043.laptop-wlc.uni-heidelberg.de [147.142.68.43])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by gfuc.org (Postfix) with ESMTPSA id 5D3831E00D0;
        Wed,  9 Jan 2019 09:16:10 +0000 (UTC)
Subject: Re: applications hang on a btrfs spanning two partitions
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <418d4647-8c67-2481-68f1-1e722460c3de@florianstecker.de>
 <51f6646b-ca38-9b34-7061-8ab5227f00ae@suse.com>
From:   Florian Stecker <m19@florianstecker.de>
Message-ID: <2d2ac67d-3cf5-d147-f57b-785dc633821d@florianstecker.de>
Date:   Wed, 9 Jan 2019 10:16:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <51f6646b-ca38-9b34-7061-8ab5227f00ae@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

 >
 > Provide output of echo w > /proc/sysrq-trigger when the hang occurs
 > otherwise it's hard to figure what's going on.
 >

Here's one, again in gajim. This time, fdatasync() took "only" 2 seconds:

[42481.243491] sysrq: SysRq : Show Blocked State
[42481.243494]   task                        PC stack   pid father
[42481.243566] gajim           D    0 15778  15774 0x00000083
[42481.243569] Call Trace:
[42481.243575]  ? __schedule+0x29b/0x8b0
[42481.243576]  ? bit_wait+0x50/0x50
[42481.243578]  schedule+0x32/0x90
[42481.243580]  io_schedule+0x12/0x40
[42481.243582]  bit_wait_io+0xd/0x50
[42481.243583]  __wait_on_bit+0x6c/0x80
[42481.243585]  out_of_line_wait_on_bit+0x91/0xb0
[42481.243587]  ? init_wait_var_entry+0x40/0x40
[42481.243605]  write_all_supers+0x418/0xa70 [btrfs]
[42481.243622]  btrfs_sync_log+0x695/0x910 [btrfs]
[42481.243625]  ? _raw_spin_lock_irqsave+0x25/0x50
[42481.243641]  ? btrfs_log_dentry_safe+0x54/0x70 [btrfs]
[42481.243655]  btrfs_sync_file+0x3a9/0x3d0 [btrfs]
[42481.243659]  do_fsync+0x38/0x70
[42481.243661]  __x64_sys_fdatasync+0x13/0x20
[42481.243663]  do_syscall_64+0x5b/0x170
[42481.243666]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[42481.243667] RIP: 0033:0x7fd4022f873f
[42481.243671] Code: Bad RIP value.
[42481.243672] RSP: 002b:00007ffd3710a300 EFLAGS: 00000293 ORIG_RAX: 
000000000000004b
[42481.243674] RAX: ffffffffffffffda RBX: 0000000000000019 RCX: 
00007fd4022f873f
[42481.243675] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 
0000000000000019
[42481.243675] RBP: 0000000000000000 R08: 000055d8d8649f68 R09: 
00007ffd3710a320
[42481.243676] R10: 0000000000013000 R11: 0000000000000293 R12: 
0000000000000000
[42481.243677] R13: 0000000000000000 R14: 000055d8d8363fa0 R15: 
000055d8d8613040


On 1/9/19 7:24 AM, Nikolay Borisov wrote:
> 
> 
> On 8.01.19 г. 21:38 ч., Florian Stecker wrote:
>> Hi everyone,
>>
>> I extended the btrfs volume on my laptop by adding a second partition to
>> it which lies on the same SSD (using btrfs device add). Since I did
>> this, all kinds of applications regularly hang for up to 30 seconds. It
>> seems they are stuck in the fdatasync syscall. For example:
>>
>> $ strace -tt -T gajim 2>&1 | grep fdatasync
>> [...]
>> 11:36:31.112200 fdatasync(25)           = 0 <0.006958>
>> 11:36:32.147525 fdatasync(25)           = 0 <0.008138>
>> 11:36:32.156882 fdatasync(25)           = 0 <0.006866>
>> 11:36:32.165979 fdatasync(25)           = 0 <0.011797>
>> 11:36:32.178867 fdatasync(25)           = 0 <23.636614>
>> 11:36:55.827726 fdatasync(25)           = 0 <0.009595>
>> 11:36:55.838702 fdatasync(25)           = 0 <0.007261>
>> 11:36:55.850440 fdatasync(25)           = 0 <0.006807>
>> 11:36:55.858168 fdatasync(25)           = 0 <0.006767>
>> [...]
>>
>> File descriptor 25 here points to a file which is just ~90KB, so it
>> really shouldn't take that long.
>>
>> Removing the second partition again resolves the problem. Does anyone
>> know this issue? Is it related to btrfs? Or am I just doing something
>> wrong?
>>
>> Best,
>> Florian
>>
>> Some more info:
>>
>> $ btrfs device usage /
>> /dev/sda2, ID: 2
>>     Device size:            52.16GiB
>>     Device slack:              0.00B
>>     Data,single:             1.00GiB
>>     Unallocated:            51.16GiB
>>
>> /dev/sda8, ID: 1
>>     Device size:           174.92GiB
>>     Device slack:              0.00B
>>     Data,single:           168.91GiB
>>     Metadata,single:         3.01GiB
>>     System,single:           4.00MiB
>>     Unallocated:             3.00GiB
>>
>> $ fdisk -l /dev/sda
>> Disk /dev/sda: 238.5 GiB, 256060514304 bytes, 500118192 sectors
>> Disk model: SAMSUNG SSD PM87
>> Units: sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disklabel type: gpt
>> Disk identifier: A48B5A25-AA84-4D3F-90DD-E8A4991BDF03
>>
>> Device         Start       End   Sectors   Size Type
>> /dev/sda1       2048   1026047   1024000   500M EFI System
>> /dev/sda2    1026048 110422015 109395968  52.2G Linux filesystem
>> /dev/sda8  110422016 477263871 366841856 174.9G Linux filesystem
>> /dev/sda9  477263872 481458175   4194304     2G Linux swap
>>
>> $ uname -a
>> Linux dell 4.20.0-arch1-1-ARCH #1 SMP PREEMPT Mon Dec 24 03:00:40 UTC
>> 2018 x86_64 GNU/Linux

> 
>>
>>
