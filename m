Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56610 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbaFMOKD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 10:10:03 -0400
Message-ID: <539B06C0.6020606@fb.com>
Date: Fri, 13 Jun 2014 10:12:16 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix RCU correctness warning when running sanity
 tests
References: <1402423961-12169-1-git-send-email-fdmanana@gmail.com>	<1402424236-13459-1-git-send-email-fdmanana@gmail.com> <CAL3q7H46cZbLRd764BnB-yPjc9ha+YfFQ-RGewXfGmrc0k5-Ug@mail.gmail.com>
In-Reply-To: <CAL3q7H46cZbLRd764BnB-yPjc9ha+YfFQ-RGewXfGmrc0k5-Ug@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/13/2014 05:09 AM, Filipe David Manana wrote:
> On Tue, Jun 10, 2014 at 7:17 PM, Filipe David Borba Manana
> <fdmanana@gmail.com> wrote:
>> When CONFIG_PROVE_RCU=y and CONFIG_PROVE_RCU_REPEATEDLY=y, the
>> following was dumped in dmesg:
>>
>> [ 3197.218064] ===============================
>> [ 3197.218064] [ INFO: suspicious RCU usage. ]
>> [ 3197.218066] 3.15.0-rc8-fdm-btrfs-next-33+ #4 Not tainted
>> [ 3197.218067] -------------------------------
>> [ 3197.218068] include/linux/radix-tree.h:196 suspicious rcu_dereference_check() usage!
>> [ 3197.218068]
>> [ 3197.218068] other info that might help us debug this:
>> [ 3197.218068]
>> [ 3197.218070]
>> [ 3197.218070] rcu_scheduler_active = 1, debug_locks = 1
>> [ 3197.218071] 1 lock held by modprobe/12024:
>> [ 3197.218072]  #0:  (&(&fs_info->buffer_lock)->rlock){+.+...}, at: [<ffffffffa025c5fa>] btrfs_free_dummy_root+0x5a/0x1d0 [btrfs]
>> [ 3197.218093]
>> [ 3197.218093] stack backtrace:
>> [ 3197.218095] CPU: 3 PID: 12024 Comm: modprobe Not tainted 3.15.0-rc8-fdm-btrfs-next-33+ #4
>> [ 3197.218096] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>> [ 3197.218097]  0000000000000001 ffff8800af18fc18 ffffffff81685c5a 000000000000feb0
>> [ 3197.218099]  ffff8800cf6ccb40 ffff8800af18fc48 ffffffff810a6316 ffff8801d955f640
>> [ 3197.218101]  ffff8800d719e328 ffff8800d719e370 ffff8800d719c000 ffff8800af18fcb8
>> [ 3197.218102] Call Trace:
>> [ 3197.218105]  [<ffffffff81685c5a>] dump_stack+0x4e/0x68
>> [ 3197.218108]  [<ffffffff810a6316>] lockdep_rcu_suspicious+0xe6/0x130
>> [ 3197.218119]  [<ffffffffa025c728>] btrfs_free_dummy_root+0x188/0x1d0 [btrfs]
>> [ 3197.218129]  [<ffffffffa025f56a>] btrfs_test_qgroups+0xea/0x1bb [btrfs]
>> [ 3197.218137]  [<ffffffffa03a19d2>] ? ftrace_define_fields_btrfs_space_reservation+0xfd/0xfd [btrfs]
>> [ 3197.218144]  [<ffffffffa03a19d2>] ? ftrace_define_fields_btrfs_space_reservation+0xfd/0xfd [btrfs]
>> [ 3197.218151]  [<ffffffffa03a1ab7>] init_btrfs_fs+0xe5/0x184 [btrfs]
>> [ 3197.218154]  [<ffffffff81000352>] do_one_initcall+0x102/0x150
>> [ 3197.218157]  [<ffffffff8103d223>] ? set_memory_nx+0x43/0x50
>> [ 3197.218160]  [<ffffffff81682668>] ? set_section_ro_nx+0x6d/0x74
>> [ 3197.218162]  [<ffffffff810d91cc>] load_module+0x1cdc/0x2630
>> [ 3197.218164]  [<ffffffff810d4e90>] ? show_initstate+0x60/0x60
>> [ 3197.218166]  [<ffffffff810d9c9e>] SyS_finit_module+0x8e/0x90
>> [ 3197.218168]  [<ffffffff81698212>] system_call_fastpath+0x16/0x1b
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> 
> Chris,
> 
> Please drop this patch from your integration branch.
> Sasha fixed this too but in a simpler way:
> https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/patch/4337091/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=udAT%2BO62eFj7qxpld6pYEp%2FRKmeGPjqGP8i%2Fb8%2FcJ2s%3D%0A&s=e3bbde8e6b7bd327f6f32a8f959089bed8f4a25a27fa8b0ddf2589cf70b8a89f
> (In fact both patches applied probably trigger another warning the rcu

Thanks, it did look overlapping to me, was going to sort it out in the
morning.

-chris
