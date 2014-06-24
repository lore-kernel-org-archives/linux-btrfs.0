Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48510 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaFXKAd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 06:00:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WzNWd-0000n8-Jr
	for linux-btrfs@vger.kernel.org; Tue, 24 Jun 2014 12:00:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 12:00:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 12:00:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
Date: Tue, 24 Jun 2014 10:00:14 +0000 (UTC)
Message-ID: <pan$240f5$66208982$352d3c2d$120cf64f@cox.net>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com>
	<ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com>
	<CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com>
	<144BDE55-B4B9-405A-B106-F7681FBAF761@colorremedies.com>
	<CAB=7dhms_ehP4y+L_tMBrdUnJiwXAOn7E4Fa9u3euVBwBKHOKA@mail.gmail.com>
	<27F042E8-CC94-497D-96B7-283AA1CBD296@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 23 Jun 2014 23:19:37 -0600 as excerpted:

>> I zeroed out the drive and ran every smartctl test on it I could find
>> and it never threw any more errors.
> 
> Zeroing SSDs isn't a good way to do it. Use ATA Secure Erase instead.
> The drive is overprovisioned, so there are pages without LBAs assigned,
> which means they can't be written to by software. Plus "zeros" make SSD
> pages full of zeros, rather than being empty and ready to be written to.
> ATA Secure Erase is supposed to make them empty (write ready) and does
> it for all pages.
> 
> http://mackonsti.wordpress.com/2011/11/22/ssd-secure-erase-ata-command/

Tho in this case, the bad section was obviously assigned as it was 
triggering errors, and writing zeros to the entire thing might just have 
triggered the drive to cycle the bad area out of use, replacing it from 
the reserves.

So while zeroing an SSD is a bad idea in general, it still might be 
worthwhile to try in a case like this, particularly if after a a secure-
erase command the media is still giving errors.

IOW, YMMV. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

