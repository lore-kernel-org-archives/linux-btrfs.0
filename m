Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:35376 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXJhT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 05:37:19 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail2.fujitsu.co.jp (Postfix) with ESMTP id 410FB3EE0CE
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 18:37:17 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 52610AC0676
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 18:37:16 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id EF9D51DB803C
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 18:37:15 +0900 (JST)
Message-ID: <53A9464A.2090008@jp.fujitsu.com>
Date: Tue, 24 Jun 2014 18:35:06 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix crash when starting transaction
References: <1403524739-28436-1-git-send-email-fdmanana@gmail.com>	<53A8E3BD.6000702@jp.fujitsu.com> <CAL3q7H4e9_nw1G+YzaaUcdPt46Lm_r_s7CwcegDqCXLgUmG6jg@mail.gmail.com>
In-Reply-To: <CAL3q7H4e9_nw1G+YzaaUcdPt46Lm_r_s7CwcegDqCXLgUmG6jg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

(2014/06/24 17:29), Filipe David Manana wrote:
> On Tue, Jun 24, 2014 at 3:34 AM, Satoru Takeuchi
> <takeuchi_satoru@jp.fujitsu.com> wrote:
>> Hi Filipe,
>>
>> (2014/06/23 20:58), Filipe David Borba Manana wrote:
>>> Often when starting a transaction we commit the currently running transaction,
>>> which can end up writing block group caches when the current process has its
>>> journal_info set to NULL (and not to a transaction). This makes our assertion
>>> at btrfs_check_data_free_space() (current_journal != NULL) fail, resulting
>>> in a crash/hang. Therefore fix it by setting journal_info.
>>
>> Do you have any reproducer?
>
> Just run xfstests in a loop. This depends on specific timings, and at
> least in my test machine it happens rarely. In 4 continuous days of
> running all xfstests in a loop, I got this 3 times in different tests:
> generic/083, generic/251 and generic/320.

Oh... it seems to hard to reproduce for me. I'll take a look
at this patch anyway.

Thanks,
Satoru

