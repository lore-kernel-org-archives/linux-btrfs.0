Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57867 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3CCXwq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 18:52:46 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id F0C477C0402
	for <linux-btrfs@vger.kernel.org>; Sun,  3 Mar 2013 16:52:45 -0700 (MST)
Date: Sun, 3 Mar 2013 18:52:43 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Michael Schmitt <tcwardrobe@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: weird kernel-oopses while deleting files on btrfs
Message-ID: <20130303235243.GA26002@shiny.masoncoding.com>
References: <513356D5.5030301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <513356D5.5030301@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 03, 2013 at 06:57:41AM -0700, Michael Schmitt wrote:
> Hi list,
> 
> some rather unexpected btrfs-oopses for my taste. I use btrfs for some
> time now (mostly on external harddisks) and these "oopses" happened
> during some simple file and folder deletion operation on that device. It
> is a luks-encrypted 80GB drive. Anything like that known? And the fs was
> created just yesterday, how come there is a message like...
> 
> [91491.919358] btrfs: mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.

This may be from first mount after mkfs.  It depends on your tools.

> 
> ... but the kernel used (3.7.3 from Debian experimental on Debian sid)
> was installed several days ago. What kind of oopses are these? As of now
> there is no real data on that device. But if there were, would I need to
> be concerned about the integrity of those files?
>
> [93283.762006] WARNING: at /build/buildd-linux_3.7.3-1~experimental.1-i386-eX5kUQ/linux-3.7.3/fs/btrfs/extent-tree.c:6297 btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]()

These are not oopsen but warnings.  It's an ENOSPC warning as we try to
delete the extents.  It did happen sometimes in this kernel, but it is
only a warning.

-chris
