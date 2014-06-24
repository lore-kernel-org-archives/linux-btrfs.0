Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56708 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750712AbaFXEQC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 00:16:02 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com>
Date: Mon, 23 Jun 2014 22:15:59 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <144BDE55-B4B9-405A-B106-F7681FBAF761@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com> <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com>
To: Mike Hartman <mike@hartmanipulation.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 23, 2014, at 8:58 PM, Mike Hartman <mike@hartmanipulation.com> wrote:

> I have a dd image, but not a btrfs-image. I ran the btrfs-image
> command, but it threw the same errors as everything else and generated
> a 0 byte file.
> 
> I agree that it SOUNDS like some kind of media failure, but if so it
> seems odd to me that I was able to dd the entire partition with no
> read errors. Even if there was something wrong with the drive that
> prevented writing you'd think the ability to read it all would result
> in a recoverable image.

I've read of too many SSD failure cases to trust a graceful failure of an SSD. I guess I don't really trust an HDD either but at least they don't self destruct upon reaching end of life as apparently some SSDs do:
http://techreport.com/review/26523/the-ssd-endurance-experiment-casualties-on-the-way-to-a-petabyte

Anyway, it could be ECC failure where it says pass but it's actually corrupt, in which case it's silent data corruption which neither triggers ECC errors or read failures. You just get bad data. And really bad luck if this happens with Btrfs metadata that isn't DUP but is fundamental for mounting and/or repairing the system so it can be mounted.

Of course it could just be a bug so it's worth trying David's integration branch.


	• Firmware Version: 0006

Firmware 0007 is current for this SSD.


	• 173 Wear_Leveling_Count     PO--CK   086   086   000    -    728
	•   1  0x018  6      49304625928  Logical Sectors Written
	• 202 Perc_Rated_Life_Used    ---RC-   086   086   000    -    14

Those are all reasonable.

	• 181 Non4k_Aligned_Access    -O---K   100   100   000    -    36 0 35

Probably unrelated, but that's a curious attribute and value.

	• 199 UDMA_CRC_Error_Count    -OS-CK   100   100   000    -    15

That's not good in that it means interface problems have happened at some point. But they can happen and just not get caught, which results in corruption. Drive ECC will not correct these problems. So how many good writes on the way to the drive but were corrupted by the time they got there? Obviously there's no way to know this from available information.

 6  0x008  4             9821  Number of Hardware Resets

Why is the hardware being reset so many times?


Chris Murphy

