Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52413 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbbAWIqf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 03:46:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YEZss-0006Pe-Jo
	for linux-btrfs@vger.kernel.org; Fri, 23 Jan 2015 09:46:30 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2015 09:46:30 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2015 09:46:30 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs convert running out of space
Date: Fri, 23 Jan 2015 08:46:23 +0000 (UTC)
Message-ID: <pan$40d11$63f07406$84874b72$fbf45436@cox.net>
References: <CA+WRLO9nCFgjHzY1F_xR5PpmgaSEemfmZ=MtiSpiaHcROQnq-A@mail.gmail.com>
	<CA+WRLO8gGUxxHhqQfgQWXyU0kT2=nf7u5oPFYJTWY=hSMNBj=w@mail.gmail.com>
	<CAJCQCtRe+0n84PUZuWKw0UUwK_RF_AhW4sMZ+07r96qaNvRWKg@mail.gmail.com>
	<CA+WRLO-VnULLGOE1VkrOortCdQNCKPCwJ70FDJL3KQwru8TLhQ@mail.gmail.com>
	<CAJCQCtQQnovS94fo-hRQa_O6Q7EM9KOCPFxC3FTkTC4=CT93sA@mail.gmail.com>
	<CA+WRLO89nFArYhRgjqPBruW0avExOZcf9iZgvusLAr_+4ddxoQ@mail.gmail.com>
	<CAJCQCtTiboWRVkZLE2Te9Kb00SXxUk0_AwE5xv-vTHxrpaDCqA@mail.gmail.com>
	<CA+WRLO-oUUQhfJ_LnwaQmr_-sJK_oTCE89R11N3kM-vj-Gv6Wg@mail.gmail.com>
	<CAJCQCtRZy3Pi5CF4a9CfQSzmFm9poumJhBZaSRixRrpqsBPk_g@mail.gmail.com>
	<CA+WRLO_Yu6nqkhVP6YyxwvrzK8LCtSUMB7XL_ki0+LJiZHkS8w@mail.gmail.com>
	<pan$92dfe$2be12b41$73cefff0$d3e7dbcf@cox.net>
	<20150123085441.79265c9a@marcec.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Fri, 23 Jan 2015 08:54:41 +0100 as excerpted:

> Am Fri, 23 Jan 2015 04:34:19 +0000 (UTC)
> schrieb Duncan <1i5t5.duncan@cox.net>:
> 
>> Gareth Pye posted on Fri, 23 Jan 2015 08:58:08 +1100 as excerpted:
>> 
>> > What are the chances that splitting all the large files up into sub
>> > gig pieces, finish convert, then recombine them all will work?
>> 
> [...]
>> Option 2: Since new files should be created using the desired target
>> mode (raid1 IIRC), you may actually be able to move them off and
>> immediately back on, so they appear as new files and thus get created
>> in the desired mode.
> 
> With current coreutils, wouldn't that also work if he moves the files to
> another (temporary) subvolume? (And with future coreutils, by copying
> the files without using reflinks and then removing the originals.)

If done correctly, yes.

However, "off the filesystem" is far simpler to explain over email or the 
like, and is much less ambiguous in terms of "OK, but did you do it 
'correctly'" if it doesn't end up helping.  If it doesn't work, it 
doesn't work.  If "move to a different subvolume under specific 
conditions in terms of reflinking and the like" doesn't work, there's 
always the question of whether it /really/ didn't work, or if somehow the 
instructions weren't clear enough and thus failure was simply the result 
of a failure to fully meet the technical requirements.

Of course if I was doing it myself, and if I was absolutely sure of the 
technical details in terms of what command I had to use to be /sure/ it 
didn't simply reflink and thus defeat the whole exercise, I'd likely use 
the shortcut.  But in reality, if it didn't work I'd be second-guessing 
myself and would probably move everything entirely off and back on to be 
sure, and knowing that, I'd probably do it the /sure/ way in the first 
place, avoiding the chance of having to redo it to prove to myself that 
I'd done it correctly.

Of course, having demonstrated to myself that it worked, if I ever had 
the problem again, I might try the shortcut, just to demonstrate to my 
own satisfaction the full theory that the effect of the shortcut was the 
same as the effect of doing it the longer and more fool-proof way.  But 
of course I'd rather not have the opportunity to try that second-half 
proof. =:^)

Make sense? =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

