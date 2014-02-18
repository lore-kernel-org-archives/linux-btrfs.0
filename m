Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42758 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752304AbaBRWNB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 17:13:01 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck does not fix
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5303D6C8.80103@friedels.name>
Date: Tue, 18 Feb 2014 15:12:57 -0700
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Message-Id: <9583F3D2-78BB-40C3-A1CD-E2D8DE4CA89E@colorremedies.com>
References: <52C7127F.3060902@friedels.name>	<0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>	<52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba>	<52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name>	<A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com>	<52F73E2B.9080103@friedels.name>	<837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com>	<82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com>	<53010EF9.60805@friedels.name>	<21AD6EBC-FDDA-4BDE-B0B4-D6A8BBAD58F0@colorremedies.com> <pan$475be$cb0c1165$a3d91acc$c206709@cox.net> <5303D6C8.80103@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 18, 2014, at 2:55 PM, Hendrik Friedel <hendrik@friedels.name> wrote:

> Hello,
> 
> >> It looks like everything is single except for 4GB of data which is still
>>> raid0. Weird. There should be a bunch of messages in dmesg during a
>>> normal/successful balance, and either something mentioned or missing
>>> might provide a clue why some chunks weren't converted.
> >
>> Agreed.
> 
> time ./btrfs balance start  -dconvert=single,soft /mnt/BTRFS/Video/
> ERROR: error during balancing '/mnt/BTRFS/Video/' - No space left on device
> There may be more info in syslog - try dmesg | tail
> 
> real    0m23.803s
> user    0m0.000s
> sys     0m1.070s
> 
> dmesg:
> [697498.761318] btrfs: relocating block group 19874593112064 flags 9
> [697507.614140] btrfs: relocating block group 19715679322112 flags 9
> [697516.218690] btrfs: 2 enospc errors during balance

You could try mounting with enospc_debug option and retrying, see if there's more information dmesg. But the large number of problems btfs check is finding, it may not be possible to move these 4GB.

So hopefully the data you need is already backed up and you can just blow this file system away. Or if you're looking to keep testing, you could try building a btrfs-next kernel to see if it can unwind this problem. And for btrfs-progs there's David Sterba's integration branch, is probably the most appropriate. But I haven't kept track of fsck related patches since v3.12 was released so I don't know if there's something newer that applies. Which is why it's easier to just back up and blow this thing away entirely and start from scratch.


Chris Murphy

