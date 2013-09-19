Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:4458 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab3ISSTh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Sep 2013 14:19:37 -0400
Message-ID: <523B4036.7030204@linux.intel.com>
Date: Thu, 19 Sep 2013 11:19:34 -0700
From: Saul Wold <sgw@linux.intel.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Issue building a file based rootfs image with mkfs.btrfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi there,

I am attempting to build a rootfs image from an existing rootfs 
directory tree.  I am using the 0.20 @ 194aa4a of Chris's git repo.

The couple problem I saw was that the target image file needed to exist, 
although I think I can patch that then the FS size was much larger than 
the actual size, I tracked this to the usage of ftw not accounting for 
symlinks, I have a patch for that which I will send once I finish 
getting the other issues resolved.

Next issue I hit was an assertion failure after getting "not enough free 
space" message:

not enough free space
add_file_items failed
unable to traverse_directory
Making image is aborted.
mkfs.btrfs: mkfs.c:1542: main: Assertion `!(ret)' failed.

I am kind of stuck on this one, took it as far as I can right now. 
Would I be better off dropping back to 0.19 or can we move forward 
fixing this?

Thanks

-- 
     Sau!

Saul Wold
Yocto Component Wrangler @ Intel
Yocto Project / Poky Build System

