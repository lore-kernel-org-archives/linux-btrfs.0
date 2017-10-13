Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53628 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753231AbdJMNes (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 09:34:48 -0400
Date: Fri, 13 Oct 2017 15:33:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/21] Btrfs: rework outstanding_extents
Message-ID: <20171013133301.GO3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-2-git-send-email-jbacik@fb.com>
 <704b1207-5219-89dd-6ddd-582ed74f759f@suse.com>
 <20171013131050.q5huwryq444utast@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171013131050.q5huwryq444utast@destiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 13, 2017 at 09:10:52AM -0400, Josef Bacik wrote:
> On Fri, Oct 13, 2017 at 11:39:15AM +0300, Nikolay Borisov wrote:
> > 
> > 
> > On 29.09.2017 22:43, Josef Bacik wrote:
> > >  
> > > +static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
> > > +						 int mod)
> > > +{
> > > +	ASSERT(spin_is_locked(&inode->lock));
> > > +	inode->outstanding_extents += mod;
> > > +	if (btrfs_is_free_space_inode(inode))
> > > +		return;
> > > +}
> > > +
> > > +static inline void btrfs_mod_reserved_extents(struct btrfs_inode *inode,
> > > +					      int mod)
> > > +{
> > > +	ASSERT(spin_is_locked(&inode->lock));
> > 
> > lockdep_assert_held(&inode->lock); for both functions. I've spoken with
> > Peterz and he said any other way of checking whether a lock is held, I
> > quote, "must die"
> > 
> 
> Blah I continually forget that's what we're supposed to use now.

I try to keep such information on
https://btrfs.wiki.kernel.org/index.php/Development_notes#BCP

Just started the section with best practices, feel free to add more.
