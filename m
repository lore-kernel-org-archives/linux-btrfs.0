Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16549 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbLDAwy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Dec 2015 19:52:54 -0500
Date: Thu, 3 Dec 2015 16:52:37 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Codebird <codebird@birds-are-nice.me>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs crashing the kernel with Seagate 8TB SMR drives.
Message-ID: <20151204005237.GE19589@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <566084F8.5050705@birds-are-nice.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <566084F8.5050705@birds-are-nice.me>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 03, 2015 at 06:07:52PM +0000, Codebird wrote:
> I've got a nice bug for you - because I can offer you what everyone likes to
> see, a precise error message.
> 
> I've got a btrfs filesystem spread over six devices, RAID1 mode. Four of
> these are Seagate 8TB archive drives - those SMR ones that a few others have
> reported failing when used with btrfs. I've had that issue too, and I just
> can't explain why, other than to say that it only occurs when using them on
> my mainboard SATA ports, not via USB dock. But that's not what I'm reporting
> - that's just the source of the problem that causes the crash I am
> reporting.
> 
> The crash occurs when scrubbing, after some time and some terabytes - or
> possibly just when reading a certain place, I'm not sure - and it gives this
> helpful error left on the screen along with a system so unresponsive numlock
> won't flash:
> 
> BTRFS: Error (device sdg1) in  __btrfs_free_extent:6360: errno=-5 IO failure
> BTRFS: Error (device sdg1) in  __btrfs_free_extent:6360: errno=-5 IO failure
> BTRFS: Error (device sdg1) in  btrfs_run_delayed_refs:2851: errno=-5 IO
> failure
> BTRFS: Error (device sdg1) in  btrfs_run_delayed_refs:2851: errno=-5 IO
> failure
> BTRFS: Error (device sdg1) in  btrfs_run_delayed_refs:2851: errno=-5 IO
> failure
> <long indent, as if a CR was lost> BTRFS: assertion failed:
> f(fs_info->sb->s_flags & MS  <Cut by edge of screen>
> -----------[ cut here ]------------
> kernel BUG at ../fs/btrfs/ctree.h:4057!
> 
> Not sure if some of those 5 might be 6, as I was in a hurry to get it back
> up both times and just got a blurry photo. But it looks to me like there
> might be a chunk of code that doesn't handle a hardware fault - rather than
> cleanly return an error it's causing the kernel to hang entirely. I've
> managed to get this to happen twice now, so it's certainly something worth
> looking into. This is on SUSE tumbleweed, with kernel 4.3.0-2-default.

We do set btrfs to readonly state when handing this EIO error, but
what's happening here is that btrfs failed to stop scrub workers
calling repair_io_failure() and hit that ASSERT.

Will send a patch to you.

Thanks,

-liubo

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
