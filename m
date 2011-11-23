From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: stripe alignment consideration for btrfs on RAID5
Date: Wed, 23 Nov 2011 17:04:17 +0000 (UTC)
Message-ID: <slrnjcq9sh.b3r.stephane.chazelas@spam.is.invalid>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hiya,

is there any recommendation out there to setup a btrfs FS on top
of hardware or software raid5 or raid6 wrt stripe/stride alignment?

>From mkfs.btrfs, it doesn't look like there's much that can be
adjusted that would help, and what I'm asking might not even
make sense for btrfs but I thought I'd just ask.

Thanks,
Stephane

