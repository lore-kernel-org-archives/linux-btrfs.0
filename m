Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp38.i.mail.ru ([94.100.177.98]:47023 "EHLO smtp38.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbcFPBFu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 21:05:50 -0400
Received: from 82-169-65-155.ip.telfort.nl ([82.169.65.155]:57078 helo=centurion.home)
	by smtp38.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1bDLkh-0003ga-DF
	for linux-btrfs@vger.kernel.org; Thu, 16 Jun 2016 04:05:48 +0300
Received: from [192.168.1.85] (unknown [192.168.1.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion.home (Postfix) with ESMTPSA id C451518CE0D
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jun 2016 03:05:43 +0200 (CEST)
Subject: Re: Process is blocked for more than 120 seconds
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56374C7D.5080609@mail.ru> <563DECF0.8080901@mail.ru>
 <56409EE4.6070605@gmail.com> <564328B8.2020509@mail.ru>
From: Dmitry Katsubo <dma_k@mail.ru>
Message-ID: <5761FB62.30001@mail.ru>
Date: Thu, 16 Jun 2016 03:05:38 +0200
MIME-Version: 1.0
In-Reply-To: <564328B8.2020509@mail.ru>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-11-11 12:38, Dmitry Katsubo wrote:
> On 2015-11-09 14:25, Austin S Hemmelgarn wrote:
>> On 2015-11-07 07:22, Dmitry Katsubo wrote:
>>> Hi everyone,
>>>
>>> I have noticed the following in the log. The system continues to run,
>>> but I am not sure for how long it will be stable. Should I start
>>> worrying? Thanks in advance for the opinion.
>>>
>> This just means that a process was stuck in the D state (uninterruptible
>> I/O sleep) for more than 120 seconds.  Depending on a number of factors,
>> this happening could mean:
>> 1. Absolutely nothing (if you have low-powered or older hardware, for
>> example, I get these regularly on a first generation Raspberry Pi if I
>> don't increase the timeout significantly)
>> 2. The program is doing a very large chunk of I/O (usually with the
>> O_DIRECT flag, although this probably isn't the case here)
>> 3. There's a bug in the blocked program (this is rarely the case when
>> this type of thing happens)
>> 4. There's a bug in the kernel (which is why this dumps a stack trace)
>> 5. The filesystem itself is messed up somehow, and the kernel isn't
>> handling it properly (technically a bug, but a more specific case of it).
>> 6. You're hardware is misbehaving, failing, or experienced a transient
>> error.
>>
>> Assuming you can rule out possibilities 1 and 6, I think that 4 is the
>> most likely cause, as all of the listed programs (I'm assuming that
>> 'master' is from postfix) are relatively well audited, and all of them
>> hit this at the same time.
>>
>> For what it's worth, if you want you can do:
>> echo 0 > /proc/sys/kernel/hung_task_timeout_secs
>> like the message says to stop these from appearing in the future, or use
>> some arbitrary number to change the timeout before these messages appear
>> (I usually use at least 150 on production systems, and more often 300,
>> although on something like a Raspberry Pi I often use timeouts as high
>> as 1800 seconds).
> 
> Thanks for comments, Austin.
> 
> The system is "normal" PC, running Intel Core 2 Duo Mobile @1.66GHz.
> "master" is indeed a postfix process.
> 
> I haven't seen anything like that when I was on 3.16 kernel, but after I
> have upgraded to 4.2.3, I caught that message. I/O and CPU load are
> usually low, but it could be (6) from your list, as the system is
> generally very old (5+ years).
> 
> As the problem appeared only once for passed 15 days, I think it is just
> a transient error. Thanks for clarifying the possible reasons.

The problem (rarely) re-occurs. It does not happen on XFS filesystem (root)
but only on btrfs. I will increase timeout up to 300 and see what happens.

=== cut dmesg ===
INFO: task fail2ban-server:1747 blocked for more than 120 seconds.
      Tainted: G        W       4.4.0-1-rt-686-pae #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fail2ban-server D 0000001f     0  1747      1 0x00000000
 f1ca1bc0 00200086 f2d24190 0000001f 00000000 f79ca4c0 f3d21bc0 00000000
 c1168726 f1ca1bc0 e9152000 00000000 e9151d8c c156075f c0d25a90 f1ca1bc0
 e9151db4 c1561ed4 00000000 00000000 f1ca1bc0 00000002 eab98940 c0d25a90
Call Trace:
 [<c1168726>] ? __filemap_fdatawrite_range+0xb6/0xf0
 [<c156075f>] ? schedule+0x3f/0xd0
 [<c1561ed4>] ? __rt_mutex_slowlock+0x74/0x140
 [<c1562373>] ? rt_mutex_slowlock+0xf3/0x250
 [<f8c2bb8e>] ? btrfs_write_marked_extents+0xae/0x190 [btrfs]
 [<c1562575>] ? rt_mutex_lock+0x45/0x50
 [<f8c78515>] ? btrfs_sync_log+0x1d5/0x9a0 [btrfs]
 [<c106ec71>] ? pin_current_cpu+0x71/0x1a0
 [<c1091cda>] ? preempt_count_add+0x8a/0xb0
 [<c106edb3>] ? unpin_current_cpu+0x13/0x70
 [<f8c474ee>] ? btrfs_sync_file+0x3ce/0x410 [btrfs]
 [<f8c47120>] ? start_ordered_ops+0x40/0x40 [btrfs]
 [<c11f9767>] ? vfs_fsync_range+0x47/0xb0
 [<c11f983c>] ? do_fsync+0x3c/0x60
 [<c11f9ab5>] ? SyS_fdatasync+0x15/0x20
 [<c100393d>] ? do_fast_syscall_32+0x8d/0x150
 [<c1563e28>] ? sysenter_past_esp+0x3d/0x61
 [<c1560000>] ? pci_mmcfg_check_reserved+0x90/0xb0
INFO: task cleanup:2093 blocked for more than 120 seconds.
      Tainted: G        W       4.4.0-1-rt-686-pae #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
cleanup         D d0f5de0c     0  2093  28135 0x00000000
 eab99bc0 00200086 c1836760 d0f5de0c 00000002 f79ca4c0 f3d21bc0 00000000
 00000001 eab99bc0 d0f5e000 f325d2c4 d0f5ddfc c156075f f325d000 00000088
 d0f5de30 f8c72f36 00000310 f325d290 00000000 eab99bc0 c10afd70 f325d2dc
Call Trace:
 [<c156075f>] ? schedule+0x3f/0xd0
 [<f8c72f36>] ? wait_log_commit+0xc6/0xf0 [btrfs]
 [<c10afd70>] ? wake_atomic_t_function+0x70/0x70
 [<f8c786aa>] ? btrfs_sync_log+0x36a/0x9a0 [btrfs]
 [<c106ec71>] ? pin_current_cpu+0x71/0x1a0
 [<c1091cda>] ? preempt_count_add+0x8a/0xb0
 [<c106edb3>] ? unpin_current_cpu+0x13/0x70
 [<f8c792d4>] ? btrfs_log_dentry_safe+0x64/0x70 [btrfs]
 [<f8c474ee>] ? btrfs_sync_file+0x3ce/0x410 [btrfs]
 [<c11c6100>] ? do_sys_truncate+0xb0/0xb0
 [<f8c47120>] ? start_ordered_ops+0x40/0x40 [btrfs]
 [<c11f9767>] ? vfs_fsync_range+0x47/0xb0
 [<c11f983c>] ? do_fsync+0x3c/0x60
 [<c11f9a92>] ? SyS_fsync+0x12/0x20
 [<c100393d>] ? do_fast_syscall_32+0x8d/0x150
 [<c1563e28>] ? sysenter_past_esp+0x3d/0x61
INFO: task lmtpd:2101 blocked for more than 120 seconds.
      Tainted: G        W       4.4.0-1-rt-686-pae #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
lmtpd           D db0c7e0c     0  2101   7894 0x00000000
 cd540940 00200086 c1836760 db0c7e0c 00000002 f79674c0 c1706dc0 00000000
 00000001 cd540940 db0c8000 f325d2e4 db0c7dfc c156075f f325d000 00000087
 db0c7e30 f8c72f36 00000314 f325d290 00000000 cd540940 c10afd70 f325d2fc
Call Trace:
 [<c156075f>] ? schedule+0x3f/0xd0
 [<f8c72f36>] ? wait_log_commit+0xc6/0xf0 [btrfs]
 [<c10afd70>] ? wake_atomic_t_function+0x70/0x70
 [<f8c783e5>] ? btrfs_sync_log+0xa5/0x9a0 [btrfs]
 [<c106ec71>] ? pin_current_cpu+0x71/0x1a0
 [<c1091cda>] ? preempt_count_add+0x8a/0xb0
 [<c106edb3>] ? unpin_current_cpu+0x13/0x70
 [<f8c792d4>] ? btrfs_log_dentry_safe+0x64/0x70 [btrfs]
 [<f8c474ee>] ? btrfs_sync_file+0x3ce/0x410 [btrfs]
 [<f8c47120>] ? start_ordered_ops+0x40/0x40 [btrfs]
 [<c11f9767>] ? vfs_fsync_range+0x47/0xb0
 [<c11f983c>] ? do_fsync+0x3c/0x60
 [<c11f9ab5>] ? SyS_fdatasync+0x15/0x20
 [<c100393d>] ? do_fast_syscall_32+0x8d/0x150
 [<c1563e28>] ? sysenter_past_esp+0x3d/0x61
INFO: task nmbd:2104 blocked for more than 120 seconds.
      Tainted: G        W       4.4.0-1-rt-686-pae #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nmbd            D f6a652d4     0  2104   1702 0x00000000
 eab9ca00 00200086 c1836760 f6a652d4 00000002 f79ca4c0 f3d21bc0 00000000
 c10929fb eab9ca00 ca910000 f2fe2ea0 ca90fd20 c156075f f2023900 f325d1dc
 ca90fd48 f8c2b70f 00000000 eab9ca00 c10afd70 f6a652ec dfd2bdb4 98141c71
Call Trace:
 [<c10929fb>] ? migrate_enable+0x8b/0x150
 [<c156075f>] ? schedule+0x3f/0xd0
 [<f8c2b70f>] ? wait_current_trans.isra.21+0xaf/0xf0 [btrfs]
 [<c10afd70>] ? wake_atomic_t_function+0x70/0x70
 [<f8c2d09a>] ? start_transaction+0x29a/0x500 [btrfs]
 [<c106edb3>] ? unpin_current_cpu+0x13/0x70
 [<f8c2d31c>] ? btrfs_start_transaction+0x1c/0x20 [btrfs]
 [<f8c3e5d0>] ? btrfs_create+0x40/0x240 [btrfs]
 [<c106ec71>] ? pin_current_cpu+0x71/0x1a0
 [<c1563445>] ? _raw_spin_lock+0x15/0x40
 [<c1091cda>] ? preempt_count_add+0x8a/0xb0
 [<c11d3bab>] ? vfs_create+0xcb/0x140
 [<c11d626c>] ? path_openat+0x103c/0x1130
 [<c119ec91>] ? page_add_file_rmap+0x11/0x50
 [<c11d7ce8>] ? do_filp_open+0x68/0xe0
 [<c106edb3>] ? unpin_current_cpu+0x13/0x70
 [<c10929fb>] ? migrate_enable+0x8b/0x150
 [<c11e5375>] ? __alloc_fd+0xa5/0x160
 [<c11c7af6>] ? do_sys_open+0x116/0x220
 [<c11c7c22>] ? SyS_open+0x22/0x30
 [<c100393d>] ? do_fast_syscall_32+0x8d/0x150
 [<c1563e28>] ? sysenter_past_esp+0x3d/0x61
=== end ===

-- 
With best regards,
Dmitry
