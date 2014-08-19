Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47945 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaHSEHV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 00:07:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XJahc-0001H0-LA
	for linux-btrfs@vger.kernel.org; Tue, 19 Aug 2014 06:07:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 06:07:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Aug 2014 06:07:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Putting very big and small files in one subvolume?
Date: Tue, 19 Aug 2014 04:07:06 +0000 (UTC)
Message-ID: <pan$644f0$9bc28c9e$b8087cfe$5c092f90@cox.net>
References: <CAH-HCWVDtPv9gYxpcA4drK=FDes_0z8QTxqOBcocWf9T_b4tyQ@mail.gmail.com>
	<pan$df1ba$a20420a2$2ac33113$90ec0a1@cox.net> <lstftk$tmt$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Mon, 18 Aug 2014 19:16:20 +0100 as excerpted:

> Also, for the file segment being defragged, abandon any links to other
> snapshots to in effect deliberately replicate the data where appropriate
> so that data segment is fully defragged.

FWIW, this is the current state.

The initial attempt at snapshot-aware-defrag was committed to mainline 
(the kernel release is listed in the wiki's changelog page) but people 
quickly ran into scaling issues with multi-thousand-snapshot systems as 
well as quotas that weren't originally expected or, I guess, tested, pre-
mainline-merge, so they ended up reverting the snapshot awareness 
temporarily, until they could come up with something more scalable.  I 
believe they've addressed some of that now, but I'm not sure it's yet 
scaling the way the original trial suggested it needed to, and snapshot-
aware-defrag remains disabled for the time being.

So at least currently, defragging isn't snapshot aware, and as a result, 
if the filesystem is highly fragmented, attempting to defrag will 
increase space usage substantially as all those snapshot links are broken 
in ordered to defrag the file on the currently mounted and being defragged 
snapshot.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

