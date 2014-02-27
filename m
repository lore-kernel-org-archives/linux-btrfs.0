Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbaB0RCK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 12:02:10 -0500
Date: Thu, 27 Feb 2014 18:02:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/9] Btrfs: use bitfield instead of integer data type for
 the some variants in btrfs_root
Message-ID: <20140227170207.GJ16073@suse.cz>
Reply-To: dsterba@suse.cz
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com>
 <1392890939-19044-4-git-send-email-miaox@cn.fujitsu.com>
 <20140222002337.GO16073@twin.jikos.cz>
 <530DAF6D.5090007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530DAF6D.5090007@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 26, 2014 at 05:10:05PM +0800, Miao Xie wrote:
> On Sat, 22 Feb 2014 01:23:37 +0100, David Sterba wrote:
> > On Thu, Feb 20, 2014 at 06:08:54PM +0800, Miao Xie wrote:
> >> @@ -1352,13 +1347,15 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
> >>  	root->root_key.objectid = BTRFS_TREE_LOG_OBJECTID;
> >>  	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
> >>  	root->root_key.offset = BTRFS_TREE_LOG_OBJECTID;
> >> +
> >>  	/*
> >> +	 * DON'T set REF_COWS for log trees
> >> +	 *
> >>  	 * log trees do not get reference counted because they go away
> >>  	 * before a real commit is actually done.  They do store pointers
> >>  	 * to file data extents, and those reference counts still get
> >>  	 * updated (along with back refs to the log tree).
> >>  	 */
> >> -	root->ref_cows = 0;
> > 
> > This looks like a bugfix hidden in a cleanup patch. If it is standalone
> > and not related to changes in this patchset, it makes sense to send it
> > separately (and possibly CC stable).
> 
> It is a cleanup because we have set it to 0 before.
> 
> I add this comment just to remind the other developer that don't set this flag.
> (The old one is not so striking, I think.)

Ox, thanks for explanation.
