Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33592 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765AbbLHPZX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Dec 2015 10:25:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6K8n-00045o-60
	for linux-btrfs@vger.kernel.org; Tue, 08 Dec 2015 16:25:21 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 16:25:21 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2015 16:25:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing recursive fault and parent transid verify failed
Date: Tue, 8 Dec 2015 15:25:14 +0000 (UTC)
Message-ID: <pan$73edd$edd83c4d$2a373055$4b6032dd@cox.net>
References: <20151207015715.GA13954@alistair-xps13>
	<pan$42653$68e1a3aa$3a4c1c2c$b0e89f8@cox.net>
	<20151207100256.GA6836@alistair-xps13>
	<pan$cb93a$b4f560b9$2dfdbdbc$17d7a835@cox.net>
	<20151207195504.GA9262@alistair-xps13>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alistair Grant posted on Tue, 08 Dec 2015 06:55:04 +1100 as excerpted:

> On Mon, Dec 07, 2015 at 01:48:47PM +0000, Duncan wrote:
>> Alistair Grant posted on Mon, 07 Dec 2015 21:02:56 +1100 as excerpted:
>> 
>> > I think I'll try the btrfs restore as a learning exercise, and to
>> > check the contents of my backup (I don't trust my memory, so
>> > something could have changed since the last backup).
>> 
>> Trying btrfs restore is an excellent idea.  It'll make things far
>> easier if you have to use it for real some day.
>> 
>> Note that while I see your kernel is reasonably current (4.2 series), I
>> don't know what btrfs-progs ubuntu ships.  There have been some marked
>> improvements to restore somewhat recently, checking the wiki
>> btrfs-progs release-changelog list says 4.0 brought optional metadata
>> restore, 4.0.1 added --symlinks, and 4.2.3 fixed a symlink path check
>> off-by-one error. (And don't use 4.1.1 as its mkfs.btrfs is broken and
>> produces invalid filesystems.)  So you'll want at least progs 4.0 to
>> get the optional metadata restoration, and 4.2.3 to get full symlinks
>> restoration support.
>> 
>> 
> Ubuntu 15.10 comes with btrfs-progs v4.0.  It looks like it is easy
> enough to compile and install the latest version from
> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git so
> I'll do that.
> 
> Should I stick to 4.2.3 or use the latest 4.3.1?

I generally use the latest myself, but recommend as a general guideline 
that at minimum, a userspace version series matching that of your kernel 
be used, as if the usual kernel recommendations (within two kernel series 
of either current or LTS, so presently 4.2 or 4.3 for current or 3.18 or 
4.1 for LTS) are followed, that will keep userspace reasonably current as 
well, and the userspace of a particular version was being developed 
concurrently with the kernel of the same series, so they're relatively in 
sync.

So with a 4.2 kernel, I'd suggest at least a 4.2 userspace.  If you want 
the latest, as I generally do, and are willing to put up with occasional 
bleeding edge bugs like that broken mkfs.btrfs in 4.1.1, by all means, 
use the latest, but otherwise, the general same series as your kernel 
guideline is quite acceptable.

The exception would be if you're trying to fix or recover from a broken 
filesystem, in which case the very latest tends to have the best chance 
at fixing things, since it has fixes for (or lacking that, at least 
detection of) the latest round of discovered bugs, that older versions 
will lack.

While btrfs restore does fall into the recover from broken category, we 
know from the changelogs that nothing specific has gone into it since the 
mentioned 4.2.3 symlink off-by-one fix, so while I would recommend at 
least that since you are going to be working with restore, there's no 
urgent need for 4.3.0 or 4.3.1 if you're more comfortable with the older 
version.  (In fact, while I knew I was on 4.3.something, I just had to 
run btrfs version, to check whether it was 4.3 or 4.3.1, myself.  FWIW, 
it was 4.3.1.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

