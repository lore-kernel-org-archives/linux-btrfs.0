Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56471 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaJDVdo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Oct 2014 17:33:44 -0400
Date: Sat, 4 Oct 2014 23:33:33 +0200
From: Marc Dietrich <marvin24@gmx.de>
To: Filipe Manana <fdmanana@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: FIBMAP unsupported
Message-Id: <20141004233333.a31053a21e4f5c446e4eebac@gmx.de>
In-Reply-To: <542EA15F.9080703@suse.com>
References: <6602102.lhBckFYBLs@fb07-iapwap2>
	<20141002172549.GV11436@twin.jikos.cz>
	<2356843.HqzAreCEMf@ax5200p>
	<6603452.o3OqIjYaDr@ax5200p>
	<542EA15F.9080703@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 03 Oct 2014 14:15:11 +0100
Filipe Manana <fdmanana@suse.com> wrote:
> Just tried it and I confirm filefrag's call to ioctl FS_IOC_FIEMAP fails
> with -EEXIST.
> 
> It's actually a known issue affecting any of the 3.17 RCs (except RC1).
> The extent map manipulation/merging is broken for some cases. Try with
> this 2 patches on top of 3.17-rcX:
> 
> https://patchwork.kernel.org/patch/4929981/
> https://patchwork.kernel.org/patch/4945191/

ok, 2nd patch did not apply cleanly, so I just replaced the < with <=.

Otherwise, I can confirm the patches are fixing the issue here.

> Or, alternatively, reverting this patch:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=51f395ad4058883e4273b02fdebe98072dbdc0d2
> 
> Someone else reported on this list a write/pwrite/writev failure with
> errno EEXIST too (and apparently caused by the same reason).
> 
> This broken extent map handling is serious IMHO, it can make fsync log
> bogus extent items for example, amongst other possible bad and weird things.

Yes, it clearly corrupted by files in a strange way. Please try to get
it into final, or at least -stable if too late.

Marc
