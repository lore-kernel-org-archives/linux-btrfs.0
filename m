Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab3GJW0w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 18:26:52 -0400
Date: Thu, 11 Jul 2013 00:26:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Andrew Vagin <avagin@gmail.com>, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org, kzak@redhat.com, xemul@openvz.org
Subject: Re: btrfs: stat(2) and /proc/pid/maps returns different devices
Message-ID: <20130710222650.GI25386@suse.cz>
Reply-To: dsterba@suse.cz
References: <20130704095138.GB12359@gmail.com>
 <20130708215446.GH18204@twin.jikos.cz>
 <20130710163105.GR32502@wotan.suse.de>
 <20130710174545.GS32502@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130710174545.GS32502@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 10, 2013 at 10:45:45AM -0700, Mark Fasheh wrote:
> Well, what do I get when I pretend I don't care any more? The little voice
> in my head says "keep plugging away". Here's another attempt at fixing this
> problem in a sane manner. Basically, this time we're adding a flag to
> s_flags which btrfs sets. Proc will see the flag and call ->getattr().
> 
> This compiles, but it needs testing (which I will get to soon). It still has
> a bunch of problems in my honest opinion but maybe if we get something
> acceptable upstream we can work from there.
> 
> Also, as Andrew pointed out there's more than one place which is return
> different device than from stat(2) so I probably need to update more sites
> to deal with this.
> 
> Does anyone see a problem with this approach?

The approach looks ok to me, the implementation is internal to vfs and
fairly minimal. The bit that bothers me is the name of the flag, it's
completely unobvious what it means.

There are some differences to the linked suse patch:

> +static dev_t proc_get_dev_from_stat(struct inode *inode)
> +{
> +	struct dentry *dentry = d_find_any_alias(inode);

This does the dentry -> inode mapping, while originally there was

	&file->f_path

passing just the inode to proc_get_dev_from_stat unnecessarily drops the
available information that's about to be retrieved again.

> +	struct kstat kstat;
> +
> +	if (!dentry)
> +		goto out_error;
> +	if (inode->i_op->getattr(NULL, dentry, &kstat))

The suse patch calls vfs_getattr that in turn calls

	security_inode_getattr(path->mnt, path->dentry);

That would be missing.

Plus checks for presence of the ->getattr operation. Though this is
superfluous with btrfs, I suggest to use vfs_getattr here, which will
fix all of the above.

> +		goto out_error_dput;
> +
> +	dput(dentry);
> +	return kstat.dev;
> +
> +out_error_dput:
> +	dput(dentry);
> +out_error:
> +	return inode->i_sb->s_dev;
> +}
