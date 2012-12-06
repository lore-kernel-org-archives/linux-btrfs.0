Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:44311
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347Ab2LFUfR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Dec 2012 15:35:17 -0500
From: Thorn Roby <Thorn.Roby@harlandfs.com>
To: "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Mounted compress-force=zlib, compresses when files copied in,
 but not when written directly by application
Date: Thu, 6 Dec 2012 20:34:39 +0000
Message-ID: <6726B0D4C83B3047A636A714BAB0B92306CC00@DSM-SRV-MBX2.harlandfs.com>
References: <loom.20121204T201625-335@post.gmane.org>
 <20121205020131.GA5204@liubo>
 <6726B0D4C83B3047A636A714BAB0B92306C5A4@DSM-SRV-MBX2.harlandfs.com>
 <20121206065914.GA5294@liubo.jp.oracle.com>
In-Reply-To: <20121206065914.GA5294@liubo.jp.oracle.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It appears to be an issue with the initial sparse file allocation. When I manually create 2GB datafiles using dd from /dev/zero, instead of allowing MongoDB to allocate them as needed, compression seems to be working correctly.

-----Original Message-----
From: Liu Bo [mailto:bo.li.liu@oracle.com] 
Sent: Wednesday, December 05, 2012 11:59 PM
To: Thorn Roby
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Mounted compress-force=zlib, compresses when files copied in, but not when written directly by application

On Wed, Dec 05, 2012 at 05:42:51PM +0000, Thorn Roby wrote:
> My previous reply was incorrect in one point - the data is never copied from the transaction log into the sparse datafiles, instead the application writes the same data independently to both locations.
> Also, I failed to mention that the files are memmapped, and it's possible that the write operations attempt to use DIRECT_IO, which I believe is disabled by btrfs with compression - is it possible that an attempt to use DIRECT_IO or memmapped files would prevent compression?
> 

Actually, writting with DIRECT_IO will fall back to buffer write for safety, and mmap files just dirty pages, should be same with buffer write, so it might be other reasons.

thanks,
liubo


