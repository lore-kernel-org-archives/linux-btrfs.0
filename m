Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34515 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751222AbcJZFYL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 01:24:11 -0400
Received: by mail-pf0-f174.google.com with SMTP id n85so16276511pfi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Oct 2016 22:24:11 -0700 (PDT)
Date: Tue, 25 Oct 2016 22:24:08 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, david@fromorbit.com, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        hch@infradead.org, jweiner@fb.com
Subject: Re: [PATCH 5/5] don't set *REFERENCED unless we are on the lru list
Message-ID: <20161026052408.GA32082@vader>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-6-git-send-email-jbacik@fb.com>
 <20161025224442.GA18879@vader.DHCP.thefacebook.com>
 <706289B2-E2F9-46A0-903A-9D5CB5F21CBF@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <706289B2-E2F9-46A0-903A-9D5CB5F21CBF@dilger.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2016 at 10:17:19PM -0600, Andreas Dilger wrote:
> On Oct 25, 2016, at 4:44 PM, Omar Sandoval <osandov@osandov.com> wrote:
> > 
> > On Tue, Oct 25, 2016 at 02:41:44PM -0400, Josef Bacik wrote:
> >> With anything that populates the inode/dentry cache with a lot of one time use
> >> inodes we can really put a lot of pressure on the system for things we don't
> >> need to keep in cache.  It takes two runs through the LRU to evict these one use
> >> entries, and if you have a lot of memory you can end up with 10's of millions of
> >> entries in the dcache or icache that have never actually been touched since they
> >> were first instantiated, and it will take a lot of CPU and a lot of pressure to
> >> evict all of them.
> >> 
> >> So instead do what we do with pagecache, only set the *REFERENCED flags if we
> >> are being used after we've been put onto the LRU.  This makes a significant
> >> difference in the system's ability to evict these useless cache entries.  With a
> >> fs_mark workload that creates 40 million files we get the following results (all
> >> in files/sec)
> >> 
> >> Btrfs			Patched		Unpatched
> >> Average Files/sec:	72209.3		63254.2
> >> p50 Files/sec:		70850		57560
> >> p90 Files/sec:		68757		53085
> >> p99 Files/sec:		68757		53085
> >> 
> >> XFS			Patched		Unpatched
> >> Average Files/sec:	61025.5		60719.5
> >> p50 Files/sec:		60107		59465
> >> p90 Files/sec: 		59300		57966
> >> p99 Files/sec: 		59227		57528
> >> 
> >> Ext4			Patched		Unpatched
> >> Average Files/sec:	121785.4	119248.0
> >> p50 Files/sec:		120852		119274
> >> p90 Files/sec:		116703		112783
> >> p99 Files/sec:		114393		104934
> >> 
> >> The reason Btrfs has a much larger improvement is because it holds a lot more
> >> things in memory so benefits more from faster slab reclaim, but across the board
> >> is an improvement for each of the file systems.
> >> 
> >> Signed-off-by: Josef Bacik <jbacik@fb.com>
> >> ---
> >> fs/dcache.c | 15 ++++++++++-----
> >> fs/inode.c  |  5 ++++-
> >> 2 files changed, 14 insertions(+), 6 deletions(-)
> >> 
> >> diff --git a/fs/dcache.c b/fs/dcache.c
> >> index 5c7cc95..a558075 100644
> >> --- a/fs/dcache.c
> >> +++ b/fs/dcache.c
> >> @@ -779,8 +779,6 @@ repeat:
> >> 			goto kill_it;
> >> 	}
> >> 
> >> -	if (!(dentry->d_flags & DCACHE_REFERENCED))
> >> -		dentry->d_flags |= DCACHE_REFERENCED;
> >> 	dentry_lru_add(dentry);
> >> 
> >> 	dentry->d_lockref.count--;
> >> @@ -803,6 +801,13 @@ static inline void __dget_dlock(struct dentry *dentry)
> >> 	dentry->d_lockref.count++;
> >> }
> >> 
> >> +static inline void __dget_dlock_reference(struct dentry *dentry)
> >> +{
> >> +	if (dentry->d_flags & DCACHE_LRU_LIST)
> >> +		dentry->d_flags |= DCACHE_REFERENCED;
> >> +	dentry->d_lockref.count++;
> >> +}
> >> +
> >> static inline void __dget(struct dentry *dentry)
> >> {
> >> 	lockref_get(&dentry->d_lockref);
> >> @@ -875,7 +880,7 @@ again:
> >> 			    (alias->d_flags & DCACHE_DISCONNECTED)) {
> >> 				discon_alias = alias;
> >> 			} else {
> >> -				__dget_dlock(alias);
> >> +				__dget_dlock_reference(alias);
> >> 				spin_unlock(&alias->d_lock);
> >> 				return alias;
> >> 			}
> >> @@ -886,7 +891,7 @@ again:
> >> 		alias = discon_alias;
> >> 		spin_lock(&alias->d_lock);
> >> 		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
> >> -			__dget_dlock(alias);
> >> +			__dget_dlock_reference(alias);
> >> 			spin_unlock(&alias->d_lock);
> >> 			return alias;
> >> 		}
> >> @@ -2250,7 +2255,7 @@ struct dentry *__d_lookup(const struct dentry *parent, const struct qstr *name)
> >> 		if (!d_same_name(dentry, parent, name))
> >> 			goto next;
> >> 
> >> -		dentry->d_lockref.count++;
> >> +		__dget_dlock_reference(dentry);
> > 
> > This misses dentries that we get through __d_lookup_rcu(), so I think
> > your change made it so most things aren't getting DCACHE_REFERENCED set
> > at all. Maybe something like this instead?
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 5c7cc95..d7a56a8 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -412,15 +412,6 @@ static void d_lru_shrink_move(struct list_lru_one *lru, struct dentry *dentry,
> > 	list_lru_isolate_move(lru, &dentry->d_lru, list);
> > }
> > 
> > -/*
> > - * dentry_lru_(add|del)_list) must be called with d_lock held.
> > - */
> > -static void dentry_lru_add(struct dentry *dentry)
> > -{
> > -	if (unlikely(!(dentry->d_flags & DCACHE_LRU_LIST)))
> > -		d_lru_add(dentry);
> > -}
> > -
> > /**
> >  * d_drop - drop a dentry
> >  * @dentry: dentry to drop
> > @@ -779,9 +770,12 @@ void dput(struct dentry *dentry)
> > 			goto kill_it;
> > 	}
> > 
> > -	if (!(dentry->d_flags & DCACHE_REFERENCED))
> > -		dentry->d_flags |= DCACHE_REFERENCED;
> > -	dentry_lru_add(dentry);
> > +	if (likely(dentry->d_flags & DCACHE_LRU_LIST)) {
> > +		if (!(dentry->d_flags & DCACHE_REFERENCED))
> > +			dentry->d_flags |= DCACHE_REFERENCED;
> 
> There is no benefit to checking if DCACHE_REFERENCED is unset before
> trying to set it.  You've already accessed the cacheline, so you can
> avoid the branch here and just set it unconditionally.
> 
> Cheers, Andreas

We've accessed the cacheline, but it can still be shared, no? If we did
this unconditionally, we'd dirty the cacheline on every dput() as
opposed to only the first and second times it's been put.

-- 
Omar
