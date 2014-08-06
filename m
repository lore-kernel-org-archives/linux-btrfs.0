Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10502 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbaHFPSc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Aug 2014 11:18:32 -0400
Message-ID: <53E24738.5070908@fb.com>
Date: Wed, 6 Aug 2014 11:18:16 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix compressed write corruption on enospc
References: <1406213285-19607-1-git-send-email-bo.li.liu@oracle.com> <3143412.n5KSJct7YP@merkaba> <53E22F37.9000308@fb.com> <4178355.kT8uO1WxjX@merkaba>
In-Reply-To: <4178355.kT8uO1WxjX@merkaba>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/06/2014 10:43 AM, Martin Steigerwald wrote:
> Am Mittwoch, 6. August 2014, 09:35:51 schrieb Chris Mason:
>> On 08/06/2014 06:21 AM, Martin Steigerwald wrote:
>>>> I think this should go to stable. Thanks, Liu.
>>
>> I'm definitely tagging this for stable.
>>
>>> Unfortunately this fix does not seem to fix all lockups.
>>
>> The traces below are a little different, could you please send the whole
>> file?
> 
> Will paste it at the end.

[90496.156016] kworker/u8:14   D ffff880044e38540     0 21050      2 0x00000000
[90496.157683] Workqueue: btrfs-delalloc normal_work_helper [btrfs]
[90496.159320]  ffff88022880f990 0000000000000002 ffff880407f649b0 ffff88022880ffd8
[90496.160997]  ffff880044e38000 0000000000013040 ffff880044e38000 7fffffffffffffff
[90496.162686]  ffff880301383aa0 0000000000000002 ffffffff814705d0 ffff880301383a98
[90496.164360] Call Trace:
[90496.166028]  [<ffffffff814705d0>] ? michael_mic.part.6+0x21/0x21
[90496.167854]  [<ffffffff81470fd0>] schedule+0x64/0x66
[90496.169574]  [<ffffffff814705ff>] schedule_timeout+0x2f/0x114
[90496.171221]  [<ffffffff8106479a>] ? wake_up_process+0x2f/0x32
[90496.172867]  [<ffffffff81062c3b>] ? get_parent_ip+0xd/0x3c
[90496.174472]  [<ffffffff81062ce5>] ? preempt_count_add+0x7b/0x8e
[90496.176053]  [<ffffffff814717f3>] __wait_for_common+0x11e/0x163
[90496.177619]  [<ffffffff814717f3>] ? __wait_for_common+0x11e/0x163
[90496.179173]  [<ffffffff810647aa>] ? wake_up_state+0xd/0xd
[90496.180728]  [<ffffffff81471857>] wait_for_completion+0x1f/0x21
[90496.182285]  [<ffffffffc044e3b3>] btrfs_async_run_delayed_refs+0xbf/0xd9 [btrfs]
[90496.183833]  [<ffffffffc04624e1>] __btrfs_end_transaction+0x2b6/0x2ec [btrfs]
[90496.185380]  [<ffffffffc0462522>] btrfs_end_transaction+0xb/0xd [btrfs]
[90496.186940]  [<ffffffffc0451742>] find_free_extent+0x8a9/0x976 [btrfs]
[90496.189464]  [<ffffffffc0451990>] btrfs_reserve_extent+0x6f/0x119 [btrfs]
[90496.191326]  [<ffffffffc0466b45>] cow_file_range+0x1a6/0x377 [btrfs]
[90496.193080]  [<ffffffffc047adc4>] ? extent_write_locked_range+0x10c/0x11e [btrfs]
[90496.194659]  [<ffffffffc04677e4>] submit_compressed_extents+0x100/0x412 [btrfs]
[90496.196225]  [<ffffffff8120e344>] ? debug_smp_processor_id+0x17/0x19
[90496.197776]  [<ffffffffc0467b78>] async_cow_submit+0x82/0x87 [btrfs]
[90496.199383]  [<ffffffffc048644b>] normal_work_helper+0x153/0x224 [btrfs]
[90496.200944]  [<ffffffff81052d8c>] process_one_work+0x16f/0x2b8
[90496.202483]  [<ffffffff81053636>] worker_thread+0x27b/0x32e
[90496.204000]  [<ffffffff810533bb>] ? cancel_delayed_work_sync+0x10/0x10
[90496.205514]  [<ffffffff81058012>] kthread+0xb2/0xba
[90496.207040]  [<ffffffff81470000>] ? ap_handle_dropped_data+0xf/0xc8
[90496.208565]  [<ffffffff81057f60>] ? __kthread_parkme+0x62/0x62
[90496.210096]  [<ffffffff81473f6c>] ret_from_fork+0x7c/0xb0
[90496.211618]  [<ffffffff81057f60>] ? __kthread_parkme+0x62/0x62


Ok, this should explain the hang.  submit_compressed_extents is calling
cow_file_range with a locked page.

cow_file_range is trying to find a free extent and in the process is
calling btrfs_end_transaction, which is running the async delayed refs,
which is trying to write dirty pages, which is waiting for your locked
page.

I should be able to reproduce this ;)

-chris

