Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111AbcEFNGw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 May 2016 09:06:52 -0400
Date: Fri, 6 May 2016 15:06:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: don't force mounts to wait for cleaner_kthread to
 delete one or more subvolumes
Message-ID: <20160506130632.GC29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462422229-23797-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <CAL3q7H6t85yJhztBrCMp=YF9Th6Eh369kZsKh9dwXHS-3isaog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6t85yJhztBrCMp=YF9Th6Eh369kZsKh9dwXHS-3isaog@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 05, 2016 at 10:12:32AM +0100, Filipe Manana wrote:
> On Thu, May 5, 2016 at 5:23 AM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> > During a mount, we start the cleaner kthread first because the transaction
> > kthread wants to wake up the cleaner kthread.  We start the transaction
> > kthread next because everything in btrfs wants transactions.  We do reloc
> > recovery in the thread that was doing the original mount call once the
> > transaction kthread is running.  This means that the cleaner kthread
> > could already be running when reloc recovery happens (e.g. if a snapshot
> > delete was started before a crash).
> >
> > Relocation does not play well with the cleaner kthread, so a mutex was
> > added in commit 5f3164813b90f7dbcb5c3ab9006906222ce471b7 "Btrfs: fix
> > race between balance recovery and root deletion" to prevent both from
> > being active at the same time.
> >
> > If the cleaner kthread is already holding the mutex by the time we get
> > to btrfs_recover_relocation, the mount will be blocked until at least
> > one deleted subvolume is cleaned (possibly more if the mount process
> > doesn't get the lock right away).  During this time (which could be an
> > arbitrarily long time on a large/slow filesystem), the mount process is
> > stuck and the filesystem is unnecessarily inaccessible.
> >
> > Fix this by locking cleaner_mutex before we start cleaner_kthread, and
> > unlocking the mutex after mount no longer requires it.  This ensures
> > that the mounting process will not be blocked by the cleaner kthread.
> > The cleaner kthread is already prepared for mutex contention and will
> > just go to sleep until the mutex is available.
> 
> You miss your Signed-off-by: .... tag (git format-patch or git commit
> with -s add it automatically).
> Once you get that, you can add my Reviewed-by: Filipe Manana <fdmanana@suse.com>

Updated and added to for-next.
