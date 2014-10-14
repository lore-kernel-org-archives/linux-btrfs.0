Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44933 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaJNLRu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 07:17:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 14 Oct 2014 13:17:41 +0200
From: admin@prnet.org
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs random filesystem corruption in kernel 3.17
In-Reply-To: <pan$e02d1$5d8cd0cc$87f3cfc$b14a0d51@cox.net>
References: <543450DC.90504@prnet.org>
 <1412714780.2374.0@mail.thefacebook.com> <543A61EE.7070200@prnet.org>
 <CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
 <543C35C3.9070002@prnet.org>
 <CAGfcS_n5+ToT6kM5+J9TLjdwpriC3uu7hg2HVZXTmTSo-URO9Q@mail.gmail.com>
 <pan$e02d1$5d8cd0cc$87f3cfc$b14a0d51@cox.net>
Message-ID: <c2103f1c229cdd887b8743d0946a8a8f@prnet.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Summarizing what I've seen on the threads...

First of all many thanks for summarizing the info.

> 1) The bug seems to be read-only snapshot related.  The connection to
> send is that send creates read-only snapshots, but people creating 
> read-
> only snapshots for other purposes are now reporting the same problem, 
> so
> it's not send, it's the read-only snapshots.

In fact send does not create a read-only snapshot, snapshots are created 
manually prior to calling send.

> 2) Writable snapshots haven't been implicated yet, and the working set
> from which the snapshots are taken doesn't seem to be affected, either.
> So in that sense it's not affecting ordinary usage, only the read-only
> snapshots themselves.
> 
> 3) More problematic, however, is the fact that these apparently 
> corrupted
> read-only snapshots often are not listed properly and can't be deleted,
> tho I'm not sure if that's /all/ the corrupted snapshots or only part 
> of
> them. So while it may not affect ordinary operation in the short term,
> over time until there's a fix, people routinely doing read-only 
> snapshots
> are going to be getting more and more of these undeletable snapshots, 
> and
> depending on whether the eventual patch only prevents more or can
> actually fix the bad ones (possibly via btrfs check or the like),
> affected filesystems may ultimately have to be blown away and recreated
> with a fresh mkfs, in ordered to kill the currently undeletable 
> snapshots.
> 
> So the first thing to do would be to shut off whatever's making 
> read-only
> snapshots, so you don't make the problem worse while it's being
> investigated.  For those who can do that without too big an 
> interruption
> to their normal routine (who don't depend on send/receive, for 
> instance),
> just keep it off for the time being.  For those who depend on read-only
> snapshots (send-receive for backup and the data is too valuable to not 
> do
> the backups for a few days), consider switching back to 3.16-stable --
> from 3.16.3 at least, the patch for the compress bug is there, so that
> shouldn't be a problem.
> 
> And if you're affected, be aware that until we have a fix, we don't 
> know
> if it'll be possible to remove the affected and currently undeletable
> snapshots.  If it's not, at some point you'll need to do a fresh
> mkfs.btrfs, to get rid of the damage.  Since the bug doesn't appear to
> affect writable snapshots or the "head" from which snapshots are made,
> it's not urgent, and a full fix is likely to include a patch to detect
> and fix the problem as well, but until we know what the problem is we
> can't be sure of that, so be prepared to do that mkfs at some point, as
> at this point it's possible that's the only way you'll be able to kill
> the corrupted snapshots.

I don't agree with you concerning the not urgent part. In my opinion, 
any problem leading to filesystem or other data corruption should be 
considered as urgent, at least as long as it isn't known what exactly is 
affected and whether there is a simple way to salvage the corruption 
without going the backup/restore route.

> 4) Total speculation on my part, but given the wanted transid (aka
> generation, in different contexts) is significantly lower than the 
> found
> transid, and the fact that the problem appears to be limited to
> /read-only/ snapshots, my first suspicion is that something's getting
> updated that would normally apply to all snapshots, but the read-only
> nature of the snapshots is preventing the full update there.  The 
> transid
> of the block is updated, but the snapshot being read-only is preventing
> update of the pointer in that snapshot accordingly.
> 
> What I do /not/ know is whether the bug is that something's getting
> updated that should NOT be, and it's simply the read-only snapshots
> letting us know about it since the writable snapshots are fully 
> updated,
> even if that breaks the snapshot (breaking writable snapshots in a
> different and currently undetected way), or if instead, it's a 
> legitimate
> update, like a balance simply moving the snapshot around but not
> affecting it otherwise, and the bug is that the read-only snapshots
> aren't allowing the legitimate update.
> 
> Either way, this more or less developed over the weekend, and it's 
> Monday
> now, so the devs should be on it.  If it's anything like the 3.15/3.16
> compression bug, it'll take some time for them to properly trace it, 
> and
> then to figure out an appropriate fix, but they will.  Chances are 
> we'll
> have at least some decent progress on a trace by Friday, and maybe even 
> a
> good-to-go patch. =:^)
