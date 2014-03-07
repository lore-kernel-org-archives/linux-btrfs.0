Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42156 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbaCGOEL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 09:04:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WLvNh-0007y7-SQ
	for linux-btrfs@vger.kernel.org; Fri, 07 Mar 2014 15:04:09 +0100
Received: from 63.239.65.11 ([63.239.65.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Mar 2014 15:04:09 +0100
Received: from ericsbinaryworld by 63.239.65.11 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Mar 2014 15:04:09 +0100
To: linux-btrfs@vger.kernel.org
From: Eric Mesa <ericsbinaryworld@gmail.com>
Subject: Re: Understanding btrfs and backups
Date: Fri, 7 Mar 2014 14:03:44 +0000 (UTC)
Message-ID: <loom.20140307T144540-512@post.gmane.org>
References: <loom.20140306T191655-366@post.gmane.org> <pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:
> *But*, btrfs snapshots by themselves remain on the existing btrfs 
> filesystem, and thus are subject to many of the same risks as the 
> filesystem itself.  As you mentioned raid is redundancy not backup, 
> snapshots aren't backup either; snapshots are multiple logical copies 
> thus protecting you from accidental deletion or bad editing, but pointed 
> at the same data blocks without redundancy, and if those data blocks or 
> the entire physical media go bad...
> 
> Which is where real backups, separate copies on separate physical media, 
> come in, which is where btrfs send/receive, as the ars-technica article 
> was describing, comes in.
> 
> The idea is to make a read-only snapshot on the local filesystem, read-
> only so it can't change while it's being sent, and then use btrfs send to 
> send that snapshot to be stored on some other media, which can optionally 
> be over the network to a machine and media at a different site, altho it 
> can be to a different device on the same machine, as well.
> 
> The first time you do this, there's no existing copy at the other end, so 
> btrfs send sends a full copy and btrfs receive writes it out.  After 
> that, the receive side has a snapshot identical to the one created on the 
> send side and further btrfs send/receives to the same set simply 
> duplicate the differences between the reference and the new snapshot from 
> the send end to the receive end.  As with local snapshots, old ones can 
> be deleted on both the send and receive ends, as long as at least one 
> common reference snapshot is maintained on both ends, so diffs taken 
> against the send side reference can be applied to an appropriately 
> identical receive side reference, thereby updating the receive side to 
> match the new read-only snapshot on the send side.
> 
> Hopefully that's clearer now. =:^)
> 


Duncan - thanks for this comprehensive explanation. For a huge portion of
your reply...I was all wondering why you and others were saying snapshots
aren't backups. They certainly SEEMED like backups. But now I see that the
problem is one of precise terminology vs colloquialisms. In other words,
snapsshots are not backups in and of themselves. They are like Mac's Time
Machine. BUT if you take these snapshots and then put them on another media
- whether that's local or not - THEN you have backups. Am I right, or am I
still missing something subtle? 

I think the most important thing you said was at the end and I'd like a
little clarification on that if it's OK with you. 

"As with local snapshots, old ones can 
> be deleted on both the send and receive ends, as long as at least one 
> common reference snapshot is maintained on both ends, so diffs taken 
> against the send side reference can be applied to an appropriately 
> identical receive side reference, thereby updating the receive side to 
> match the new read-only snapshot on the send side."

So, let's say I have everything set up. This means I created the read-only
shot on my home btrfs volume and sent it to the backup drive. I'm making
hourly snapshots and after each snapshot is made, it's sent to the backup
drive. So, obviously the backup drive needs to be at least as big as the
home drive so it can store what's on home plus the snapshot-diffs. Now let's
be extreme and say that in the course of a year I touch and somehow change
every single file on the home drive. That means if I only had one snapshot
I'd need home drive x 2 space. (for used space, not unused space, naturally)
So I might want my backups to have last's year's data, but wouldn't want to
need to upgrade the size of my actual home drive. So I would want to
maintain less snapshots on my home drive than my backup drive. (It's
possible I'm missing something here...something subtle that makes this not
necessary) So do I only need to make sure I have the latest snapshot or
maybe latest plus n-1 on the home drive while the backup drive can have all
snapshots since the beginning? I THINK that can be the case based on reading
your sentence, but I just want to make sure. 

In case you were wondering, this is based on what's happened to me with Back
in Time. I had to reduce the number of backups I was keeping because my home
drive wasn't at 100%, but the backupdrive was at 100% because I'd added and
deleted some VMs and other large files (video files I think). And Back in
Time intelligently does not remove the oldest backup off the top until it
knows it has made a new backup - which it couldn't do because it was at
100%. So I had to delete the top 1 or 2 backups and then tell it to keep
less backups. Your description of snapshots makes it seems much less likely
that this would be an issue. Although Back in Time is an incremental backup,
its takes up more space. If I may venture to see if I've learned something
from your response, is it because when I change a file Back in Time stores
the entire changed file while btrfs only stores the bits that have changed?
Also, does it matter if the file is binary or text? If I'm editing metadata
on an mp3 file is the resulting snapshot the entire mp3 or just what's
changed? (vs how it would work with a text file)

