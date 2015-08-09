Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58376 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992842AbbHIC45 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Aug 2015 22:56:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZOGn8-0006a1-Cf
	for linux-btrfs@vger.kernel.org; Sun, 09 Aug 2015 04:56:54 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2015 04:56:54 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2015 04:56:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fs unreadable after powercycle: BTRFS (device sda): parent
 transid verify failed on 427084513280 wanted 390924 found 390922
Date: Sun, 9 Aug 2015 02:56:49 +0000 (UTC)
Message-ID: <pan$24874$5c494beb$ed9709e6$399a5c96@cox.net>
References: <CABL_Pd-Z6-raB3ngEDbj=-d+QVMohGQ9DHXqv0fVvVNy-HVxUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Tippmann posted on Sat, 08 Aug 2015 20:43:34 +0200 as excerpted:

> Hi, after a hard reboot (powercycle) a btrfs volume did not come up
> again:
> 
> It's a single 4TB disk - only btrfs with lzo - data=single,metadata=dup
> 
> [  121.831814] BTRFS info (device sda): disk space caching is enabled [
> 121.857820] BTRFS (device sda): parent transid verify failed on
> 427084513280 wanted 390924 found 390922 [  121.861607] BTRFS (device
> sda):
> parent transid verify failed on 427084513280 wanted 390924 found 390922
> [ 121.861715] BTRFS: failed to read tree root on sda [  121.878111]
> BTRFS: open_ctree failed
> 
> btrfs-progs v4.0 Kernel: 4.1.4
> 
> I'm quite sure that the HDD is fine (no SMART Problems, Disk Errorlog is
> empty, It's a new Enterprise-Drive that worked well in the past
> days/weeks).
> 
> So I'm kind at loss what to do:
> 
> How can I recover from that problem? I've found just a note in the
> FAQ[1] but no solution to the problem.

[The FAQ reference was to the wiki problem faq, transid failure 
explanation, but it didn't say what to do about it.]

Did you try the recovery mount option suggested earlier in the problem-faq 
under mount problems?

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mount_my_filesystem.2

For transid failures, that's what I'd try first, since that scans 
previous tree-roots and tries to use the first one it can read.  Since 
the transid it wants (390924) is only a couple ahead of what it finds 
(390922), and the recover mount option scans backward in the tree-root 
history to see if it can find any that work, that could well solve the 
problem.

If not, as Hugo mentions, given find-tree-root looks good, btrfs restore 
has a good chance of working.  I've used that myself to good effect a 
couple times when a btrfs refused to mount (I have backups if I have to 
use 'em, but recovery or restore, when they work, will normally leave me 
with more current copies, since I tend to let my backups get somewhat 
stale).  There's a page on the wiki for using it with find-root if 
necessary, but the wiki page is a bit dated.  The btrfs-restore manpage 
should be current, but doesn't have the detail about using it with find-
root that the wiki page has.

> Maybe someone can give some clues why does this happen in the first
> place?
> Is it unfortunate timing due to the abrupt power cycle?
> Shouldn't CoW protect against this somewhat?

As Hugo says, in theory cow should protect against this, but the 
combination of possible bugs in a still not yet fully stable and mature 
btrfs, and possibly buggy hardware, means theory and practice don't 
always line up as well as they should, in theory. (How's that for an 
ouroboros, aka snake eating it's tail circular-reference, explanation? 
=:^)

But the recovery mount option is a reasonable first recovery (now 
ouroboroi =:^) option, and btrfs restore not too bad to work with if that 
fails.

Referencing the hardware write-caching option you mentioned later, yes, 
turning that off can help... in theory... but it also tends to have a 
DRAMATICALLY bad effect on spinning rust write performance (I don't know 
enough about SSD write caching to venture a guess), and in some cases 
voids warranties due to the additional thrashing it's likely to cause as 
well, so do your research before turning it off.  In general, it's not a 
good idea as it's simply not worth it.  Both Linux at the generic IO 
level and the various filesystem stacks are designed to work around all 
but the worst hardware IO barrier failures, and the write slowdown and 
increased disk thrashing are simply not worth it, in most cases.  If the 
hardware is actually bad enough that it's worth it, I'd strongly consider 
different hardware.





-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

