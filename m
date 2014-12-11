Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:36749 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964924AbaLKISH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 03:18:07 -0500
Received: by mail-yh0-f44.google.com with SMTP id c41so2069007yho.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 00:18:06 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 11 Dec 2014 09:18:06 +0100
Message-ID: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>
Subject: ENOSPC after conversion [Was: Fixing Btrfs Filesystem Full Problems typo?]
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'll reboot the thread with a recap and my latest findings.

* Half full 3TB disk converted from ext4 to Btrfs, after first
verifying it with fsck.
* Undo subvolume deleted after being happy with the conversion.
* Recursive defrag.
* Full balance, that ended with "98 enospc errors during balance."

In that order, nothing in between. No snapshots or other subvolumes.
Loads of real free space.

Btrfs check reports a clean filesystem.

Btrfs balance -musage=100 -dusage=99 works, but not -dusage=100.

Conversion of metadata (~1.55 GiB) to DUP worked fine.

A theory, based on the error messages, is that some of the converted
files, even after defrag, still have extents larger than 1GiB and
hence don't fit in a native Btrfs extent.

Running defrag several more times and balance again doesn't help.

An error looks like:
BTRFS info (device sdc1): relocating block group 1821099687936 flags 1
BTRFS error (device sdc1): allocation failed flags 1, wanted 2013265920
BTRFS: space_info 1 has 4773171200 free, is not full
BTRFS: space_info total=1494648619008, used=1489775505408, pinned=0,
reserved=99700736, may_use=2102390784, readonly=241664


The following script returned 46 filenames (looking up the block group
in the error):
grep -B 1 "BTRFS error" /var/log/syslog | grep relocating | cut -d ' ' -f 14 | \
while read block
do
    echo "Block group: $block"
    btrfs inspect-internal logical-resolve $block /mnt
done

The files are ranging from 41KiB to 6.6GiB in size, which doesn't seem
to support the theory of too large extents.

Moving the 46 files to another disk (no errors reported) and running
balance again resulted in "64 enospc errors during balance" - down
from 98 errors.

Running the above script again gives this error for about half of the
block groups:
ioctl ret=-1, error: No such file or directory

I had no such errors the first time I looked up block groups.

What's the next step in zeroing in on the bug, before I start over?
And I will start over.
