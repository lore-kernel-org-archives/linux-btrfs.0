From: Chris Mason <chris.mason@oracle.com>
Subject: Re: volume broken? btrfsck fails
Date: Sun, 11 Jul 2010 20:43:15 -0400
Message-ID: <20100712004315.GN3032@think>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com>
 <BC6F2F1C-B57E-4FCB-9B25-ACD9C35858C2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Yee-Ting Li <yee379@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BC6F2F1C-B57E-4FCB-9B25-ACD9C35858C2@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 11, 2010 at 01:19:34AM -0700, Yee-Ting Li wrote:
> so after leaving the array for a while, with the disk churning away for a few days, it stopped. i copied some files off the disk (everything seems okay) and decided to unmount and run btrfsck again - this time i get a different error:
> 
> $ sudo /usr/local/bin/btrfsck /dev/sdf
[ ... ick ... ]

> failed to find block number 364457984
> Aborted

Was this after a fresh mkfs?  Clearly things are very corrupt on this
original drive.  It would be a good test case for Yan Zhengs new fsck
code, but first I'd like to figure out if you're still seeing the old
corruption of if you've started over.

-chris

