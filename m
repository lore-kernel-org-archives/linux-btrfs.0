Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbcEDM3b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 08:29:31 -0400
Date: Wed, 4 May 2016 14:29:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH, maybe WRONG] btrfs: don't let btrfs_recover_relocation
 get stuck waiting for cleaner_kthread to delete a snapshot
Message-ID: <20160504122912.GR29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160504011009.GB15597@hungrycats.org>
 <CAL3q7H6CL5ZFuAfLU0W501w58w=9iG5yg5ODM+-7MT4aA7kiRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6CL5ZFuAfLU0W501w58w=9iG5yg5ODM+-7MT4aA7kiRw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 04, 2016 at 10:49:23AM +0100, Filipe Manana wrote:
> On Wed, May 4, 2016 at 2:10 AM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> > This is one way to fix a long hang during mounts.  There's probably a
> > better way, but this is the one I've used to get my filesystems up
> > and running.
> >
> > We start the cleaner kthread first because the transaction kthread wants
> > to wake up the cleaner kthread.  We start the transaction kthread next
> > because everything in btrfs wants transactions.  We do reloc recovery
> > once the transaction kthread is running.  This means that the cleaner
> > kthread could already be running when reloc recovery happens (e.g. if a
> > snapshot delete was started before a crash).
> >
> > Reloc recovery does not play well with the cleaner kthread, so a mutex
> > was added in commit 5f3164813b90f7dbcb5c3ab9006906222ce471b7 "Btrfs:
> > fix race between balance recovery and root deletion" to prevent both
> > from running at the same time.
> >
> > The cleaner kthread could already be holding the mutex by the time we
> > get to btrfs_recover_relocation, and if it is, the mount will be blocked
> > until at least one snapshot is deleted (possibly more if the mount process
> > doesn't get the lock right away).  During this time (which could be an
> > arbitrarily long time on a large/slow filesystem), the mount process is
> > stuck and the filesystem is unnecessarily inaccessible.
> >
> > Fix this by locking cleaner_mutex before we start the cleaner_kthread,
> > and unlocking it when we have finished with it in the mount function.
> > This allows the mount to proceed to completion before resuming snapshot
> > deletion.  I'm not sure about the error cases, and the asymmetrical
> > pthread_mutex_lock/unlocks are just ugly.  Other than that, this patch
> > works.
> >
> > An alternative (and possibly better) solution would be to add an extra
> > check in btrfs_need_cleaner_sleep() for a flag that would be set at the
> > end of mounting.  This should keep cleaner_kthread sleeping until just
> > before mount is finished.
> 
> Looks valid and good to me.
> The alternative solution you describe would unnecessarily be more
> complex without any benefit.
> I prefer what you did, it's correct and simple. Just 2 comments below.

We could detect if mount is finished by checking for MS_BORN in
superblock->s_flags (set by VFS). But that would be extra code to do
just that, while cleaner kthread is prepared for the mutex contention and
sleeps if necessary.

I like the approach proposed in the patch as well.
