Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44475 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdKCHGp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 03:06:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eAW3n-0002QI-Rg
        for linux-btrfs@vger.kernel.org; Fri, 03 Nov 2017 08:06:35 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
Date: Fri, 3 Nov 2017 08:06:33 +0100
Message-ID: <20171103080633.7233b2fe@jupiter.sol.kaishome.de>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
        <f17a1de9-8340-dae3-3b29-0e04440ca2a3@rqc.ru>
        <CAH=dxU7APYANHn3PjqepY9dr9F3RRhzE1OSgtar9tN-74haS9g@mail.gmail.com>
        <20171102214613.10af365e@jupiter.sol.kaishome.de>
        <CAH=dxU59aq-KFKPb0qhMvd3B=OXdScK223HzcMcvUkFwcas-SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 2 Nov 2017 23:24:29 -0400
schrieb Dave <davestechshop@gmail.com>:

> On Thu, Nov 2, 2017 at 4:46 PM, Kai Krakow <hurikhan77@gmail.com>
> wrote:
> > Am Wed, 1 Nov 2017 02:51:58 -0400
> > schrieb Dave <davestechshop@gmail.com>:
> >  
>  [...]  
>  [...]  
>  [...]  
> >>
> >> Thanks for confirming. I must have missed those reports. I had
> >> never considered this idea until now -- but I like it.
> >>
> >> Are there any blogs or wikis where people have done something
> >> similar to what we are discussing here?  
> >
> > I used rsync before, backup source and destination both were btrfs.
> > I was experiencing the same btrfs bug from time to time on both
> > devices, luckily not at the same time.
> >
> > I instead switched to using borgbackup, and xfs as the destination
> > (to not fall the same-bug-in-two-devices pitfall).  
> 
> I'm going to stick with btrfs everywhere. My reasoning is that my
> biggest pitfalls will be related to lack of knowledge. So focusing on
> learning one filesystem better (vs poorly learning two) is the better
> strategy for me, given my limited time. (I'm not an IT professional of
> any sort.)
> 
> Is there any problem with the Borgbackup repository being on btrfs?

No. I just wanted to point out that keeping backup and source on
different media (which includes different technology, too) is common
best practice and adheres to the 3-2-1 backup strategy.


> > Borgbackup achieves a
> > much higher deduplication density and compression, and as such also
> > is able to store much more backup history in the same storage
> > space. The first run is much slower than rsync (due to enabled
> > compression) but successive runs are much faster (like 20 minutes
> > per backup run instead of 4-5 hours).
> >
> > I'm currently storing 107 TB of backup history in just 2.2 TB backup
> > space, which counts a little more than one year of history now,
> > containing 56 snapshots. This is my retention policy:
> >
> >   * 5 yearly snapshots
> >   * 12 monthly snapshots
> >   * 14 weekly snapshots (worth around 3 months)
> >   * 30 daily snapshots
> >
> > Restore is fast enough, and a snapshot can even be fuse-mounted
> > (tho, in that case mounted access can be very slow navigating
> > directories).
> >
> > With latest borgbackup version, the backup time increased to around
> > 1 hour from 15-20 minutes in the previous version. That is due to
> > switching the file cache strategy from mtime to ctime. This can be
> > tuned to get back to old performance, but it may miss some files
> > during backup if you're doing awkward things to file timestamps.
> >
> > I'm also backing up some servers with it now, then use rsync to sync
> > the borg repository to an offsite location.
> >
> > Combined with same-fs local btrfs snapshots with short retention
> > times, this could be a viable solution for you.  
> 
> Yes, I appreciate the idea. I'm going to evaluate both rsync and
> Borgbackup.
> 
> The advantage of rsync, I think, is that it will likely run in just a
> couple minutes. That will allow me to run it hourly and to keep my
> live volume almost entire free of snapshots and fully defragmented.
> It's also very simple as I already have rsync. And since I'm going to
> run btrfs on the backup volume, I can perform hourly snapshots there
> and use Snapper to manage retention. It's all very simple and relies
> on tools I already have and know.
> 
> However, the advantages of Borgbackup you mentioned (much higher
> deduplication density and compression) make it worth considering.
> Maybe Borgbackup won't take long to complete successive (incremental)
> backups on my system.

Once a full backup was taken, incremental backups are extremely fast.
At least for me, it works much faster than rsync. And as with btrfs
snapshots, each incremental backup is also a full backup. It's not like
traditional backup software that needs the backup parent and grand
parent to make use of the differential and/or incremental backups.

There's one caveat, tho: Only one process can access a repository at a
time, that is you need to serialize different backup jobs if you want
them to go into the same repository. Deduplication is done only within
the same repository. Tho, you might be able to leverage btrfs
deduplication (e.g. using bees) across multiple repositories if you're
not using encrypted repositories.

But since you're currently using send/receive and/or rsync, encrypted
storage of the backup doesn't seem to be an important point to you.

Burp with its client/server approach may have an advantage here, so its
setup seems to be more complicated. Borg is really easy to use. I never
tried burp, tho.


> I'll have to try it to see. It's a very nice
> looking project. I'm surprised I never heard of it before.

It seems to follow similar principles as burp (which I never heard of
previously). It seems like the really good backup software has some
sort of PR problem... ;-)


-- 
Regards,
Kai

Replies to list-only preferred.

