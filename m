From: "Olivier B." <xen.list@daevel.fr>
Subject: Re: [Xen-devel] Linux 3.2.2 & btrfs, on a DomU
Date: Sun, 05 Feb 2012 20:58:10 +0100
Message-ID: <4F2EDF52.8080104@daevel.fr>
References: <4F22F403.2030104@daevel.fr> <4F27B447.5020003@daevel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F27B447.5020003@daevel.fr>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

so, it was a Xen bug, and it is fixed in the last 3.2.3 kernel.

Sorry for the noise,

Olivier

On 31/01/2012 10:28, Olivier B. wrote:
> Hi,
>
> since I have no response from Xen developpers, I suppose it's a btrfs=
 problem ; but maybe I'm wrong. What can you think about that error ?
>
> thanks,
> Olivier
>
> PS : I have not subscribe do the list, so CC me please.
>
>
> Le 27/01/2012 19:59, Olivier B. a =E9crit :
>> Hi,
>>
>> I switch one of my DomU to a 3.2.2 linux kernel (renamed in 2.6.42.2=
,
>> for compatibility with some software), and I have some problem with =
btrfs.
>>
>> I don't know if it's a btrfs or xen problem, the call trace is :
>>
>> [56580.320024] INFO: rcu_sched detected stall on CPU 0 (t=3D15000 ji=
ffies)
>> [56580.320024] Pid: 11505, comm: btrfs-delayed-m Tainted: G C
>> 2.6.42.2-dae-xen #2
>> [56580.320024] Call Trace:
>> [56580.320024] <IRQ> [<ffffffff81084719>] ? __rcu_pending+0x82/0x337
>> [56580.320024] [<ffffffff810678bd>] ? tick_nohz_handler+0xbe/0xbe
>> [56580.320024] [<ffffffff81084ccc>] ? rcu_check_callbacks+0x7e/0xae
>> [56580.320024] [<ffffffff81050d44>] ? update_process_times+0x31/0x63
>> [56580.320024] [<ffffffff8106791f>] ? tick_sched_timer+0x62/0x7e
>> [56580.320024] [<ffffffff8105e8b4>] ? __run_hrtimer.isra.28+0x52/0xa=
a
>> [56580.320024] [<ffffffff8105ee8c>] ? hrtimer_interrupt+0xd5/0x1a1
>> [56580.320024] [<ffffffff8100537e>] ? xen_timer_interrupt+0x28/0x159
>> [56580.320024] [<ffffffff81080097>] ? handle_irq_event_percpu+0x24/0=
x11c
>> [56580.320024] [<ffffffff810824b1>] ? handle_percpu_irq+0x35/0x4c
>> [56580.320024] [<ffffffff811cbe90>] ? __xen_evtchn_do_upcall+0x154/0=
x1eb
>> [56580.320024] [<ffffffff8100525c>] ? xen_force_evtchn_callback+0x9/=
0xa
>> [56580.320024] [<ffffffff811cd490>] ? xen_evtchn_do_upcall+0x22/0x32
>> [56580.320024] [<ffffffff812f863e>] ? xen_do_hypervisor_callback+0x1=
e/0x30
>> [56580.320024] <EOI> [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1=
000
>> [56580.320024] [<ffffffff810013aa>] ? hypercall_page+0x3aa/0x1000
>> [56580.320024] [<ffffffff811cc7d5>] ? xen_poll_irq_timeout+0x38/0x44
>> [56580.320024] [<ffffffff812ee21f>] ? xen_spin_lock_slow+0x86/0xdf
>> [56580.320024] [<ffffffff8100688a>] ? __xen_spin_lock+0x32/0x3b
>> [56580.320024] [<ffffffff8106bd6a>] ? do_raw_spin_lock+0x5/0x8
>> [56580.320024] [<ffffffffa002badd>] ?
>> find_free_extent.constprop.77+0x495/0x94b [btrfs]
>> [56580.320024] [<ffffffffa00689fe>] ?
>> btrfs_add_delayed_tree_ref+0x77/0x120 [btrfs]
>> [56580.320024] [<ffffffffa002e61b>] ? btrfs_reserve_extent+0xa4/0x14=
8
>> [btrfs]
>> [56580.320024] [<ffffffffa002eadb>] ? btrfs_alloc_free_block+0x15d/0=
x283
>> [btrfs]
>> [56580.320024] [<ffffffff81005842>] ? check_events+0x12/0x20
>> [56580.320024] [<ffffffffa0021f3a>] ? __btrfs_cow_block+0x102/0x32c =
[btrfs]
>> [56580.320024] [<ffffffffa0022257>] ? btrfs_cow_block+0xf3/0x102 [bt=
rfs]
>> [56580.320024] [<ffffffffa0024c84>] ? btrfs_search_slot+0x225/0x64e =
[btrfs]
>> [56580.320024] [<ffffffffa00285f2>] ?
>> lookup_inline_extent_backref+0xa8/0x360 [btrfs]
>> [56580.320024] [<ffffffffa002a35c>] ? __btrfs_free_extent+0xcb/0x5c8
>> [btrfs]
>> [56580.320024] [<ffffffff812f1dac>] ? __slab_free+0xd6/0x206
>> [56580.320024] [<ffffffff810b9c65>] ? arch_local_irq_restore+0x7/0x8
>> [56580.320024] [<ffffffffa002d87e>] ? run_clustered_refs+0x65f/0x6a9
>> [btrfs]
>> [56580.320024] [<ffffffff81177fe4>] ? rb_next+0x39/0x3f
>> [56580.320024] [<ffffffffa002d991>] ? btrfs_run_delayed_refs+0xc9/0x=
185
>> [btrfs]
>> [56580.320024] [<ffffffff812ee18a>] ? xen_spin_unlock_slow+0x4d/0x5c
>> [56580.320024] [<ffffffffa003b13a>] ? __btrfs_end_transaction+0x90/0=
x1dd
>> [btrfs]
>> [56580.320024] [<ffffffffa006ff08>] ?
>> btrfs_async_run_delayed_node_done+0xf8/0x156 [btrfs]
>> [56580.320024] [<ffffffffa005a150>] ? worker_loop+0x16a/0x45a [btrfs=
]
>> [56580.320024] [<ffffffffa0059fe6>] ? btrfs_queue_worker+0x279/0x279
>> [btrfs]
>> [56580.320024] [<ffffffff8105bbba>] ? kthread+0x76/0x7e
>> [56580.320024] [<ffffffff812f84f4>] ? kernel_thread_helper+0x4/0x10
>> [56580.320024] [<ffffffff812f65b3>] ? int_ret_from_sys_call+0x7/0x1b
>> [56580.320024] [<ffffffff812f5cbc>] ? retint_restore_args+0x5/0x6
>> [56580.320024] [<ffffffff812f84f0>] ? gs_change+0x13/0x13
>>
>> I had the problem with 3.2, 3.2.1, then 3.2.2. With and without the
>> renaming to 2.6.42.x.
>>
>> The Xen version is 4.0.1 (from Debian amd64), and the Dom0 kernel is=
 a
>> 3.1.0 (also from Debian).
>>
>> Thanks for any advice,
>>
>> Olivier B.
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xensource.com
>> http://lists.xensource.com/xen-devel
>>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
