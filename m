Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36419 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbcBETge (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Feb 2016 14:36:34 -0500
Received: by mail-ob0-f171.google.com with SMTP id ba1so97814252obb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Feb 2016 11:36:33 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 5 Feb 2016 14:36:33 -0500
Message-ID: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
Subject: BTRFS RAM requirements, RAID 6 stability/write holes and expansion questions
From: Mackenzie Meyer <snackmasterx@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've tried checking around on google but can't find information
regarding the RAM requirements of BTRFS and most of the topics on
stability seem quite old.

So first would be memory requirements, my goal is to use deduplication
and compression. Approximately how many GB of RAM per TB of storage
would be recommended?

RAID 6 write holes?
The BTRFS wiki states that parity might be inconsistent after a crash.
That said, the wiki page for RAID 5/6 doesn't look like it has much
recent information on there. Has this issue been addressed and if not,
are there plans to address the RAID write hole issue? What would be a
recommended workaround to resolve inconsistent parity, should an
unexpected power down happen during write operations?

RAID 6 stability?
Any articles I've tried looking for online seem to be from early 2014,
I can't find anything recent discussing the stability of RAID 5 or 6.
Are there or have there recently been any data corruption bugs which
impact RAID 6? Would you consider RAID 6 safe/stable enough for
production use?

Do you still strongly recommend backups, or has stability reached a
point where backups aren't as critical? I'm thinking from a data
consistency standpoint, not a hardware failure standpoint.

I plan to start with a small array and add disks over time. That said,
currently I have mostly 2TB disks and some 3TB disks. If I replace all
2TB disks with 3TB disks, would BTRFS then start utilizing the full
3TB capacity of each disk, or would I need to destroy and rebuild my
array to benefit from the larger disks?


Thanks!
