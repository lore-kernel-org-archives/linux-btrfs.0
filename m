Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn1bn0101.outbound.protection.outlook.com ([157.56.110.101]:21632
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751874AbbCXW54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 18:57:56 -0400
From: "Kline, Matthew" <matthew.kline@flukenetworks.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance fails with no space errors (despite having plenty)
Date: Tue, 24 Mar 2015 22:25:30 +0000
Message-ID: <E8C63C11EA3FB04DBDFEDECEFD927FD1140C1E31@US-EVT-EXM04-P.global.tektronix.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry to necrobump this, but the issue came up again.
I'm now on Linux 3.19.2 with btrfs-progs 3.19, and I converted my work laptop
from ext4 to btrfs. Same issue - the conversion goes well,
removing the ext* subvolume is fine, defragging is works,
and then when I balance, it claims there is no space left on the device
when the drive is 35% full. Dmesg is useless once again,
giving only "1 enospc errors during balance".

The last time this was an issue (the original post in this thread),
I ended up just copying everything to an external drive,
reformatting the btrfs partition, and copying things back.

This time I did what was suggested below (moving all +1GB files off-drive
to tmpfs and then back on) in case defrag missed something, and balance
still fails. I was sure to rename the files and sync as suggested.

Is there a known bug still lurking in ext4 conversion?

Duncan <1i5t5.duncan <at> cox.net> writes:

> Either way, assuming it's the super-extent problem which I
> think it is, other than trying a defrag again, one way to
> for sure solve that problem is to make a list of all your
> over 1 GiB files, and move them out of the filesystem and
> then back in, so they get recreated in native btrfs format.
> 
> If moving all > 1 GiB files off of the filesystem and
> then back on, thus recreating them in native btrfs format,
> doesn't help, then either you missed one and it's still
> triggering the issue, or there's something else going
> on.
> 


