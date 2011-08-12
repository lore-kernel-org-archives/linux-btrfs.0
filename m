From: Simon Kirby <sim@hostway.ca>
Subject: Re: Slow snapshot deletion
Date: Thu, 11 Aug 2011 17:40:36 -0700
Message-ID: <20110812004036.GA3960@hostway.ca>
References: <20110728200444.GA30801@untroubled.org> <1311884805-sup-7662@shiny> <1311886250-sup-5126@shiny> <20110804163536.GA25185@untroubled.org> <20110811150456.GA558@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110811150456.GA558@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 11, 2011 at 09:04:56AM -0600, Bruce Guenter wrote:

> On Thu, Aug 04, 2011 at 10:35:36AM -0600, Bruce Guenter wrote:
> > Ok, I ran it for more than a few minutes.  Early on (shortly after boot), the output shows this for a long time:
> 
> Does anybody have any ideas what might be going on?

By chance, does "vmstat 1" or top show a high system cpu% while this is
happening, and if so, does cat /proc/<pid>/stack of the PIDs in R state
sometimes show things under btrfs_run_delayed_refs like
setup_cluster_no_bitmap() and rb_next()?

I haven't been able to build a 2.6.39 to verify yet, but 2.6.38.5 does
not show the problem for some reason. This is on a backup server, too,
with 20 3 TB btrfs volumes.

You should also be able to see a stack trace in this case (NOT the
uninterruptible sleep case) with echo l > /rpoc/sysrq-trigger, or use
oprofile or "perf top", which is what I am using. I see output such as:

     samples  pcnt function                           DSO
     _______ _____ __________________________________ ______________

    13537.00 59.2% rb_next                            [kernel]
     3539.00 15.5% _raw_spin_lock                     [kernel]
     1668.00  7.3% setup_cluster_no_bitmap            [kernel]
      799.00  3.5% tree_search_offset                 [kernel]
      476.00  2.1% fill_window                        [kernel]

and and perf record -g; perf report --stdio, which gives me:

47.60%  btrfs-transacti  [kernel.kallsyms]          [k] rb_next
        |
        --- rb_next
           |
           |--97.36%-- setup_cluster_no_bitmap
           |          btrfs_find_space_cluster
           |          find_free_extent
           |          btrfs_reserve_extent
           |          btrfs_alloc_free_block
           |          __btrfs_cow_block
           |          btrfs_cow_block
           |          |
           |          |--99.95%-- btrfs_search_slot
           |          |          |
           |          |          |--55.01%-- lookup_inline_extent_backref
           |          |          |          |
           |          |          |          |--97.17%-- __btrfs_free_extent
           |          |          |          |          run_clustered_refs
           |          |          |          |          btrfs_run_delayed_refs
           |          |          |          |          |
           |          |          |          |          |--88.72%-- btrfs_commit_transaction
           |          |          |          |          |          transaction_kthread

At one point, I rebooted the box without unmounting, and mounting of the
60 TB of btrfs volumes never actually finished within 8 hours. It seemed
to get stuck on one of them about half way through, constantly writing
(slowly) and taking lots of CPU. This is just from mounting, not any use.
Booting back into 2.6.38.5 was fine. The kernel giving problems was 3.0,
and now 3.1-rc1.

Before, when it actually was mounted, "sync" (with nothing else dirtying
pages) also took 4 minutes to run and pegged the CPU with a profile
similar to the above.

I tried started trying to do a bisection but tons of other things have
changed and it takes quite a while to verify each pass. It also doesn't
help that I can't seem to reproduce it on any other non-production boxes.

Simon-
