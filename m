From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Can btrfs silently repair read-error in raid1
Date: Tue, 8 May 2012 09:13:31 +0200
Message-ID: <CAFvQSYTtcxdy=y4LiV6x8znDm+UD-or1TFMvLrUbad6d+cXqbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a quite unreliable SSD here which develops some bad blocks from
time to time which result in read-errors.
Once the block is written to again, its remapped internally and
everything is fine again for that block.

Would it be possible to create 2 btrfs partitions on that drive and
use it in RAID1 - with btrfs silently repairing read-errors when they
occur?
Would it require special settings, to not fallback to read-only mode
when a read-error occurs?

Thank you in advance, Clemens
