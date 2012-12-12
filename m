Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:60070 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab2LLOrO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 09:47:14 -0500
Date: Wed, 12 Dec 2012 09:47:11 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: put delayed iput tracking list inside in-memory
 inode
Message-ID: <20121212144711.GA3152@localhost.localdomain>
References: <1354274683-17762-1-git-send-email-bo.li.liu@oracle.com>
 <20121211145750.GC3126@localhost.localdomain>
 <20121212015038.GD12318@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121212015038.GD12318@liubo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 11, 2012 at 06:50:40PM -0700, Liu Bo wrote:
> On Tue, Dec 11, 2012 at 09:57:50AM -0500, Josef Bacik wrote:
> > On Fri, Nov 30, 2012 at 04:24:43AM -0700, Liu Bo wrote:
> > > This can save us a dynamic memory allocation/free.
> > > 
> > 
> > You can have multiple outstanding delayed iputs per inode, so this will result
> > in inodes still being in use on unmount, so this isn't going to work.
> 
> Yeah, you're right, but what if we add a check
> 
> if (list_empty(&bi->iput_list))
> 	list_add(&bi->iput_list, &fs_info->iput_list));
> 
> Am I missing something?
> 

Yes, we have the delayed iput stuff to keep us from running the actual iput
stuff where we are for locking reasons.  If we do the if (list_empty) check then
we have to do something for the case wehre the list isn't empty so we don't leak
references to the inode, which would basically mean doing an iput which is what
we don't want to do.  We could do a hybrid approach where we do your list and
then allocate if we're already on the list, or add a counter so we know how many
references to drop.  But this as it is won't work.  (Keep in mind I've been
buried in tree logging for 3 months so if I'm wrong bear with me).  Thanks,

Josef
