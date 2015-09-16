Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail16.tpgi.com.au ([203.12.160.231]:34247 "EHLO
	mail16.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbIPMmF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 08:42:05 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Brendan Heading <brendanheading@gmail.com>, Duncan <1i5t5.duncan@cox.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: BTRFS as image store for KVM?
Date: Wed, 16 Sep 2015 12:41:49 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F6459691D27A1@Server.waterlogic.com.au>
References: <55F88ECC.1040604@menke.ac>
	<pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
 <CA+BsyQ44kPzk1txVUro7vv2=CH6SF3=9zoSkpMVmqnjtuws5Zw@mail.gmail.com>
In-Reply-To: <CA+BsyQ44kPzk1txVUro7vv2=CH6SF3=9zoSkpMVmqnjtuws5Zw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Brendan Heading
> Sent: Wednesday, 16 September 2015 9:36 PM
> To: Duncan <1i5t5.duncan@cox.net>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: BTRFS as image store for KVM?
> 
> > Btrfs has two possible solutions to work around the problem.  The
> > first one is the autodefrag mount option, which detects file
> > fragmentation during the write and queues up the affected file for a
> > defragmenting rewrite by a lower priority worker thread.  This works
> > best on the small end, because as file size increases, so does time to
> > actually write it out, and at some point, depending on the size of the
> > file and how busy the database/VM is, writes are (trying to) come in
> > faster than the file can be rewritten.  Typically, there's no problem
> > under a quarter GiB, with people beginning to notice performance
> > issues at half to 3/4 GiB, tho on fast disks and not too busy VMs/DBs
> > (which may well include your home system, depending on what you use
> > the VMs for), you might not see problems until size reaches 2 GiB or
> > so.  As such, autodefrag tends to be a very good option for firefox
> > sqlite database files, for instance, as they tend to be small enough
> > not to have issues.  But it's not going to work so well for multi-GiB VM
> images.
> 
> [unlurking for the first time]
> 
> This problem has been faced by a certain very large storage vendor whom I
> won't name, who provide an option similar to the above. Reading between
> the lines I think their approach is to try to detect which accesses are read-
> sequential, and schedule those blocks for rewriting in sequence. They also
> have a feature to run as a background job which can be scheduled to run
> during an off peak period where they can reorder entire files that are
> significantly out of sequence. I'd expect the algorithm is intelligent ie there's
> no need to rewrite entire large files that are mostly sequential with a few
> out-of-order sections.
> 
> Has anyone considered these options for btrfs ? Not being able to run VMs
> on it is probably going to be a bit of a killer ..

I run VMs on BTRFS using regular consumer grade SSDs and hardware, it works great I think. My hosts are windows server + MS SQL. Not the most ideal workload, but I care about data integrity so I'm willing to sacrifice a bit of speed for it. Checksums have prevented countless corruption issues. Although now that I think about it the spinning rust backup disks are the only ones that have ever had any corruption. I guess SSDs have their own internal checksumming as well.
The speed seems quite reasonable, but the server has around 16G ram free which I presume is being used as a cache, which seems to help.

Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
