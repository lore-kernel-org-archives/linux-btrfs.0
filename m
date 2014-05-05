Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53332 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756885AbaEEVtW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 May 2014 17:49:22 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Unable to boot
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1399302707150.24606@sphs.ro>
Date: Mon, 5 May 2014 15:49:20 -0600
Cc: Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <40C60877-4F96-42D9-8818-DDAE21B64F9E@colorremedies.com>
References: <1399024804436.53859@sphs.ro> <B2BE5A00-6E38-4B2D-9A80-AB1F49F1830B@colorremedies.com> <1399302243852.20163@sphs.ro>,<20140505150720.GQ24298@carfax.org.uk> <1399302707150.24606@sphs.ro>
To: George Pochiscan <george.pochiscan@sphs.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 5, 2014, at 9:11 AM, George Pochiscan <george.pochiscan@sphs.ro> wrote:

> Hello Hugo,
> 
> Running btrfs-zero-log /dev/md127 i have the following error:
> 
> checksum verify failed on 1001492480 found 74CC3F5D wanted C222A2C9
> Csum didn't match
> btrfs-zero-log: extent-tree.c:2717: alloc_reserved_tree_block: Assertion `!(ret)' failed.
> Aborted (core dumped)
> 
> Full output : http://pastebin.com/3h5zVuWg
> Full dmesg : http://pastebin.com/r9Fk8J8F

OK. Well I'm out of ideas at this point. I'm not a developer, and don't know what the problem is or how to fix it. So my advice at this point will be like throwing spaghetti  at a wall. (There is a lot of spaghetti available to throw at the wall when it comes to fixing btrfs if the normal mount code doesn't fix it automatically.)

Baring better advice from pretty much anyone else:

- First, btrfs-image -c9 -t4 /dev/md127 /path/for/large/file

The resulting file will be somewhere between 50% to 100% of the size reported for metadata by btrfs filesystem df. put this somewhere in case a developer wants to look at it in the current state.

- Then, btrfs check --init-csum-tree /dev/md127 will remove all checksums from the file system and should remove the csum errors preventing mount. The problem with this is it removes all checksums, so every read is reported as a mismatch but still permits the reads to proceed. As a result it's just a way to mount the file system, make a backup, and then created a new file system to restore to. So it's a recovery operation rather than a repair operation.

Chris Murphy