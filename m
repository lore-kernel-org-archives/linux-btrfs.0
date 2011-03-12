From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: BTRFS fsck tool
Date: Sat, 12 Mar 2011 18:53:00 -0500
Message-ID: <4D7C075C.2060702@gmail.com>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com> <4D7591CC.6060301@shiftmail.org> <AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com> <20110308065255.24100.qmail@stuge.se> <1299762048-sup-3940@think> <4D7BF890.5010601@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>, Peter Stuge <peter@stuge.se>,
	Alexey A Nikitin <moonwalker@syrius.us>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Spelic <spelic@shiftmail.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D7BF890.5010601@shiftmail.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/12/2011 05:49 PM, Spelic wrote:
> On 03/10/2011 02:02 PM, Chris Mason wrote:
>> Cutting the power isn't problem unless you're using something
>> where cache flushes are not supported.
> Some disks lie about cache flush having completed.

This is really not true for modern enterprise class drives. You might have more 
issues with USB thumbdrives and other really low end parts.

Ric

> But why doesn't the option for mounting with an earlier superblock work?
> Could you improve that area?
>
> I think that, except on "near to enospc" situations, the new blocks
> being allocated for FS operation should have been free for a while, at
> least one hour (*). In this way new filesystem operations would not
> overwrite old superblocks and old data structures and these would remain
> readable to get a consistent "old version" of the filesystem.
> So in case of abrupt poweroff and wrong flush mechanism, the user could
> still mount with an, e.g., 10-minutes older superblock and get a
> workable 10-minutes older version of the filesystem.
> Or am I missing something?
>
> (*) 1 hour would render highly unlikely that data stays for that long
> uncommitted in the drive's writeback cache. The drive flushes all data
> out whenever it's idle...
>
> Thank you
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

