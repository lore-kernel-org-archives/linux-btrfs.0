Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45199 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751209AbdDJD2D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Apr 2017 23:28:03 -0400
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: About the behavior of inline extent
Message-ID: <f9dc56cc-720e-0df1-f6c7-790e93276ee0@cn.fujitsu.com>
Date: Mon, 10 Apr 2017 11:27:55 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Recent btrfs/137 test case makes me wonder what's the designed behavior 
of btrfs inline data extent.

The current behavior in fact is quite a chaos.
We need a standard of how inline extent should behave.

1) max_inline limit
    The problem of current max_inline is, it's never clear what it is
    limiting.

    For example, we don't allow page sized inline extent if not
    compressed.
    But we allow page sized inline extent if it's compressed.
    Is it just limiting size after compression?
    What if we really want to limit size before compression?

2) inline extent condition
    Is inline extent allowed if we have following regular extent?

    For plain extent, prealloc can cause regular extent to co-exist with
    inlined one.
    While normal write will only convert inlined extent to regular one.

    While for compressed extent, it can co-exist with regular extent, by
    # xfs_io -f -c "pwrite 0 4k" -c sync -c "pwrite 4k 16k" /mnt/btrfs/file

    So which is the correct behavior?
    Personally I think we should not allow co-exist, as it's already
    causing a lot of fixes for it, that's to say neither current
    behavior is correct.

3) inline extent and fallocate
    For inline extent, as long as we are calling fallocate inside the
    page size, only the isize is expanded.

    Only beyond page size, we get prealloc extents.
    (However inlined extent is still here, not converted)

    What's the designed behavior? Convert inline to regular or just
    leave it as is?

Thanks,
Qu


