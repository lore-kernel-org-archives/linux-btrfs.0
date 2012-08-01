Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40957 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab2HAMk6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 08:40:58 -0400
Received: by ghrr11 with SMTP id r11so749980ghr.19
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Aug 2012 05:40:57 -0700 (PDT)
Message-ID: <501923D4.5070607@gmail.com>
Date: Wed, 01 Aug 2012 20:40:52 +0800
From: Liu Bo <liub.liubo@gmail.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs Intermittent ENOSPC Issues
References: <CAKcLGm-JYUUTc+NodFHFi2SLpE7=JSwRigygt5x8xgy_bYzzoQ@mail.gmail.com>
In-Reply-To: <CAKcLGm-JYUUTc+NodFHFi2SLpE7=JSwRigygt5x8xgy_bYzzoQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/2012 03:37 AM, Mitch Harder wrote:
> I've been working on running down intermittent ENOSPC issues.
> 
> I can only seem to replicate ENOSPC errors when running zlib
> compression.  However, I have been seeing similar ENOSPC errors to a
> lesser extent when playing with the LZ4HC patches.
> 
> I apologize for not following up on this sooner, but I had drifted
> away from using zlib, and didn't notice there was still an issue.
> 
> My test case involves un-archiving linux git sources to a freshly
> formatted btrfs partition, mounted with compress-force=zlib.  I am
> using a 16 GB partition on a 250 GB Western Digital SATA Hard Disk.
> My current kernel is x86_64 linux-3.5.0 merged with Chris' for-linus
> branch (for 3.6_rc).  This includes Josef's "Btrfs: flush delayed
> inodes if we're short on space" patch.
> 
> I haven't isolated a root cause, but here's the feedback I have so far.
> 
> (1)  My test case won't generate ENOSPC issues with lzo compression or
> no compression.
> 
> (2)  I've inserted some trace_printk debugging statements to trace
> back the call stack, and the ENOSPC errors only seem to occur on a new
> transaction: vfs_create -> btrfs_create -> btrfs_start_transaction ->
> start_transaction -> btrfs_block_rsv_add -> reserve_metadata_bytes.
> 
> (3)  The ENOSPC condition will usually clear in a few seconds,
> allowing writes to proceed.
> 
> (4)  I've added a loop to the reserve_metadata_bytes() function to
> loop back with 'flush_state = FLUSH_DELALLOC (1)' for 1024 retries.
> This reduces and/or eliminates the ENOSPC errors, as if we're waiting
> on something else that is trying to complete.
> 
> (5)  I've been heavily debugging the reserve_metadata_bytes()
> function, and I'm seeing problems with the way
> space_info->bytes_may_use is handled.  The space_info->bytes_may_use
> value is important in determining if we're in an over-commit state.
> But space_info->bytes_may_use value is often increased arbitrarily
> without any mechanism for correcting the value.  Subsequently,
> space_info->bytes_may_use quickly increases in size to the point where
> we are always in fallback allocation as if we're overcommitted.  In my
> trials, it was hard to capture a point where space_info->bytes_may_use
> wasn't larger than the available size.
> 

Interesting results.

IIRC, space_info->bytes_may_use seems not to be arbitrarily increased:

Block_rsv wants NUM bytes
          -> space_info's bytes_may_use += NUM

Block_rsv uses SOME bytes and release itself
          -> space_info's bytes_may_use -= (NUM - SOME)

So IMO it is 'over-reserve' that causes ENOSPC.

Maybe we can try to find why more bytes need to be reserved with
compress=zlib/compress=LZ4HC.

thanks,
liubo

> (6)  Even though reserve_metadata_bytes() is almost always in fallback
> overcommitted mode, it is still working pretty well, and I've
> developed the perception that the problem is something that needs to
> finish elsewhere.
> 
> Sorry for not having a patch to fix the issue.  I'll try to keep
> banging on it as time allows.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

