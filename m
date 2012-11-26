Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:3616 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124Ab2KZBjl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Nov 2012 20:39:41 -0500
Date: Mon, 26 Nov 2012 12:39:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ryan Wang <openspace.wang@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: How to run xfstests against btrfs on multipath disks on SuSE?
Message-ID: <20121126013931.GN32450@dastard>
References: <CAPxxNQ=SRZ33U8nLjK8a3+MPfy3Qz98ALcALXWK_x=dmW9+BoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPxxNQ=SRZ33U8nLjK8a3+MPfy3Qz98ALcALXWK_x=dmW9+BoA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 26, 2012 at 09:26:31AM +0800, Ryan Wang wrote:
> Hello,
> 
> I tried to kick off xfstests against btrfs on multipath device,
> e.g I set TEST_DEV="/dev/mapper/mpatha", which is a
> symlink to "/dev/dm-0". I mkfs.btrfs mpatha beforehand.
> 
> When I run "./check 001", it said:
> "
> common.rc: Error: $TEST_DEV (/dev/dm-0) is not a MOUNTED btrfs filesystem
> "
> 
> The I checked the script common.rc, and found that it uses
> df to determine the filesystem type and it uses the realpath
> "/dev/dm-0" instead of "/dev/mapper/mpatha", while df always
> shows "devtmpfs" instead of "btrfs" for /dev/dm-0.
> 
> I run "mount" and found that devtmpfs is mount on /dev/ ***by default***
> in SuSE.
> Even though  I run "mount -t btrfs /dev/dm-0 /somedir", df still showed
> devtmpfs.
> 
> Any ideas to kick off the xfstests?

seeing as you've now sent this to 3 lists that the xfstests
maintainers are likely not to read, I've added the proper list to
the cc list. i.e. xfs@oss.sgi.com.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
