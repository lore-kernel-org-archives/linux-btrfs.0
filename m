Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33090 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbdF1WDE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 18:03:04 -0400
Received: by mail-oi0-f47.google.com with SMTP id p66so52705585oia.0
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Jun 2017 15:02:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c3f16d38-1331-e420-2a92-37db71ea8dee@suse.com>
References: <CAMp4zn9Bv=ULBx9f-jPAZrmc9oOOT+egpypBPSjajd03WFA71A@mail.gmail.com>
 <CAMp4zn9KmzW2gC9hHsuATsDZSMWT6PeqkA+cBLj3wMroZkXFLA@mail.gmail.com>
 <4c844bc7-2cee-d249-b1af-e1da7cab35a0@suse.com> <c3f16d38-1331-e420-2a92-37db71ea8dee@suse.com>
From: Sargun Dhillon <sargun@sargun.me>
Date: Wed, 28 Jun 2017 15:02:17 -0700
Message-ID: <CAMp4zn_6up7FVB=HdkAka7B5qkYDNE_mseiWP2+SC-v_Gu4Vog@mail.gmail.com>
Subject: Re: Lock between userspace and btrfs-cleaner on extent_buffer
To: Jeff Mahoney <jeffm@suse.com>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 28, 2017 at 2:55 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 6/27/17 5:12 PM, Jeff Mahoney wrote:
>> On 6/13/17 9:05 PM, Sargun Dhillon wrote:
>>> On Thu, Jun 8, 2017 at 11:34 AM, Sargun Dhillon <sargun@sargun.me> wrote:
>>>> I have a deadlock caught in the wild between two processes --
>>>> btrfs-cleaner, and userspace process (Docker). Here, you can see both
>>>> of the backtraces. btrfs-cleaner is trying to get a lock on
>>>> ffff9859d360caf0, which is owned by Docker's pid. Docker on the other
>>>> hand is trying to get a lock on ffff9859dc0f0578, which is owned by
>>>> btrfs-cleaner's Pid.
>>>>
>>>> This is on vanilla 4.11.3 without much workload. The background
>>>> workload was basically starting and stopping Docker with a medium
>>>> sized image like ubuntu:latest with sleep 5. So, snapshot creation,
>>>> destruction. And there's some stuff that's logging to btrfs.
>>
>> Hi Sargun -
>>
>> We hit this bug in testing last week.  I have a patch that I've written
>> up and have run under your reproducer for a while.  So far it hasn't
>> hit.  I'll post it shortly and CC you.  It does depend lightly on the
>> rbtree code, though.  Since we'll want this fix for -stable, I'll write
>> up a version for that too.
>
> After thinking about it a bit more, I think my patch just happens to
> make it less likely to hit but would ultimately degrade into a livelock
> where it was a deadlock previously.  I was just trylocking and
> requeuing, so both threads are allowed to do other work and maybe even
> finish but ultimately if there's a true deadlock it'll hit anyway.
>
> -Jeff
>
Does it make sense to spend the time on making it so that
btrfs-cleaner has abortable operations, and the ability to abort if
the root deletion either takes too long, or if it receives a signal?
Although, such a case may result in a livelock, to me it seems like a
lot less bad than deadlocking.