>
> Thanks.
>
>>
>> Thanks,
>> Satoru
>>
>>>
>>> Two different traces of this issue follow below.
>>>
>>> 1)
>>>
>>>       [51502.241936] BTRFS: assertion failed: current->journal_info, file: fs/btrfs/extent-tree.c, line: 3670
>>>       [51502.242213] ------------[ cut here ]------------
>>>       [51502.242493] kernel BUG at fs/btrfs/ctree.h:3964!
>>>       [51502.242669] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
>>>       (...)
>>>       [51502.244010] Call Trace:
>>>       [51502.244010]  [<ffffffffa02bc025>] btrfs_check_data_free_space+0x395/0x3a0 [btrfs]
>>>       [51502.244010]  [<ffffffffa02c3bdc>] btrfs_write_dirty_block_groups+0x4ac/0x640 [btrfs]
>>>       [51502.244010]  [<ffffffffa0357a6a>] commit_cowonly_roots+0x164/0x226 [btrfs]
>>>       [51502.244010]  [<ffffffffa02d53cd>] btrfs_commit_transaction+0x4ed/0xab0 [btrfs]
>>>       [51502.244010]  [<ffffffff8168ec7b>] ? _raw_spin_unlock+0x2b/0x40
>>>       [51502.244010]  [<ffffffffa02d6259>] start_transaction+0x459/0x620 [btrfs]
>>>       [51502.244010]  [<ffffffffa02d67ab>] btrfs_start_transaction+0x1b/0x20 [btrfs]
>>>       [51502.244010]  [<ffffffffa02d73e1>] __unlink_start_trans+0x31/0xe0 [btrfs]
>>>       [51502.244010]  [<ffffffffa02dea67>] btrfs_unlink+0x37/0xc0 [btrfs]
>>>       [51502.244010]  [<ffffffff811bb054>] ? do_unlinkat+0x114/0x2a0
>>>       [51502.244010]  [<ffffffff811baebc>] vfs_unlink+0xcc/0x150
>>>       [51502.244010]  [<ffffffff811bb1a0>] do_unlinkat+0x260/0x2a0
>>>       [51502.244010]  [<ffffffff811a9ef4>] ? filp_close+0x64/0x90
>>>       [51502.244010]  [<ffffffff810aaea6>] ? trace_hardirqs_on_caller+0x16/0x1e0
>>>       [51502.244010]  [<ffffffff81349cab>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>>       [51502.244010]  [<ffffffff811be9eb>] SyS_unlinkat+0x1b/0x40
>>>       [51502.244010]  [<ffffffff81698452>] system_call_fastpath+0x16/0x1b
>>>       [51502.244010] Code: 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 89 f1 48 c7 c2 71 13 36 a0 48 89 fe 31 c0 48 c7 c7 b8 43 36 a0 48 89 e5 e8 5d b0 32 e1 <0f> 0b 0f 1f 44 00 00 55 b9 11 00 00 00 48 89 e5 41 55 49 89 f5
>>>       [51502.244010] RIP  [<ffffffffa03575da>] assfail.constprop.88+0x1e/0x20 [btrfs]
>>>
>>> 2)
>>>
>>>       [25405.097230] BTRFS: assertion failed: current->journal_info, file: fs/btrfs/extent-tree.c, line: 3670
>>>       [25405.097488] ------------[ cut here ]------------
>>>       [25405.097767] kernel BUG at fs/btrfs/ctree.h:3964!
>>>       [25405.097940] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
>>>       (...)
>>>       [25405.100008] Call Trace:
>>>       [25405.100008]  [<ffffffffa02bc025>] btrfs_check_data_free_space+0x395/0x3a0 [btrfs]
>>>       [25405.100008]  [<ffffffffa02c3bdc>] btrfs_write_dirty_block_groups+0x4ac/0x640 [btrfs]
>>>       [25405.100008]  [<ffffffffa035755a>] commit_cowonly_roots+0x164/0x226 [btrfs]
>>>       [25405.100008]  [<ffffffffa02d53cd>] btrfs_commit_transaction+0x4ed/0xab0 [btrfs]
>>>       [25405.100008]  [<ffffffff8109c170>] ? bit_waitqueue+0xc0/0xc0
>>>       [25405.100008]  [<ffffffffa02d6259>] start_transaction+0x459/0x620 [btrfs]
>>>       [25405.100008]  [<ffffffffa02d67ab>] btrfs_start_transaction+0x1b/0x20 [btrfs]
>>>       [25405.100008]  [<ffffffffa02e3407>] btrfs_create+0x47/0x210 [btrfs]
>>>       [25405.100008]  [<ffffffffa02d74cc>] ? btrfs_permission+0x3c/0x80 [btrfs]
>>>       [25405.100008]  [<ffffffff811bc63b>] vfs_create+0x9b/0x130
>>>       [25405.100008]  [<ffffffff811bcf19>] do_last+0x849/0xe20
>>>       [25405.100008]  [<ffffffff811b9409>] ? link_path_walk+0x79/0x820
>>>       [25405.100008]  [<ffffffff811bd5b5>] path_openat+0xc5/0x690
>>>       [25405.100008]  [<ffffffff810ab07d>] ? trace_hardirqs_on+0xd/0x10
>>>       [25405.100008]  [<ffffffff811cdcd2>] ? __alloc_fd+0x32/0x1d0
>>>       [25405.100008]  [<ffffffff811be2a3>] do_filp_open+0x43/0xa0
>>>       [25405.100008]  [<ffffffff811cddf1>] ? __alloc_fd+0x151/0x1d0
>>>       [25405.100008]  [<ffffffff811abcfc>] do_sys_open+0x13c/0x230
>>>       [25405.100008]  [<ffffffff810aaea6>] ? trace_hardirqs_on_caller+0x16/0x1e0
>>>       [25405.100008]  [<ffffffff811abe12>] SyS_open+0x22/0x30
>>>       [25405.100008]  [<ffffffff81698452>] system_call_fastpath+0x16/0x1b
>>>       [25405.100008] Code: 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 89 f1 48 c7 c2 51 13 36 a0 48 89 fe 31 c0 48 c7 c7 d0 43 36 a0 48 89 e5 e8 6d b5 32 e1 <0f> 0b 0f 1f 44 00 00 55 b9 11 00 00 00 48 89 e5 41 55 49 89 f5
>>>       [25405.100008] RIP  [<ffffffffa03570ca>] assfail.constprop.88+0x1e/0x20 [btrfs]
>>>
>>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>>> ---
>>>    fs/btrfs/transaction.c | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>>> index ac984a3..fe4abe9 100644
>>> --- a/fs/btrfs/transaction.c
>>> +++ b/fs/btrfs/transaction.c
>>> @@ -491,7 +491,11 @@ again:
>>>        smp_mb();
>>>        if (cur_trans->state >= TRANS_STATE_BLOCKED &&
>>>            may_wait_transaction(root, type)) {
>>> +             void *journal_info = current->journal_info;
>>> +             if (!journal_info)
>>> +                     current->journal_info = h;
>>>                btrfs_commit_transaction(h, root);
>>> +             current->journal_info = journal_info;
>>>                goto again;
>>>        }
>>>
>>>
>>
>
>
>

