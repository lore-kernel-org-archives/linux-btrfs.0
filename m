Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40203 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbaDIQvf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 12:51:35 -0400
Date: Wed, 9 Apr 2014 09:51:34 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Upgrade to 3.14.0 messed up raid0 array (btrfs cleaner crashes in fs/btrfs/extent-tree.c:5748 and fs/btrfs/free-space-cache.c:1183 )
Message-ID: <20140409165134.GO10789@merlins.org>
References: <20140408153609.GE23524@merlins.org> <20140408220903.GV9923@merlins.org> <53448AFA.4080601@fb.com> <20140409043125.GI10789@merlins.org> <20140409053139.GJ10789@merlins.org> <20140409154259.GM10789@merlins.org> <53456B45.8050906@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53456B45.8050906@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 09, 2014 at 11:46:13AM -0400, Chris Mason wrote:
> Downloading the image now.  I'd just run a readonly btrfsck /dev/xxx

http://marc.merlins.org/tmp/btrfs-raid0-image-fsck.txt (6MB)

I admit to not knowing how to read that output, I've only ever seen
thousands of lines of output from it on any filesystem., but hopefully you
know how to grep out expected noise.

But since we're talking about this, is btrfsck ever supposed to return clean
on a clean filesystem?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
