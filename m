From: "Evgeny A. Marchenko" <xengine@mail.ru>
Subject: Re: Question: Build btrfs filesystem from specific directory.
Date: Sat, 12 Jun 2010 06:33:11 +0400
Message-ID: <201006120633.12043.xengine@mail.ru>
References: <AANLkTimbW5pNGsFxRZYRRjY0Ke-Wyb4aaBkUZgilVMlR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimbW5pNGsFxRZYRRjY0Ke-Wyb4aaBkUZgilVMlR@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> I'm founding the solution to build btrfs filesystem image from
> specific directory.
> it's common concept at mobile build environment.
> e.g., ubifs and cramfs support this feature.
> 
> In case of ubifs
> -r, -d, --root=DIR       build file system from directory DIR
> In case of cramfs
> dirname    root of the filesystem to be compressed
> 
> But btrfs doesn't support it.
Maybe because btrfs is not a compressed read-only filesystem

> So does it have any plan to support this feature at btrfs?
You can create file-backed loop device, mount it and copy the directory 
contents there. Than unmount the loop and voila - you have btrfs image

Regards, Evgeny Marchenko
