Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59698 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2GEOeS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 10:34:18 -0400
Date: Thu, 5 Jul 2012 07:34:17 -0700
From: Marc MERLIN <marc@merlins.org>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Long btrfs hangs during suspend to RAM / BTRFS warning (device dm-0): Aborting unused transaction
Message-ID: <20120705143417.GB21630@merlins.org>
References: <20120626193637.GA27856@merlins.org> <20120626193637.GA27856@merlins.org> <20120627013818.GA3556@merlins.org> <20120627052012.GA32533@merlins.org> <20120629123624.GS7472@merlins.org> <20120702195820.GA10655@merlins.org> <4FF3DB87.5090405@cn.fujitsu.com> <20120704151556.GD6807@merlins.org> <4FF595D8.6040509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF595D8.6040509@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 05, 2012 at 09:25:44PM +0800, Liu Bo wrote:
> On 07/04/2012 11:15 PM, Marc MERLIN wrote:
> I'd expect to get some info from the following one, but I fails.
> 
> Is it reproducible on your box?

It was reproducible when I reported it, but not anymore now. I couldn't stay
in a state where I was getting hangs and corruption.

I had problems with btrfs-delalloc- taking most of the CPU and deadlocking
the machine for minutes or even over half an hour. I'm pretty sure it was
related to the fact that I only had 10GB free on my partition (including
lots of snapshots).
Now that I'm back to >40GB free, I haven't had the problem come back.

How about these I reported:
[102231.845170] btrfs no csum found for inode 3910562 start 0
[102231.855415] btrfs_readpage_end_io_hook: 26 callbacks suppressed
[102231.855418] btrfs csum failed ino 3910562 off 0 csum 3145117582 private 0
[102231.999555] btrfs no csum found for inode 3910588 start 294912
[102232.009479] btrfs csum failed ino 3910588 off 294912 csum 697692408 private 0
[102232.142602] btrfs no csum found for inode 3910588 start 360448
[102232.142661] btrfs no csum found for inode 3910588 start 393216
[102232.968939] BTRFS warning (device dm-0): Aborting unused transaction.
[102234.107914] BTRFS warning (device dm-0): Aborting unused transaction.
[102235.218139] BTRFS warning (device dm-0): Aborting unused transaction.

I know I got corruption since I saw some of my files being damaged, but 
are they useful in any way, or not so much?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
