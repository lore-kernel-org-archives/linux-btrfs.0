Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:59315 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751396AbaEBJRe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 May 2014 05:17:34 -0400
Message-ID: <536362B9.7020505@elastichosts.com>
Date: Fri, 02 May 2014 10:17:45 +0100
From: Alin Dobre <alin.dobre@elastichosts.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Negative qgroup sizes
References: <53624D07.2000602@elastichosts.com> <pan$cea24$895c4bc2$f096e7bb$50b7a75d@cox.net>
In-Reply-To: <pan$cea24$895c4bc2$f096e7bb$50b7a75d@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the response, Duncan.

On 01/05/14 17:58, Duncan wrote:
> 
> Tho you are slightly outdated on your btrfs-progs version, 3.14.1 being 
> current.  But I think the code in question is kernel code and the progs 
> simply report it, so I don't think that can be the problem in this case.

Yes, I'm aware that 3.14 version of btrfs progs was already there, but
this is just for couple of weeks and I'm pretty sure that the kernel
code (which does the real time accounting) is broken.

> So if you are doing snapshots, you can try not doing them (switching to 
> conventional backup if necessary) and see if that stabilizes your 
> numbers.  If so, you know there's still more problems in that area.
> 
> Of course if the subvolumes involved aren't snapshotted, then the problem 
> must be elsewhere, but I do know the snapshotting case /is/ reasonably 
> difficult to get right... while staying within a reasonable performance 
> envelope at least.
> 

I have already searched and found some patches around this issue, but I
thought I'd also mention the issue on this mailing list and hoped that I
somehow missed something. The subvolumes are highly probable to be
snapshotted, so this might indeed be the case.

Cheers,
Alin.
