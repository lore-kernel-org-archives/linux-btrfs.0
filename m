Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35931 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752051AbaEJBzH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 21:55:07 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140510010518.GP16185@carfax.org.uk>
Date: Fri, 9 May 2014 19:54:20 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <2AB0814E-BFF4-47A9-832F-2DED825E5763@colorremedies.com>
References: <2678329.EOSaIZaHNO@quad> <0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com> <20140510004254.GB9276@merlins.org> <20140510010518.GP16185@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 9, 2014, at 7:05 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Fri, May 09, 2014 at 05:42:54PM -0700, Marc MERLIN wrote:
>> On Sat, May 10, 2014 at 10:13:43AM +1000, Chris Samuel wrote:
>>>> Right now, I do see:
>>>> legolas:~# cat /proc/sys/kernel/tainted
>>>> 512
>>> 
>>> IIUC that's an array of bit flags, and that value means you've had a previous 
>>> kernel warning at that point according to:
>>> 
>>> https://www.kernel.org/doc/Documentation/sysctl/kernel.txt
>> 
>> Yep, I meant to say that I don't have the 'G' now.
> 
>   G is actually good, I think. IIRC, it's "everything we've had to
> this point has been under a license where we have the source
> available". It's when you load a proprietary module that you get the P
> and the G goes away.
> 
>> It's likely that vbox did 'G' even if I didn't successfully start it,
>> and even if I haven't had problems with it 'till now, it's a possible
>> culprit (more details below)
> 
>   I think G is actually a default state, and is "good".

The G just means it's not a proprietary kernel module, but it's still out of tree. So the kernel is in a state that we don't really know, without finding out what's causing it to be tainted. If it's a video or wireless driver (pretty likely) then it's probably sufficiently unrelated to fs to not matter.

However, I have a recent case in VBox guest, with guest additions built. That cause the kernel to be tainted G because it's an out of tree kernel module for guest additions. I'm getting a bunch of Btrfs errors that aren't reproducible with an untainted kernel. So I'm not filing a bug against Btrfs, instead I've filed a bug against VirtualBox because I'm also getting a pile of read write errors with /dev/sda which is backed by a VDI. A virtual device producing hardware read write errors (as far as linux kernel is concerned). But only with guest additions loaded. And the sustained copy event that triggers it doesn't even involve sda. It's a shared folder copy as the source, to a raw device as destination. Yet I get dozens of read write errors on sda, and ensuing Btrfs complaints as well. But in this case Btrfs is behaving exactly as I'd expect. What's unexpected is the virtual sata device behaving wrong, but apparently only with guest additions loaded.

Chris Murphy

