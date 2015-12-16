Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbbLPNzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 08:55:25 -0500
Date: Wed, 16 Dec 2015 14:53:20 +0100
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree log
 replay
Message-ID: <20151216135320.GR4227@suse.cz>
Reply-To: dsterba@suse.cz
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151214173200.GO4227@twin.jikos.cz>
 <566F016D.8050403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <566F016D.8050403@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 14, 2015 at 12:50:37PM -0500, Austin S. Hemmelgarn wrote:
> On 2015-12-14 12:32, David Sterba wrote:
> > On Thu, Dec 10, 2015 at 10:34:06AM +0800, Qu Wenruo wrote:
> >> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
> >> option to get real readonly mount, like "norecovery" in ext* and xfs.
> >>
> >> Since the new parse_options() need to check new flags at remount time,
> >> so add a new parameter for parse_options().
> >>
> >> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> >> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> >> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> >
> > I've read the discussions around the change and from the user's POV I'd
> > suggest to add another mount option that would be just an alias for any
> > mount options that would implement the 'hard-ro' semantics.
> >
> > Say it's called 'nowr'. Now it would imply 'nologreplay', but may cover
> > more options in the future.
> It should also imply noatime.  I'm not sure how BTRFS handles atime when 
> mounted RO, but I know a lot of old UNIX systems updated atime even on 
> filesystems mounted RO, and I know that at least at one point Linux did too.

A mount with -o ro will not touch atimes. At one point the read-only
snapshots changed atimes, but this has been fixed since.

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/inode.c#n1602
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/inode.c#n5973

> >   mount -o ro,nowr /dev/sdx /mnt
> >
> > would work when switching kernels.
> 
> I like this idea, but I think that having a name like true-ro or hard-ro 
> and making it imply ro (and noatime) would probably be better (or at 
> least, simpler to use from a user perspective).

Ok, a single option to do the real-ro sounds better than ro,something.
