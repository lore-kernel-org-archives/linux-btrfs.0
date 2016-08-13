Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:57881 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbcHNJOz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Aug 2016 05:14:55 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bYi04-00063e-GN
	for linux-btrfs@vger.kernel.org; Sun, 14 Aug 2016 01:05:56 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs quota issues
Date: Sat, 13 Aug 2016 23:05:50 +0000 (UTC)
Message-ID: <pan$541a$1c388cce$2546386a$4951cf94@cox.net>
References: <CAGj_d3D2OZt2nY622rp9NzxgAfKZ2iN1kLSQ2Ras-0fM+1+-ig@mail.gmail.com>
	<pan$302f2$7d1c6375$718b454d$bb3a6a2@cox.net>
	<CAGj_d3BTkO_cUJ2Lihi2dnD+oJUFTfqHeEBm2i2vVhS=1Y9MrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rakesh Sankeshi posted on Fri, 12 Aug 2016 08:47:13 -0700 as excerpted:

> Another question I had was, is there any way to check what's the
> directory/file sizes prior to compression and how much copression btrfs
> did, etc? Basicaly some stats around compression and/or dedupe from
> btrfs.

There's some dedupe reportes I've seen posted, that basically show shared 
vs. unique extents, but that's out of both my area of usage /and/ my area 
of interest, so that's pretty much all I can say on that.

Compression...  AFAIK there's no nice neat admin-level command for it 
(yet?), but it's possible to get the raw information via filefrag -v.  
The output is a list of extents for the file in question, with both their 
(uncompressed) size and start/end addresses.  If the size is greater than 
the space they take up based on their start/end addresses, then obviously 
that extent is compressed.  People have posted python scripts and the 
like that process that information into something higher level that an 
admin could digest, but I believe you'll have to mine the list archives 
to find them.

In the context of filefrag, it is worth mentioning, however, that btrfs 
compression blocks are 128 KiB in (uncompressed) size, and that filefrag 
considers each such reported block its own extent, even where it's 
contiguous with the next one.  Put another way, filefrag doesn't 
understand btrfs compression, tho it's possible to use its output to 
figure out whether a file is compressed or not, and by how much.

It's also relatively easy to quickly scan the filefrag output to see if 
all the extents are 128 KiB in size and consider that compressed, and/or 
to divide the file size by 128 KiB and see if that matches the number of 
reported extents, considering it compressed if so.  For a few one-off 
files, that's easy enough to do manually, but you'd definitely want to 
automate the process if you wanted that information on more than a few 
individual files.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

