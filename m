Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57470 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2GaThu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 15:37:50 -0400
Received: by obbuo13 with SMTP id uo13so11037378obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 12:37:49 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 31 Jul 2012 14:37:49 -0500
Message-ID: <CAKcLGm-JYUUTc+NodFHFi2SLpE7=JSwRigygt5x8xgy_bYzzoQ@mail.gmail.com>
Subject: Btrfs Intermittent ENOSPC Issues
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been working on running down intermittent ENOSPC issues.

I can only seem to replicate ENOSPC errors when running zlib
compression.  However, I have been seeing similar ENOSPC errors to a
lesser extent when playing with the LZ4HC patches.

I apologize for not following up on this sooner, but I had drifted
away from using zlib, and didn't notice there was still an issue.

My test case involves un-archiving linux git sources to a freshly
formatted btrfs partition, mounted with compress-force=zlib.  I am
using a 16 GB partition on a 250 GB Western Digital SATA Hard Disk.
My current kernel is x86_64 linux-3.5.0 merged with Chris' for-linus
branch (for 3.6_rc).  This includes Josef's "Btrfs: flush delayed
inodes if we're short on space" patch.

I haven't isolated a root cause, but here's the feedback I have so far.

(1)  My test case won't generate ENOSPC issues with lzo compression or
no compression.

(2)  I've inserted some trace_printk debugging statements to trace
back the call stack, and the ENOSPC errors only seem to occur on a new
transaction: vfs_create -> btrfs_create -> btrfs_start_transaction ->
start_transaction -> btrfs_block_rsv_add -> reserve_metadata_bytes.

(3)  The ENOSPC condition will usually clear in a few seconds,
allowing writes to proceed.

(4)  I've added a loop to the reserve_metadata_bytes() function to
loop back with 'flush_state = FLUSH_DELALLOC (1)' for 1024 retries.
This reduces and/or eliminates the ENOSPC errors, as if we're waiting
on something else that is trying to complete.

(5)  I've been heavily debugging the reserve_metadata_bytes()
function, and I'm seeing problems with the way
space_info->bytes_may_use is handled.  The space_info->bytes_may_use
value is important in determining if we're in an over-commit state.
But space_info->bytes_may_use value is often increased arbitrarily
without any mechanism for correcting the value.  Subsequently,
space_info->bytes_may_use quickly increases in size to the point where
we are always in fallback allocation as if we're overcommitted.  In my
trials, it was hard to capture a point where space_info->bytes_may_use
wasn't larger than the available size.

(6)  Even though reserve_metadata_bytes() is almost always in fallback
overcommitted mode, it is still working pretty well, and I've
developed the perception that the problem is something that needs to
finish elsewhere.

Sorry for not having a patch to fix the issue.  I'll try to keep
banging on it as time allows.
