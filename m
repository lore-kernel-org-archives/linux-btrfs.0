Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab3GSUvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jul 2013 16:51:18 -0400
Date: Fri, 19 Jul 2013 13:51:15 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, Andrew Vagin <avagin@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        kzak@redhat.com, xemul@openvz.org
Subject: Re: btrfs: stat(2) and /proc/pid/maps returns different devices
Message-ID: <20130719205115.GK32502@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20130704095138.GB12359@gmail.com> <20130708215446.GH18204@twin.jikos.cz> <20130710163105.GR32502@wotan.suse.de> <20130710174545.GS32502@wotan.suse.de> <20130710222650.GI25386@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130710222650.GI25386@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 11, 2013 at 12:26:50AM +0200, David Sterba wrote:
> On Wed, Jul 10, 2013 at 10:45:45AM -0700, Mark Fasheh wrote:
> > Well, what do I get when I pretend I don't care any more? The little voice
> > in my head says "keep plugging away". Here's another attempt at fixing this
> > problem in a sane manner. Basically, this time we're adding a flag to
> > s_flags which btrfs sets. Proc will see the flag and call ->getattr().
> > 
> > This compiles, but it needs testing (which I will get to soon). It still has
> > a bunch of problems in my honest opinion but maybe if we get something
> > acceptable upstream we can work from there.
> > 
> > Also, as Andrew pointed out there's more than one place which is return
> > different device than from stat(2) so I probably need to update more sites
> > to deal with this.
> > 
> > Does anyone see a problem with this approach?
> 
> The approach looks ok to me, the implementation is internal to vfs and
> fairly minimal. The bit that bothers me is the name of the flag, it's
> completely unobvious what it means.

I'll come up with something better for my next revision :)

> 
> There are some differences to the linked suse patch:
> 
> > +static dev_t proc_get_dev_from_stat(struct inode *inode)
> > +{
> > +	struct dentry *dentry = d_find_any_alias(inode);
> 
> This does the dentry -> inode mapping, while originally there was
> 
> 	&file->f_path
> 
> passing just the inode to proc_get_dev_from_stat unnecessarily drops the
> available information that's about to be retrieved again.

Good catch, thanks.


> 
> > +	struct kstat kstat;
> > +
> > +	if (!dentry)
> > +		goto out_error;
> > +	if (inode->i_op->getattr(NULL, dentry, &kstat))
> 
> The suse patch calls vfs_getattr that in turn calls
> 
> 	security_inode_getattr(path->mnt, path->dentry);
> 
> That would be missing.
> 
> Plus checks for presence of the ->getattr operation. Though this is
> superfluous with btrfs, I suggest to use vfs_getattr here, which will
> fix all of the above.

Ok checking for the operation is definitely needed. I'll check for
->getattr(). The rest of the stuff in our suse patch must have been added
after my own commit. Do you know why this was added? Since this is all
internal to proc I didn't think we needed all this extra stuff to replicate
vfs_gettatr().
	--Mark

--
Mark Fasheh
