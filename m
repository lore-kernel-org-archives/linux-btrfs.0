Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34757 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbbLLKUq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Dec 2015 05:20:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a7hI7-0006ZC-RH
	for linux-btrfs@vger.kernel.org; Sat, 12 Dec 2015 11:20:44 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Dec 2015 11:20:34 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Dec 2015 11:20:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: subvols and parents - how?
Date: Sat, 12 Dec 2015 10:20:28 +0000 (UTC)
Message-ID: <pan$2e32c$6c70baa2$b0e37031$90391f41@cox.net>
References: <1448340960.14125.51.camel@scientia.net>
	<pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
	<1448400350.21291.88.camel@scientia.net>
	<pan$3a1c9$86b20059$6602684a$c91a5eb4@cox.net>
	<1449635882.20578.2.camel@scientia.net>
	<pan$eafa8$b5da4379$31bc32b1$5bc4c9a0@cox.net>
	<1449887577.31388.91.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sat, 12 Dec 2015 03:32:57 +0100 as
excerpted:

> [B]etter said I largely rewrote:
> https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Subvolumes
> which I think should rather be its own wiki article.
> 
> One of the devs/experts... please double check it and pick/drop what
> you like/dislike.

I'd hesitate to call myself a real "expert" on subvolumes because I don't 
run them here (tho I did play with them a bit, before deciding the 
additional benefit for my use-case wasn't worth the additional 
complexity), so nearly all of what I post on the subject is simply 
restatement of other people's posts on the subject[1], but...

Looks quite reasonable to me... and /much/ more filled out than the last 
time I read it. =:^)

> Especially notice that I've changed what was in the wiki, namely
> subvolid=0 would mount the toplevel subovl,... I changed that to 5.

On that particular point, subvolid=0 is a special-case alias to 
subvolid=5, for those for which 0 as reference to the toplevel subvolume 
makes more sense than 5.

So 0 or 5, doesn't particularly matter in practice.  Tho 5 is the actual 
tree ID (AFAIK) with 0 simply an alias to it, so 5 is arguably 
technically slightly more correct, while 0 could be argued to be humanly 
slightly more correct as the logical/expected ID for the toplevel 
subvolume.

You might put that there too, somewhere, if you have a mind to do it...

> Also I assumed the manpage would be correct and subvol= is always
> relative to the top level subvol, thus subvol=/ should mount that.

Haven't the foggiest...

> What's still missing now, IMHO, is:
> - the snapshots subchapter itself is not complete (especially ro vs. rw
> snapshots)... and implications like not mounting snapshots noatime, and
> write amplification effects

Yes.

> - a guide when one should make subvole (e.g. keeping things on the root
> fs together, unless it's separate like /var/www is usually, but
> /var/lib typically "corresponds" to a state of /etc and /usr.

I see you added that (as mentioned in a followup).  Looks good.

> - what I've asked in another mail,.. about subvols and mountopts.
> 
> That rework also contains your security idea... shamelessly not quoting
> you there O:-)

That looks good too... tho to be fair that too was simply reposting 
someone else's idea... which was both *entirely* new to me when I read it 
as I'd simply not considered that before, and equally immediately obvious 
in hindsight, which is why it stuck with me so well, because the 
combination of entirely new viewpoint on something and "Duh, he's 
absolutely right and I should have seen it myself" tends to /be/ pretty 
memorable! =:^)

Anyway, glad it's mentioned on the wiki, now. =:^)

---
[1] No claim of subvolume expert: And also because I've a bit of the 
sysadmin's healthy superstition of ever claiming to be an expert until 
it's so clearly the case it's becoming ridiculous to try to claim 
otherwise, since if there's the slightest doubt, Murphy will surely see/
hear and assert his law shortly thereafter, demonstrating the fallacy of 
the claim, likely with a brown-bag level error! =:^\  Of course, without 
anything but the toplevel subvolumes here, that might make the unwary 
sysadmin unwisely bold, but lest I be unpleasantly reminded of the fact 
that the top-level's a subvolume too, I'm still wary of tempting either 
Murphy or fate with such a claim of expertise! =:^\

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

