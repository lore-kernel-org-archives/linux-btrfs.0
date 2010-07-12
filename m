From: Yee-Ting Li <yee379@gmail.com>
Subject: Re: volume broken? btrfsck fails
Date: Sun, 11 Jul 2010 21:05:05 -0700
Message-ID: <CD1C214E-4F4C-490E-B719-181933DF36E5@gmail.com>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com> <BC6F2F1C-B57E-4FCB-9B25-ACD9C35858C2@gmail.com> <20100712004315.GN3032@think>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100712004315.GN3032@think>
List-ID: <linux-btrfs.vger.kernel.org>


On 11 Jul 2010, at 17:43, Chris Mason wrote:
> Was this after a fresh mkfs?  Clearly things are very corrupt on this
> original drive.  It would be a good test case for Yan Zhengs new fsck
> code, but first I'd like to figure out if you're still seeing the old
> corruption of if you've started over.

nope, same disk as before when the btrfsck exited with:

btrfsck: disk-io.c:410: find_and_setup_root: Assertion `!(ret)' failed.

the strange thing was that i'm pretty sure that btrfs crashed the system a couple of times (hung). after reboot the mounted drive would basically churn away for hours and spit out lots of the parent transid messages. but after a while it stops and everything seems fine again.

i don't mind losing files on the disk array, but it would be nice if it could tell me the actual filenames which are corrupt.

Yee.