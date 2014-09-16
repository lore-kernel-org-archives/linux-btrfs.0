Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:58852 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbaIPT5Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 15:57:16 -0400
Received: by mail-qa0-f52.google.com with SMTP id m5so483325qaj.25
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 12:57:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Sep 2014 15:57:15 -0400
Message-ID: <CAGURhyPOQf2SjAemqe8TG6sv-G+VHg0si5CkMxL=yh52Na-3Rw@mail.gmail.com>
Subject: Measuring overhead of reference counting in btrfs
From: Chris Dragga <chrisdragga@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi-

I'm doing a project that involves, among other things, measuring the
block write overhead that reference counting snapshots imposes in
btrfs, and I wanted to run my methodology by the mailing list, to see
if there were any holes in it.  I'm counting backrefs here as
reference counts, since they're used for the same purpose.

Essentially, I'm using extent_buffers to track reference count I/O.
In the functions __btrfs_inc_extent_ref and __btrfs_free_extent, I
check whether the reference count was incremented above one or
decremented to a minimum of one, respectively; if so, I mark the
extent_buffer as having been used for reference counts.  Conversely,
if the buffer was employed for allocation or deallocation, I mark
that; to this end, I also mark the buffers used in
alloc_reserved_tree_block.  I also mark extent_buffers written in
write_one_cache_group, create_pending_block_groups, and
btrfs_remove_block_group as having been accessed for block groups.
Finally, in  write_one_eb, I count each extent_buffer that has only
been marked for reference counting and use the total as an indicator
of the overhead incurred.

Does this seem accurate?  Are there any points at which I might be
missing I/O that goes to extent buffers that store reference counts?
I'm deliberately ignoring side-effects of reference count
modification, like B-Tree splitting, as that I/O isn't related to the
algorithm and would be difficult to track in a verifiable fashion.

Thanks,
Chris Dragga
