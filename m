Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56010 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaDGKe2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 06:34:28 -0400
Received: by mail-pa0-f52.google.com with SMTP id rd3so6582352pab.11
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Apr 2014 03:34:27 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 Apr 2014 12:34:27 +0200
Message-ID: <CAPpBBdPc4ScNEhfYF0SMHwSxZSjN4hYni66VTytMRE6D0BB1rw@mail.gmail.com>
Subject: "No space left on device" during retroactive compression with btrfs
 filesystem defragment
From: George Eleftheriou <eleftg@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Scenario: I had a subvolume with compression disabled and with many snapshots.

Then I decided to compress it retroactively with the following commands:

btrfs  filesystem  defragment  -r  -v  -czlib  /path

find  /path  -xdev  -type  d  -print  -exec btrfs filesystem
defragment -czlib  '{}'  \;

as indicated in the arch btrfs wiki.

I quickly ran into ENOSPC "no space left on device" errors which at
first didn't make sense but then, a little later, the obvious occured
to me:

The snapshots were still uncompressed, so the newly compressed data
were allocated separately taking up free space.

So I removed the snapshots, repeated the steps and lived happily ever after.

Browsing the btrfs wiki for a relevant warning I just found this one:

Caveat: Before Linux 3.9, which adds snapshot-aware defragmentation,
defragmenting a file which had a COW copy (either a snapshot copy or
one made with cp --reflink or bcp) would produce two unrelated files.
If you defragmented a subvolume that had a snapshot, you would roughly
double the disk usage, as the snapshot files were no longer COW images
of the originals.

Which comes close but not quite, since the issue happened during
compression and not plain defragmentation and since the kernel I was
running was 3.13.8

Do you think this scenario deserves a WARNING in the
defragmentation/compression area of the wiki just in case someone else
attempts the same in the future?
