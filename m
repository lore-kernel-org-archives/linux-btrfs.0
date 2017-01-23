Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:60470 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdAWU12 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 15:27:28 -0500
Subject: Re: Hard crash on 4.9.5
To: Matt McKinnon <matt@techsquare.com>, linux-btrfs@vger.kernel.org
References: <83c1a49a-b2ea-c7b6-151d-cbd15b6c9c93@techsquare.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b1779afa-a3c0-b86a-f3bb-f2b469bd6c9b@mendix.com>
Date: Mon, 23 Jan 2017 21:27:22 +0100
MIME-Version: 1.0
In-Reply-To: <83c1a49a-b2ea-c7b6-151d-cbd15b6c9c93@techsquare.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/23/2017 09:03 PM, Matt McKinnon wrote:
> Wondering what to do about this error which says 'reboot needed'.  Has
> happened a three times in the past week:
> 
> Jan 23 14:16:17 my_machine kernel: [ 2568.595648] BTRFS error (device
> sda1): err add delayed dir index item(index: 23810) into the deletion
> tree of the delayed node(root id: 257, inode id: 2661433, errno: -17)
> Jan 23 14:16:17 my_machine kernel: [ 2568.611010] ------------[ cut here
> ]------------
> Jan 23 14:16:17 my_machine kernel: [ 2568.615628] kernel BUG at
> fs/btrfs/delayed-inode.c:1557!
> Jan 23 14:16:17 my_machine kernel: [ 2568.620942] invalid opcode: 0000
> [#1] SMP
> [...]

The purpose of the code involved is that if you create a directory or
file and quickly remove it again, the filesystem doesn't need to do two
disk writes, it can just erase it again from its memory before writing
anything to disk.

---- 8< more ----

This is when the functionality was added:

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=16cdcec736cd214350cdb591bf1091f8beedefa0

If you look for "err add delayed dir" in the source code of that commit
message, you see where the error message is constructed

errno: -17, just after it called __btrfs_add_delayed_insertion_item

__btrfs_add_delayed_insertion_item calls __btrfs_add_delayed_item, and
the only non-0 return in that function is: return -EEXIST, which is -17

I think this means you added a file or directory, and the kernel code
tried to add adding the file twice to the list of additions, which it
has no way to deal with except making the whole kernel crash.

---- >8 ----

A while ago someone reported this on IRC, running a 4.8.13 kernel.
(that's when I looked up the above info). I can also find it in Oct 2016
in my IRC logs, but without any info on kernel version.

Anyway, it seems to point to something that's going wrong with changes
that are *not* on disk *yet*, and the crash is preventing .

-- 
Hans van Kranenburg
