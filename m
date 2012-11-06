Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:40562 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2KFSyG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2012 13:54:06 -0500
Message-ID: <50995DAB.6070103@giantdisaster.de>
Date: Tue, 06 Nov 2012 19:57:47 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Bart Noordervliet <bart@noordervliet.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
References: <cover.1352214751.git.sbehrens@giantdisaster.de> <CAGy7UtjR+kZoBYWaeg=-jHbJHQh4pe3Jt5cwX-rTQEBHFkQ-YQ@mail.gmail.com>
In-Reply-To: <CAGy7UtjR+kZoBYWaeg=-jHbJHQh4pe3Jt5cwX-rTQEBHFkQ-YQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/06/2012 19:17, Bart Noordervliet wrote:
> Great new feature Stefan, thanks a lot! Going to give it a spin right
> away. While compiling I got this (probably superfluous) error that you
> might want to prevent:
>
> fs/btrfs/dev-replace.c: In function ‘btrfs_dev_replace_start’:
> fs/btrfs/dev-replace.c:344:5: warning: ‘ret’ may be used uninitialized
> in this function [-Wmaybe-uninitialized]
>
> Regards,
>
> Bart
>

Yes, this happens on 32 bit builds, not on 64 bit builds. If you look at 
the source code, the compiler is obviously wrong (or I am blind).

         ret = btrfs_dev_replace_find_srcdev(root, args->start.srcdevid,
                                             args->start.srcdev_name,
                                             &src_device);
         mutex_unlock(&fs_info->volume_mutex);
         if (ret) {  <-- this is line 344

But thanks for the feedback anyway!
