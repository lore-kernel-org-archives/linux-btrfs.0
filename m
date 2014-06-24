Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57188 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751026AbaFXFTi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 01:19:38 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAB=7dhms_ehP4y+L_tMBrdUnJiwXAOn7E4Fa9u3euVBwBKHOKA@mail.gmail.com>
Date: Mon, 23 Jun 2014 23:19:37 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <27F042E8-CC94-497D-96B7-283AA1CBD296@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com> <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com> <144BDE55-B4B9-405A-B106-F7681FBAF761@colorremedies.com> <CAB=7dhms_ehP4y+L_tMBrdUnJiwXAOn7E4Fa9u3euVBwBKHOKA@mail.gmail.com>
To: Mike Hartman <mike@hartmanipulation.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 23, 2014, at 10:34 PM, Mike Hartman <mike@hartmanipulation.com> wrote:

>> 
>> Firmware 0007 is current for this SSD.
> 
> I assume that's probably not something I should mess with right now
> though, right?

I would deal with that later. A firmware change now might make things worse if you care about this file system or any data on the drive. But seeing as it "improves reliability" I have no way of knowing if it's related.

> Actually, now that I think about it, that may be related to the errors
> I saw months ago. I had some bad blocks or something, and when the
> system attempted to access them I would get a bunch of errors in the
> logs. I believe one of the things the system would do was attempt to
> reset the drive connection (maybe multiple times).

Yes Ok that's normal.

> I zeroed out the drive and ran every smartctl test on it I could find
> and it never threw any more errors.

Zeroing SSDs isn't a good way to do it. Use ATA Secure Erase instead. The drive is overprovisioned, so there are pages without LBAs assigned, which means they can't be written to by software. Plus "zeros" make SSD pages full of zeros, rather than being empty and ready to be written to. ATA Secure Erase is supposed to make them empty (write ready) and does it for all pages.

http://mackonsti.wordpress.com/2011/11/22/ssd-secure-erase-ata-command/

> I'll see if I can track down any of the smartctl results from back
> then and compare the "Number of Hardware Resets" value, as well as
> UDMA_CRC_Error_Count.

It could be a loose or intermittent connection; maybe they are one off events as the laptop was in motion. Hard to say.




Chris Murphy

