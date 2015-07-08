Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58207 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbbGHATJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jul 2015 20:19:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZCd4s-00067B-6n
	for linux-btrfs@vger.kernel.org; Wed, 08 Jul 2015 02:19:06 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 02:19:06 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 02:19:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Error while balance after convert from ext4
Date: Wed, 8 Jul 2015 00:18:59 +0000 (UTC)
Message-ID: <pan$2e38c$aafcae5e$5b1bff88$546fb2b@cox.net>
References: <CAFdkf7Pqkjf=H11LaGQusDE_OT3zK1civwrHWeqmTS27uB4FPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Николай Овчинников posted on Wed, 08 Jul 2015 00:46:48 +0300 as excerpted:

> While balancing after succsecful converting from ext4 filesystem moved
> into read-only mode and balance aborted.
> Before balance df says about 6Gb freespace.
> Now filesystem can be mounted only in recovery mode with 1 dir and about
> 20 zero-sized files.

> Is there a chance to recover these files?

FWIW, there have been several other reports of conversion not going so 
well recently.  The opinion of at least some users is that apparently, 
btrfs has moved on from where it was when the conversion tool was built, 
and the conversion tool hasn't kept up, causing problems with the 
conversion in more cases, recently.  (FWIW, I've never particularly 
trusted filesystem conversion tools in the first place.  As such,  I 
always had a strong preference for doing a fresh mkfs, then copying 
things over from the old filesystem.  That way, the old filesystem 
becomes the backup you're restoring to a fresh filesystem from, and it 
remains a backup, in case there are issues with the new filesystem, as 
well as for all the other reasons, including fat-fingering, that valuing 
the data is in practice defined as having a backup.)


Meanwhile, to answer your question, yes, the files can be recovered from 
the backups you had if you valued the data.  If you didn't have them, the 
data obviously wasn't important, and you simply had a bit of help 
clearing your cache of unimportant junk-files. =:^)

Seriously, the sysadmin's standard backup rule states that if you don't 
have a backup, by definition, you value the data less than the time and 
resources necessary to create the backup, no matter any claims to the 
contrary.  Further, for purposes of this rule a would-be backup that 
hasn't been tested restorable isn't yet a backup as a backup isn't 
complete until it's tested.

Of course, the fact that btrfs isn't yet fully stable means the rule 
applies double, compared to its normal application to a fully stable 
filesystem.

And of course, converting a filesystem without a backup is also something 
that by definition is never done with data you actually care about, so at 
/least/ double again (if not 4X on its own).

Which means the rule applied at 4X-8X strength.  You REALLY had a backup 
(and at 4-8X strength, probably more than one), or REALLY don't care 
about the data.


But, there does remain a glimmer of hope in case you had no backup.  
There's the btrfs restore tool you can try.  I'm not sure how well it'll 
work on an incompletely rebalanced after convert filesystem, but it's 
worth a try.  You will need somewhere else to store the restored files, 
since it works with an unmounted filesystem without writing to it (so at 
least it can't make the problem worse).  If restore can't find a usable 
root on its own, you can try using btrfs-find-root, and feed that (or 
rather the corresponding bytenr) to btrfs restore using the -t option.  
There's a somewhat dated but still useful writeup on the wiki about it.

https://btrfs.wiki.kernel.org/index.php/Restore

Note that generation and tranaction-id (transid) are different words for 
the same thing, btrfs restore -t <bytenr> -l lists the various subtree 
roots available from that root (the part of the writeup where it says 
select the root with the most available trees in it), there's now a -D 
dry-run option that will let you get at least some idea how many files 
can be restored, and that the new -m (metadata, ownership/perms info) and 
-S (symlinks) options allow restoring these, as they won't be restored by 
default.

Again, I'm not sure how well restore will do with a fresh conversion 
where the balance died like that, but it's worth a shot, and has a couple 
times restored newer versions of files than my backups had, working well 
for me, tho with a filesystem that was btrfs all along, not converted.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

