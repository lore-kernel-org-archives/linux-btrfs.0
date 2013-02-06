Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47357 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab3BFQIh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 11:08:37 -0500
Date: Thu, 7 Feb 2013 00:02:56 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Zach Brown <zab@redhat.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] btrfs: add delayed_iput list head to btrfs inode
Message-ID: <20130206160255.GB30198@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <511180E4.2020600@redhat.com>
 <20130205231405.GM14246@lenny.home.zabbo.net>
 <20130206020854.GA2278@liubo.jp.oracle.com>
 <51127C61.3070503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51127C61.3070503@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 06, 2013 at 09:53:05AM -0600, Eric Sandeen wrote:
> On 2/5/13 8:08 PM, Liu Bo wrote:
> > On Tue, Feb 05, 2013 at 03:14:05PM -0800, Zach Brown wrote:
> >>> +	struct btrfs_inode *b_inode = BTRFS_I(inode);
> >>> +	struct btrfs_fs_info *fs_info = b_inode->root->fs_info;
> >>>  
> >>>  	if (atomic_add_unless(&inode->i_count, -1, 1))
> >>>  		return;
> >>>  
> >>> -	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
> >>> -	delayed->inode = inode;
> >>> -
> >>>  	spin_lock(&fs_info->delayed_iput_lock);
> >>> -	list_add_tail(&delayed->list, &fs_info->delayed_iputs);
> >>> +	list_add_tail(&b_inode->delayed_iput, &fs_info->delayed_iputs);
> >>>  	spin_unlock(&fs_info->delayed_iput_lock);
> >>>  }
> >>
> >> Hmm.  I'm not great with inode life cycles, but isn't this only safe if
> >> someone else can't get an i_count reference while this is in flight?  It
> >> looks like the final iput does the unhashing, and so on, so couldn't an
> >> iget/iput race with this and try to add the inode's list_head twice?
> > 
> > Yeah, same concern here.  Basically this will result in inodes still being
> > in use on unmount.
> > 
> > Actually I did a similar one, here is some disscussion:
> > 
> > https://patchwork.kernel.org/patch/1824711/
> 
> I read it, thanks.  Did you try the counter approach?

Yes, it'll bring a tradeoff situation.

With counter, we need to lock the list all the time instead of
doing a splice on the list and unlocking it.  I think splice would be
faster so I didn't go further(I MIGHT be wrong on this)..

thanks,
liubo