>> -Jeff
>>
>>>> crash> bt -FF
>>>> PID: 3423   TASK: ffff985ec7a16580  CPU: 2   COMMAND: "btrfs-cleaner"
>>>>  #0 [ffffafca9d9078e8] __schedule at ffffffffbb235729
>>>>     ffffafca9d9078f0: 0000000000000000 [ffff985eccb2e580:task_struct]
>>>>     ffffafca9d907900: [ffff985ec7a16580:task_struct] ffff985ed949b280
>>>>     ffffafca9d907910: ffffafca9d907978 __schedule+953
>>>>     ffffafca9d907920: btree_get_extent 000000009de968f0
>>>>     ffffafca9d907930: ffff985ed949b280 ffffafca9d907958
>>>>     ffffafca9d907940: 0000000000000004 00a90842012fd9df
>>>>     ffffafca9d907950: [ffff985ec7a16580:task_struct]
>>>> [ffff9859d360cb50:btrfs_extent_buffer]
>>>>     ffffafca9d907960: [ffff9859d360cb58:btrfs_extent_buffer]
>>>> [ffff985ec7a16580:task_struct]
>>>>     ffffafca9d907970: [ffff985ec7a16580:task_struct] ffffafca9d907990
>>>>     ffffafca9d907980: schedule+54
>>>>  #1 [ffffafca9d907980] schedule at ffffffffbb235c96
>>>>     ffffafca9d907988: [ffff9859d360caf0:btrfs_extent_buffer] ffffafca9d9079f8
>>>>     ffffafca9d907998: btrfs_tree_read_lock+204
>>>>  #2 [ffffafca9d907998] btrfs_tree_read_lock at ffffffffc03e112c [btrfs]
>>>>     ffffafca9d9079a0: ffff985e00000000 [ffff985ec7a16580:task_struct]
>>>>     ffffafca9d9079b0: autoremove_wake_function
>>>> [ffff9859d360cb60:btrfs_extent_buffer]
>>>>     ffffafca9d9079c0: [ffff9859d360cb60:btrfs_extent_buffer] 00a90842012fd9df
>>>>     ffffafca9d9079d0: [ffff985a6ca3c370:Acpi-State]
>>>> [ffff9859d360caf0:btrfs_extent_buffer]
>>>>     ffffafca9d9079e0: ffffafca9d907ac0 [ffff985e751bc000:kmalloc-8192]
>>>>     ffffafca9d9079f0: [ffff985e751bc000:kmalloc-8192] ffffafca9d907a48
>>>>     ffffafca9d907a00: __add_missing_keys+190
>>>>  #3 [ffffafca9d907a00] __add_missing_keys at ffffffffc040abae [btrfs]
>>>>     ffffafca9d907a08: 0000000000000000 ffffafca9d907a28
>>>>     ffffafca9d907a18: free_extent_buffer+75 00a90842012fd9df
>>>>     ffffafca9d907a28: ffffafca9d907ab0 ffffafca9d907be8
>>>>     ffffafca9d907a38: 0000000000000000 [ffff985e78dae540:btrfs_path]
>>>>     ffffafca9d907a48: ffffafca9d907b28 find_parent_nodes+889
>>>>  #4 [ffffafca9d907a50] find_parent_nodes at ffffffffc040c4d9 [btrfs]
>>>>     ffffafca9d907a58: [ffff985e751bc000:kmalloc-8192]
>>>> [ffff9859d613cf40:kmalloc-32]
>>>>     ffffafca9d907a68: [ffff9859d613c220:kmalloc-32] 0000000000000000
>>>>     ffffafca9d907a78: 00000000030dc000 0000000000000000
>>>>     ffffafca9d907a88: [ffff985e78dae540:btrfs_path] 0000000000000000
>>>>     ffffafca9d907a98: 0000000178dae540 0000000000000000
>>>>     ffffafca9d907aa8: 0000000000000002 ffffafca9d907ab0
>>>>     ffffafca9d907ab8: ffffafca9d907ab0 [ffff985a6ca3c370:Acpi-State]
>>>>     ffffafca9d907ac8: [ffff985a6ca3ce10:Acpi-State] c000985e751bc000
>>>>     ffffafca9d907ad8: 01a900000000030d 0000000000000000
>>>>     ffffafca9d907ae8: a900000000030dc0 0000000000000001
>>>>     ffffafca9d907af8: 00a90842012fd9df [ffff9859d613c220:kmalloc-32]
>>>>     ffffafca9d907b08: ffffafca9d907be8 00000000030dc000
>>>>     ffffafca9d907b18: [ffff985e751bc000:kmalloc-8192] 0000000000000000
>>>>     ffffafca9d907b28: ffffafca9d907b98 __btrfs_find_all_roots+169
>>>>  #5 [ffffafca9d907b30] __btrfs_find_all_roots at ffffffffc040cb09 [btrfs]
>>>>     ffffafca9d907b38: 0000000000000000 0000000000000000
>>>>     ffffafca9d907b48: 0000000000000000 0000000000000000
>>>>     ffffafca9d907b58: 0000000000000000 [ffff9859d5e63c10:kmalloc-64]
>>>>     ffffafca9d907b68: 00a90842012fd9df [ffff985e751bc788:kmalloc-8192]
>>>>     ffffafca9d907b78: [ffff9859d5e63140:kmalloc-64]
>>>> [ffff985e9dfa8ee8:btrfs_transaction]
>>>>     ffffafca9d907b88: [ffff985e9dfa8d80:btrfs_transaction] 0000000000000321
>>>>     ffffafca9d907b98: ffffafca9d907bd0 btrfs_find_all_roots+85
>>>>  #6 [ffffafca9d907ba0] btrfs_find_all_roots at ffffffffc040cbf5 [btrfs]
>>>>     ffffafca9d907ba8: ffffafca9d907be8 0000000000000000
>>>>     ffffafca9d907bb8: 0000000042b93000 [ffff985e751bc000:kmalloc-8192]
>>>>     ffffafca9d907bc8: [ffff985e751bc000:kmalloc-8192] ffffafca9d907c18
>>>>     ffffafca9d907bd8: btrfs_qgroup_trace_extent+302
>>>>  #7 [ffffafca9d907bd8] btrfs_qgroup_trace_extent at ffffffffc04115ee [btrfs]
>>>>     ffffafca9d907be0: 0000000000001000 [ffff9859d613cf40:kmalloc-32]
>>>>     ffffafca9d907bf0: 00a90842012fd9df [ffff9859dc0f0578:btrfs_extent_buffer]
>>>>     ffffafca9d907c00: 0000000000000ce5 0000000000002fa4
>>>>     ffffafca9d907c10: [ffff985e751bc000:kmalloc-8192] ffffafca9d907c80
>>>>     ffffafca9d907c20: btrfs_qgroup_trace_leaf_items+279
>>>>  #8 [ffffafca9d907c20] btrfs_qgroup_trace_leaf_items at ffffffffc0411747 [btrfs]
>>>>     ffffafca9d907c28: 0000000042b93000 [ffff985eb63d9a40:btrfs_trans_handle]
>>>>     ffffafca9d907c38: 72ffffffc03848e8 6c00000000000003
>>>>     ffffafca9d907c48: 0000000000000000 00a90842012fd9df
>>>>     ffffafca9d907c58: 0000000000000011 0000000000000000
>>>>     ffffafca9d907c68: [ffff985e751bc000:kmalloc-8192]
>>>> [ffff9859dc0f0578:btrfs_extent_buffer]
>>>>     ffffafca9d907c78: 0000000000000000 ffffafca9d907ce0
>>>>     ffffafca9d907c88: btrfs_qgroup_trace_subtree+451
>>>>  #9 [ffffafca9d907c88] btrfs_qgroup_trace_subtree at ffffffffc0411943 [btrfs]
>>>>     ffffafca9d907c90: ff00000000000000 mark_extent_buffer_accessed+89
>>>>     ffffafca9d907ca0: [ffff9859dc0f0578:btrfs_extent_buffer] 00a90842012fd9df
>>>>     ffffafca9d907cb0: [ffff985eb63d9a40:btrfs_trans_handle] 0000000000000000
>>>>     ffffafca9d907cc0: [ffff9859dc0f0578:btrfs_extent_buffer]
>>>> [ffff985e701d1380:kmalloc-192]
>>>>     ffffafca9d907cd0: [ffff985e751bc000:kmalloc-8192] 0000000000000000
>>>>     ffffafca9d907ce0: ffffafca9d907d98 do_walk_down+759
>>>> #10 [ffffafca9d907ce8] do_walk_down at ffffffffc0386627 [btrfs]
>>>>     ffffafca9d907cf0: 0000000000004000 [ffff985e78dae380:btrfs_path]
>>>>     ffffafca9d907d00: [ffff985ec77ff000:kmalloc-2048] 0000000000000011
>>>>     ffffafca9d907d10: 0000000002434000 [ffff985eb63d9a40:btrfs_trans_handle]
>>>>     ffffafca9d907d20: [ffff985e78dae384:btrfs_path]
>>>> [ffff985e78dae388:btrfs_path]
>>>>     ffffafca9d907d30: ffffafca9d907db4 0000000100000000
>>>>     ffffafca9d907d40: [ffff985e9dfa8da8:btrfs_transaction] ffffafca9d907d80
>>>>     ffffafca9d907d50: join_transaction+900 [ffff985eb63d9a40:btrfs_trans_handle]
>>>>     ffffafca9d907d60: 0000000000000201 00a90842012fd9df
>>>>     ffffafca9d907d70: [ffff985e78dae380:btrfs_path] 0000000000000001
>>>>     ffffafca9d907d80: [ffff985e701d1380:kmalloc-192]
>>>> [ffff985e78dae384:btrfs_path]
>>>>     ffffafca9d907d90: [ffff985ec77ff000:kmalloc-2048] ffffafca9d907de8
>>>>     ffffafca9d907da0: walk_down_tree+189
>>>> #11 [ffffafca9d907da0] walk_down_tree at ffffffffc038697d [btrfs]
>>>>     ffffafca9d907da8: [ffff985eb63d9a40:btrfs_trans_handle] 00000000701d1380
>>>>     ffffafca9d907db8: 00a90842012fd9df [ffff985e701d1380:kmalloc-192]
>>>>     ffffafca9d907dc8: [ffff985eb63d9a40:btrfs_trans_handle]
>>>> [ffff985ec77ff1df:kmalloc-2048]
>>>>     ffffafca9d907dd8: [ffff985ec77ff000:kmalloc-2048]
>>>> [ffff985e78dae380:btrfs_path]
>>>>     ffffafca9d907de8: ffffafca9d907e78 btrfs_drop_snapshot+996
>>>> #12 [ffffafca9d907df0] btrfs_drop_snapshot at ffffffffc03892c4 [btrfs]
>>>>     ffffafca9d907df8: 0000000000000000 [ffff985ec77ff104:kmalloc-2048]
>>>>     ffffafca9d907e08: 0000000000000001 [ffff985ec77ff028:kmalloc-2048]
>>>>     ffffafca9d907e18: [ffff985eb6d0c000:kmalloc-2048] ffff985e00000001
>>>>     ffffafca9d907e28: [ffff985e751bc000:kmalloc-8192] __schedule+961
>>>>     ffffafca9d907e38: [ffff985e751bc0e0:kmalloc-8192]
>>>> [ffff985e751bc0b8:kmalloc-8192]
>>>>     ffffafca9d907e48: 00a90842012fd9df [ffff985ec77ff3a0:kmalloc-2048]
>>>>     ffffafca9d907e58: [ffff985e751bc8b8:kmalloc-8192]
>>>> [ffff985e751bc000:kmalloc-8192]
>>>>     ffffafca9d907e68: [ffff985ec77ff000:kmalloc-2048]
>>>> [ffff985eb6d0c000:kmalloc-2048]
>>>>     ffffafca9d907e78: ffffafca9d907ea8 btrfs_clean_one_deleted_snapshot+183
>>>> #13 [ffffafca9d907e80] btrfs_clean_one_deleted_snapshot at
>>>> ffffffffc03a1aa7 [btrfs]
>>>>     ffffafca9d907e88: [ffff985ec7a16580:task_struct]
>>>> [ffff985e751bc000:kmalloc-8192]
>>>>     ffffafca9d907e98: [ffff985ec7a16580:task_struct]
>>>> [ffff985e751bc6e0:kmalloc-8192]
>>>>     ffffafca9d907ea8: ffffafca9d907ef8 cleaner_kthread+314
>>>> #14 [ffffafca9d907eb0] cleaner_kthread at ffffffffc039894a [btrfs]
>>>>     ffffafca9d907eb8: 00000001c7a16580 [ffff985e751bc928:kmalloc-8192]
>>>>     ffffafca9d907ec8: 0000000000000000 [ffff987d4599df00:kmalloc-96]
>>>>     ffffafca9d907ed8: [ffff985eac290380:kmalloc-64] ffffafca9ce2ba28
>>>>     ffffafca9d907ee8: [ffff985eb6d0c000:kmalloc-2048]
>>>> [ffff985ec7a16580:task_struct]
>>>>     ffffafca9d907ef8: ffffafca9d907f40 kthread+265
>>>> #15 [ffffafca9d907f00] kthread at ffffffffbaaa4929
>>>>     ffffafca9d907f08: cleaner_kthread  [ffff987d4599df38:kmalloc-96]
>>>>     ffffafca9d907f18: kthread          [ffff985eac290380:kmalloc-64]
>>>>     ffffafca9d907f28: 0000000000000000 0000000000000000
>>>>     ffffafca9d907f38: 0000000000000000 ffffafca9d907f50
>>>>     ffffafca9d907f48: ret_from_fork+44
>>>> #16 [ffffafca9d907f48] ret_from_fork at ffffffffbb23b1bc
>>>>
>>>> crash> bt -FF
>>>> PID: 3651   TASK: ffff985e735fc880  CPU: 1   COMMAND: "dockerd"
>>>>  #0 [ffffafca9cbe76e0] __schedule at ffffffffbb235729
>>>>     ffffafca9cbe76e8: 0000000000000000 [ffff985eccb2d700:task_struct]
>>>>     ffffafca9cbe76f8:
>>>> [ffff985e735fc880:task_struct(1899:docker.service)] ffff985ed945b280
>>>>     ffffafca9cbe7708: ffffafca9cbe7770 __schedule+953
>>>>     ffffafca9cbe7718: btree_get_extent 000000009de968f0
>>>>     ffffafca9cbe7728: ffff985ed945b280 ffffafca9cbe7750
>>>>     ffffafca9cbe7738: 0000000000000004 bd74f794474322a9
>>>>     ffffafca9cbe7748:
>>>> [ffff985e735fc880:task_struct(1899:docker.service)]
>>>> [ffff9859dc0f05d8:btrfs_extent_buffer]
>>>>     ffffafca9cbe7758: [ffff9859dc0f05e0:btrfs_extent_buffer]
>>>> [ffff985e735fc880:task_struct(1899:docker.service)]
>>>>     ffffafca9cbe7768:
>>>> [ffff985e735fc880:task_struct(1899:docker.service)] ffffafca9cbe7788
>>>>     ffffafca9cbe7778: schedule+54
>>>>  #1 [ffffafca9cbe7778] schedule at ffffffffbb235c96
>>>>     ffffafca9cbe7780: [ffff9859dc0f0578:btrfs_extent_buffer] ffffafca9cbe77f0
>>>>     ffffafca9cbe7790: btrfs_tree_read_lock+204
>>>>  #2 [ffffafca9cbe7790] btrfs_tree_read_lock at ffffffffc03e112c [btrfs]
>>>>     ffffafca9cbe7798: ffff985e00000000
>>>> [ffff985e735fc880:task_struct(1899:docker.service)]
>>>>     ffffafca9cbe77a8: autoremove_wake_function
>>>> [ffff9859dc0f05e8:btrfs_extent_buffer]
>>>>     ffffafca9cbe77b8: [ffff9859dc0f05e8:btrfs_extent_buffer] bd74f794474322a9
>>>>     ffffafca9cbe77c8: [ffff9879cfe971e0:Acpi-State]
>>>> [ffff9859dc0f0578:btrfs_extent_buffer]
>>>>     ffffafca9cbe77d8: ffffafca9cbe78b8 [ffff985e751bc000:kmalloc-8192]
>>>>     ffffafca9cbe77e8: [ffff985e751bc000:kmalloc-8192] ffffafca9cbe7840
>>>>     ffffafca9cbe77f8: __add_missing_keys+190
>>>>  #3 [ffffafca9cbe77f8] __add_missing_keys at ffffffffc040abae [btrfs]
>>>>     ffffafca9cbe7800: 0000000000000000 ffffafca9cbe7820
>>>>     ffffafca9cbe7810: free_extent_buffer+75 bd74f794474322a9
>>>>     ffffafca9cbe7820: ffffafca9cbe78a8 ffffafca9cbe79d8
>>>>     ffffafca9cbe7830: 0000000000000000 [ffff985e74e89ee0:btrfs_path]
>>>>     ffffafca9cbe7840: ffffafca9cbe7920 find_parent_nodes+889
>>>>  #4 [ffffafca9cbe7848] find_parent_nodes at ffffffffc040c4d9 [btrfs]
>>>>     ffffafca9cbe7850: [ffff985e751bc000:kmalloc-8192]
>>>> [ffff985c943a12a0:kmalloc-32]
>>>>     ffffafca9cbe7860: [ffff985c943a1b60:kmalloc-32] 0000000000000000
>>>>     ffffafca9cbe7870: 0000000002434000 0000000000000000
>>>>     ffffafca9cbe7880: [ffff985e74e89ee0:btrfs_path] 0000000000000000
>>>>     ffffafca9cbe7890: 0000000000000000 0000000000000000
>>>>     ffffafca9cbe78a0: 0000000000000007 ffffafca9cbe78a8
>>>>     ffffafca9cbe78b0: ffffafca9cbe78a8 [ffff9879cfe971e0:Acpi-State]
>>>>     ffffafca9cbe78c0: [ffff9879cfe97cd0:Acpi-State] 4000ffffbac1a330
>>>>     ffffafca9cbe78d0: 00a9000000000243 0000000000000000
>>>>     ffffafca9cbe78e0: a900000000024340 0000000000000000
>>>>     ffffafca9cbe78f0: bd74f794474322a9 [ffff985c943a1b60:kmalloc-32]
>>>>     ffffafca9cbe7900: ffffafca9cbe79d8 0000000002434000
>>>>     ffffafca9cbe7910: [ffff985e751bc000:kmalloc-8192] 0000000000000000
>>>>     ffffafca9cbe7920: ffffafca9cbe7990 __btrfs_find_all_roots+169
>>>>  #5 [ffffafca9cbe7928] __btrfs_find_all_roots at ffffffffc040cb09 [btrfs]
>>>>     ffffafca9cbe7930: 0000000000000000 0000000000000000
>>>>     ffffafca9cbe7940: 0000000000000000 0000000000000000
>>>>     ffffafca9cbe7950: 0000000000000000 0000000000000000
>>>>     ffffafca9cbe7960: bd74f794474322a9 [ffff985e751bc788:kmalloc-8192]
>>>>     ffffafca9cbe7970: [ffff985e751bc000:kmalloc-8192]
>>>> [ffff985e1e932540:kmalloc-96]
>>>>     ffffafca9cbe7980: 0000000000000616 [ffff985e9dfa8ee8:btrfs_transaction]
>>>>     ffffafca9cbe7990: ffffafca9cbe79c8 btrfs_find_all_roots+85
>>>>  #6 [ffffafca9cbe7998] btrfs_find_all_roots at ffffffffc040cbf5 [btrfs]
>>>>     ffffafca9cbe79a0: ffffafca9cbe79d8 0000000000000000
>>>>     ffffafca9cbe79b0: 0000000002434000 [ffff985e751bc000:kmalloc-8192]
>>>>     ffffafca9cbe79c0: [ffff9859d702fac0:kmalloc-64] ffffafca9cbe79f0
>>>>     ffffafca9cbe79d0: btrfs_qgroup_trace_extent_post+52
>>>>  #7 [ffffafca9cbe79d0] btrfs_qgroup_trace_extent_post at
>>>> ffffffffc0411494 [btrfs]
>>>>     ffffafca9cbe79d8: [ffff985c943a12a0:kmalloc-32] bd74f794474322a9
>>>>     ffffafca9cbe79e8: [ffff985eba32a5a0:btrfs_trans_handle] ffffafca9cbe7a60
>>>>     ffffafca9cbe79f8: btrfs_add_delayed_tree_ref+446
>>>>  #8 [ffffafca9cbe79f8] btrfs_add_delayed_tree_ref at ffffffffc03f551e [btrfs]
>>>>     ffffafca9cbe7a00: [ffff9859d406bd40:file_lock_cache] 0000000000000000
>>>>     ffffafca9cbe7a10: [ffff9859d702fac0:kmalloc-64] 0000000000004000
>>>>     ffffafca9cbe7a20: 0000000002434000 000000019cbe7a50
>>>>     ffffafca9cbe7a30: bd74f794474322a9 [ffff9859d4799068:btrfs_extent_buffer]
>>>>     ffffafca9cbe7a40: 0000000000000001 000000000000001b
>>>>     ffffafca9cbe7a50: [ffff9859d360caf0:btrfs_extent_buffer]
>>>> [ffff985e751bc000:kmalloc-8192]
>>>>     ffffafca9cbe7a60: ffffafca9cbe7a88 btrfs_inc_extent_ref+76
>>>>  #9 [ffffafca9cbe7a68] btrfs_inc_extent_ref at ffffffffc037ea5c [btrfs]
>>>>     ffffafca9cbe7a70: 0000000000000000 0000000000000001
>>>>     ffffafca9cbe7a80: 0000000000000000 ffffafca9cbe7b40
>>>>     ffffafca9cbe7a90: __btrfs_mod_ref+338
>>>> #10 [ffffafca9cbe7a90] __btrfs_mod_ref at ffffffffc037fb92 [btrfs]
>>>>     ffffafca9cbe7a98: 0000000000000000 0000000000000000
>>>>     ffffafca9cbe7aa8: btrfs_lookup_extent_info+1032 ffffafca9cbe7b70
>>>>     ffffafca9cbe7ab8: ffffafca9cbe7b68 0000000000000002
>>>>     ffffafca9cbe7ac8: 0000000000000000 0000000000000616
>>>>     ffffafca9cbe7ad8: btrfs_inc_extent_ref [ffff985eba32a5a0:btrfs_trans_handle]
>>>>     ffffafca9cbe7ae8: 0000000000000000 000001069cbe7b98
>>>>     ffffafca9cbe7af8: 01a900000000030d 0000000000000000
>>>>     ffffafca9cbe7b08: 0000000000000003 bd74f794474322a9
>>>>     ffffafca9cbe7b18: [ffff985eba32a5a0:btrfs_trans_handle]
>>>> [ffff9859d4799068:btrfs_extent_buffer]
>>>>     ffffafca9cbe7b28: [ffff985e751bc000:kmalloc-8192]
>>>> [ffff9859d360caf0:btrfs_extent_buffer]
>>>>     ffffafca9cbe7b38: [ffff9859cc626000:kmalloc-2048] ffffafca9cbe7b50
>>>>     ffffafca9cbe7b48: btrfs_inc_ref+20
>>>> #11 [ffffafca9cbe7b48] btrfs_inc_ref at ffffffffc0385674 [btrfs]
>>>>     ffffafca9cbe7b50: ffffafca9cbe7ba8 update_ref_for_cow+220
>>>> #12 [ffffafca9cbe7b58] update_ref_for_cow at ffffffffc03755fc [btrfs]
>>>>     ffffafca9cbe7b60: ffffafca9cbe7be8 0000000000000002
>>>>     ffffafca9cbe7b70: 0000000000000002 bd74f794474322a9
>>>>     ffffafca9cbe7b80: [ffff9859cc626000:kmalloc-2048]
>>>> [ffff9859d360caf0:btrfs_extent_buffer]
>>>>     ffffafca9cbe7b90: [ffff985eba32a5a0:btrfs_trans_handle]
>>>> [ffff985a0779e878:btrfs_extent_buffer]
>>>>     ffffafca9cbe7ba0: [ffff9859d4799068:btrfs_extent_buffer] ffffafca9cbe7c30
>>>>     ffffafca9cbe7bb0: __btrfs_cow_block+536
>>>> #13 [ffffafca9cbe7bb0] __btrfs_cow_block at ffffffffc0375a78 [btrfs]
>>>>     ffffafca9cbe7bb8: ffffafca9cbe7cf0 [ffff9859d360caf0:btrfs_extent_buffer]
>>>>     ffffafca9cbe7bc8: 0000000000000000 000000009cbe7c00
>>>>     ffffafca9cbe7bd8: [ffff985e751bc000:kmalloc-8192] 0000000000000001
>>>>     ffffafca9cbe7be8: 00ffafca00000000 0100000000000001
>>>>     ffffafca9cbe7bf8: 0000000000000000 bd74f794474322a9
>>>>     ffffafca9cbe7c08: [ffff9859d360caf0:btrfs_extent_buffer]
>>>> [ffff9859cc626000:kmalloc-2048]
>>>>     ffffafca9cbe7c18: [ffff985a0779e878:btrfs_extent_buffer] ffffafca9cbe7cf0
>>>>     ffffafca9cbe7c28: [ffff985eba32a5a0:btrfs_trans_handle] ffffafca9cbe7c88
>>>>     ffffafca9cbe7c38: btrfs_cow_block+255
>>>> #14 [ffffafca9cbe7c38] btrfs_cow_block at ffffffffc0375fbf [btrfs]
>>>>     ffffafca9cbe7c40: 0000000000000000 0000000000000000
>>>>     ffffafca9cbe7c50: 00000000030dc000 0000000074e89992
>>>>     ffffafca9cbe7c60: [ffff985e74e89930:btrfs_path] 0000000000000001
>>>>     ffffafca9cbe7c70: [ffff9859cc626000:kmalloc-2048] 0000000000000001
>>>>     ffffafca9cbe7c80: 0000000000000002 ffffafca9cbe7d28
>>>>     ffffafca9cbe7c90: btrfs_search_slot+520
>>>> #15 [ffffafca9cbe7c90] btrfs_search_slot at ffffffffc0379a28 [btrfs]
>>>>     ffffafca9cbe7c98: [ffff985e751bc788:kmalloc-8192]
>>>> [ffff985e751bc000:kmalloc-8192]
>>>>     ffffafca9cbe7ca8: ffff985e00000000 ffffffff00000001
>>>>     ffffafca9cbe7cb8: 00000002004322a9 0000000000000002
>>>>     ffffafca9cbe7cc8: ffffafca9cbe7d3f 00000001010070b8
>>>>     ffffafca9cbe7cd8: [ffff985eba32a5a0:btrfs_trans_handle] ffffffff00000001
>>>>     ffffafca9cbe7ce8: 0000000300000000 [ffff9859d360caf0:btrfs_extent_buffer]
>>>>     ffffafca9cbe7cf8: bd74f794474322a9 0000000000000007
>>>>     ffffafca9cbe7d08: [ffff985e74e89930:btrfs_path]
>>>> [ffff985a0a3270b8:dentry(1899:docker.service)]
>>>>     ffffafca9cbe7d18: [ffff9859cc626000:kmalloc-2048]
>>>> [ffff985eba32a5a0:btrfs_trans_handle]
>>>>     ffffafca9cbe7d28: ffffafca9cbe7d80 btrfs_lookup_dir_item+120
>>>> #16 [ffffafca9cbe7d30] btrfs_lookup_dir_item at ffffffffc0393528 [btrfs]
>>>>     ffffafca9cbe7d38: 7800000000000000 5400000000000001
>>>>     ffffafca9cbe7d48: 000000005d1d0684 bd74f794474322a9
>>>>     ffffafca9cbe7d58:
>>>> [ffff985a86ebe8b0:btrfs_inode(1899:docker.service)]
>>>> [ffff985a86eb8c90:btrfs_inode(1899:docker.service)]
>>>>     ffffafca9cbe7d68: [ffff9859cc626000:kmalloc-2048]
>>>> [ffff985e74e89930:btrfs_path]
>>>>     ffffafca9cbe7d78: 0000000000000178 ffffafca9cbe7e18
>>>>     ffffafca9cbe7d88: __btrfs_unlink_inode+170
>>>> #17 [ffffafca9cbe7d88] __btrfs_unlink_inode at ffffffffc03a895a [btrfs]
>>>>     ffffafca9cbe7d90: ffffffffffffffff [ffff985e751bc000:kmalloc-8192]
>>>>     ffffafca9cbe7da0: 0000000000000201 000000000000017f
>>>>     ffffafca9cbe7db0: [ffff985a0a3270b8:dentry(1899:docker.service)]
>>>> 00000007c03a24fb
>>>>     ffffafca9cbe7dc0: [ffff985eba32a5a0:btrfs_trans_handle] 0000000000014000
>>>>     ffffafca9cbe7dd0: 0000000000140000
>>>> [ffff985e735fc880:task_struct(1899:docker.service)]
>>>>     ffffafca9cbe7de0: bd74f794474322a9
>>>> [ffff985a86eb8c90:btrfs_inode(1899:docker.service)]
>>>>     ffffafca9cbe7df0: __cpu_possible_mask [ffff985eba32a5a0:btrfs_trans_handle]
>>>>     ffffafca9cbe7e00: [ffff9859cc626000:kmalloc-2048]
>>>> [ffff985a86eb8e70:btrfs_inode(1899:docker.service)]
>>>>     ffffafca9cbe7e10: [ffff985eba32a5a0:btrfs_trans_handle] ffffafca9cbe7e40
>>>>     ffffafca9cbe7e20: btrfs_unlink_inode+28
>>>> #18 [ffffafca9cbe7e20] btrfs_unlink_inode at ffffffffc03ac49c [btrfs]
>>>>     ffffafca9cbe7e28:
>>>> [ffff985a86ebe8b0:btrfs_inode(1899:docker.service)]
>>>> [ffff985a0a327080:dentry(1899:docker.service)]
>>>>     ffffafca9cbe7e38: [ffff9859cc626000:kmalloc-2048] ffffafca9cbe7e78
>>>>     ffffafca9cbe7e48: btrfs_unlink+132
>>>> #19 [ffffafca9cbe7e48] btrfs_unlink at ffffffffc03ac554 [btrfs]
>>>>     ffffafca9cbe7e50: [ffff985a0a327080:dentry(1899:docker.service)]
>>>> [ffff985a86ebea90:btrfs_inode(1899:docker.service)]
>>>>     ffffafca9cbe7e60:
>>>> [ffff985a86eb8e70:btrfs_inode(1899:docker.service)] ffffafca9cbe7ee0
>>>>     ffffafca9cbe7e70:
>>>> [ffff985a86eb8f18:btrfs_inode(1899:docker.service)] ffffafca9cbe7eb8
>>>>     ffffafca9cbe7e80: vfs_unlink+241
>>>> #20 [ffffafca9cbe7e80] vfs_unlink at ffffffffbac52611
>>>>     ffffafca9cbe7e88: apparmor_path_unlink+27 0000000000000000
>>>>     ffffafca9cbe7e98: [ffff985ec7774000:kmalloc-4096] 0000000000000000
>>>>     ffffafca9cbe7ea8:
>>>> [ffff985a86eb8e70:btrfs_inode(1899:docker.service)] 00000000ffffff9c
>>>>     ffffafca9cbe7eb8: ffffafca9cbe7f38 do_unlinkat+639
>>>> #21 [ffffafca9cbe7ec0] do_unlinkat at ffffffffbac555df
>>>>     ffffafca9cbe7ec8: [ffff985a0a327080:dentry(1899:docker.service)]
>>>> 000000c42114dc80
>>>>     ffffafca9cbe7ed8: 0000000000000000 0000000000000000
>>>>     ffffafca9cbe7ee8: [ffff987d4131d9a0:mnt_cache]
>>>> [ffff985a0a326900:dentry(1899:docker.service)]
>>>>     ffffafca9cbe7ef8: 000000079476b40d [ffff985ec7774093:kmalloc-4096]
>>>>     ffffafca9cbe7f08: bd74f794474322a9 000000c42001800c
>>>>     ffffafca9cbe7f18: 0000000000000080 0000000000001c80
>>>>     ffffafca9cbe7f28: 000000000000003b 0000000000000000
>>>>     ffffafca9cbe7f38: ffffafca9cbe7f48 sys_unlinkat+27
>>>> #22 [ffffafca9cbe7f40] sys_unlinkat at ffffffffbac5619b
>>>>     ffffafca9cbe7f48: 000000c4223c8da0 entry_SYSCALL_64_fastpath+30
>>>> #23 [ffffafca9cbe7f50] entry_SYSCALL_64_fastpath at ffffffffbb23af3b
>>>>     RIP: 000000000068b674  RSP: 000000c4223c8d30  RFLAGS: 00000246
>>>>     RAX: ffffffffffffffda  RBX: 000000000000000f  RCX: 000000000068b674
>>>>     RDX: 0000000000000000  RSI: 000000c42114dc80  RDI: ffffffffffffff9c
>>>>     RBP: 000000c4223c8c48   R8: 0000000000000000   R9: 0000000000000000
>>>>     R10: 0000000000000000  R11: 0000000000000246  R12: 000000c4223c9f70
>>>>     R13: 0000000000000b80  R14: 000000000000001f  R15: 0005555555555555
>>>>     ORIG_RAX: 0000000000000107  CS: 0033  SS: 002b
>>>
>>> This issue seems to be pretty easy to reproduce. The following script
>>> can lock-up btrfs-cleaner in less than 5 minutes of time. It requires
>>> that you have a btrfs volume with qgroups and limits setup on
>>> /mnt/btrfs (or whatever you set ROOT to). This was tested on a 32-CPU
>>> machine, without CONFIG_PREEMPT. Upon disabling cores, we were not
>>> able to reproduce the issue.
>>>
>>> #!/bin/bash -x
>>>
>>> ROOT=/mnt/btrfs
>>> #sudo btrfs quota enable ${ROOT}
>>>
>>> btrfs subvolume create ${ROOT}/foo
>>> mkdir -p ${ROOT}/snapshots
>>> mkdir -p ${ROOT}/bar
>>>
>>> set +x
>>> for i in $(seq 1 15000); do
>>>         dd if=/dev/urandom of=${ROOT}/foo/${i} bs=$((1 + RANDOM %
>>> (4096 * 10000))) count=1 status=none
>>> done
>>> set -x
>>>
>>> SUBVOLCOUNT=100
>>> btrfs subvolume delete $ROOT/snapshots/foo*
>>> for i in $(seq 1 $SUBVOLCOUNT); do
>>>         btrfs subvolume snapshot ${ROOT}/foo ${ROOT}/snapshots/foo${i}
>>> done
>>>
>>> while true; do
>>>         # Delete $SUBVOLCOUNT random subvolumes
>>>         volumes_to_delete=""
>>>         for i in $(seq 1 10); do
>>>                 vol_id=$((1 + RANDOM % $SUBVOLCOUNT))
>>>                 volumes_to_delete="${volumes_to_delete}
>>> ${ROOT}/snapshots/foo${vol_id}"
>>>                 set +x
>>>                 for i in $(seq 1 1500); do
>>>                         dd if=/dev/urandom
>>> of=${ROOT}/snapshots/foo${vol_id}/${i} bs=100 count=1 status=none
>>>                 done
>>>                 set -x
>>>         done
>>>         volumes_to_delete=$(echo $volumes_to_delete|cut -b1-)
>>>         set +x
>>>         for i in $(seq 500); do
>>>                 mkdir ${ROOT}/bar/${i}
>>>         done
>>>         btrfs subvolume delete $volumes_to_delete
>>>         for i in $(seq 500); do
>>>                 rmdir ${ROOT}/bar/${i}
>>>         done
>>>         set -x
>>>         for vol in $volumes_to_delete; do
>>>                 if [ ! -d $vol ]; then
>>>                         btrfs subvolume snapshot ${ROOT}/foo $vol
>>>                 fi
>>>         done
>>> done
>>>
>>> #####
>>> The cleaner gets stuck in:
>>> [<ffffffffc04af12c>] btrfs_tree_read_lock+0xcc/0x120 [btrfs]
>>> [<ffffffffc04d8bae>] __add_missing_keys+0xbe/0x130 [btrfs]
>>> [<ffffffffc04da4d9>] find_parent_nodes+0x379/0x900 [btrfs]
>>> [<ffffffffc04dab09>] __btrfs_find_all_roots+0xa9/0x120 [btrfs]
>>> [<ffffffffc04dabf5>] btrfs_find_all_roots+0x55/0x70 [btrfs]
>>> [<ffffffffc04df5ee>] btrfs_qgroup_trace_extent+0x12e/0x170 [btrfs]
>>> [<ffffffffc04df747>] btrfs_qgroup_trace_leaf_items+0x117/0x150 [btrfs]
>>> [<ffffffffc04df943>] btrfs_qgroup_trace_subtree+0x1c3/0x350 [btrfs]
>>> [<ffffffffc0454627>] do_walk_down+0x2f7/0x590 [btrfs]
>>> [<ffffffffc045497d>] walk_down_tree+0xbd/0x100 [btrfs]
>>> [<ffffffffc04572c4>] btrfs_drop_snapshot+0x3e4/0x8b0 [btrfs]
>>> [<ffffffffc046faa7>] btrfs_clean_one_deleted_snapshot+0xb7/0x100 [btrfs]
>>> [<ffffffffc046694a>] cleaner_kthread+0x13a/0x190 [btrfs]
>>> [<ffffffff9e8a4929>] kthread+0x109/0x140
>>> [<ffffffff9f03b1bc>] ret_from_fork+0x2c/0x40
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> And the opposing process (where the actual syscall varies):
>>> [<ffffffffc04af12c>] btrfs_tree_read_lock+0xcc/0x120 [btrfs]
>>> [<ffffffffc04d8bae>] __add_missing_keys+0xbe/0x130 [btrfs]
>>> [<ffffffffc04da4d9>] find_parent_nodes+0x379/0x900 [btrfs]
>>> [<ffffffffc04dab09>] __btrfs_find_all_roots+0xa9/0x120 [btrfs]
>>> [<ffffffffc04dabf5>] btrfs_find_all_roots+0x55/0x70 [btrfs]
>>> [<ffffffffc04df494>] btrfs_qgroup_trace_extent_post+0x34/0x60 [btrfs]
>>> [<ffffffffc04c351e>] btrfs_add_delayed_tree_ref+0x1be/0x1e0 [btrfs]
>>> [<ffffffffc044ca5c>] btrfs_inc_extent_ref+0x4c/0x60 [btrfs]
>>> [<ffffffffc044db92>] __btrfs_mod_ref+0x152/0x240 [btrfs]
>>> [<ffffffffc0453674>] btrfs_inc_ref+0x14/0x20 [btrfs]
>>> [<ffffffffc04435fc>] update_ref_for_cow+0xdc/0x340 [btrfs]
>>> [<ffffffffc0443a78>] __btrfs_cow_block+0x218/0x5e0 [btrfs]
>>> [<ffffffffc0443fbf>] btrfs_cow_block+0xff/0x1e0 [btrfs]
>>> [<ffffffffc0447a28>] btrfs_search_slot+0x208/0x9c0 [btrfs]
>>> [<ffffffffc047b2f1>] btrfs_truncate_inode_items+0x1a1/0x1040 [btrfs]
>>> [<ffffffffc047c28c>] btrfs_truncate+0xfc/0x2c0 [btrfs]
>>> [<ffffffffc047cbbd>] btrfs_setattr+0x22d/0x370 [btrfs]
>>> [<ffffffff9ea636ab>] notify_change+0x2db/0x430
>>> [<ffffffff9ea40ac5>] do_truncate+0x75/0xc0
>>> [<ffffffff9ea53552>] path_openat+0x362/0x1450
>>> [<ffffffff9ea55949>] do_filp_open+0x99/0x110
>>> [<ffffffff9ea420e4>] do_sys_open+0x124/0x210
>>> [<ffffffff9ea421ee>] SyS_open+0x1e/0x20
>>> [<ffffffff9f03af3b>] entry_SYSCALL_64_fastpath+0x1e/0xad
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> We have a small emergency patch that appears to help, until an actual
>>> solution is found (if anyone else is running into this):
>>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>>> index 7699e16..e0a261a8 100644
>>> --- a/fs/btrfs/backref.c
>>> +++ b/fs/btrfs/backref.c
>>> @@ -1566,11 +1566,18 @@ int btrfs_find_all_roots(struct
>>> btrfs_trans_handle *trans,
>>>  {
>>>         int ret;
>>>
>>> -       if (!trans)
>>> +       if (!trans) {
>>>                 down_read(&fs_info->commit_root_sem);
>>> +               down_write(&fs_info->find_all_root_sem);
>>> +       } else
>>> +               down_read(&fs_info->find_all_root_sem);
>>> +
>>>         ret = __btrfs_find_all_roots(trans, fs_info, bytenr, time_seq, roots);
>>> -       if (!trans)
>>> +       if (!trans) {
>>> +               up_write(&fs_info->find_all_root_sem);
>>>                 up_read(&fs_info->commit_root_sem);
>>> +       } else
>>> +               up_read(&fs_info->find_all_root_sem);
>>>         return ret;
>>>  }
>>>
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index c411590..9ed0735 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -840,6 +840,8 @@ struct btrfs_fs_info {
>>>
>>>         struct rw_semaphore commit_root_sem;
>>>
>>> +       struct rw_semaphore find_all_root_sem;
>>> +
>>>         struct rw_semaphore cleanup_work_sem;
>>>
>>>         struct rw_semaphore subvol_sem;
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index eb1ee7b..c227895 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -2741,6 +2741,7 @@ int open_ctree(struct super_block *sb,
>>>         mutex_init(&fs_info->volume_mutex);
>>>         mutex_init(&fs_info->ro_block_group_mutex);
>>>         init_rwsem(&fs_info->commit_root_sem);
>>> +       init_rwsem(&fs_info->find_all_root_sem);
>>>         init_rwsem(&fs_info->cleanup_work_sem);
>>>         init_rwsem(&fs_info->subvol_sem);
>>>         sema_init(&fs_info->uuid_tree_rescan_sem, 1);
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>
>
> --
> Jeff Mahoney
> SUSE Labs
>
