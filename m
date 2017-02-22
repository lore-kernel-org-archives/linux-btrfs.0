Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:38919 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933109AbdBVTkI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 14:40:08 -0500
Subject: Re: BTRFS critical: corrupt leaf, slot offset bad; then read-only
To: Lukas Tribus <lukyt@gmx.net>, linux-btrfs@vger.kernel.org
References: <7d3cccae-4761-4799-9ceb-2735519bee8f@gmx.net>
 <0d721199-9407-ff6b-7a31-4dc5dae08e7b@gmx.net>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <1774ecd3-a28c-908a-ec3b-bc98db36f34e@mendix.com>
Date: Wed, 22 Feb 2017 20:40:03 +0100
MIME-Version: 1.0
In-Reply-To: <0d721199-9407-ff6b-7a31-4dc5dae08e7b@gmx.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/22/2017 08:44 AM, Lukas Tribus wrote:
> Upgrading to 4.8, the FS no longer causes a kernel calltrace and does
> not go read-only. It only shows the "corrupt leaf, slot offset bad"
> message.
> 
> A scrub completed without errors on 3 devices, while it was aborted on 2
> devices. Not sure why it was aborted, since there is no error message in
> dmesg?
> 
> Any suggestions why the scrub was aborted?

Maybe because of the "corrupt leaf" error.

> # uname -a
> Linux srv1-dom0 4.8.0-36-generic #36~16.04.1-Ubuntu SMP Sun Feb 5
> 09:39:57 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> # btrfs scrub status /storage/users/
> scrub status for f50f980e-7640-49c7-bf8d-20d55cfe6005
>         scrub started at Wed Feb 22 00:07:33 2017 and was aborted after
> 06:35:42
>         total bytes scrubbed: 10.60TiB with 0 errors
> /# btrfs scrub status /storage/users/ -d
> scrub status for f50f980e-7640-49c7-bf8d-20d55cfe6005
> scrub device /dev/dm-5 (id 1) history
>         scrub started at Wed Feb 22 00:07:33 2017 and finished after
> 06:35:36
>         total bytes scrubbed: 2.30TiB with 0 errors
> scrub device /dev/dm-6 (id 2) history
>         scrub started at Wed Feb 22 00:07:33 2017 and finished after
> 06:35:30
>         total bytes scrubbed: 2.30TiB with 0 errors
> scrub device /dev/dm-7 (id 3) history
>         scrub started at Wed Feb 22 00:07:33 2017 and finished after
> 06:35:42
>         total bytes scrubbed: 2.30TiB with 0 errors
> scrub device /dev/dm-8 (id 4) history
>         scrub started at Wed Feb 22 00:07:33 2017 and was aborted after
> 05:01:37
>         total bytes scrubbed: 1.85TiB with 0 errors
> scrub device /dev/mapper/sde3_crypt (id 5) history
>         scrub started at Wed Feb 22 00:07:33 2017 and was aborted after
> 05:01:37
>         total bytes scrubbed: 1.85TiB with 0 errors
> #dmesg | grep BTRFS
> [  929.737119] BTRFS critical (device dm-9): corrupt leaf, slot offset
> bad: block=5242107641856,root=1, slot=39
> [19772.594129] BTRFS critical (device dm-9): corrupt leaf, slot offset
> bad: block=5242107641856,root=1, slot=39
> [19777.127704] BTRFS critical (device dm-9): corrupt leaf, slot offset
> bad: block=5242107641856,root=1, slot=39
> [19777.552191] BTRFS critical (device dm-9): corrupt leaf, slot offset
> bad: block=5242107641856,root=1, slot=39

Ok, this is not a csum failure, so probably not the disk giving other
data back than what was sent to it when doing the writes, or a disk
controller which corrupted the data while writing.

And, it's a metadata page, in which part of the entries do not make
sense any more to btrfs. Specifically, it's in root 1, which is the tree
which contains information about all other subtrees containing metadata,
so it's quite an important one.

So, the corruption which is now present in there likely happened in
memory before writing it out. This is also a scenario in which DUP or
RAIDx on disk doesn't help you, because in memory it's stored just once.

If this is a bitflip like thing in memory, it would probably be possible
to spot it and manually correct it (using a patched btrfschk with
bitflip patch, or manually by hexediting++).

Another option is memory corruption or a bug somewhere else in the
kernel, which lead to a memory address of a pointer being changed,
leading to a write to memory end up in the middle of some btrfs metadata
waiting to be checksummed and written to disk.

Question here is... is it easier for you to nuke the filesystem and
restore the files from somewhere else, or do you want to figure out
manually if it's recoverable, and spend some time with dd, hexedit,
reading struct definitions in btrfs kernel C code etc...

If the regular --repair can't fix it (and it can't do magic if you shoot
a hole in it with a shotgun), then there's no automated other tool that
can do it now.

Since it's block 5242107641856 all the time, it might be worthwhile to
have a look at it. Either it's that block, or there's a bigger mess
hidden behind it.

-- 
Hans van Kranenburg
