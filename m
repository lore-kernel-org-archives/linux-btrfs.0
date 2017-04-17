Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f170.google.com ([209.85.213.170]:36805 "EHLO
        mail-yb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755770AbdDQQ6K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 12:58:10 -0400
Received: by mail-yb0-f170.google.com with SMTP id s22so7111000ybe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Apr 2017 09:58:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Apr 2017 10:58:09 -0600
Message-ID: <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 5:53 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> Regarding BTRFS specifically:
> * Given my recently newfound understanding of what the 'ssd' mount option
> actually does, I'm inclined to recommend that people who are using high-end
> SSD's _NOT_ use it as it will heavily increase fragmentation and will likely
> have near zero impact on actual device lifetime (but may _hurt_
> performance).  It will still probably help with mid and low-end SSD's.

What is a high end SSD these days? Built-in NVMe?



> * Files with NOCOW and filesystems with 'nodatacow' set will both hurt
> performance for BTRFS on SSD's, and appear to reduce the lifetime of the
> SSD.

Can you elaborate. It's an interesting problem, on a small scale the
systemd folks have journald set +C on /var/log/journal so that any new
journals are nocow. There is an initial fallocate, but the write
behavior is writing in the same place at the head and tail. But at the
tail, the writes get pushed torward the middle. So the file is growing
into its fallocated space from the tail. The header changes in the
same location, it's an overwrite.

So long as this file is not reflinked or snapshot, filefrag shows a
pile of mostly 4096 byte blocks, thousands. But as they're pretty much
all continuous, the file fragmentation (extent count) is usually never
higher than 12. It meanders between 1 and 12 extents for its life.

Except on the system using ssd_spread mount option. That one has a
journal file that is +C, is not being snapshot, but has over 3000
extents per filefrag and btrfs-progs/debugfs. Really weird.

Now, systemd aside, there are databases that behave this same way
where there's a small section contantly being overwritten, and one or
more sections that grow the data base file from within and at the end.
If this is made cow, the file will absolutely fragment a ton. And
especially if the changes are mostly 4KiB block sizes that then are
fsync'd.

It's almost like we need these things to not fsync at all, and just
rely on the filesystem commit time...





-- 
Chris Murphy
