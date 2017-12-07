Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:43174 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754104AbdLGOwu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 09:52:50 -0500
Received: by mail-it0-f68.google.com with SMTP id u62so15340468ita.2
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Dec 2017 06:52:50 -0800 (PST)
Subject: Re: [PATCH v5 0/3] Add cli and ioctl to deregister devices
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171207143623.26710-1-anand.jain@oracle.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2ff368d4-a38a-59c9-565a-8c55702217ae@gmail.com>
Date: Thu, 7 Dec 2017 09:52:46 -0500
MIME-Version: 1.0
In-Reply-To: <20171207143623.26710-1-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-07 09:36, Anand Jain wrote:
> Add ability to deregister a or all devices. I have named this sub cmd
> as deregister, but I am open to your suggestions.
Being a bit picky here, but from the perspective of a native speaker of 
American English, I would say that 'deregister' sounds rather synthetic 
and somewhat harsh and alien.

Given that, as odd as it sounds, I think 'ignore' might be a more user 
friendly name for the sub-command.  It accurately describes what the 
command is doing (telling the kernel to ignore the device), and it's a 
lot less alien sounding than 'deregister'.

If you're set on having it be based on the word 'register', I would 
suggest changing it to 'unregister', as I think that sounds more natural 
than 'deregister'.

Additionally, if you do continue with 'deregister' or go with 
'unregister' as the name though, I would suggest adding 'register' as a 
synonym for the 'scan' sub-command to keep things reasonably symmetrical.
> 
> Further I am using /dev/btrfs-control and struct btrfs_ioctl_vol_args
> for now, just similar to other ioctls in super.c including btrfs dev
> scan, if rather it makes sense to use btrfs_ioctl_vol_args_v2 I shall.
> Oepn to suggestions.
> 
> Kernel:
> Patch 1/3 is preparatory patch, provides helper to delete a device.
> Patch 2/3 adds ioctl to delete device from the device list.
> Patch 3/3 provides default feature to delete all fs_devices in the list.
> 
> btrfs-progs:
> Patch 1/2 introduce 'btrfs dev deregister <device>'
> Patch 2/2 make the device optional and when not provided, deregisters all
> unmounted devices.
> 
> v2:
>    Accepted review from Nikolay, details are in the specific patch.
>    Patch 1/2 is renamed from
>      [PATCH 1/2] btrfs: refactor btrfs_free_stale_device() to get device list delete
>    to
>      [PATCH 1/2] btrfs: add function to device list delete
> v3:
>    No change. Send to correct ML.
> v4:
>    No change. But as the ML thread may be confusing, so resend.
> v5:
>    Mainly adds feature to deregister all unmounted devices.
>    Accepts review from David, for details ref change log.
> 
> Anand Jain (3):
>    btrfs: add function to device list delete
>    btrfs: introduce feature to deregister a btrfs device
>    btrfs: add feature to deregister all unmounted devices
> 
>   fs/btrfs/super.c           |   9 ++++
>   fs/btrfs/volumes.c         | 119 +++++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/volumes.h         |   3 ++
>   include/uapi/linux/btrfs.h |   9 +++-
>   4 files changed, 138 insertions(+), 2 deletions(-)
> 
> Anand Jain (2):
>    btrfs-progs: add 'btrfs device unregister' cli
>    btrfs-progs: add feature to deregister all devices
> 
>   cmds-device.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   ioctl.h       |  8 +++++-
>   2 files changed, 89 insertions(+), 1 deletion(-)
> 

