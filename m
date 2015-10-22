Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:57960 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964891AbbJVO6e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Oct 2015 10:58:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 22 Oct 2015 16:58:31 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix regression when running delayed references
In-Reply-To: <CAL3q7H5UaNNjNOv+72c6ZCdkf0X9oW3Mwbgg=5tOvXBt0BRtbQ@mail.gmail.com>
References: <1445503918-22398-1-git-send-email-fdmanana@kernel.org>
 <5628AD20.4060900@cn.fujitsu.com>
 <CAL3q7H6GauCUEyFFVf_50B4WM-GV5nfjmquBAWR0N+O5phUUUg@mail.gmail.com>
 <CAL3q7H5UaNNjNOv+72c6ZCdkf0X9oW3Mwbgg=5tOvXBt0BRtbQ@mail.gmail.com>
Message-ID: <70d472fe30931a09115ac0f4051802d1@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-10-22 11:47, Filipe Manana a écrit :
> On Thu, Oct 22, 2015 at 10:43 AM, Filipe Manana <fdmanana@kernel.org> 
> wrote:
>> On Thu, Oct 22, 2015 at 10:32 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> 
>> wrote:
>>> 
>>> 
>>>  wrote on 2015/10/22 09:47 +0100:
>>>> 
>>>> From: Filipe Manana <fdmanana@suse.com>
>>>> 
>>>> In the kernel 4.2 merge window we had a refactoring/rework of the 
>>>> delayed
>>>> references implementation in order to fix certain problems with 
>>>> qgroups.
>>>> However that rework introduced one more regression that leads to the
>>>> following trace when running delayed references for metadata:
>>>> 
>>>> [35908.064664] kernel BUG at fs/btrfs/extent-tree.c:1832!
>>>> [35908.065201] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>>> [35908.065201] Modules linked in: dm_flakey dm_mod btrfs 
>>>> crc32c_generic
>>>> xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace 
>>>> fscache
>>>> sunrpc loop fuse parport_pc psmouse i2
>>>> [35908.065201] CPU: 14 PID: 15014 Comm: kworker/u32:9 Tainted: G     
>>>>    W
>>>> 4.3.0-rc5-btrfs-next-17+ #1
>>>> [35908.065201] Hardware name: QEMU Standard PC (i440FX + PIIX, 
>>>> 1996), BIOS
>>>> rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 
>>>> 04/01/2014
>>>> [35908.065201] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper
>>>> [btrfs]
>>>> [35908.065201] task: ffff880114b7d780 ti: ffff88010c4c8000 task.ti:
>>>> ffff88010c4c8000
>>>> [35908.065201] RIP: 0010:[<ffffffffa04928b5>]  [<ffffffffa04928b5>]
>>>> insert_inline_extent_backref+0x52/0xb1 [btrfs]
>>>> [35908.065201] RSP: 0018:ffff88010c4cbb08  EFLAGS: 00010293
>>>> [35908.065201] RAX: 0000000000000000 RBX: ffff88008a661000 RCX:
>>>> 0000000000000000
>>>> [35908.065201] RDX: ffffffffa04dd58f RSI: 0000000000000001 RDI:
>>>> 0000000000000000
>>>> [35908.065201] RBP: ffff88010c4cbb40 R08: 0000000000001000 R09:
>>>> ffff88010c4cb9f8
>>>> [35908.065201] R10: 0000000000000000 R11: 000000000000002c R12:
>>>> 0000000000000000
>>>> [35908.065201] R13: ffff88020a74c578 R14: 0000000000000000 R15:
>>>> 0000000000000000
>>>> [35908.065201] FS:  0000000000000000(0000) GS:ffff88023edc0000(0000)
>>>> knlGS:0000000000000000
>>>> [35908.065201] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> [35908.065201] CR2: 00000000015e8708 CR3: 0000000102185000 CR4:
>>>> 00000000000006e0
>>>> [35908.065201] Stack:
>>>> [35908.065201]  ffff88010c4cbb18 0000000000000f37 ffff88020a74c578
>>>> ffff88015a408000
>>>> [35908.065201]  ffff880154a44000 0000000000000000 0000000000000005
>>>> ffff88010c4cbbd8
>>>> [35908.065201]  ffffffffa0492b9a 0000000000000005 0000000000000000
>>>> 0000000000000000
>>>> [35908.065201] Call Trace:
>>>> [35908.065201]  [<ffffffffa0492b9a>] 
>>>> __btrfs_inc_extent_ref+0x8b/0x208
>>>> [btrfs]
>>>> [35908.065201]  [<ffffffffa0497117>] ?
>>>> __btrfs_run_delayed_refs+0x4d4/0xd33 [btrfs]
>>>> [35908.065201]  [<ffffffffa049773d>] 
>>>> __btrfs_run_delayed_refs+0xafa/0xd33
>>>> [btrfs]
>>>> [35908.065201]  [<ffffffffa04a976a>] ? 
>>>> join_transaction.isra.10+0x25/0x41f
>>>> [btrfs]
>>>> [35908.065201]  [<ffffffffa04a97ed>] ? 
>>>> join_transaction.isra.10+0xa8/0x41f
>>>> [btrfs]
>>>> [35908.065201]  [<ffffffffa049914d>] 
>>>> btrfs_run_delayed_refs+0x75/0x1dd
>>>> [btrfs]
>>>> [35908.065201]  [<ffffffffa04992f1>] 
>>>> delayed_ref_async_start+0x3c/0x7b
>>>> [btrfs]
>>>> [35908.065201]  [<ffffffffa04d4b4f>] normal_work_helper+0x14c/0x32a
>>>> [btrfs]
>>>> [35908.065201]  [<ffffffffa04d4e93>] 
>>>> btrfs_extent_refs_helper+0x12/0x14
>>>> [btrfs]
>>>> [35908.065201]  [<ffffffff81063b23>] process_one_work+0x24a/0x4ac
>>>> [35908.065201]  [<ffffffff81064285>] worker_thread+0x206/0x2c2
>>>> [35908.065201]  [<ffffffff8106407f>] ? rescuer_thread+0x2cb/0x2cb
>>>> [35908.065201]  [<ffffffff8106407f>] ? rescuer_thread+0x2cb/0x2cb
>>>> [35908.065201]  [<ffffffff8106904d>] kthread+0xef/0xf7
>>>> [35908.065201]  [<ffffffff81068f5e>] ? kthread_parkme+0x24/0x24
>>>> [35908.065201]  [<ffffffff8147d10f>] ret_from_fork+0x3f/0x70
>>>> [35908.065201]  [<ffffffff81068f5e>] ? kthread_parkme+0x24/0x24
>>>> [35908.065201] Code: 6a 01 41 56 41 54 ff 75 10 41 51 4d 89 c1 49 89 
>>>> c8 48
>>>> 8d 4d d0 e8 f6 f1 ff ff 48 83 c4 28 85 c0 75 2c 49 81 fc ff 00 00 00 
>>>> 77 02
>>>> <0f> 0b 4c 8b 45 30 8b 4d 28 45 31
>>>> [35908.065201] RIP  [<ffffffffa04928b5>]
>>>> insert_inline_extent_backref+0x52/0xb1 [btrfs]
>>>> [35908.065201]  RSP <ffff88010c4cbb08>
>>>> [35908.310885] ---[ end trace fe4299baf0666457 ]---
>>>> 
>>>> This happens because the new delayed references code no longer 
>>>> merges
>>>> delayed references that have different sequence values. The 
>>>> following
>>>> steps are an example sequence leading to this issue:
>>>> 
>>>> 1) Transaction N starts, fs_info->tree_mod_seq has value 0;
>>>> 
>>>> 2) Extent buffer (btree node) A is allocated, delayed reference Ref1 
>>>> for
>>>>     bytenr A is created, with a value of 1 and a seq value of 0;
>>>> 
>>>> 3) fs_info->tree_mod_seq is incremented to 1;
>>>> 
>>>> 4) Extent buffer A is deleted through btrfs_del_items(), which calls
>>>>     btrfs_del_leaf(), which in turn calls btrfs_free_tree_block(). 
>>>> The
>>>>     later returns the metadata extent associated to extent buffer A 
>>>> to
>>>>     the free space cache (the range is not pinned), because the 
>>>> extent
>>>>     buffer was created in the current transaction (N) and writeback 
>>>> never
>>>>     happened for the extent buffer (flag BTRFS_HEADER_FLAG_WRITTEN 
>>>> not set
>>>>     in the extent buffer).
>>>>     This creates the delayed reference Ref2 for bytenr A, with a 
>>>> value
>>>>     of -1 and a seq value of 1;
>>>> 
>>>> 5) Delayed reference Ref2 is not merged with Ref1 when we create it,
>>>>     because they have different sequence numbers (decided at
>>>>     add_delayed_ref_tail_merge());
>>>> 
>>>> 6) fs_info->tree_mod_seq is incremented to 2;
>>>> 
>>>> 7) Some task attempts to allocate a new extent buffer (done at
>>>>     extent-tree.c:find_free_extent()), but due to heavy 
>>>> fragmentation
>>>>     and running low on metadata space the clustered allocation fails
>>>>     and we fall back to unclustered allocation, which finds the
>>>>     extent at offset A, so a new extent buffer at offset A is 
>>>> allocated.
>>>>     This creates delayed reference Ref3 for bytenr A, with a value 
>>>> of -1
>>>>     and a seq value of 2;
>>>> 
>>>> 8) Ref3 is not merged neither with Ref2 nor Ref1, again because they
>>>>     all have different seq values;
>>>> 
>>>> 9) We start running the delayed references 
>>>> (__btrfs_run_delayed_refs());
>>>> 
>>>> 10) The delayed Ref1 is the first one being applied, which ends up
>>>>      creating an inline extent backref in the extent tree;
>>>> 
>>>> 10) Next the delayed reference Ref3 is selected for execution, and 
>>>> not
>>>>      Ref2, because select_delayed_ref() always gives a preference 
>>>> for
>>>>      positive references (that have an action of 
>>>> BTRFS_ADD_DELAYED_REF);
>>>> 
>>>> 11) When running Ref3 we encounter alreay the inline extent backref
>>>>      in the extent tree at insert_inline_extent_backref(), which 
>>>> makes
>>>>      us hit the following BUG_ON:
>>>> 
>>>>          BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
>>>> 
>>>>      This is always true because owner corresponds to the level of 
>>>> the
>>>>      extent buffer/btree node in the btree.
>>>> 
>>>> For the scenario described above we hit the BUG_ON because we never 
>>>> merge
>>>> references that have different seq values.
>>>> 
>>>> We used to do the merging before the 4.2 kernel, more specifically, 
>>>> before
>>>> the commmits:
>>>> 
>>>>    c6fc24549960 ("btrfs: delayed-ref: Use list to replace the 
>>>> ref_root in
>>>> ref_head.")
>>>>    c43d160fcd5e ("btrfs: delayed-ref: Cleanup the unneeded 
>>>> functions.")
>>>> 
>>>> This issue became more exposed after the following change that was 
>>>> added
>>>> to 4.2 as well:
>>>> 
>>>>    cffc3374e567 ("Btrfs: fix order by which delayed references are 
>>>> run")
>>>> 
>>>> Which in turn fixed another regression by the two commits previously
>>>> mentioned.
>>>> 
>>>> So fix this by bringing back the delayed reference merge code, with 
>>>> the
>>>> proper adaptations so that it operates against the new data 
>>>> structure
>>>> (linked list vs old red black tree implementation).
>>>> 
>>>> This issue was hit running fstest btrfs/063 in a loop. Several 
>>>> people have
>>>> reported this issue in the mailing list when running on kernels 
>>>> 4.2+.
>>> 
>>> 
>>> Thanks Filipe,
>>> 
>>> My fault again. :(
>>> But I'm not completely sure about if tree_mod_seq is still needed 
>>> now.
>>> 
>>> IIRC, with the new qgroup accounting happen at commit_transaction 
>>> time,
>>> btrfs_find_all_roots() should either searching commit tree for old 
>>> roots, or
>>> search current tree for new roots.
>>> No need to search using tree_mod_seq.
>>> 
>>> If so, I'd like just allow merging refs without checking 
>>> tree_mod_seq.
> 
> And to make it clear, that wouldn't work. If a backref walker starts
> iterating the btrees and then new delayed refs get merged
> independently of the current tree mod seq, the walker will see an
> inconsistent state in the extent tree if the delayed references are
> run (which can happen often before a transaction commit).
> 
> So either make delayed references continue using tree mod seq as
> before 4.2, or come with a whole new mechanism that replaces the tree
> mod seq while still giving the same consistency guarantees.

I used your patch at https://patchwork.kernel.org/patch/7463161/ to 
build a 4.3.0-rc6 kernel.
I mounted my FS with skip_balance, cancelled the paused balance (just to 
be sure), then started a new one with :

# btrfs balance start -dconvert=raid5,soft /tank

(half of my data blocks are RAID1, the other half is RAID5, the goal is 
to be fully RAID5).

I got a different stacktrace than the usual one, via netconsole, after a 
few minutes. It's still referencing btrfs_run_delayed_refs though:

[  822.461809] ------------[ cut here ]------------
[  822.461833] kernel BUG at fs/btrfs/extent-tree.c:2287!
[  822.461849] invalid opcode: 0000 [#1] SMP
[  822.461866] Modules linked in: nfnetlink_queue nfnetlink_log 
nfnetlink xt_multiport xt_comment xt_conntrack xt_nat xt_tcpudp xts 
gf128mul drbg ansi_cprng btrfs nf_conntrack_ftp nf_conntrack_sane 
iptable_security iptable_filter iptable_mangle iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4
[  822.462365] CPU: 1 PID: 3810 Comm: btrfs-transacti Tainted: G        
W       4.3.0-rc6p7463161+ #3
[  822.462391] Hardware name: ASUS All Series/H87I-PLUS, BIOS 1005 
01/06/2014
[  822.462412] task: ffff88011a4a1a00 ti: ffff8800b6638000 task.ti: 
ffff8800b6638000
[  822.462434] RIP: 0010:[<ffffffffc032310b>]  [<ffffffffc032310b>] 
__btrfs_run_delayed_refs.constprop.73+0x108b/0x10d0 [btrfs]
[  822.462476] RSP: 0018:ffff8800b663bcb0  EFLAGS: 00010202
[  822.462495] RAX: 0000000000000001 RBX: ffff8800b3821888 RCX: 
ffff8800b3a46cb8
[  822.462517] RDX: 0000000000000001 RSI: 00000000000001e1 RDI: 
ffff8800b3a46cb0
[  822.462543] RBP: ffff8800b663bdb8 R08: 0000000000000000 R09: 
ffff8800b3a46cb8
[  822.462565] R10: ffff8800b3a46cb8 R11: ffff8800b3a46cb8 R12: 
0000000000000000
[  822.462587] R13: 0000000000000000 R14: 00000afefd330000 R15: 
ffff8800b3a46c38
[  822.462687] FS:  0000000000000000(0000) GS:ffff88011fb00000(0000) 
knlGS:0000000000000000
[  822.462716] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  822.462736] CR2: 00007ff7a21ca000 CR3: 0000000001c10000 CR4: 
00000000000406e0
[  822.462762] Stack:
[  822.462770]  ffffffffc037c8be ffff88011fb169f0 0000000000000001 
0000000000000001
[  822.462802]  0000000000000001 ffff88011a4a1a60 ffff8800b663bd38 
ffff8800b663bd40
[  822.462831]  ffffffff810aded5 ffffffff8101fcc9 ffff8800b663bd20 
00000000000014d9
[  822.462859] Call Trace:
[  822.462877]  [<ffffffffc037c8be>] ? 
try_merge_free_space.isra.26+0x12e/0x180 [btrfs]
[  822.462902]  [<ffffffff810aded5>] ? put_prev_entity+0x35/0x660
[  822.462924]  [<ffffffff8101fcc9>] ? sched_clock+0x9/0x10
[  822.462949]  [<ffffffffc0325dcd>] btrfs_run_delayed_refs+0x7d/0x2b0 
[btrfs]
[  822.462972]  [<ffffffff817aa7ab>] ? schedule_timeout+0x16b/0x2a0
[  822.462999]  [<ffffffffc033a6b3>] btrfs_commit_transaction+0x43/0xb10 
[btrfs]
[  822.463028]  [<ffffffffc0335c19>] transaction_kthread+0x1a9/0x230 
[btrfs]
[  822.463056]  [<ffffffffc0335a70>] ? 
btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[  822.463080]  [<ffffffff81097099>] kthread+0xc9/0xe0
[  822.463096]  [<ffffffff81096fd0>] ? kthread_park+0x60/0x60
[  822.463116]  [<ffffffff817aba8f>] ret_from_fork+0x3f/0x70
[  822.463134]  [<ffffffff81096fd0>] ? kthread_park+0x60/0x60
[  822.463153] Code: c0 48 8b bd 40 ff ff ff 31 c0 e8 31 94 fe ff 0f 0b 
be d3 00 00 00 48 c7 c7 3b c6 3b c0 e8 6e 63 d5 c0 e9 64 f9 ff ff 0f 0b 
0f 0b <0f> 0b be d3 00 00 00 48 c7 c7 3b c6 3b c0 e8 52 63 d5 c0 e9 60
[  822.463300] RIP  [<ffffffffc032310b>] 
__btrfs_run_delayed_refs.constprop.73+0x108b/0x10d0 [btrfs]
[  822.463335]  RSP <ffff8800b663bcb0>
[  822.472131] ---[ end trace f1e21f38cb0ea144 ]---

A couple other stacktraces follow after some seconds, then the system 
dies completely. sysrqd doesn't even work to reboot it remotely using 
sysrq logic.

fs/btrfs/extent-tree.c:2287 is the line you get from a vanilla 4.3-rc6 + 
your patch. I'll post it as soon as I can get somebody to manually 
reboot this remote machine (my kernel build machine is the same than the 
one hosting the btrfs FS).

Don't hesitate to ask if you need me to debug or even ftrace something.

Thanks,

-- 
Stéphane.

>>> I was going to do it but not completely sure is there any other user 
>>> of
>>> tree_mod_seq.
>>> And if it's possible to get rid of tree_mod_seq and merge with last
>>> delayed_ref, things should get cleaner without new codes.
>> 
>> Well, the tree mod seq is what allows backref walkers (and possibly
>> other paths) to get a consistent view of all btrees and delayed refs
>> state while doing some processing - that's why we have calls to
>> btrfs_check_delayed_seq() when running delayed references - so that
>> any backref walker will not see changes that happen after it started,
>> i.e. it will see a consistent view of all the btrees (like an
>> in-memory snapshot of all btrees while the transaction is running).
>> 
>> I don't think you can get this level of consistency through any other
>> existing means.
>> So just adding back yet more code that was removed despite still being 
>> needed.
>> 
>> This is affecting way too many people now, I would like to get this
>> fixed and later, if there's a better (new) solution for this, we can
>> get it in.
>> 
>> thanks
>> 
>>> 
>>> Thanks,
>>> Qu
>>> 
>>> 
>>> 
>>>> 
>>>> Fixes: c6fc24549960 ("btrfs: delayed-ref: Use list to replace the 
>>>> ref_root
>>>> in ref_head.")
>>>> Reported-by: Peter Becker <floyd.net@gmail.com>
>>>> Reported-by: Stéphane Lesimple <stephane_btrfs@lesimple.fr>
>>>> Reported-by: Malte Schröder <malte@tnxip.de>
>>>> Reported-by: Derek Dongray <derek@valedon.co.uk>
>>>> Reported-by: Erkki Seppala <flux-btrfs@inside.org>
>>>> Cc: stable@vger.kernel.org  # 4.2+
>>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>>> ---
>>>>   fs/btrfs/delayed-ref.c | 113
>>>> +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>   fs/btrfs/extent-tree.c |  14 ++++++
>>>>   2 files changed, 127 insertions(+)
>>>> 
>>>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>>>> index ac3e81d..4832943 100644
>>>> --- a/fs/btrfs/delayed-ref.c
>>>> +++ b/fs/btrfs/delayed-ref.c
>>>> @@ -197,6 +197,119 @@ static inline void drop_delayed_ref(struct
>>>> btrfs_trans_handle *trans,
>>>>                 trans->delayed_ref_updates--;
>>>>   }
>>>> 
>>>> +static bool merge_ref(struct btrfs_trans_handle *trans,
>>>> +                     struct btrfs_delayed_ref_root *delayed_refs,
>>>> +                     struct btrfs_delayed_ref_head *head,
>>>> +                     struct btrfs_delayed_ref_node *ref,
>>>> +                     u64 seq)
>>>> +{
>>>> +       struct btrfs_delayed_ref_node *next;
>>>> +       bool done = false;
>>>> +
>>>> +       next = list_first_entry(&head->ref_list, struct
>>>> btrfs_delayed_ref_node,
>>>> +                               list);
>>>> +       while (!done && &next->list != &head->ref_list) {
>>>> +               int mod;
>>>> +               struct btrfs_delayed_ref_node *next2;
>>>> +
>>>> +               next2 = list_next_entry(next, list);
>>>> +
>>>> +               if (next == ref)
>>>> +                       goto next;
>>>> +
>>>> +               if (seq && next->seq >= seq)
>>>> +                       goto next;
>>>> +
>>>> +               if (next->type != ref->type || next->no_quota !=
>>>> ref->no_quota)
>>>> +                       goto next;
>>>> +
>>>> +               if ((ref->type == BTRFS_TREE_BLOCK_REF_KEY ||
>>>> +                    ref->type == BTRFS_SHARED_BLOCK_REF_KEY) &&
>>>> +                   
>>>> comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref),
>>>> +                                  
>>>> btrfs_delayed_node_to_tree_ref(next),
>>>> +                                  ref->type))
>>>> +                       goto next;
>>>> +               if ((ref->type == BTRFS_EXTENT_DATA_REF_KEY ||
>>>> +                    ref->type == BTRFS_SHARED_DATA_REF_KEY) &&
>>>> +                   
>>>> comp_data_refs(btrfs_delayed_node_to_data_ref(ref),
>>>> +                                  
>>>> btrfs_delayed_node_to_data_ref(next)))
>>>> +                       goto next;
>>>> +
>>>> +               if (ref->action == next->action) {
>>>> +                       mod = next->ref_mod;
>>>> +               } else {
>>>> +                       if (ref->ref_mod < next->ref_mod) {
>>>> +                               swap(ref, next);
>>>> +                               done = true;
>>>> +                       }
>>>> +                       mod = -next->ref_mod;
>>>> +               }
>>>> +
>>>> +               drop_delayed_ref(trans, delayed_refs, head, next);
>>>> +               ref->ref_mod += mod;
>>>> +               if (ref->ref_mod == 0) {
>>>> +                       drop_delayed_ref(trans, delayed_refs, head, 
>>>> ref);
>>>> +                       done = true;
>>>> +               } else {
>>>> +                       /*
>>>> +                        * Can't have multiples of the same ref on a 
>>>> tree
>>>> block.
>>>> +                        */
>>>> +                       WARN_ON(ref->type == 
>>>> BTRFS_TREE_BLOCK_REF_KEY ||
>>>> +                               ref->type == 
>>>> BTRFS_SHARED_BLOCK_REF_KEY);
>>>> +               }
>>>> +next:
>>>> +               next = next2;
>>>> +       }
>>>> +
>>>> +       return done;
>>>> +}
>>>> +
>>>> +void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
>>>> +                             struct btrfs_fs_info *fs_info,
>>>> +                             struct btrfs_delayed_ref_root 
>>>> *delayed_refs,
>>>> +                             struct btrfs_delayed_ref_head *head)
>>>> +{
>>>> +       struct btrfs_delayed_ref_node *ref;
>>>> +       u64 seq = 0;
>>>> +
>>>> +       assert_spin_locked(&head->lock);
>>>> +
>>>> +       if (list_empty(&head->ref_list))
>>>> +               return;
>>>> +
>>>> +       /* We don't have too many refs to merge for data. */
>>>> +       if (head->is_data)
>>>> +               return;
>>>> +
>>>> +       spin_lock(&fs_info->tree_mod_seq_lock);
>>>> +       if (!list_empty(&fs_info->tree_mod_seq_list)) {
>>>> +               struct seq_list *elem;
>>>> +
>>>> +               elem = list_first_entry(&fs_info->tree_mod_seq_list,
>>>> +                                       struct seq_list, list);
>>>> +               seq = elem->seq;
>>>> +       }
>>>> +       spin_unlock(&fs_info->tree_mod_seq_lock);
>>>> +
>>>> +       ref = list_first_entry(&head->ref_list, struct
>>>> btrfs_delayed_ref_node,
>>>> +                              list);
>>>> +       while (&ref->list != &head->ref_list) {
>>>> +               if (seq && ref->seq >= seq)
>>>> +                       goto next;
>>>> +
>>>> +               if (merge_ref(trans, delayed_refs, head, ref, seq)) 
>>>> {
>>>> +                       if (list_empty(&head->ref_list))
>>>> +                               break;
>>>> +                       ref = list_first_entry(&head->ref_list,
>>>> +                                              struct
>>>> btrfs_delayed_ref_node,
>>>> +                                              list);
>>>> +                       continue;
>>>> +               }
>>>> +next:
>>>> +               ref = list_next_entry(ref, list);
>>>> +       }
>>>> +}
>>>> +
>>>>   int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
>>>>                             struct btrfs_delayed_ref_root 
>>>> *delayed_refs,
>>>>                             u64 seq)
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index 522fb45..42d9310 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -2433,7 +2433,21 @@ static noinline int 
>>>> __btrfs_run_delayed_refs(struct
>>>> btrfs_trans_handle *trans,
>>>>                         }
>>>>                 }
>>>> 
>>>> +               /*
>>>> +                * We need to try and merge add/drops of the same 
>>>> ref
>>>> since we
>>>> +                * can run into issues with relocate dropping the 
>>>> implicit
>>>> ref
>>>> +                * and then it being added back again before the 
>>>> drop can
>>>> +                * finish.  If we merged anything we need to re-loop 
>>>> so we
>>>> can
>>>> +                * get a good ref.
>>>> +                * Or we can get node references of the same type 
>>>> that
>>>> weren't
>>>> +                * merged when created due to bumps in the tree mod 
>>>> seq,
>>>> and
>>>> +                * we need to merge them to prevent adding an inline
>>>> extent
>>>> +                * backref before dropping it (triggering a BUG_ON 
>>>> at
>>>> +                * insert_inline_extent_backref()).
>>>> +                */
>>>>                 spin_lock(&locked_ref->lock);
>>>> +               btrfs_merge_delayed_refs(trans, fs_info, 
>>>> delayed_refs,
>>>> +                                        locked_ref);
>>>> 
>>>>                 /*
>>>>                  * locked_ref is the head node, so we have to go one
>>>> 
>>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

