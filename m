From: Arjen Nienhuis <a.g.nienhuis@gmail.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Sun, 16 Jan 2011 01:18:28 +0100
Message-ID: <AANLkTikyLsWSOAV856uYWf3r=J=3aTHsiETDDOa4Wuag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I like your idea and implementation for offline deduplication a lot. I
think it will save me 50% of my backup storage!

Your code walks/scans the directory/file tree of the filesystem. Would
it be possible to walk/scan the disk extents sequentially in disk
order?

- This would be more I/O-efficient
- This would save you reading previously
deduped/snapshotted/hardlinked files more than once.
- Maybe this would make it possible to deduplicate directories as well.

Met vriendelijke groet,
Arjen Nienhuis

P.S. The NTFS implementation on Windows has 'ioctls' to read the MFT
sequentially in disk order and it's *fast*. It's being used for things
like defrag.
