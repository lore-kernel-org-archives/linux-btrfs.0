From: Thomas Kupper <thomas@kupper.org>
Subject: Re: RAID-10 arrays built with btrfs & md report 2x difference in 	available size?
Date: Fri, 29 Jan 2010 22:57:33 +0100
Message-ID: <048D5581-1D1D-4F82-9FE3-0DBC1106EDB4@kupper.org>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: 0.bugs.only.0@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


> noticing from above
> 
> >>  ... size 931.51GB used 2.03GB ...
> 
> 'used' more than the 'size'?
> 
> more confused ...

For me, it looks as if 2.03GB is way smaller than 931.51GB (2 << 931), no? Everything seems to be fine here.

And regarding your original mail: it seems that df is still lying about the size of the btrfs fs, check http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg00758.html