Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34264 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab3GZNJT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 09:09:19 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 989009A06A8
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jul 2013 07:09:18 -0600 (MDT)
Date: Fri, 26 Jul 2013 09:09:15 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: check to see if root_list is empty before adding
 it to dead roots
Message-ID: <20130726130915.GA24583@localhost.localdomain>
References: <1374779620-28788-1-git-send-email-jbacik@fusionio.com>
 <51F243A7.1060907@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51F243A7.1060907@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 26, 2013 at 11:38:47AM +0200, Stefan Behrens wrote:
> On Thu, 25 Jul 2013 15:13:40 -0400, Josef Bacik wrote:
> > A user reported a panic when running with autodefrag and deleting snapshots.
> > This is because we could end up trying to add the root to the dead roots list
> > twice.  To fix this check to see if we are empty before adding ourselves to the
> > dead roots list.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> Tested-by: Stefan Behrens <sbehrens@giantdisaster.de>
> 
> The patch eliminates the crash. The question still is whether the double addition to the list is an indication for a problem and this patch just hides that there is a problem.

This is what is happening

start writing file
  notice it was a random write, add it to the defrag list
Delete subvol
 evict all dentry/icache
  roots inode tree is empty, add to dead root
process defrag inodes
  lookup inode based on its location and root
    do our defrag
      iput in finish_ordered_io, which removes us from the inode tree
        notice the inode tree is empty, add root to dead root 
	  EXPLOSION

So we could probably avoid this issue by checking the root's count before we go
to lookup the inode and just bailing if the used count is 0, but then if we race
between looking up the root and looking up the inode we could end up in the same
situation, because we'd have to check again after looking up the inode and iput
there if the count was 0 and we'd be in the same mess again, though with a much
smaller window.  So this patch fixes the actual problem, it's not a paper over.
I will fix us to not do anything if the root has been deleted since theres no
sense in doing the extra work, but we'll still need this for the small window
between looking up the root and looking up the inode.  Thanks,

Josef
