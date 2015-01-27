Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58258 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbbA0GVA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Jan 2015 01:21:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YFzWC-0001MY-E7
	for linux-btrfs@vger.kernel.org; Tue, 27 Jan 2015 07:20:56 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2015 07:20:56 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2015 07:20:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs convert running out of space
Date: Tue, 27 Jan 2015 06:20:45 +0000 (UTC)
Message-ID: <pan$699f3$69a09ae3$223042ab$ffc7f7d1@cox.net>
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
	<pan$40d11$63f07406$84874b72$fbf45436@cox.net>
	<20150125162344.299c3661@marcec.fritz.box>
	<CA+WRLO_hvAVRXxzrD-1QguZiRJk7tpnnWuZJ-en=X0mBO5GzBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye posted on Tue, 27 Jan 2015 14:24:03 +1100 as excerpted:

> Have gone with the move stuff off then finish convert plan. Convert has
> now finished and I'm 60% of the way through moving all the big files
> back on.
> 
> Thanks for the help guys.

Glad the big-file-move-off seems to have worked for you, and thanks for 
confirming that moving them off did indeed solve your conversion 
blockers.  Evidently btrfs still has a few rough spots to iron out when 
it comes to those big files. =:^(

Please confirm when all big files are moved back on, too, just to be sure 
there's nothing unexpected on that side, but based on the conversion-from-
ext* reports, I expect it to be smooth sailing.  Btrfs really does have a 
problem with large files existing in large enough extents that it can't 
really handle them properly, and once they are off the filesystem 
temporarily, generally even moved off and back on, it does seem to break 
up the log jam (well, in this case huge-extent-jam =:^) and you're back 
in business! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

