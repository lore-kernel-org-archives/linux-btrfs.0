Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35857 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab3HHPbj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 11:31:39 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5FA9C9A06BF
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Aug 2013 09:31:39 -0600 (MDT)
Date: Thu, 8 Aug 2013 11:31:37 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Josef Bacik <jbacik@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        <viro@ZenIV.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, Chris Mason <chris.mason@fusionio.com>,
        Andrew Vagin <avagin@gmail.com>
Subject: Re: [PATCH][RESEND] vfs: allow /proc/PID/maps to get device from stat
Message-ID: <20130808153137.GE16712@localhost.localdomain>
References: <20130807195718.GC31381@wotan.suse.de>
 <20130807201826.GA23804@infradead.org>
 <20130807205146.GE2397@localhost.localdomain>
 <20130808121349.GC5180@infradead.org>
 <20130808130207.GA16712@localhost.localdomain>
 <20130808134805.GB24181@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130808134805.GB24181@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 06:48:05AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 08, 2013 at 09:02:07AM -0400, Josef Bacik wrote:
> > This won't work, try having 10000 subvolumes with dirty inodes and do sync then
> > go skiing, you'll have time :).  Thanks,
> 
> Why would the dirty inodes make any difference?  If you share the bdi
> between the subvolumes the sync workflow should be exactly the same
> still.
> 

The inodes are in the per-sb list, so we may start all the writing but we don't
wait all at once, so in the case of btrfs we will write all the dirty inodes,
and then wait on the ones in whatever sb we have, and then sync, which will
commit the transaction.  Then we go to the next sb and wait on those inodes
which will dirty metadata which means we'll have another transaction and we'll
commit the transaction and so on and so forth.  This means we write the
superblock 10000 times for one sync when we could have just done it once.

Now we could probably get around this by having ->sync_fs wait itself for all of
the inodes to complete and then commit the transaction once, but we're still
going to get called the 99999 times for the same damned file system that has
already had everything done.

And this is just one example, IIRC there were a few other issues that popped up
because we assume sb == completely separate file system, freeze I think is one
of those things.  I'm sure there were other ones but the last time I tried to do
this was 2010/2011 and many brain cells have died since then.  Thanks,

Josef
