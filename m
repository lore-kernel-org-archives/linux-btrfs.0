Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42788 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab2L3Tka (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Dec 2012 14:40:30 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so11132447obb.33
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Dec 2012 11:40:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50DED3D2.7010502@friedels.name>
References: <50BFB3B2.8040405@friedels.name>
	<CAKcLGm_44rjGwyKox0xO1SqWP1SkY-z8vpST6n99Q4g6eN9Lrw@mail.gmail.com>
	<50C4E152.2000102@friedels.name>
	<CAKcLGm8wm1Gfe0ESCubGusqe_zojJp=7JORLXuq_EUdY22JOWA@mail.gmail.com>
	<50CCD247.3090701@friedels.name>
	<CAKcLGm-bwUriSBzoM2FTV9Rv1=dYp=5H_me8VZX6vygtXEhADg@mail.gmail.com>
	<50D0EB73.4090304@friedels.name>
	<50DED3D2.7010502@friedels.name>
Date: Sun, 30 Dec 2012 13:34:35 -0600
Message-ID: <CAKcLGm-Te1nTCieN+AOnxhLyB_5EaHHYZ+R6gV7yaFqzJN7nqA@mail.gmail.com>
Subject: Re: segmentation-fault in btrfsck (git-version)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 29, 2012 at 5:28 AM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello,
>
> I re-send this message, hoping that someone can give me a hint?
>
> Regards,
> Hendrik
>

Two possibilities come to mind (although there may be others).

(1)  The file still exists, but it is somewhere you did not expect.

(2)  Your filesystem tree has some sort of corruption.

For item (1), have you thoroughly searched the entire volume for this
file with something like:

find <path/to/volume/top/level/mount>  -iname 'Sting_Live_in_Berlin'

It is possible that the file exists in a snapshot or different
directory then you were expecting.

If the filesystem tree is corrupted, the task becomes tricky.

Perhaps you can look at the Wiki entry for how the filesystem tree is
constructed:

https://btrfs.wiki.kernel.org/index.php/Trees

Then examine the btrfs-debug-tree output around these entries, and try
to determine why the tree still has entries for these files, but does
not show these files nor report the problem with btrfsck.
