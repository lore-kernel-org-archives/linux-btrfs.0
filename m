Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44353 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbcKHNMc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 08:12:32 -0500
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any kernel
 version
To: dsterba@suse.cz
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <824aa945-fd1f-45a2-9123-2bd810f464d6@oracle.com>
Date: Tue, 8 Nov 2016 21:14:39 +0800
MIME-Version: 1.0
In-Reply-To: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi David,

  This patch isn't integrated, any idea why ? Just a note, if it matters,
  this set has already been integrated into Oracle Linux.

Thanks, Anand


On 11/23/15 20:56, Anand Jain wrote:
> Btrfs-progs is a tool for the btrfs kernel and we hope latest btrfs-progs
> be compatible w any set of older/newer kernels.
>
> So far mkfs.btrfs and btrfs-convert sets the default features, for eg,
> skinny-metadata even if the running kernel does not supports it, and
> so the mount fails on the running.
>
> Here in this set of patches will make sure the progs understands the
> kernel supported features.
>
> So in this patch, checks if sysfs tells whether the feature is
> supported if not, then it will relay on static kernel version which
> provided that feature (skinny-metadata here in this example), next
> if for some reason the running kernel does not provide the kernel
> version, then it will fall back to the original method to enable
> the feature with a hope that kernel will support it.
>
> Also the last patch adds a warning when we fail to read either
> sysfs features or the running kernel version.
>
> With this I hope all the concerns from the review comments are
> addressed.
>
>
> Anand Jain (5):
>   btrfs-progs: introduce framework to check kernel supported features
>   btrfs-progs: add framework to check features supported by sysfs
>   btrfs-progs: kernel based default features for mkfs
>   btrfs-progs: kernel based default features for btrfs-convert
>   btrfs-progs: add warning when we fail to read sysfs or kernel version
>
>  btrfs-convert.c |  18 ++++++-
>  mkfs.c          |  22 ++++++++-
>  utils.c         | 146 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  utils.h         |   2 +
>  4 files changed, 173 insertions(+), 15 deletions(-)
>
