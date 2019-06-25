Return-Path: <SRS0=RfiN=UY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC22CC48BD4
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Jun 2019 10:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84CB4215EA
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Jun 2019 10:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbfFYKvO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Jun 2019 06:51:14 -0400
Received: from len.romanrm.net ([91.121.75.85]:44490 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbfFYKvN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jun 2019 06:51:13 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jun 2019 06:51:13 EDT
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id 5903F202BE
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jun 2019 10:41:55 +0000 (UTC)
Date:   Tue, 25 Jun 2019 15:41:55 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     linux-btrfs@vger.kernel.org
Subject: CoW overhead from old extents?
Message-ID: <20190625154155.7b660feb@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I have a number of VM images in sparse NOCOW files, with:

  # du -B M -sc *
  ...
  46030M	total

and:

  # du -B M -sc --apparent-size *
  ...
  96257M	total

But despite there being nothing else on the filesystem and no snapshots,

  # df -B M .

  ... 1M-blocks   Used Available Use% ...
  ...   710192M 69024M   640102M  10% ...

The filesystem itself is:

  Data, RAID0: total=70.00GiB, used=67.38GiB
  System, RAID0: total=64.00MiB, used=16.00KiB
  Metadata, RAID0: total=1.00GiB, used=7.03MiB
  GlobalReserve, single: total=16.00MiB, used=0.00B

So there's about 23 GB of overhead to store only 46 GB of data.

I vaguely remember the reason is something along the lines of the need to keep
around old extents, which are split in the middle when CoWed, but the entire
old extent must be also kept in place, until overwritten fully.

These NOCOW files are being snapshotted for backup purposes, and the snapshot
is getting removed usually within 30 minutes (while the VMs are active and
writing to their files), so it was not pure NOCOW 100% of the time.

Main question is, can we have this recorded/explained in the wiki in precise
terms (perhaps in Gotchas), or is there maybe already a description of this
issue on it somewhere? I looked through briefly just now, and couldn't find
anything similar. Only remember this being explained once on the mailing list
a few years ago. (Anyone has a link?)

Also, any way to mitigate this and regain space? Short of shutting down the
VMs, copying their images into new files and deleting old ones. Balance,
defragment or "fallocate -d" (for the non-running ones) do not seem to help.

What's unfortunate is that "fstrim -v" only reports ~640 GB as having been
trimmed, which means the overhead part will be not freed by TRIM if this was
on top of thin-provisioned storage either.

-- 
With respect,
Roman
