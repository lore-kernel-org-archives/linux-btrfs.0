Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87423C4332F
	for <linux-btrfs@archiver.kernel.org>; Sat, 12 Nov 2022 03:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiKLDtX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 22:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbiKLDtW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2022 22:49:22 -0500
Received: from drax.kayaks.hungrycats.org (drax.kayaks.hungrycats.org [174.142.148.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 834D72CE12
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Nov 2022 19:49:21 -0800 (PST)
Received: by drax.kayaks.hungrycats.org (Postfix, from userid 1002)
        id 134F05F6554; Fri, 11 Nov 2022 22:49:17 -0500 (EST)
Date:   Fri, 11 Nov 2022 22:49:17 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: infinite looping in logical_ino ioctl
Message-ID: <Y28XvZmK0bAS4Ht/@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I've been chasing an infinite loop in the logical_ino ioctl that appears
when dedupe and logical_ino are used together on the same filesystem.
An easy way to do that is to run bees on a CPU with a double-digit
number of cores, but I've also knocked down servers several times in
the last year by running accidentally allowing 'btdu' and 'duperemove'
to run at the same time.

The bug has been highly resistant to analysis.  Even in the best cases,
it takes up to 70 hours of heavy dedupe+logical_ino on every core to
trigger.  bpftrace relies on RCU, but the RCU grace period doesn't happen
on the core running the infinite loop, so bpftraces simply stop when
the bug occurs.  Almost any change to the code in fs/btrfs/backref.c,
even incrementing a static variable counter in some other function,
causes the problem to become much harder to repro, and another similar
change makes it come back.  Once the infinite loop is started, it's
fairly robust--nothing but a reboot gets it out of the loop.

Yesterday I was been able to capture the bug in kgdb on an
unmodified 5.19.16 kernel after 60 hours, and the infinite loop is in
add_all_parents:

    462         while (!ret && count < ref->count) {
...
    486                 fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
    487                 disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
    488                 data_offset = btrfs_file_extent_offset(eb, fi);
    489 
    490                 if (disk_byte == wanted_disk_byte) {
...
    517 next:
    518                 if (time_seq == BTRFS_SEQ_LAST)
    519                         ret = btrfs_next_item(root, path);
    520                 else
    521                         ret = btrfs_next_old_item(root, path, time_seq);
    522         }

In the infinite looping case, time_seq is a 4-digit number, ret and
count are always 0, ref->count is 1, and disk_byte != wanted_disk_byte.
Those conditions never change, so we can't get out of this loop.

When I tried to probe more deeply what btrfs_next_old_item was doing,
I found that the code is somehow executing btrfs_next_item on line 519,
despite time_seq having the value 3722 at the time.  Iteration over the
items in views at two different points in time sounds like it could
result in infinite looping, but I wasn't able to confirm that before
the gdb session died.  I'm now waiting for my test VM to repro again.

Maybe this bug isn't in the _code_ after all...?  I wasn't expecting
to get here, so I'm not sure what to try next.

Kernel built on Debian with gcc (Debian 12.2.0-7) 12.2.0.

Old references:

User report of bees lockup:
[1] https://lore.kernel.org/linux-btrfs/c9f1640177563f545ef70eb6ec1560faa1bb1bd7.camel@bcom.cz/

My previous attempt to bisect the bug or use bpftrace on it:
[2] https://lore.kernel.org/linux-btrfs/20211210183456.GP17148@hungrycats.org/
