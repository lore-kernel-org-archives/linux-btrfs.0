Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50287 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbJGOLn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Oct 2015 10:11:43 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 8 Oct 2015 00:11:40 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 7EAC7357804F
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2015 01:11:37 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t97EBTsf14090430
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Oct 2015 01:11:37 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t97EB4wi023541
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Oct 2015 01:11:04 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, fdmanana@gmail.com, chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: Intialize btrfs_root->highest_objectid when loading tree root and subvolume roots
Date: Wed, 07 Oct 2015 19:40:46 +0530
Message-ID: <8703019.0plYdL21k7@localhost.localdomain>
In-Reply-To: <20151007092503.GG7734@twin.jikos.cz>
References: <1444063465-5641-1-git-send-email-chandan@linux.vnet.ibm.com> <20151007092503.GG7734@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 07 Oct 2015 11:25:03 David Sterba wrote:
> On Mon, Oct 05, 2015 at 10:14:24PM +0530, Chandan Rajendra wrote:
> > +	if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
> > +		mutex_unlock(&root->objectid_mutex);
> > +		ret = -ENOSPC;
> 
> ENOSPC ... I don't think it's right as this could be with a normal
> enospc during subvolume creation. The problem is that theh inode number
> space is exhausted, the closest error code I see is EOVERFLOW. As this
> is an ioctl we can afford to define the meaning of this return value as
> such (unlike for eg. creat()/open()).
> 
> > +		goto free_root_dev;
> > +	}
> > +
> > +	mutex_unlock(&root->objectid_mutex);
> > +
> > 
> >  	return 0;

David, Are you suggesting that we return -EOVERFLOW from within
btrfs_init_fs_root() and continue returning -ENOSPC in case of error
(i.e. tree_root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID) from
open_ctree()?

If yes, btrfs_init_fs_root() gets invoked from open_ctree() via
btrfs_read_fs_root_no_name() and hence we may end up returning -EOVERFLOW when
servicing the mount() syscall.

-- 
chandan

