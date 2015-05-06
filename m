Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52053 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbbEFL4W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 07:56:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ypxw3-0005Hs-GW
	for linux-btrfs@vger.kernel.org; Wed, 06 May 2015 13:56:19 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 13:56:19 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 13:56:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [REQ] Help to gain access to btrfsraid6 pool that won't mount
Date: Wed, 6 May 2015 11:55:51 +0000 (UTC)
Message-ID: <pan$bf105$8407f6ba$59e45aa$6ad3abdc@cox.net>
References: <mi8452$i00$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

TheJay posted on Mon, 04 May 2015 15:44:35 +0000 as excerpted:

> What could I try to see if I can mount this pool and gain access to the
> data?
> 
> While I have a backup of the data, next time I may not, and I am trying
> to learn how to go about.

If you can't get it to mount based on the other subthreads, and you have 
sufficient space on an existing/working filesystem to recover the files 
to, you can try btrfs restore.

I wrote up a longer reply covering restore in another recent thread, 
"Help on broken filesystem", OP by Ermanno Baschiera, which should be in 
the archives... yes...

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/44765

That in turn refers to the (outdated) restore writeup on the wiki.

Since then, I had to use it again myself, updating my year-old personal 
experience.  Among other things, btrfs-progs v4.0 has a new metadata 
restore option, which should restore ownership/perms/dates as well as the 
file data.  There's a patch to restore symlinks too, but it apparently 
didn't make it into 4.0, so you'll have to try the integration branch or 
apply it manually after finding it on the list.  The looping too many 
times point apparently doesn't apply any more, at least on a full run, 
tho it still cuts short if you use the dry-run option.  Additionally, the 
dry-run option gave me some metadata restoration errors that a full write-
files run didn't give me, so dry-run ends up being rather more 
pessimistic about what can be restored than what it actually restores.

If you're lucky, restore will "just work".  If not, you can try feeding 
it roots you found using btrfs-find-root, as detailed in the above post.  
On my recent experience I was lucky and it worked without that, so I 
didn't get to update my personal experience knowledge in that regard.

You did say you have a backup (good admin! =:^) this time, but wanted to 
practice in case you weren't so lucky next time.  Practice is good, and 
practicing restore when you don't /have/ to depend on it as you have a 
current backup is even better, but do keep in mind the admin's backup 
rule I mention in the other post.

As it happens, I had a backup I could have used in my recent restore 
experience case as well, but it wasn't as current as I'd have liked.  I 
had knowingly taken that risk and would have settled for the old backup 
if I had to, but restore gave me the very pleasant (under the 
circumstances) choice of either the more current copies from btrfs 
restore but having to redo the symlinks manually, or using the older 
backup.  It's actually very nice having that choice as it takes all the 
pressure away of worrying about fat-fingering the one chance you'd 
otherwise have left! =:^)

Plus, while restore "just worked" for me this time, if it hadn't and I 
had to do the find-root thing, I would have had the luxury of simply 
saying OK, too much hassle, I'll just use the older backups and go from 
there.  I'd have probably still tried the find-root thing, because they 
/were/ more current and as you note having the experience is good, but 
again, with the backups if I had to use 'em, the pressure would have been 
off, and that in itself is valuable. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

