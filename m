Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34476 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400AbbLOBt6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 20:49:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a8ekW-0003pd-9j
	for linux-btrfs@vger.kernel.org; Tue, 15 Dec 2015 02:49:56 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 02:49:56 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 02:49:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: poor performance on deleting many large files
Date: Tue, 15 Dec 2015 01:49:50 +0000 (UTC)
Message-ID: <pan$c3e1a$7bad3839$12bcfe1f$4c2ff85e@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<pan$eea04$e9596e27$78b44461$c5754723@cox.net>
	<1448488198.4717.4.camel@gmail.com>
	<pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
	<1448562347.8809.16.camel@scientia.net>
	<pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
	<1448582805.11377.9.camel@scientia.net>
	<pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
	<1448683025.6837.4.camel@scientia.net>
	<pan$46a28$81694e9d$c6d5f048$1c8bcdd8@cox.net>
	<1449958538.15961.3.camel@scientia.net> <566ED124.30803@gmail.com>
	<1450121957.6629.41.camel@scientia.net> <566F261F.4040705@gmail.com>
	<566F34F0.8050407@bouton.name> <1450135505.6629.66.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Tue, 15 Dec 2015 00:25:05 +0100 as
excerpted:

> On Mon, 2015-12-14 at 22:30 +0100, Lionel Bouton wrote:
> 
>> I use noatime and nodiratime

> FYI: noatime implies nodiratime :-)

Was going to post that myself.  Is there some reason you:

a) use nodiratime when noatime is already enabled, despite the fact that 
the latter already includes the former, or

b) didn't sufficiently research the option (at least the current mount 
manpage documents that noatime includes nodiratime under both the noatime 
and nodiratime options, and at least some hint of that has been in the 
manpage for years as I recall reading it when I first read of nodiratime 
and checked whether my noatime options included it) before standardizing 
on it, or

c) might have actually been talking in general, and there's some mounts 
you don't actually choose to make noatime, but still want nodiratime, or

d) chose that isn't otherwise reflected in the above?  If so, please 
describe, as it could be a learning experience for me, and possibly 
others as well.

>> Finally Linus Torvalds has been quite vocal and consistent on the
>> general subject of the kernel not breaking user-space APIs no matter
>> what so I wouldn't have much hope for default kernel mount options
>> changes...

> He surely is right in general,... but when the point has been reached,
> where only a minority actually requires the feature... and the minority
> actually starts to suffer from that... it may change.

Generally speaking, the practical rule is that you don't break userspace, 
but that a break that isn't noticed and reported by someone within a few 
release cycles is considered OK, as obviously nobody who actually cares 
enough about the possibility of old userspace breaking on new kernels 
enough to test for it was (still) using that functionality anyway.  (This 
is sometimes known as the "if a tree falls in the forest and there's 
nobody around to hear it, did it actually fall", rule. =:^)

But if it's noticed and reported before the new behavior itself is locked 
into place by other userspace relying on it, the change in behavior must 
be reverted.  (There have actually been a few cases over the years where 
they went to rather exceptional lengths to make two otherwise 
incompatible userspace-exposed behaviors both continue to work for the 
userspace that expected that behavior, without actually coding in such 
obvious hacks as executable name conditionals or the like, as others have 
been known to do at times.  Sometimes these fixes do end up bending the 
rules a bit, particularly the no-policy-in-the-kernel rule, but they do 
reinforce the now userspace breakage rule.)

The possible workarounds include the handful of kernel compatibility 
options that when enabled continue otherwise userspace breaking behavior 
such as removing old kernel API procfs files and the like.

That practical rule does in effect make it possible to do userspace-
breaking changes if you wait around long enough that there's nobody who 
will complain still actually using the old behavior.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

