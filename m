Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60702 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbaAMITG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 03:19:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W2cjh-0004dU-5s
	for linux-btrfs@vger.kernel.org; Mon, 13 Jan 2014 09:19:05 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 09:19:05 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jan 2014 09:19:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID 1 with no data on it when accidentally switched HDD
Date: Mon, 13 Jan 2014 08:18:42 +0000 (UTC)
Message-ID: <pan$137$6980616b$bce212bf$29519e1a@cox.net>
References: <b93a253364541dd18356eaefb64d3168@www.jitmail.de>
	<EF449A1E-2C53-43BB-883E-98EE848E60CB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 12 Jan 2014 14:50:03 -0700 as excerpted:

> This change in block device designation is why using /dev/X in fstab is
> not a good idea, it's an ambiguous entry. I don't know what file system
> was actually mounted by fstab, and to what volume sdc was added. I
> suggest changing fstab to use fs UUID from blkid.

FWIW, I use labels here.  They work as well (as long as you don't 
duplicate them) and are much more human-friendly than UUIDs.  I have a 
particular labeling scheme that guarantees they're unique within my 
setup, and are extremely likely to be unique with the set of any other 
hardware I'd use, as well.

I use GPT partitioning (instead of MBR) for better fault tolerance and 
flexibility here, too, and it has partition names/labels which can be 
used in fstab, too.  I use the same label and partlabel scheme, with the 
filesystem label generally reflecting the partlabel(s) it's created on, 
however, so it doesn't really matter which I use, except that PARTLABEL= 
is longer in fstab, so I use the shorter LABEL=, instead.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

