Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34492 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbcDFHB4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Apr 2016 03:01:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anhTN-0003rf-O9
	for linux-btrfs@vger.kernel.org; Wed, 06 Apr 2016 09:01:53 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 09:01:53 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 09:01:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 2/2] btrfs: do not write corrupted metadata blocks to
 disk
Date: Wed, 6 Apr 2016 07:01:48 +0000 (UTC)
Message-ID: <pan$a843e$8766e27e$f9abbf89$d28ba692@cox.net>
References: <1457608215-18089-1-git-send-email-alex@zadarastorage.com>
	<CAD=QJKhYurWnNrXunX+_=KYamdTqnZ2tzO7_+gFxv12c1bd1Hg@mail.gmail.com>
	<CAOcd+r1TmxAE__Mh0AXpiMPjR=r+5u+H_sW+jv=QU54_skt0eA@mail.gmail.com>
	<CAD=QJKjD+CcqkyXG_J6Tq0vLSrx3QD7X1NBU2oPeCt4TmKBd7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas D Steeves posted on Wed, 06 Apr 2016 00:04:36 -0400 as excerpted:

> Ah, that's exactly what I was looking for!  Thank you.  It took forever,
> and brought me back to what it was like to fsck large ext2 volumes.  Is
> btrfs check conceptually identical to a read-only fsck of a ext2 volume?
> If now how does it defer?

That question had me confused for a moment as I couldn't figure out what 
was "deferred", until I realized you must have meant "differ". =:^)

At a suitably high level, yes, btrfs check (without --repair) is 
comparable to a read-only fsck of an ext* volume.  They're both quite 
deep and thorough checks of their respective filesystems.

But while ext2 had no journal and thus required such a deep fsck on 
reboot to recover after a bad shutdown, the later generations had a 
journal and avoided that, tho running an occasional fsck was still 
recommended.  What they run automatically (on boot) is a very brief check 
that just checks some basics and that the filesystem looks like it 
should, replaying the journal if shutdown wasn't safely done, but nothing 
very thorough at all.

And btrfs, being an atomic operation copy-on-write (cow) filesystem, is 
to a journaled filesystem like ext3/4, what a journaled filesystem like 
ext3/4 is to an earlier unjournaled filesystem like ext2.  Which is why 
btrfs check doesn't normally need to be run -- because in general, the 
atomic cow nature of btrfs means that a commit is done atomically, you 
either get the state of the previous commit, or of the new one.  There's 
no way to get a half-way state where only part of the data was written, 
which was the problem ext2 had, that the ext3 and later ext4 journal was 
designed to alleviate, but that an atomic cow filesystem such as btrfs 
does away with entirely.

(Tho btrfs does have a journal, its use is far more limited.  Normally, 
commits happen only every 30 seconds or so, and the btrfs journal simply 
replays any fsynced file changes between commits so they still hit the 
filesystem in the case of a crash before a later commit did it the normal 
way.  IOW, it's only a shortcut to faster fsyncs, which would otherwise 
force a full filesystem commit before returning, much as they did on 
ext3.  But even without that replay, a btrfs should be self-consistent to 
one of the two latest commits, with only the fsyncs done between commits 
lost if the log isn't replayed at all.)

Of course all that assumes no critical bugs.  There's a reason btrfs is 
still considered stabilizing, not fully stable and mature yet, as there 
are still bugs being found and fixed that prevent this ideal from being 
reality in more cases than we'd like, tho the filesystem is in general 
stable enough for many to use daily, as many including myself do, as long 
as they have backups just in case, and their world won't end if they 
actually have to use them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

