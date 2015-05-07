Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49970 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbbEGDPg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 23:15:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YqCHe-00057Z-J2
	for linux-btrfs@vger.kernel.org; Thu, 07 May 2015 05:15:34 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 05:15:34 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 05:15:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.19.6: __btrfs_free_extent:5987: errno=-2 No such entry, did
 btrfs check --repair break it?
Date: Thu, 7 May 2015 03:15:29 +0000 (UTC)
Message-ID: <pan$35a54$19207abe$b0c45d30$33b4f329@cox.net>
References: <4306bc25fe19b7dd623c8e724292d7bb@admin.virtall.com>
	<1409745869.21602.21.camel@localhost> <20140824000720.GN3875@merlins.org>
	<20140926214821.GX13219@merlins.org> <20150502141102.GB1809@merlins.org>
	<20150501210013.GH13624@merlins.org> <20150429232130.GA23814@merlins.org>
	<20150502163010.GK13624@merlins.org> <20150505063215.GA28387@merlins.org>
	<20150505195610.GE23216@merlins.org> <20150505210209.GG23216@merlins.org>
	<pan$a2a67$3e7e2090$a73a1a0d$778571d0@cox.net>
	<CAJCQCtT2YSfWQWmETiOzv4z0pJFnNP2fNXnu+ZZtVyOHurr90A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 06 May 2015 11:25:51 -0600 as excerpted:

> On Wed, May 6, 2015 at 5:04 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> Long story short, nothing I tried (mounting with recovery, the new
>> integrated btrfs rescue zero-log, btrfs check --repair...)
> 
> What is integrated btrfs rescue zero-log btrfs check? Where is it? I
> don't see a check or repair option in btrfs rescue, I do see zero-log
> (and chunk-recover and super-recover).

I think you misread me.  Either that or I'm misreading you and am totally 
confused about what your question is...

Btrfs-zero-log was previously its own command.  In 4.0 it has moved under 
the btrfs rescue command as btrfs rescue zero-log.  That's what I was 
referring to as the new integrated btrfs rescue zero-log.

Then there's a comma, and specifically stated btrfs check --repair 
(starting with btrfs, thus suggesting an entirely new command as that's 
what btrfs commands start with), a /separate/ command I ran.

I'm not sure where you got btrfs rescue zero log btrfs check, apparently 
interpreting that as a single command, despite the comma and repeated 
btrfs, and the hint in "nothing I tried", which suggests several things 
were tried...

So someone's obviously confused, but I'm not sure if it's you or me or 
both! =:^)

>> So I got to use the new btrfs-progs v4.0 metadata-restoration option in
>> btrfs restore,
> 
> In man btrfs-restore I only see a -m option, is that what you're
> referring to?

Yes.  That too is new in 4.0, the patch in fact being new enough I wasn't 
actually expecting to see it in a release until 4.1 or at least 4.0.1.

But it works well (except with dry-run, -D, which apparently is falling a 
bit behind as it still has the too many loops error from older code that 
no longer affects a normal write-out run, too). =:^)

Since I suggested restoring ownership/perms to the person who came up 
with the patch (his first one restored dates but not ownership/perms, as 
the date issue was his itch and he scratched it, so I suggested ownership/
perms too, my itch, which not being a coder I can't scratch directly), 
I'm happy as a kid at Christmas! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

