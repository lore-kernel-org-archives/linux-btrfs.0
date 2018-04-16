Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:39285 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbeDPOf0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 10:35:26 -0400
Received: by mail-vk0-f54.google.com with SMTP id n124so9593237vkd.6
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 07:35:26 -0700 (PDT)
MIME-Version: 1.0
From: Jayashree Mohan <jayashree2912@gmail.com>
Date: Mon, 16 Apr 2018 09:35:24 -0500
Message-ID: <CA+EzBbDv8GKKgSVwAYwQAn5Q3-MMz2BLUeFcjn3uv6eNBKvs5g@mail.gmail.com>
Subject: Hard link not persisted on fsync
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Vijaychidambaram Velayudhan Pillai <vijay@cs.utexas.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The following seems to be a crash consistency bug on btrfs, where in
the link count is not persisted even after a fsync on the original
file.

Consider the following workload :
creat foo
link (foo, A/bar)
fsync(foo)
---Crash---

Now, on recovery we expect the metadata of foo to be persisted i.e
have a link count of 2. However in btrfs, the link count is 1 and file
A/bar is not persisted. The expected behaviour would be to persist the
dependencies of inode foo. That is to say, shouldn't fsync of foo
persist A/bar and correctly update the link count?
Note that ext4, xfs and f2fs recover to the correct link count of 2
for the above workload.

Let us know what you think about this behavior.

Thanks,
Jayashree Mohan
