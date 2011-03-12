From: Spelic <spelic@shiftmail.org>
Subject: Re: BTRFS fsck tool
Date: Sat, 12 Mar 2011 23:49:52 +0100
Message-ID: <4D7BF890.5010601@shiftmail.org>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com>
 <4D7591CC.6060301@shiftmail.org>
 <AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com>
 <20110308065255.24100.qmail@stuge.se> <1299762048-sup-3940@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Peter Stuge <peter@stuge.se>,
	Alexey A Nikitin <moonwalker@syrius.us>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1299762048-sup-3940@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/10/2011 02:02 PM, Chris Mason wrote:
> Cutting the power isn't problem unless you're using something
> where cache flushes are not supported.

Some disks lie about cache flush having completed.

But why doesn't the option for mounting with an earlier superblock work?
Could you improve that area?

I think that, except on "near to enospc" situations, the new blocks
being allocated for FS operation should have been free for a while, at
least one hour (*). In this way new filesystem operations would not
overwrite old superblocks and old data structures and these would remain
readable to get a consistent "old version" of the filesystem.
So in case of abrupt poweroff and wrong flush mechanism, the user could
still mount with an, e.g., 10-minutes older superblock and get a
workable 10-minutes older version of the filesystem.
Or am I missing something?

(*) 1 hour would render highly unlikely that data stays for that long
uncommitted in the drive's writeback cache. The drive flushes all data
out whenever it's idle...

Thank you
