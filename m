Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:36451 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbdATSEr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 13:04:47 -0500
Received: by mail-yw0-f172.google.com with SMTP id v200so96543595ywc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jan 2017 10:04:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com> <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
From: Chris Murphy <chris@colorremedies.com>
Date: Fri, 20 Jan 2017 11:04:45 -0700
Message-ID: <CAJCQCtSM=2eDNXuDGEJiEZ1mmY_wotvqAfHBWKq2OQ26xsy4sQ@mail.gmail.com>
Subject: Re: btrfs check lowmem vs original
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For sanitizing the debug tree I tried this backwards method:

# btrfs-image -c5 -t4 -s /dev/mapper/brick1 > btrfsimage_30f4724a.bin
# lvcreate -V 603440807936b -T vg/thintastic -n btr1
# btrfs-image -r btrfsimage_30f4724a.bin /dev/vg/btr1
# btrfs inspect-internal dump-tree /dev/vg/btr1 > btrfsdebugtree_30f4724a.log

But I see by default, -r makes modifications to the chunk tree, so
maybe it's not a useful debug tree? Anyway, the two btrfs checks
(original and lowmem) and the debug tree are here:

30f4724a-first.logs.tar 254MiB
https://drive.google.com/open?id=0B_2Asp8DGjJ9QmZOV3pNS212Yk0

There are 4 more file systems, 2 are single device, 2 are two device
(raid1) fs's. I'm not sure how to use this indirect btrfs-image
approach with raid1.


Chris Murphy
