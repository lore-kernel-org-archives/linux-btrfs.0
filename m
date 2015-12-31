Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33351 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbbLaS3n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 13:29:43 -0500
Received: by mail-ig0-f170.google.com with SMTP id mv3so162946194igc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 10:29:42 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20151231162757.GB5579@cuci.nl>
References: <20151231160416.GA5579@cuci.nl>
	<20151231162757.GB5579@cuci.nl>
Date: Thu, 31 Dec 2015 18:29:42 +0000
Message-ID: <CAL3q7H7J_tL89wpZ5DJPX8N-0Dv9-KKpPROOserK+hn8E9O2qA@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/send.c:1482
From: Filipe Manana <fdmanana@gmail.com>
To: "Stephen R. van den Berg" <srb@cuci.nl>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 31, 2015 at 4:27 PM, Stephen R. van den Berg <srb@cuci.nl> wrote:
> Stephen R. van den Berg wrote:
>>I'm running 4.4.0-rc7.
>>This exact problem was present on 4.0.5 and 4.3.3 too though.
>
>>I do a "btrfs send /var/lib/lxc/template64/rootfs", that generates
>>the following error consistently at the same file, over and over again:
>
>>Dec 29 14:49:04 argo kernel: kernel BUG at fs/btrfs/send.c:1482!
>
> Ok, found part of the solution.
> The kernel bug was being triggered by symbolic links in that
> subvolume that have an empty target.  It is unknown how
> these ever ended up on that partition.

Well they can happen due a crash or snapshotting at very specific
points in time when an error happens while creating a symlink at
least.
I've sent a change for send that makes it not BUG_ON() but instead
fail with an EIO error and print a message do dmesg/syslog telling
that an empty symlink exists:

https://patchwork.kernel.org/patch/7936741/

As for fixing the (very) rare cases where we end up creating empty
symlinks, it's not trivial to fix.

Thanks.

>
> The partitions have been created using regular btrfs.
> The only strange thing that might have happened, is that I ran duperemove
> over those partitions afterward.
> --
> Stephen.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
