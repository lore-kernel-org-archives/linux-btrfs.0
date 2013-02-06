Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41343 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab3BFCLx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 21:11:53 -0500
Date: Wed, 6 Feb 2013 10:08:55 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zach Brown <zab@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] btrfs: add delayed_iput list head to btrfs inode
Message-ID: <20130206020854.GA2278@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <511180E4.2020600@redhat.com>
 <20130205231405.GM14246@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130205231405.GM14246@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 05, 2013 at 03:14:05PM -0800, Zach Brown wrote:
> > +	struct btrfs_inode *b_inode = BTRFS_I(inode);
> > +	struct btrfs_fs_info *fs_info = b_inode->root->fs_info;
> >  
> >  	if (atomic_add_unless(&inode->i_count, -1, 1))
> >  		return;
> >  
> > -	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
> > -	delayed->inode = inode;
> > -
> >  	spin_lock(&fs_info->delayed_iput_lock);
> > -	list_add_tail(&delayed->list, &fs_info->delayed_iputs);
> > +	list_add_tail(&b_inode->delayed_iput, &fs_info->delayed_iputs);
> >  	spin_unlock(&fs_info->delayed_iput_lock);
> >  }
> 
> Hmm.  I'm not great with inode life cycles, but isn't this only safe if
> someone else can't get an i_count reference while this is in flight?  It
> looks like the final iput does the unhashing, and so on, so couldn't an
> iget/iput race with this and try to add the inode's list_head twice?

Yeah, same concern here.  Basically this will result in inodes still being
in use on unmount.

Actually I did a similar one, here is some disscussion:

https://patchwork.kernel.org/patch/1824711/

thanks,
liubo
