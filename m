Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35677 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbbKXVLZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 16:11:25 -0500
Received: by ioc74 with SMTP id 74so33864874ioc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 13:11:24 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <56523AC8.7050205@voidptr.de>
References: <56523AC8.7050205@voidptr.de>
Date: Tue, 24 Nov 2015 21:11:24 +0000
Message-ID: <CAL3q7H4J32TvWHtM+B9wULwGbjc7RhVPyQNZxEnjKJc24jsmHQ@mail.gmail.com>
Subject: Re: btrfs send reproducibly fails for a specific subvolume after
 sending 15 GiB, scrub reports no errors
From: Filipe Manana <fdmanana@gmail.com>
To: Nils Steinger <nst@voidptr.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 22, 2015 at 9:59 PM, Nils Steinger <nst@voidptr.de> wrote:
> Hi,
>
> I recently ran into a problem while trying to back up some of my btrfs
> subvolumes over the network:
> `btrfs send` works flawlessly on snapshots of most subvolumes, but keeps
> failing on snapshots of a certain subvolume — always after sending 15 GiB:
>
> btrfs send /btrfs/snapshots/home/2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT |
> pv | ssh kappa "btrfs receive /mnt/300gb/backups/snapshots/zeta/home/"
> At subvol /btrfs/snapshots/home/2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT
> At subvol 2015-11-17_03:28:14_BOOT-AUTOSNAPSHOT
> ERROR: send ioctl failed with -2: No such file or directory
>   15GB 0:34:34 [7,41MB/s]

Which kernel version?

Try with a 4.3 kernel (or the latest you can, like a 4.2 or 4.1). If
it persists, you can create an image of your filesystem like this for
example:

btrfs-image -c 9 /dev/whatever fs.img

The image won't contain your data (it will all be replaced with
zeroes) but file and directory names and xattrs will remain untouched
(there's an option to sanitize file names, but that might not help
debugging what's going on with send).
If this is an option for you, you can send me the image for debugging
and getting the bug fixed - but please make sure you try a recent
kernel first (ideally 4.3) to see if the problem reproduces there, the
send code (like the rest of btrfs and the linux kernel) keeps changing
between kernel versions (bug fixes, etc).

>
> I've tried piping the output to /dev/null instead of ssh and got the
> same error (again after sending 15 GiB), so this seems to be on the
> sending side.
>
> However, btrfs scrub reports no errors and I don't get any messages in
> dmesg when the btrfs send fails.
>
> What could cause this kind of error?
> And is there a way to fix it, preferably without recreating the FS?
>
>
> Regards,
> Nils Steinger
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
