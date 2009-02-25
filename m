From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: [PATCH] Backport for 2.6.27 and 2.6.26 on the experimental
	branch
Date: Wed, 25 Feb 2009 18:09:28 -0500
Message-ID: <20090225230928.GB9232@tux64-01>
References: <20090220174518.GA23955@tux64-01> <499EF58F.6020807@hp.com> <20090223222304.GB13878@tux64-01> <49A41F26.2020202@hp.com> <20090224203629.GB12209@tux64-01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090224203629.GB12209@tux64-01>
List-ID: <linux-btrfs.vger.kernel.org>

A second update to this. It seems the problem is that btrfs gets stuck
in an infinite loop while in tree_insert. I'm not sure why yet. Below is
my back trace incase anyone wants to have a look.

[ 9824.393942] SysRq : Show Blocked State
[ 9824.393942]   task                PC stack   pid father
[ 9824.393942] ls            D 00000000     0  3456   3334
[ 9824.393942]        f1ada8c0 00200082 01c19000 00000000 01c19000 f1adaa4c c27f7fa0 00000000 
[ 9824.393942]        f518830c 001f711e c27e68a4 c013604c 00000000 00000000 00000000 000000ff 
[ 9824.393942]        c27f7fa0 0243d000 c27e68a4 c015688a c02b8498 f1b6fc64 f1b6fc64 c01568bd 
[ 9824.393942] Call Trace:
[ 9824.393942]  [<c013604c>] getnstimeofday+0x37/0xbc
[ 9824.393942]  [<c015688a>] sync_page+0x0/0x36
[ 9824.393942]  [<c02b8498>] io_schedule+0x49/0x80
[ 9824.393942]  [<c01568bd>] sync_page+0x33/0x36
[ 9824.393942]  [<c02b85c4>] __wait_on_bit_lock+0x2a/0x52
[ 9824.393942]  [<c015687c>] __lock_page+0x4e/0x54
[ 9824.393942]  [<c0131909>] wake_bit_function+0x0/0x3c
[ 9824.393942]  [<f8f9d2da>] read_extent_buffer_pages+0x133/0x2f1 [btrfs]
[ 9824.393942]  [<f8f820b4>] btree_read_extent_buffer_pages+0x39/0x8c [btrfs]
[ 9824.393942]  [<f8f83d9d>] btree_get_extent+0x0/0x173 [btrfs]
[ 9824.393942]  [<f8f823ba>] read_tree_block+0x29/0x4c [btrfs]
[ 9824.393942]  [<f8f72336>] btrfs_search_slot+0x4fe/0x638 [btrfs]
[ 9824.393942]  [<f8f8186b>] btrfs_lookup_inode+0x27/0x88 [btrfs]
[ 9824.393942]  [<f8f87bce>] btrfs_read_locked_inode+0x53/0x2fc [btrfs]
[ 9824.393942]  [<c018485c>] iget5_locked+0x7a/0x12b
[ 9824.393942]  [<f8f89acf>] btrfs_find_actor+0x0/0x27 [btrfs]
[ 9824.393942]  [<f8f87ebd>] btrfs_iget+0x46/0x6c [btrfs]
[ 9824.393942]  [<f8f88056>] btrfs_lookup_dentry+0x173/0x184 [btrfs]
[ 9824.393942]  [<c0183039>] d_alloc+0x138/0x17a
[ 9824.393942]  [<f8f89e90>] btrfs_lookup+0x18/0x2d [btrfs]
[ 9824.393942]  [<c017a53b>] do_lookup+0xb6/0x153
[ 9824.393942]  [<c017c12d>] __link_path_walk+0x724/0xb0b
[ 9824.393942]  [<f8f9ac63>] tree_insert+0x54/0x5b [btrfs]
[ 9824.393942]  [<c017c54b>] path_walk+0x37/0x70
[ 9824.393942]  [<c017c7fa>] do_path_lookup+0x122/0x184
[ 9824.393942]  [<c017d057>] __user_walk_fd+0x29/0x3a
[ 9824.393942]  [<c0177141>] vfs_lstat_fd+0x12/0x39
[ 9824.393942]  [<c01771d5>] sys_lstat64+0xf/0x23
[ 9824.393942]  [<c0103853>] sysenter_past_esp+0x78/0xb1
[ 9824.393942]  [<c02b0000>] acpi_pci_root_add+0x125/0x296
[ 9824.393942]  =======================
[ 9824.393942] Sched Debug Version: v0.07, 2.6.26-1-686 #1
[ 9824.393942] now at 8542803.745635 msecs
[ 9824.393942]   .sysctl_sched_latency                    : 40.000000
[ 9824.393942]   .sysctl_sched_min_granularity            : 8.000000
[ 9824.393942]   .sysctl_sched_wakeup_granularity         : 20.000000
[ 9824.393942]   .sysctl_sched_child_runs_first           : 0.000001
[ 9824.393942]   .sysctl_sched_features                   : 895
[ 9824.393942] 
[ 9824.393942] cpu#0, 1862.040 MHz
[ 9824.393942]   .nr_running                    : 2
[ 9824.393942]   .load                          : 2048
[ 9824.393942]   .nr_switches                   : 475330
[ 9824.393942]   .nr_load_updates               : 61723
[ 9824.393942]   .nr_uninterruptible            : 4294966907
[ 9824.393942]   .jiffies                       : 2060701
[ 9824.393942]   .next_balance                  : 2.060723
[ 9824.393942]   .curr->pid                     : 2199
[ 9824.393942]   .clock                         : 8542803.113648
[ 9824.393942]   .cpu_load[0]                   : 0
[ 9824.393942]   .cpu_load[1]                   : 175
[ 9824.393942]   .cpu_load[2]                   : 469
[ 9824.393942]   .cpu_load[3]                   : 621
[ 9824.393942]   .cpu_load[4]                   : 542
[ 9824.393942] 
[ 9824.393942] cfs_rq[0]:
[ 9824.393942]   .exec_clock                    : 0.000000
[ 9824.393942]   .MIN_vruntime                  : 179538.548824
[ 9824.393942]   .min_vruntime                  : 179578.548817
[ 9824.393942]   .max_vruntime                  : 179538.548824
[ 9824.393942]   .spread                        : 0.000000
[ 9824.393942]   .spread0                       : 0.000000
[ 9824.393942]   .nr_running                    : 2
[ 9824.393942]   .load                          : 2048
[ 9824.393942]   .nr_spread_over                : 0
[ 9824.393942] 
[ 9824.393942] runnable tasks:
[ 9824.393942]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 9824.393942] ----------------------------------------------------------------------------------------------------------
[ 9824.393942] R       rsyslogd  2199    179538.548820        28   120               0               0               0.000000               0.000000               0.000000 /
[ 9824.393942]         rsyslogd  3333    179538.548824         9   120               0               0               0.000000               0.000000               0.000000 /
[ 9824.393942] 
[ 9824.393942] cpu#1, 1862.040 MHz
[ 9824.393942]   .nr_running                    : 2
[ 9824.393942]   .load                          : 2048
[ 9824.393942]   .nr_switches                   : 90067
[ 9824.393942]   .nr_load_updates               : 31570
[ 9824.393942]   .nr_uninterruptible            : 390
[ 9824.393942]   .jiffies                       : 2060701
[ 9824.393942]   .next_balance                  : 2.060674
[ 9824.393942]   .curr->pid                     : 3450
[ 9824.393942]   .clock                         : 8542801.036413
[ 9824.393942]   .cpu_load[0]                   : 0
[ 9824.393942]   .cpu_load[1]                   : 0
[ 9824.393942]   .cpu_load[2]                   : 20
[ 9824.393942]   .cpu_load[3]                   : 56
[ 9824.393942]   .cpu_load[4]                   : 60
[ 9824.393942] 
[ 9824.393942] cfs_rq[1]:
[ 9824.393942]   .exec_clock                    : 0.000000
[ 9824.393942]   .MIN_vruntime                  : 40916.410301
[ 9824.393942]   .min_vruntime                  : 40926.274857
[ 9824.393942]   .max_vruntime                  : 40916.410301
[ 9824.393942]   .spread                        : 0.000000
[ 9824.393942]   .spread0                       : -138652.273960
[ 9824.393942]   .nr_running                    : 2
[ 9824.393942]   .load                          : 2048
[ 9824.393942]   .nr_spread_over                : 0
[ 9824.393942] 
[ 9824.393942] runnable tasks:
[ 9824.393942]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[ 9824.393942] ----------------------------------------------------------------------------------------------------------
[ 9824.393942]         metacity  3176     40916.410301      2904   120               0               0               0.000000               0.000000               0.000000 /
[ 9824.393942] R           bash  3450     40886.274880        34   120               0               0               0.000000               0.000000               0.000000 /
[ 9824.393942] 

Lee

On Tue, Feb 24, 2009 at 03:36:29PM -0500, Lee Trager wrote:
> I ran a few tests that Jim suggested and found that btrfs works fine on
> 2.6.26 as long as there are only 23 or less files on the file system.
> Anymore and I experience the lockup. Jim and I will be working to find a
> solution but if anyone else has any clues that would be greatly
> appreciated.
> 
> Lee
> On Tue, Feb 24, 2009 at 11:24:06AM -0500, jim owens wrote:
> > Lee Trager wrote:
> >> The more and more I look at this problem the more I tend to think that
> >> the issue is because of some change in the way the VFS or something
> >> interacts with the file system. Does anyone know of any big changes? Why
> >> is the inode being marked dirty? Is there some kind of read error. I'm
> >> completly lost in solving this problem.
> >
> > Being a filesystem guy, I always try blaming vm or drivers :)
> >
> > Until someone with real experience gives us the answer,
> > I'll work with you off the mailing list to try to narrow
> > down why this is happening.
> >
> > jim
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
