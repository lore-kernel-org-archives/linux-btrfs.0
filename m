Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:50031 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754012AbdAZRrv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jan 2017 12:47:51 -0500
Date: Thu, 26 Jan 2017 18:09:04 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Mike Galbraith <umgwanakikbuti@gmail.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [btrfs/rt] lockdep false positive
Message-ID: <20170126170903.ikq7iequ4g5mhszo@linutronix.de>
References: <1485074793.4467.49.camel@gmail.com>
 <1485107114.4467.73.camel@gmail.com>
 <20170125170209.h6tqr6zgaq6ojmco@linutronix.de>
 <1485368989.5150.60.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1485368989.5150.60.camel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-25 19:29:49 [+0100], Mike Galbraith wrote:
> On Wed, 2017-01-25 at 18:02 +0100, Sebastian Andrzej Siewior wrote:
> 
> > > [  341.960794]        CPU0
> > > [  341.960795]        ----
> > > [  341.960795]   lock(btrfs-tree-00);
> > > [  341.960795]   lock(btrfs-tree-00);
> > > [  341.960796] 
> > > [  341.960796]  *** DEADLOCK ***
> > > [  341.960796]
> > > [  341.960796]  May be due to missing lock nesting notation
> > > [  341.960796]
> > > [  341.960796] 6 locks held by kworker/u8:9/2039:
> > > [  341.960797]  #0:  ("%s-%s""btrfs", name){.+.+..}, at: [] process_one_work+0x171/0x700
> > > [  341.960812]  #1:  ((&work->normal_work)){+.+...}, at: [] process_one_work+0x171/0x700
> > > [  341.960815]  #2:  (sb_internal){.+.+..}, at: [] start_transaction+0x2a7/0x5a0 [btrfs]
> > > [  341.960825]  #3:  (btrfs-tree-02){+.+...}, at: [] btrfs_clear_lock_blocking_rw+0x55/0x100 [btrfs]
> > > [  341.960835]  #4:  (btrfs-tree-01){+.+...}, at: [] btrfs_clear_lock_blocking_rw+0x55/0x100 [btrfs]
> > > [  341.960854]  #5:  (btrfs-tree-00){+.+...}, at: [] btrfs_clear_lock_blocking_rw+0x55/0x100 [btrfs]
> > > 
> > > Attempting to describe RT rwlock semantics to lockdep prevents this.
> > 
> > and this is what I don't get. I stumbled upon this myself [0] but didn't
> > fully understand the problem (assuming this is the same problem colored
> > differently).
> 
> Yeah, [0] looks like it, though I haven't met an 'fs' variant, my
> encounters were always either 'tree' or 'csum' flavors.
> 
> > With your explanation I am not sure if I get what is happening. If btrfs
> > is taking here read-locks on random locks then it may deadlock if
> > another btrfs-thread is doing the same and need each other's locks.
> 
> I don't know if a real RT deadlock is possible.  I haven't met one,
> only variants of this bogus recursion gripe.
>  
> > If btrfs takes locks recursively which it already holds (in the same
> > context / process) then it shouldn't be visible here because lockdep
> > does not account this on -RT.
> 
> If what lockdep gripes about were true, we would never see the splat,
> we'd zip straight through that (illusion) recursive read_lock() with
> lockdep being none the wiser. 
> 
> > If btrfs takes the locks in a special order for instance only ascending
> > according to inode's number then it shouldn't deadlock.
> 
> No idea.  Locking fancy enough to require dynamic key assignment to
> appease lockdep is too fancy for me.

yup, for me, too. As long as nobody from the btrfs camp explains how
that locking workings and if it is safe I am not feeling comfortable to
shut up lockdep here.

> 	-Mike

Sebastian
