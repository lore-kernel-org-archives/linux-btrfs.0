Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33628 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3I1M3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 08:29:55 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 04AF77C0444
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Sep 2013 06:29:55 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Saul Wold <sgw@linux.intel.com>, <linux-btrfs@vger.kernel.org>
References: <523B4036.7030204@linux.intel.com>
In-Reply-To: <523B4036.7030204@linux.intel.com>
Message-ID: <20130928122952.31924.54312@localhost.localdomain>
Subject: Re: Issue building a file based rootfs image with mkfs.btrfs
Date: Sat, 28 Sep 2013 08:29:52 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Saul Wold (2013-09-19 14:19:34)
> Hi there,
> 
> I am attempting to build a rootfs image from an existing rootfs 
> directory tree.  I am using the 0.20 @ 194aa4a of Chris's git repo.
> 
> The couple problem I saw was that the target image file needed to exist, 
> although I think I can patch that then the FS size was much larger than 
> the actual size, I tracked this to the usage of ftw not accounting for 
> symlinks, I have a patch for that which I will send once I finish 
> getting the other issues resolved.
> 
> Next issue I hit was an assertion failure after getting "not enough free 
> space" message:
> 
> not enough free space
> add_file_items failed
> unable to traverse_directory
> Making image is aborted.
> mkfs.btrfs: mkfs.c:1542: main: Assertion `!(ret)' failed.
> 
> I am kind of stuck on this one, took it as far as I can right now. 
> Would I be better off dropping back to 0.19 or can we move forward 
> fixing this?

Hi Saul,

Update on my end, the problem is the image code expects every file to
fit inside a single chunk.  It's only creating 8MB chunks, so any file
over 8MB in size is causing problems.

I'm fixing it up here, I should have a patch for you on Monday.

Thanks!

-chris

