Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbbFSTTo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 15:19:44 -0400
Date: Fri, 19 Jun 2015 12:19:42 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: fix deadlock with extent-same and readpage
Message-ID: <20150619191942.GS18148@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1434661803-31188-1-git-send-email-mfasheh@suse.de>
 <1434661803-31188-3-git-send-email-mfasheh@suse.de>
 <20150619154752.GP6761@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150619154752.GP6761@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 19, 2015 at 05:47:53PM +0200, David Sterba wrote:
> On Thu, Jun 18, 2015 at 02:10:03PM -0700, Mark Fasheh wrote:
> > So I split btrfs_cmp_data() into 3 parts with a small context structure that
> > is passed between them. The first, btrfs_cmp_data_prepare() gathers up the
> > pages needed (taking page lock as required) and puts them on our context
> > structure. At this point, we are safe to lock the extent range. Afterwards,
> > we use btrfs_cmp_data() to do the data compare as usual and btrfs_cmp_data_free()
> > to clean up our context.
> 
> Sounds good.
> 
> I see some inconsitencies in the double locking.
> 
> > @@ -2808,52 +2819,120 @@ static inline void lock_extent_range(struct inode *inode, u64 off, u64 len)
> >  	}
> >  }
> >  
> > -static void btrfs_double_unlock(struct inode *inode1, u64 loff1,
> > -				struct inode *inode2, u64 loff2, u64 len)
> > +static void btrfs_double_inode_unlock(struct inode *inode1, struct inode *inode2)
> >  {
> > -	unlock_extent(&BTRFS_I(inode1)->io_tree, loff1, loff1 + len - 1);
> > -	unlock_extent(&BTRFS_I(inode2)->io_tree, loff2, loff2 + len - 1);
> > -
> >  	mutex_unlock(&inode1->i_mutex);
> >  	mutex_unlock(&inode2->i_mutex);
> 
> unlock parent lock first, child lock second -- should it be reversed?

Doesn't matter in terms of correctness, but we ought to make it consistent
especially if I'm fixing actual bugs like you found below :)


> > -static void btrfs_double_lock(struct inode *inode1, u64 loff1,
> > -			      struct inode *inode2, u64 loff2, u64 len)
> > +static void btrfs_double_inode_lock(struct inode *inode1, struct inode *inode2)
> > +{
> > +	if (inode1 < inode2)
> > +		swap(inode1, inode2);
> 
> after that, inode1 > inode2
> 
> > +
> > +	mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
> 
> higher address, locked first, parent lock
> 
> > +	if (inode1 != inode2)
> > +		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
> 
> lower address, locked second, child lock
> 
> > +}
> > +
> > +static void btrfs_double_extent_unlock(struct inode *inode1, u64 loff1,
> > +				      struct inode *inode2, u64 loff2, u64 len)
> > +{
> > +	unlock_extent(&BTRFS_I(inode1)->io_tree, loff1, loff1 + len - 1);
> > +	unlock_extent(&BTRFS_I(inode2)->io_tree, loff2, loff2 + len - 1);
> 
> reversed?
> 
> > +}
> > +
> > +static void btrfs_double_extent_lock(struct inode *inode1, u64 loff1,
> > +				     struct inode *inode2, u64 loff2, u64 len)
> >  {
> >  	if (inode1 < inode2) {
> >  		swap(inode1, inode2);
> >  		swap(loff1, loff2);
> >  	}
> > -
> > -	mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
> >  	lock_extent_range(inode1, loff1, len);
> > -	if (inode1 != inode2) {
> > -		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
> > +	if (inode1 != inode2)
> >  		lock_extent_range(inode2, loff2, len);
> > +}
> 
> higher address, locked first
> 
> If the locking sequence is always the same, it's not a problem
> deadlock-wise, but see btrfs_ioctl_clone:
> 
> 3639                 if (inode < src) {
> 3640                         mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
> 3641                         mutex_lock_nested(&src->i_mutex, I_MUTEX_CHILD);
> 3642                 } else {
> 3643                         mutex_lock_nested(&src->i_mutex, I_MUTEX_PARENT);
> 3644                         mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
> 3645                 }
> 
> lower address, locked first, parent lock
> 
> different from the order in btrfs_double_inode_lock. What happens if we
> get the locks interleaved when extent same and clone are called in
> parallel?
> 
> lock(i1)
>                 lock(i2)
> 
> lock(i2)                       <-- lockup?
> 
> 		lock(i1)
> 
> I haven't looked further whether the locking classes (parent, child)
> could prevent that, but the code should be clear enough so that I don't
> have to dig into the locking code to see if it's ok.

Nope it looks like you found a deadlock scenario. We've probably had this
for a while, I'll do a patch to update clone() with the locking helper.


> To fix it, the clone ioctl should use the same locking helper and we're
> set.

Yeah, I agree. Thanks for the helpful review David!
	--Mark

--
Mark Fasheh
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
