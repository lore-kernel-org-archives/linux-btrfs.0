Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:34257 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdAWVOD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 16:14:03 -0500
Received: by mail-yw0-f176.google.com with SMTP id w75so148666786ywg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jan 2017 13:14:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com> <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
 <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com>
From: Chris Murphy <chris@colorremedies.com>
Date: Mon, 23 Jan 2017 14:14:02 -0700
Message-ID: <CAJCQCtSDHdytGS51uLAuS9Ki7_CDKsy2x9OpPUmvwYpQ7iRrLQ@mail.gmail.com>
Subject: Re: btrfs check lowmem vs original
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK so all of these pass original check, but have problems reported by
lowmem. Separate notes about each inline.

~500MiB each, these three are data volumes, first two are raid1, third
one is single.
https://drive.google.com/open?id=0B_2Asp8DGjJ9Z3UzWnFKT3A0clU
https://drive.google.com/open?id=0B_2Asp8DGjJ9V0ROdHNoMW1BVE0
https://drive.google.com/open?id=0B_2Asp8DGjJ9Zmd1LXl6MU5WeXc

19MiB, about 15 minutes old, rootfs, OS installation only
https://drive.google.com/open?id=0B_2Asp8DGjJ9TF9LVkFlcDBzOG8

55MiB, about 1 month old, rootfs, not much activity
https://drive.google.com/open?id=0B_2Asp8DGjJ9bkJFc01qcVJxNnM

324MiB, about 5 months old, used as rootfs, all read-write snapshots
used as rootfs are forced readonly, a regression previously reported
without any dev response
https://drive.google.com/open?id=0B_2Asp8DGjJ9ZmNxdEw1RDBPcTA
http://www.spinics.net/lists/linux-btrfs/msg61817.html
https://bugzilla.kernel.org/show_bug.cgi?id=191761
