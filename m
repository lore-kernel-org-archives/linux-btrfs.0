Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43830 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbbAWEe1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 23:34:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YEVwv-0000e6-9i
	for linux-btrfs@vger.kernel.org; Fri, 23 Jan 2015 05:34:25 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2015 05:34:25 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2015 05:34:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs convert running out of space
Date: Fri, 23 Jan 2015 04:34:19 +0000 (UTC)
Message-ID: <pan$92dfe$2be12b41$73cefff0$d3e7dbcf@cox.net>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye posted on Fri, 23 Jan 2015 08:58:08 +1100 as excerpted:

> What are the chances that splitting all the large files up into sub gig
> pieces, finish convert, then recombine them all will work?

[Further context removed due to the hassle of trying to sort the
top-posting into proper order to reply in /proper/ context.]

A likely easier alternative would be to temporarily move those files off 
the filesystem in question.

Option 1: Do that (thumb drives work well for this if you're not talking 
/terabytes/ and don't have a spare hard drive handy), finish the convert, 
and move them back.

Option 2: Since new files should be created using the desired target mode 
(raid1 IIRC), you may actually be able to move them off and immediately 
back on, so they appear as new files and thus get created in the desired 
mode.  Of course the success here depends on how many you have to move 
vs. the amount of free space available that will be used when you do so, 
but with enough space, it should "just work".

Note that with this method, if the files are small enough to entirely fit 
one-at-a-time or a-few-at-a-time in memory (I have 16 gig RAM, for 
instance, and don't tend to use more than a gig or two for apps, so could 
in theory do 12-14 gig at a time for this), you can even use a tmpfs as 
the temporary storage before moving them back to the target filesystem.  
That should be pretty fast since the one side is all memory.

This is actually the solution recommended when a btrfs from ext* 
conversion didn't have the recommended defrag and balance done afterward, 
or when even after a defrag, the balance fails due to overly large ext* 
extents, compared to the normally 1-gig extents that btrfs usually works 
with.  Move all the gig-plus files off the filesystem, thus eliminating 
the old overly large extents, and back, so the files get created with 
native btrfs sized extents.  The solution is known to work for that, so 
assuming a similar issue here, it should work here as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

