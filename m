Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46024 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751603AbdCHMYa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 07:24:30 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 989BAADA7
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Mar 2017 12:03:28 +0000 (UTC)
Subject: Re: mount policy for subvols if root is remount,ro
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <b390c27c-224b-b48b-eec3-218635f90a0e@suse.de>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <5efccd0d-7846-b077-c7f9-e2a746fea5d4@suse.de>
Date: Wed, 8 Mar 2017 06:03:26 -0600
MIME-Version: 1.0
In-Reply-To: <b390c27c-224b-b48b-eec3-218635f90a0e@suse.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/07/2017 07:59 AM, Goldwyn Rodrigues wrote:
> Hi,
> 
> I want to know if re-mounting the root filesystem read-only should
> change subvolumes mounted as read-write to read-only as well? We do
> allow mounting subvolumes RW _after_ the root filesystem is mounted RO.
> 
>  # mount /dev/vdb /mnt
>  # mount -o ro,subvol=svro /dev/vdb /mnt/svro
>  # mount -o rw,subvol=svrw /dev/vdb /mnt/svrw
>  # mount -o remount,ro /dev/vdb /mnt
>  # touch /mnt/f3
> touch: cannot touch '/mnt/f3': Read-only file system
> 
> Changes subvolume to read-only as well.
>  # touch /mnt/svrw/f3
> touch: cannot touch '/mnt/svrw/f3': Read-only file system
> 
> However, remount of subvol as RW after remount,ro of root works:
>  # mount -o remount,rw,subvol=svrw /dev/vdb /mnt/svrw
>  # touch /mnt/svrw/f3
> 

Just to add, if you remount any one subvolume to read-only, all
subvolumes turn read-only.

 # mount /dev/vdb /mnt
 # mount -o subvol=svro /dev/vdb /mnt/svro
 # mount -o subvol=svrw /dev/vdb /mnt/svrw
 # mount | grep mnt
/dev/vdb on /mnt type btrfs (rw,relatime,space_cache,subvolid=5,subvol=/)
/dev/vdb on /mnt/svro type btrfs
(rw,relatime,space_cache,subvolid=257,subvol=/svro)
/dev/vdb on /mnt/svrw type btrfs
(rw,relatime,space_cache,subvolid=258,subvol=/svrw)

 # mount -o remount,ro /dev/vdb /mnt/svro
 # mount | grep mnt
/dev/vdb on /mnt type btrfs (ro,relatime,space_cache,subvolid=5,subvol=/)
/dev/vdb on /mnt/svro type btrfs
(ro,relatime,space_cache,subvolid=257,subvol=/svro)
/dev/vdb on /mnt/svrw type btrfs
(ro,relatime,space_cache,subvolid=258,subvol=/svrw)




-- 
Goldwyn
