From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: btrfs panic - BUG: soft lockup - CPU#0 stuck for 61s!
	[fs_mark:4573]
Date: Tue, 10 Jun 2008 11:38:54 -0700
Message-ID: <1213123135.3643.7.camel@localhost.localdomain>
References: <4844336F.1010807@redhat.com>
	 <20080605143428.GA16999@think.oraclecorp.com> <484825D4.2010402@redhat.com>
	 <20080608223712.73692933@think.oraclecorp.com>
	 <1213056641.3670.54.camel@localhost.localdomain>
	 <1213058848.10187.129.camel@think.oraclecorp.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Cc: rwheeler@redhat.com, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1213058848.10187.129.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-06-09 at 20:47 -0400, Chris Mason wrote:
> On Mon, 2008-06-09 at 17:10 -0700, Mingming Cao wrote:
> > On Sun, 2008-06-08 at 22:37 -0400, Chris Mason wrote:
> > > On Thu, 05 Jun 2008 13:43:48 -0400
> > > Ric Wheeler <rwheeler@redhat.com> wrote:
> > > 
> > > > Chris Mason wrote:
> > > > > On Mon, Jun 02, 2008 at 01:52:47PM -0400, Ric Wheeler wrote:
> > > > >   
> > > > >> I can reliably get btrfs to panic by running my fs_mark code on a
> > > > >> newly created file system with lots of threads on an 8-way box. If
> > > > >> this is too aggressive, let me know ;-)
> > > > >>
> > > > >> Here is a summary of the panic:
> > > > >>     
> > > > >
> > > > > BTW, exactly how are you running fs_mark?  Mingming reminded me that
> > > > > strictly speaking this patch shouldn't be required, so there might
> > > > > be other related problems.
> > > > >
> > > > > -chris
> > > > >
> > > > >   
> > > > It still crashes, Mingming is clearly correct ;-)
> > > > 
> > > 
> > > Grin, I never should have doubted her.
> > > 
> > :) 
> > 
> > > So, the actual fix should be below.  It looks like the problem is that I've got
> > > a race in setting the pointer to a new transaction, which makes the
> > > data=ordered code take a spin lock that hasn't yet been setup.
> > > 
> > 
> > Just to be clear, so the data=ordered code(btrfs_del_ordered_inode())
> > takes a spin lock (new_trans_lock) and assume the new transaction has
> > been setup, that races with join_transaction resetting the current
> > running transaction()? 
> > 
> Yes
> 
> > I also see the btrfs_commit_transaction() could reset the
> > root->fs_info->running_transaction to be NULL, but we did not check NULL
> > pointer in the data=ordered mode code, is this a potential Bug? Or it is
> > covered somewhere else?
> > 
> 
> Thanks for double checking these.
> 
> We don't check it in btrfs_add_ordered_inode because that must be called
> with the transaction running.
> 
Thanks for clarifying, I missed this.

> btrfs_ordered_throttle is safe because it doesn't actually deref the
> pointer, it just checks for changes to it.  The important part of
> ordered_throttle is the writeback count.
> 
> So, the others should be safe, but please let me know if you see any
> holes there.
> 

Looks pretty safe to me now, I should not doubt you earlier:)

Mingming

