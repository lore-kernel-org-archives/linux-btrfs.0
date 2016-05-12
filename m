Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33663 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314AbcELRDB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 13:03:01 -0400
Received: by mail-qk0-f193.google.com with SMTP id q184so6196850qkf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 10:03:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87y47g1esh.fsf@thinkpad.rath.org>
References: <87y47g1esh.fsf@thinkpad.rath.org>
Date: Thu, 12 May 2016 19:02:56 +0200
Message-ID: <CAPmG0jYDw8Sid2jORVtfwNLpeZPAqtH429EQsraz9GzNdK1aUQ@mail.gmail.com>
Subject: Re: fsck: to repair or not to repair
From: Henk Slager <eye1tm@gmail.com>
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2016 at 11:10 PM, Nikolaus Rath <Nikolaus@rath.org> wrote:
> Hello,
>
> I recently ran btrfsck on one of my file systems, and got the following
> messages:
>
> checking extents
> checking free space cache
> checking fs roots
> root 5 inode 3149867 errors 400, nbytes wrong
> root 5 inode 3150237 errors 400, nbytes wrong
> root 5 inode 3150238 errors 400, nbytes wrong
> root 5 inode 3150242 errors 400, nbytes wrong
> root 5 inode 3150260 errors 400, nbytes wrong
> [ lots of similar message with different inode numbers ]
> root 5 inode 15595011 errors 400, nbytes wrong
> root 5 inode 15595016 errors 400, nbytes wrong
> Checking filesystem on /dev/mapper/vg0-nikratio_crypt
> UUID: 8742472d-a9b0-4ab6-b67a-5d21f14f7a38
> found 263648960636 bytes used err is 1
> total csum bytes: 395314372
> total tree bytes: 908644352
> total fs tree bytes: 352735232
> total extent tree bytes: 95039488
> btree space waste bytes: 156301160
> file data blocks allocated: 675209801728
>  referenced 410351722496
> Btrfs v3.17
>
>
>
> Can someone explain to me the risk that I run by attempting a repair,
> and (conversely) what I put at stake when continuing to use this file
> system as-is?

It has once been mentioned in this mail-list, that if the 'errors 400,
nbytes wrong' is the only error on an fs, btrfs check --repair can fix
them ( was around time of tools release 4.4 , by Qu AFAIK).
I had /(have?) about 7 of those errors in small files on an fs that is
2.5 years old and has quite some older ro snapshots. I once tried to
fix them with 4.5.0 + some patches tools, but actually they did not
get fixed. At least with 4.5.2 or 4.5.3 tools it should be possible to
fix them in your case. Maybe you first want to test it on an overlay
of the device or copy the whole fs with dd. It depends on how much
time you can allow the fs to be offline etc, it is up to you.

In my case, I recreated the files in the working subvol, but as long
as I don't remove the older snapshots, the errors 400 will still be
there I assume. At least I don't experience any negative impact of it,
so I keep it like it is until at some point in time the older
snapshots get removed or I am somehow forced to clone back the data
into a fresh fs. I am running mostly latest stable or sometimes
mainline kernel.
