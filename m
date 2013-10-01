Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:24375 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751449Ab3JAWBx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 18:01:53 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Is `btrfsck --repair` supposed to actually repair problems?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131001211255.GA5946@pyropus.ca>
Date: Tue, 1 Oct 2013 16:01:48 -0600
Cc: btrfs list <linux-btrfs@vger.kernel.org>
Message-Id: <13617928-CDCE-439D-B887-ED42F0E43F12@colorremedies.com>
References: <20131001211255.GA5946@pyropus.ca>
To: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 1, 2013, at 3:12 PM, Charles Cazabon <charlesc-lists-btrfs@pyropus.ca> wrote:

> Greetings,
> 
> I've been using btrfs for bulk-storage purposes for a couple of years now (on
> vanilla linux-stable kernels on a few machines).  I recently set up a new
> filesystem and have been copying data to it, when I had an unrelated kernel
> lockup.  As expected, after rebooting btrfsck reported some checksum verify
> errors like:
> 
> checksum verify failed on 806795800576 found 01A8A8FB wanted 51361541
> checksum verify failed on 806795800576 found 01A8A8FB wanted 51361541
> checksum verify failed on 846990413824 found FB9C4BDC wanted AA2E389E
> 
> There's a few dozen of these.
> 
> Running btrfsck with the --repair option, however, does not appear to fix
> these problems.  I'll attach the complete output of running with the --repair
> option; running btrfsck in check-only mode afterwards reports largely the same
> checksum errors as it did originally, prior to "repair".
> 
> Shouldn't `btrfsck --repair` actually repair these errors?  Am I doing
> something wrong?

It looks like the file system thinks the file has changed and isn't matching checksum. That's not obviously fixable unless both data and metadata are raid1. More information is needed:

btrfs fi df <mountpoint>
btrfs show
dmesg | grep -i btrfs
dmesg | grep ata<port#>

I'm assuming it's a SATA drive, and if so you can get the port number with the last command and no port number, and figure out what port the drive is on. For me I get a line:
[    1.388091] ata1.00: ATA-8: WDC WD5000BEVT-22ZAT0, 01.01A01, max UDMA/133

So I'd use dmesg |grep ata1

Do that for all drives in the btrfs volume.

And report the version of btrfs-progs.


Chris Murphy