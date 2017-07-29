Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:37946 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbdG2FEp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 01:04:45 -0400
Received: by mail-qt0-f193.google.com with SMTP id p3so14410681qtg.5
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 22:04:44 -0700 (PDT)
Date: Sat, 29 Jul 2017 02:04:39 -0300
From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: Re: [PATCH] btrfs: preserve i_mode if __btrfs_set_acl() fails
Message-ID: <20170729050438.GA7465@debian.home>
References: <20170729002626.GA6759@debian.home>
 <20170729004802.GA28703@li70-116.members.linode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170729004802.GA28703@li70-116.members.linode.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 29, 2017 at 12:48:04AM +0000, Josef Bacik wrote:
> On Fri, Jul 28, 2017 at 09:26:29PM -0300, Ernesto A. Fernández wrote:
> > +	ret = __btrfs_set_acl(trans, inode, acl, type);
> > +	if (ret)
> > +		goto out;
> > +
> > +	inode->i_mode = mode;
> > +	inode_inc_iversion(inode);
> > +	inode->i_ctime = current_time(inode);
> > +	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
> 
> This only needs to be set if we actually set the xattr.  I'd fix setxattr to
> call it every time it's called.

I had not thought of that, thank you.

If I'm understanding this correctly the issue would be only when setting
a NULL default acl on an inode that is not a directory. In that case I
probably shouldn't be calling btrfs_update_inode either, but I can't move
that back to setxattr.

Perhaps __btrfs_set_acl could return an error in that case, like -ENOTDIR,
and then we can set ret back to 0 before returning from btrfs_set_acl.

> > +	ret = btrfs_update_inode(trans, root, inode);
> > +	BUG_ON(ret);
> 
> No BUG_ON, return the error.

The call to BUG_ON was already there before my patch, only inside the 
__btrfs_setxattr function. Since I didn't know the reason I thought it
was best not to change it. I'll do as you say in the next version.

Thank you for your review.
