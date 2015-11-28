Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35435 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbbK1MtA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 07:49:00 -0500
Received: by oige206 with SMTP id e206so73199198oig.2
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 04:48:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1448679820.11377.52.camel@scientia.net>
References: <1448679820.11377.52.camel@scientia.net>
From: Noah Massey <noah.massey@gmail.com>
Date: Sat, 28 Nov 2015 07:48:20 -0500
Message-ID: <CADfjVrh-k0r3u=TC2vpWh2rm2QNPt1e8cyJOq5EYbKc_Jx57yg@mail.gmail.com>
Subject: Re: cannot move ro-snapshot directly but indirectly works
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2015 at 22:06 Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
>
> Hey.
>
> Not sure whether this is intended or not, but it feels at least
> somewhat strange:
>
> Consider I have a readonly snapshot (the only subvol here):
> /btrfs/snapshots/ro-snapshot
> now I want to move it to the dir:
> /btrfs/snapshots/foo/
> i.e.
> mv /btrfs/snapshots/ro-snapshot
> /btrfs/snapshots/foo/
> but the mv complains about read-only filesystem.
>

Not a developer, but I believe this is intended behavior.
Changing the direct parent directory of a subvolume is not a read only
operation: it involves modifying the '..' directory entry.
Renaming the subvolume, or moving the parent directory, modify the
overall fs-hierachy, but do not modify the subvol.

The same is true for normal directories:
mkdir /tmp/dir1
chmod -w /tmp/dir1
mv /tmp/dir1 /tmp/dir2 ## allowed
mkdir /tmp/dir3
mv /tmp/dir2 /tmp/dir3/dir2 ## Permission denied

~ Noah
