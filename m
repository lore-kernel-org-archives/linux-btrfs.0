Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:50055 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaLGPQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 10:16:20 -0500
Received: by mail-qg0-f46.google.com with SMTP id z107so2505581qgd.5
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Dec 2014 07:16:19 -0800 (PST)
MIME-Version: 1.0
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 7 Dec 2014 20:45:59 +0530
Message-ID: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
Subject: Why is the actual disk usage of btrfs considered unknowable?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

IIUC:

1) btrfs fi df already shows the alloc-ed space and the space used out of that.

2) Despite snapshots, CoW and compression, the tree knows how many
extents of data and metadata there are, and how many bytes on disk
these occcupy, no matter what is the total (uncompressed,
"unsnapshotted") size of all the directories and files on the disk.

So this means that btrfs fi df actually shows the real on-disk usage.
In this case, why do we hear people saying it's not possible to know
the actual on-disk usage and when a btrfs-formatted disk (or
partition) will go out of space?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
