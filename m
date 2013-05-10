Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36934 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3EJNEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 09:04:54 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 939219A041D
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 07:04:53 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: "dsterba@suse.cz" <dsterba@suse.cz>, David Sterba <dsterba@suse.cz>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130507115449.GE16456@twin.jikos.cz>
CC: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "alex.btrfs@zadarastorage.com" <alex.btrfs@zadarastorage.com>
References: <1363101208-30184-1-git-send-email-dsterba@suse.cz>
 <20130507004106.5844.39433@localhost.localdomain>
 <20130507115449.GE16456@twin.jikos.cz>
Message-ID: <20130510130451.12615.91756@localhost.localdomain>
Subject: Re: [PATCH v3] btrfs: clean snapshots one by one
Date: Fri, 10 May 2013 09:04:51 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-05-07 07:54:49)
> On Mon, May 06, 2013 at 08:41:06PM -0400, Chris Mason wrote:
> > > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > > index 988b860..4de2351 100644
> > > --- a/fs/btrfs/disk-io.c
> > > +++ b/fs/btrfs/disk-io.c
> > > @@ -1690,15 +1690,19 @@ static int cleaner_kthread(void *arg)
> > >         struct btrfs_root *root = arg;
> > >  
> > >         do {
> > > +               int again = 0;
> > > +
> > >                 if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
> > > +                   down_read_trylock(&root->fs_info->sb->s_umount) &&
> > >                     mutex_trylock(&root->fs_info->cleaner_mutex)) {
> > >                         btrfs_run_delayed_iputs(root);
> > > -                       btrfs_clean_old_snapshots(root);
> > > +                       again = btrfs_clean_one_deleted_snapshot(root);
> > >                         mutex_unlock(&root->fs_info->cleaner_mutex);
> > >                         btrfs_run_defrag_inodes(root->fs_info);
> > > +                       up_read(&root->fs_info->sb->s_umount);
> > 
> > Can we use just the cleaner mutex for this?  We're deadlocking during
> > 068 with autodefrag on because the cleaner is holding s_umount while
> > autodefrag is trying to bump the writer count.
> 
> I have now reproduced the deadlock and see where it's stuck.  It did not
> happen with running 068 in a loop, but after interrupting the test.

Hmmm, interrupting the test may just mean you've left it frozen?  It
happens every time for me with autodefrag on.

> 
> > If unmount takes the cleaner mutex once it should wait long enough for
> > the cleaner to stop.
> 
> You mean removing s_umount from here completely? I'm not sure about
> other mis-interaction, eg with remount + autodefrag. Miao sent a patch
> for that case http://www.spinics.net/lists/linux-btrfs/msg16634.html
> (but it would not fix this deadlock).

Mostly we need to pull the run_defrag_inodes out of the s_umount.  It
may be much smarter to put that into a dedicated worker pool.

> 
> I'm for keeping the clean-by-one patch for 3.10, we can fix other
> regressions during rc cycle.

I do agree, and left it in the pull that Linus took.  Thanks for working
on this one.

-chris
