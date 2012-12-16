Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50295 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2LPLcd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Dec 2012 06:32:33 -0500
From: Russell Coker <russell+btrfs@coker.com.au>
Reply-To: russell+btrfs@coker.com.au
To: cwillu <cwillu@cwillu.com>
Subject: Re: Intel 120G SSD write performance with 3.2.0-4-amd64
Date: Sun, 16 Dec 2012 22:32:24 +1100
Cc: linux-btrfs@vger.kernel.org
References: <201212161023.59380.russell+btrfs@coker.com.au> <CAE5mzvjVT2Wp5FOiAFeULWU6uWka3kcJaV4mLmjZ1YLzx4M7Pw@mail.gmail.com>
In-Reply-To: <CAE5mzvjVT2Wp5FOiAFeULWU6uWka3kcJaV4mLmjZ1YLzx4M7Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212162232.24547.russell+btrfs@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 16 Dec 2012, cwillu <cwillu@cwillu.com> wrote:
> 3.2 is massively old in btrfs terms, with lots of fun little stability
> and performance bugs.
> 
> > Here is the /proc/mounts entry which shows that ssd and discard options
> > are enabled.
> > 
> > /dev/disk/by-uuid/7939c405-c656-4e85-a6a0-29f17be09585 / btrfs
> > rw,seclabel,nodev,noatime,ssd,discard,space_cache 0 0
> 
> Don't use discard; it's a non-queuing command, which means your
> performance will suck unless your device is really terrible at
> garbage collection (in which case, it's just the lesser of two evils).

Thanks for the advice.  On one of my systems a reinstall of the linux-
image-3.6-trunk-amd64 package went from almost 4 minutes to only 29 seconds 
when I removed the discard option.  When I then booted the 3.6.9 kernel in 
question the package install time dropped to 27 seconds (of which more than 
half was CPU time).  I only did one test run of each, so 27s vs 29s could be 
within the range of random variation but 4 minutes vs <30s is an obvious and 
massive improvement.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
