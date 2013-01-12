Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:44368 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3ALGEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Jan 2013 01:04:52 -0500
Received: by mail-ia0-f171.google.com with SMTP id q36so2209972iaq.16
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2013 22:04:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <A2AC222E-2F40-4B0A-BFA7-C9D2D3A5B193@colorremedies.com>
References: <A2AC222E-2F40-4B0A-BFA7-C9D2D3A5B193@colorremedies.com>
Date: Sat, 12 Jan 2013 00:04:51 -0600
Message-ID: <CAE5mzvjGwnrYJUQJ97xuCm__hAE18cfLx8r5_NutFkA6dzONcQ@mail.gmail.com>
Subject: Re: obscure out of space, df and fi df are way off
From: cwillu <cwillu@cwillu.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 11, 2013 at 11:50 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Very low priority.
> No user data at risk.
> 8GB virtual disk being installed to, and the installer is puking. I'm trying to figure out why.
>
> I first get an rsync error 12, followed by the installer crashing. What's interesting is this, deleting irrelevant source file systems, just showing the mounts for the installed system:
>
> [root@localhost tmp]# df
> Filesystem                 1K-blocks    Used Available Use% Mounted on
> /dev/sda3                    3746816 3193172      1564 100% /mnt/sysimage
> /dev/sda1                     495844   31509    438735   7% /mnt/sysimage/boot
> /dev/sda3                    3746816 3193172      1564 100% /mnt/sysimage/home
>
> So there's 1.5M of free space left according to conventional df. However:
>
> [root@localhost tmp]# btrfs fi show
> Label: 'fedora_f18v'  uuid: 0c9b2b62-5ec1-4610-ab2f-9f00c909428a
>         Total devices 1 FS bytes used 2.87GB
>         devid    1 size 3.57GB used 3.57GB path /dev/sda3
>
> [root@localhost tmp]# btrfs fi df /mnt/sysimage
> Data: total=2.69GB, used=2.69GB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=438.94MB, used=183.36MB
> Metadata: total=8.00MB, used=0.00
>
> And absolutely nothing in dmesg.
>
> This is confusing. fi show says 3.57GB available and used. Whereas fi df says 2.69 available and used. So is it 3.57GB? Or is it 2.69? I suppose the simple answer is, it doesn't matter, in either case it's full. But it seems like the installer is underestimating Btrfs requirements and should be more conservative, somehow so I'd like to better understand the allocation.

There reporting is correct, but a bit obscure.  We have a FAQ item on
how to read the output on the wiki, but it's a known sore spot.

btrfs fi show reports 3.57GB allocated to block groups (so everything
is assigned to metadata or data); btrfs fi df reports how that 3.57GB
is being used: of 2.69GB allocated to data block groups, 2.69GB (i.e.,
all of it) is in use by file data; of 438.94MB of metadata (or 0.87GB
after DUP), 183.36MB is in use by metadata (which may include small
files that have been inlined).

In other words, the tools are saying that filesystem is basically full. :)

Note that the -M option to mkfs.btrfs is intended for this use-case:
filesystems where the size of a block allocation is large compared to
the size of the filesystem.  It should let you squeeze out most of the
rest of that 400MB (200MB, DUP).
