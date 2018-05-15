Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752385AbeEOIDg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 04:03:36 -0400
Subject: Re: [PATCH 0/2] btrfs: sysfs: Add entry which shows rmdir(2) can work
 for subvolume
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a8c4cc11-99f4-2390-b489-340bdc941464@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <234bbf21-794a-454a-b7d0-3f68e6a6f88a@suse.com>
Date: Tue, 15 May 2018 11:03:33 +0300
MIME-Version: 1.0
In-Reply-To: <a8c4cc11-99f4-2390-b489-340bdc941464@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.05.2018 10:30, Misono Tomohiro wrote:
> [based on current misc-next]
> 
> This adds new sysfs entry
>   /sys/fs/btrfs/features/rmdir_subvol
> to indicate that the kernel can delete a subvolume by rmdir(2),
> which is allowed by: https://www.spinics.net/lists/linux-btrfs/msg76938.html
> 
> The first patch is a cleanup and the second one is a main part.

Why do we need this - for enabling testing or something else?

> 
> Tomohiro Misono (2):
>   btrfs: sysfs: Use enum/define value intead of magic number
>   btrfs: sysfs: Add entry which shows rmdir(2) can work for subvolume
> 
>  fs/btrfs/ctree.h           |  6 ++++++
>  fs/btrfs/sysfs.c           | 39 +++++++++++++++++++++++++++++----------
>  fs/btrfs/sysfs.h           |  5 ++++-
>  include/uapi/linux/btrfs.h |  2 ++
>  4 files changed, 41 insertions(+), 11 deletions(-)
> 
