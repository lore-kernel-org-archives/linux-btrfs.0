Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f175.google.com ([209.85.213.175]:34466 "EHLO
        mail-yb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbcIFMPo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 08:15:44 -0400
Received: by mail-yb0-f175.google.com with SMTP id x93so76713532ybh.1
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Sep 2016 05:15:44 -0700 (PDT)
Subject: Re: Security implications of btrfs receive?
To: Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
Date: Tue, 6 Sep 2016 08:15:29 -0400
MIME-Version: 1.0
In-Reply-To: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-05 05:59, Graham Cobb wrote:
> Does anyone know of a security analysis of btrfs receive?
I'm not a developer, and definitely not a security specialist, just a 
security minded sysadmin who has some idea what's going on, but I can at 
least try and answer this.
>
> I assume that just using btrfs receive requires root (is that so?).  But
> I was thinking of setting up a backup server which would receive
> snapshots from various client systems, each in their own path, and I
> wondered how much the security of the backup server (and other clients'
> backups) was dependent on the security of the client.
In an ideal situation, I'd suggest setting this up with everything 
running on behalf of the client in it's own container (probably using 
LXC, but lmctfy or similar would work too).  You do need root for 
receive to work (because it has to set ownership of files), but you can 
still sandbox it to a reasonable degree.
>
> Does the "path" argument of btrfs-receive mean that *all* operations are
> confined to that path?  For example, if a UUID or transid is sent which
> refers to an entity outside the path will that other entity be affected
> or used?
As far as I know, no, it won't be affected.
> Is it possible for a file to be created containing shared
> extents from outside the path?
As far as I know, the only way for this to happen is if you're 
referencing a parent subvolume for a relative send that is itself 
sharing extents outside of the path.  From a practical perspective, 
unless you're doing deduplication on the receiving end, the this 
shouldn't be possible.
> Is it possible to confuse/affect
> filesystem metadata which would affect the integrity of subvolumes or
> files outside the path or prevent other clients from doing something
> legitimate?
>
> Do the answers change if the --chroot option is given?
This will give you no more or less security than a chroot would give on 
the system,   Pretty much, if there aren't any bugs, this will prevent 
things from getting written outside of the path specified.
> I am confused
> about the -m option -- does that mean that the root mount point has to
> be visible in the chroot?
In this case, 'root' refers to the top level of the filesystem that the 
path resides in.  So, if you have the filesystem your putting the data 
on mounted at /mnt/backups, and the data for this particular client goes 
in /mnt/backups/client, the appropriate value for the -m option would be 
/mnt/backups.
>
> Lastly, even if receive is designed to be very secure, it is possible
> that it could trigger/use code paths in the btrfs kernel code which are
> not normally used during normal file operations and so could trigger
> bugs not normally seen.  Has any work been done on testing for that (for
> example tests using malicious streams, including ones which btrfs-send
> cannot generate)?
In general, most of what btrfs receive is doing is just regular file 
operations (open, write, chown, chmod, rename, and similar things), it 
only really gets into the ioctls when dealing with shared extents, and 
when initially setting up the target subvolume, and there really isn't 
anything run on the kernel side that wouldn't be done during normal 
filesystem operation (except possibly some of the extent sharing 
things).  I haven't done any testing myself (I don't use send-receive 
except for cloning VM's, so I don't have much incentive to worry about 
it), but my guess would be that a bogus data stream is most likely to 
crash the receive process in userspace, and has relatively little risk 
of trashing the filesystem beyond what would normally happen for 
something like a bogus rsync transfer.
>
> I am just wondering whether any work has been done/published on this area.
There isn't any that I know of personally, but in theory it shouldn't be 
hard to test.
