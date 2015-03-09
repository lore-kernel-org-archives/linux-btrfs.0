Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46331 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbbCIF51 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Mar 2015 01:57:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YUqgv-0002Pd-Tq
	for linux-btrfs@vger.kernel.org; Mon, 09 Mar 2015 06:57:26 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Mar 2015 06:57:25 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Mar 2015 06:57:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Clone or Backup Filesystem with compression and dedup
Date: Mon, 9 Mar 2015 05:57:18 +0000 (UTC)
Message-ID: <pan$38464$2210246a$19a8e791$e3654447@cox.net>
References: <CAHu5UDn5rtL0-YwT52fxb8vkM7ikhjjE1hcCrC-V1PD-ua5UhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

dave posted on Sun, 08 Mar 2015 11:43:49 -0600 as excerpted:

> Greetings,
> 
> I've searched the wiki and the web [...]

Thanks for letting us know you already know about the wiki. =:^)  Just in 
case it's a different wiki... https://btrfs.wiki.kernel.org

> Use case:
> 
> I have a 5TB single drive btrfs filesystem.  The filesystem is using
> compression and deduplication (used bedup with size threshold of ~200kB
> resulting in 10s of thousands of deduplicated files).  The space savings
> is fantastic!
> 
> I have 2 blank 5TB drives to be used as a rotating offline backup,
> connecting to the computer once every few weeks and syncing the
> new/changed data.  The data is mostly static, slowly growing with
> ocassional changes.
> 
> What is the best way to:
> 
> 1) make an initial clone of the filesystem, keeping the compression and
> deduplication of the source filesystem?
> 
> 2) make periodic syncronizations of the source filesystem to the backup
> filesystem, again maintaining the compression and deduplication of the
> filesystem?
> 
> I know that I can make a new empty btrfs filesystem then rsync and
> bedup, but the file-level copy and bedup processes are very resource
> heavy and time consuming.
> 
> I've also considered adding a blank drive to the source filesystem as a
> raid mirror then breaking the mirror, but this seems like a brutal,
> unintended use of btrfs raid/redundancy..

You didn't mention btrfs send/receive.  That's the btrfs specific answer 
to the general question, and it's covered to some extent in the wiki 
(which is why I wondered if you read a different one, since you didn't 
mention send/receive after saying you'd read it).

However, while after the reference send/receive, further send/receives 
are generally very resource efficient, I don't know the extent to which 
it'll maintain the deduplication.  I don't actually use either dedup or 
send/receive for my use-case and haven't seen that specific use-case 
discussed on list and thus can't simply repeat the answer, so you'll need 
to wait for a dev or someone with more direct knowledge to answer that 
specific angle... or simply test it and report back, now that you have 
the more general answer steering you in the right direction. =:^)

What send does is make a read-only btrfs snapshot of the sending-side, 
then send that to the receiving side to recreate on a different 
filesystem.  After the first one, you keep a matching reference snapshot 
on each side to refer to, so just the changes can be sent.  Actually, it 
gets a bit fancier than that as you can have send reference multiple 
partial-reference snapshots as long as copies exist on both sides, such 
that where it makes sense send can reference other than the direct parent.

Other than the above possibility that it doesn't handle dedups as 
efficiently as it could/should, where I simply don't know, there are two 
potential disadvantages.

1) There are still possible bugs and corner-cases where send/receive 
might get stuck and thus error out on one end or the other.  A simple 
example, altho this simple case has actually been working for awhile now, 
was what happens when nesting is reversed, subdir A containing subdir B 
on the original/reference, but then switching them, so B contains A on 
the new send -- that's the kind of corner-case, only more complex now, 
that can still occasionally tie send/receive in knots and trigger an 
error.

However, it does reliably error out when there is a problem, so if both 
sides complete without errors, the result should in fact be 100% 
reliable.  Just be sure to check for errors, just in case. =:^)

As a result of this, it's always wise to have rsync or the like as a 
fallback method.  In the normal case you won't need the fallback, but if 
you do, better to have it ready to go, than to miss a backup and have 
that be the time you **NEED** it.  Of course, if you do find a send/
receive bug and can't use it for a time, be sure and keep the reference 
snapshots available so when the bug is fixed you can go back to using 
send/receive. =:^)

2) Btrfs send/receive /does/ use the btrfs snapshotting mechanism.  As 
such, the contraindications for btrfs snapshotting apply to send/receive 
as well.  Specifically, there are snapshotting complications regarding 
files set nocow, the most common use-case of which is on large (> half a 
GiB) active database and VM-image files, since the internal-rewrite-
pattern typical of such files tends to heavily fragment them on COW-based 
filesystems including btrfs.  There are, however, workarounds available, 
tho they might play havoc with dedup.

Basically, don't worry about this one if you don't regularly run VM 
images or large databases on the filesystem/subvolume you're going to be 
send/receiving.  If you do have this sort of files, further research is 
necessary, but one possibility is to segregate these onto a dedicated 
subvolume and then use other backup methods for it, since snapshots stop 
at subvolume boundaries, thus letting you use subvolumes to wall off the 
areas you don't want snapshotted and sent/received.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

