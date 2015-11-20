Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp52.i.mail.ru ([94.100.177.112]:52487 "EHLO smtp52.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934432AbbKTLjM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 06:39:12 -0500
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:41924 helo=centurion)
	by smtp52.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1Zzk1T-0006dy-4f
	for linux-btrfs@vger.kernel.org; Fri, 20 Nov 2015 14:38:35 +0300
Received: from [127.0.0.1] (localhost [IPv6:::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id CE958485913
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 12:38:31 +0100 (CET)
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
To: linux-btrfs@vger.kernel.org
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk> <564D1AE5.3000700@cn.fujitsu.com>
 <pan$61583$65d817c9$bfda2de6$465dca20@cox.net>
From: Dmitry Katsubo <dma_k@mail.ru>
Message-ID: <564F0671.8060402@mail.ru>
Date: Fri, 20 Nov 2015 12:39:29 +0100
MIME-Version: 1.0
In-Reply-To: <pan$61583$65d817c9$bfda2de6$465dca20@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If I may add:

Information for "System"

  System, DUP: total=32.00MiB, used=16.00KiB

is also quite technical, as for end user system = metadata (one can call
it "filesystem metadata" perhaps). For simplicity the numbers can be
added to "Metadata" thus eliminating that line as well.

For those power users who really want to see the tiny details like
"System" and "GlobalReserve" I suggest to implement "-v" flag:

# btrfs fi usage -v

On 2015-11-19 03:16, Duncan wrote:
> Qu Wenruo posted on Thu, 19 Nov 2015 08:42:13 +0800 as excerpted:
> 
>> Although the metadata output is showing that you still have about 512M
>> available, but the 512M is Global Reserved space, or the unknown one.
> 
> Unknown here, as the userspace (btrfs-progs) is evidently too old to show 
> it as global reserve, as it does in newer versions...
> 
>> The output is really a little confusing. I'd like the change the output
>> by adding global reserved into metadata used space and make it a sub
>> item for metadata.
> 
> Thanks for the clarification.  It's most helpful, here. =:^)
> 
> I've at times wondered if global reserve folded into one of the other 
> settings.  Apparently it comes from the metadata allocation, but while 
> metadata is normally dup (single-device btrfs) or raid1 (multi-device), 
> global reserve is single.
> 
> It would have been nice if that sort of substructure was described a bit 
> better when global reserve first made its appearance, at least in the 
> patch descriptions and release announcement, if not then yet in btrfs fi 
> df output, first implementations being what they are.  But regardless, 
> now at least it should be clear for list regulars who read this thread 
> anyway, since the above reasonably clarifies things.
> 
> As for btrfs fi df, making global reserve a metadata subentry there would 
> be one way to deal with it, preserving the exposure of the additional 
> data provided by that line (here, the fact that global reserve is 
> actually being used, underlining the fact that the filesystem is severely 
> short on space).
> 
> Another way of handling it would be to simply add the global reserve into 
> the metadata used figure before printing it, eliminating the separate 
> global reserve line, and changing the upthread posted metadata line from 
> 8.48 GiB of 9 GiB used, to 8.98 of 9 GiB used, which is effectively the 
> case if the 512 MiB of global reserve indeed comes from the metadata 
> allocation.  This would more clearly show how full metadata actually is 
> without the added complexity of an additional global reserve line, but 
> would lose the fact that global reserve is actually in use, that the 
> broken out global reserve line exposes.
> 
> I'd actually argue in favor of the latter, directly folding global 
> reserve allocation into metadata used, since it'd both be simpler, and 
> more consistent if for instance btrfs fi usage didn't report separate 
> global reserve in the overall stats, but fail to report it in the per-
> device stats and in btrfs dev usage.
> 
> Either way would make much clearer that metadata is actually running out 
> than the current report layout does, since "metadata used" would then 
> either explicitly or implicitly include the global reserve.
> 


-- 
With best regards,
Dmitry
