Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:5292 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754733Ab3I1UvX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 16:51:23 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:49308 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VQ1U0-001Sdc-4a
	for linux-btrfs@vger.kernel.org; Sat, 28 Sep 2013 14:51:20 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Corrupt btrfs filesystem recovery... (Due to *sata* errors)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <l27agq$u5a$1@ger.gmane.org>
Date: Sat, 28 Sep 2013 14:51:17 -0600
Message-Id: <87F045E8-CBB5-4818-B60B-0325EC87A56D@colorremedies.com>
References: <l27agq$u5a$1@ger.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 28, 2013, at 1:26 PM, Martin <m_btrfs@ml1.co.uk> wrote:

> Writing data via rsync at the 6Gbit/s sata rate caused
> IO errors for just THREE sectors...
> 
> Yet btrfsck bombs out with LOTs of errors…

Any fs will bomb out on write errors.

> How best to recover from this?

Why you're getting I/O errors at SATA 6Gbps link speed needs to be understood. Is it a bad cable? Bad SATA port? Drive or controller firmware bug? Or libata driver bug?

> Lots of sata error noise omitted.

And entire dmesg might still be useful. I don't know if the list will handle the whole dmesg in one email, but it's worth a shot (reply to an email in the thread, don't change the subject).

It's possible software or hardware problems are detected well before writes are even initiated.

> Running "badblocks" twice in succession (non-destructive data test!)
> shows no surface errors and no further errors on the sata interface.

SATA link speed related errors aren't related to bad blocks. If you do a smartctl -x on the drive, chances are it's recording PHY Event errors that might be relevant, and also SMART might record UDMA/CMC errors that would just corroborate that the drive also found link errors.


> 
> Running btrfsck twice gives the same result, giving a failure with:

Well honestly at this point I expect file system corruption as it's entirely possible that before the hardware dropped the link speed down to SATA 3Gbps, there was corrupt data already sent to the drive and that's not something Btrfs can know about until trying to read the data back in. So *shrug* - I don't see Btrfs as a way to totally mitigate hardware problems. It's the same problem with bad RAM, and Btrfs doesn't like that either.


Chris Murphy

