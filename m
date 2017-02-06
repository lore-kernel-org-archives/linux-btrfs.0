Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34607 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdBFVkq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 16:40:46 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1car1a-0001lN-GL
        for linux-btrfs@vger.kernel.org; Mon, 06 Feb 2017 22:40:38 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
Date: Mon, 6 Feb 2017 22:40:36 +0100
Message-ID: <20170206224036.23a7b52b@jupiter.sol.kaishome.de>
References: <1485905578.6441.20.camel@gmail.com>
        <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
        <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
        <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
        <20170205125458.252c68df@jupiter.sol.kaishome.de>
        <a3190ae7-94cc-84b1-bb89-77b1020239b8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 6 Feb 2017 07:30:31 -0500
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> > How about mounting the receiver below a directory only traversable
> > by root (chmod og-rwx)? Backups shouldn't be directly accessible by
> > ordinary users anyway.  
> There are perfectly legitimate reasons to have backups directly 
> accessible by users.  If you're running automated backups for _their_ 
> systems _they_ absolutely should have at least read access to the 
> backups _once they're stable_.

This is not what I tried to explain. The OPs question mixes the
creation process with later access. The creation process, however,
should always be isolated. See below, you're even agreeing. ;-)

> This is not a common case, but it is
> a perfectly legitimate one.  In the same way, if you're storing
> backups for your users (in this case you absolutely should not be4
> using send/receive for other reasons), then the use case dictates
> that they have some way to access them.

I don't deny that. But the OP should understand to properly isolate
both operations from each other. This is best practice, this is how it
should be done.

> > If you want a backup becoming accessible, you can later snapshot it
> > to an accessible location after send/receive finished without
> > errors.
> >
> > An in-transit backup, however, should always be protected from
> > possible disruptive access. This is an issue with any backup
> > software. So place the receive within an inaccessible directory.
> > This is not something the backup process should directly bother
> > with for simplicity.  

> I agree on this point however.  Doing a backup directly into the
> final persistent storage location is never a good idea.  It makes
> error handling more complicated, it makes handling of multi-tier
> storage more complicated (and usually less efficient), and it makes
> security more difficult.

Agreed. It complicates a lot of things. In conclusion: If done right,
the original request isn't a problem, neither is anything wrong by
design. It's a question of isolation of operations.

This is simply one of the most basic principles of a safe and secure
backup.

Personally, if I use rsync for backups, I always rsync to a scratch
location only accessible by the backup process. This scratch area may
even be incomplete, inconsistent or broken in other ways. Only when
rsync successfully finished, the scratch area will be snapshot to its
final destination - which is accessible by its users/owners. This also
has the benefit of the snapshots being self-contained deltas which can
be removed without rewriting or reorganizing partial or complete backup
history. That's a plus-point for backup safety, performance, and
retention policies.

Currently, I'm using borgbackup for my personal backups. It has a
similar approach by using checkpoints for resuming a partial backup.
Only a successful backup process creates the final checkpoint. The
intermediate checkpoints can be thrown away at any time later. It
currently stores a backup history of 95.8 TB (multiple months) on a 3 TB
hard disk. Unfortunately, I don't yet sync this to an offsite location.
My most important data (photos, mental work like programming) is stored
in a different location through other means (Git, cloud sync).

For customers, I prefer to use a local cache where the backup is
stored, then it will be synced offsite using deduplication algorithms
to reduce transfer overhead. A second, different backup software stores
another local copy for fast recovery in case of disaster. There's only
need to sync back from offsite storage in case of total local data
loss. And there's a backup for the backup. If one doesn't work, there's
always the other.

In all cases, the intermediate storage is protected from tampering by
the user, or even completely blocked to be accessed by the user. Only
final and clean snapshots are made available.

Also, error handling and cleanup is easy because errors don't leak or
propagate into the final storage. You simply can clean caches,
intermediate checkpoints, or scratch/staging areas. You can even loose
it for whatever reason (hardware problems, storage errors etc). The
only downside would be that the next backups takes longer to complete.

-- 
Regards,
Kai

Replies to list-only preferred.

