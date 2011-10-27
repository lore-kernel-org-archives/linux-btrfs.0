From: Josef Bacik <josef@redhat.com>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Thu, 27 Oct 2011 14:14:45 -0400
Message-ID: <20111027181444.GC2329@localhost.localdomain>
References: <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
 <20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
 <CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
 <20111025122320.GA3703@dhcp231-156.rdu.redhat.com>
 <CAO47_--rkkKw7AJVRHdhwVXEq736ijhVWKYhRDQdgUxix3P-0w@mail.gmail.com>
 <20111025150512.GC3703@dhcp231-156.rdu.redhat.com>
 <20111025201545.GA4082@shiny.Mikenopa.local>
 <20111025202248.GE3703@dhcp231-156.rdu.redhat.com>
 <20111026132354.GC4588@shiny.Mikenopa.local>
 <20111027150738.GA2329@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Christian Brunner <chb@muc.de>, Sage Weil <sage@newdream.net>,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20111027150738.GA2329@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 27, 2011 at 11:07:38AM -0400, Josef Bacik wrote:
> On Wed, Oct 26, 2011 at 09:23:54AM -0400, Chris Mason wrote:
> > On Tue, Oct 25, 2011 at 04:22:48PM -0400, Josef Bacik wrote:
> > > On Tue, Oct 25, 2011 at 04:15:45PM -0400, Chris Mason wrote:
> > > > On Tue, Oct 25, 2011 at 11:05:12AM -0400, Josef Bacik wrote:
> > > > > On Tue, Oct 25, 2011 at 04:25:02PM +0200, Christian Brunner wrote:
> > > > > > 
> > > > > > Attached is a perf-report. I have included the whole report, so that
> > > > > > you can see the difference between the good and the bad
> > > > > > btrfs-endio-wri.
> > > > > >
> > > > > 
> > > > > We also shouldn't be running run_ordered_operations, man this is screwed up,
> > > > > thanks so much for this, I should be able to nail this down pretty easily.
> > > > > Thanks,
> > > > 
> > > > Looks like we're getting there from reserve_metadata_bytes when we join
> > > > the transaction?
> > > >
> > > 
> > > We don't do reservations in the endio stuff, we assume you've reserved all the
> > > space you need in delalloc, plus we would have seen reserve_metadata_bytes in
> > > the trace.  Though it does look like perf is lying to us in at least one case
> > > sicne btrfs_alloc_logged_file_extent is only called from log replay and not
> > > during normal runtime, so it definitely shouldn't be showing up.  Thanks,
> > 
> > Whoops, I should have read that num_items > 0 check harder.
> > 
> > btrfs_end_transaction is doing it by setting ->blocked = 1
> > 
> >         if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
> >             should_end_transaction(trans, root)) {
> >                 trans->transaction->blocked = 1;
> > 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >                 smp_wmb();
> >         }
> > 
> >        if (lock && cur_trans->blocked && !cur_trans->in_commit) {
> >                    ^^^^^^^^^^^^^^^^^^^
> >                 if (throttle) {
> >                         /*
> >                          * We may race with somebody else here so end up having
> >                          * to call end_transaction on ourselves again, so inc
> >                          * our use_count.
> >                          */
> >                         trans->use_count++;
> >                         return btrfs_commit_transaction(trans, root);
> >                 } else {
> >                         wake_up_process(info->transaction_kthread);
> >                 }
> >         }
> > 
> 
> Not sure what you are getting at here?  Even if we set blocked, we're not
> throttling so it will just wake up the transaction kthread, so we won't do the
> commit in the endio case.  Thanks
> 

Oh I see what you were trying to say, that we'd set blocking and then commit the
transaction from the endio process which would run ordered operations, but since
throttle isn't set that won't happen.  I think that the perf symbols are just
lying to us.  Thanks,

Josef
