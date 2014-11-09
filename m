Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 17.mo6.mail-out.ovh.net ([46.105.36.150]:34469 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751095AbaKIUWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Nov 2014 15:22:33 -0500
Received: from mail179.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo6.mail-out.ovh.net (Postfix) with SMTP id D89D7FF941A
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Nov 2014 18:55:34 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Quota question
From: Cyril Scetbon <cyril.scetbon@free.fr>
In-Reply-To: <pan$648cb$e6ca8d21$192128f6$95e500d3@cox.net>
Date: Sun, 9 Nov 2014 18:55:31 +0100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <967D58C4-46E1-4508-A5A9-A0835C18E87D@free.fr>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net> <CCA13B0E-D1EE-44D8-A634-FD17C2B22C72@free.fr> <pan$648cb$e6ca8d21$192128f6$95e500d3@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-- 
Cyril SCETBON

> 1)  but is the rewrite in that, or in 
> 3.17, or in the coming 3.18, or not yet entirely there at all... that I 
> simply don't know.

If anyone can answer it'd be great !

> 
> 2) What I *DO* know and *CAN* say with quite some confidence is this:
> 
> With btrfs being in general a copy-on-write filesystem, even deletes 
> normally require /some/ space, because the metadata pointing at the file 
> in question must be rewritten, and that requires free space in ordered to 
> happen.
ok
> 
> At least in the case of full filesystem ENOSPC errors, the space-related 
> questions in the FAQ on the btrfs wiki suggest truncating a file first.  
> Find an existing file that either doesn't matter or that you have a 
> backup of elsewhere, and echo > filename (or echo >| filename if you have 
> noclobber set), therefore truncating the existing file.  A few of those 
> and with luck you'll free enough space to do some actual deletions.
> 
> While to some extent I'm guessing here since I'm not directly familiar 
> with quotas myself, it sounds as if such a severe ENOSPC condition, due 
> in your case to quotas instead of the general filesystem limits I'm more 
> familiar with, might be what you are seeing, particularly since in your 
> tests you first triggered the limit, then found a way to write a bit more 
> anyway, and only THEN found yourself unable to write anything.
> 
> If that's the case, then try the truncate trick and see if it helps.
Unfortunately : http://pastebin.com/1Mw0yiUc
> 
> In the generic filesystem case, if the truncate trick doesn't help, 
> another possible trick is to temporarily add another device of several 
> gigs capacity to the filesystem, enough to let a balance work and 
> hopefully reduce the data/metadata imbalance, after which there should be 
> enough chunk-unallocated free space left on the original device, to do a 
> btrfs device delete of the temporary device, generally still leaving 
> space left, since the balance should have reclaimed some otherwise wasted 
> chunk allocation.
> 
> I can't see how that'd apply to quotas, however, and suspect that the 
> corresponding quota-system solution would be to temporarily up the quota 
> for the affected user, only long enough to let them do the deletions they 
> need to do.  But beyond that I can't go, since I simply don't know enough 
> about the quota domain to further speculate, at this point.

I'm pretty sure it'd work by setting a temporary higher quota, but my questions are : 

- why can I exceed the quotas (580MB when 500MB was set as the limit) ?

qgroupid  excl            max_excl
-------------------------------------------
1/101999 608632832 524288000

- I really think that the quota limit should take into account an amount of space for operations that would free space

For this last question I may think that this issue is caused by the fact that I have only one file taking all the space which won't really be the regular use case. but i'd like to get an answer :)
> 
> While admittedly limited due to my lack of quota-domain knowledge, 
> perhaps that sheds at least some light on what happened and why, and 
> hopefully on how to get out of the situation.

Thank you Duncan !