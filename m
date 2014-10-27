Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45667 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752443AbaJ0QvQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 12:51:16 -0400
Subject: Re: BTRFS balance segfault, where to go from here
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <trinity-814e9704-84ce-4a27-a187-439cc5a13f06-1414401999856@3capp-mailcom-bs01>
Date: Mon, 27 Oct 2014 10:51:16 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <5DD6D691-A067-4937-A5B4-545A0DFB9B1E@colorremedies.com>
References: <trinity-814e9704-84ce-4a27-a187-439cc5a13f06-1414401999856@3capp-mailcom-bs01>
To: Stephan Alz <stephan008@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 27, 2014, at 3:26 AM, Stephan Alz <stephan008@gmx.com> wrote:
> 
> My question is where to go from here? What I going to do right now is to copy the most important data to another separated XFS drive.
> What I planning to do is:
> 
> 1, Upgrade the kernel
> 2, Upgrade BTRFS
> 3, Continue the balancing.

Definitely upgrade the kernel and see how that goes, there's been many many changes since 3.13. I would upgrade the user space tools also but that's not as important.

FYI you can mount with skip_balance mount option to inhibit resuming balance, sometimes pausing the balance isn't fast enough when there are balance problems.

> 
> 
> Could someone please also explain that how is exactly the raid10 setup works with ODD number of drives with btrfs? 
> Raid10 should be a stripe of mirrors. Now then this sdf drive is mirrored or striped or what?

I have no idea honestly. Btrfs is very tolerant of adding odd number and sizes of devices, but things get a bit nutty in actual operation sometimes. This might be one of them because traditionally raid10 is always even number of drives, odd numbers just don't make sense. But Btrfs allows the addition; I think the expectation is you'd have added two before doing the balance though.

> Some btrfs gurus could tell me that should I be worried of dataloss because of this or not?

Anything is possible so hopefully you have backups. My expectation is worse case scenario the fs gets confused and you can't mount rw anymore in which case you won't be able to make it an even drive raid10. But in the case even as ro you can update your backups, blow away the Btrfs volume and start from scratch with an even number of drives, right?

> Would I need even more free space just to add a 5th drive? If so how much more?

Gonna guess you'd need to add a drive that's at least 2.83TiB in size if you want to keep it raid10.

Chris Murphy