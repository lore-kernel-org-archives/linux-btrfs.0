Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30962 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609AbaJFN3b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 09:29:31 -0400
Message-ID: <54329935.7080404@fb.com>
Date: Mon, 6 Oct 2014 09:29:25 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: <guaneryu@gmail.com>
Subject: Re: [PATCH] btrfs: Make btrfs handle security mount options internally
 to avoid losing security label.
References: <1411450808-14988-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1411450808-14988-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/23/2014 01:40 AM, Qu Wenruo wrote:
> [BUG]
> Originally when mount btrfs with "-o subvol=" mount option, btrfs will
> lose all security lable.
> And if the btrfs fs is mounted somewhere else, due to the lost of
> security lable, SELinux will refuse to mount since the same super block
> is being mounted using different security lable.
>
> [REPRODUCER]
> With SELinux enabled:
>   #mkfs -t btrfs /dev/sda5
>   #mount -o context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/btrfs
>   #btrfs subvolume create /mnt/btrfs/subvol
>   #mount -o subvol=subvol,context=system_u:object_r:nfs_t:s0 /dev/sda5
>    /mnt/test
>
> kernel message:
> SELinux: mount invalid.  Same superblock, different security settings
> for (dev sda5, type btrfs)
>
> [REASON]
> This happens because btrfs will call vfs_kern_mount() and then
> mount_subtree() to handle subvolume name lookup.
> First mount will cut off all the security lables and when it comes to
> the second vfs_kern_mount(), it has no security label now.
>
> [FIX]
> This patch will makes btrfs behavior much more like nfs,
> which has the type flag FS_BINARY_MOUNTDATA,
> making btrfs handles the security label internally.
> So security label will be set in the real mount time and won't lose
> label when use with "subvol=" mount option.
>

Please make this an xfstest, I'm going to change how subvols are mounted 
in a bit and I'd like to make sure I don't break anything.  Thanks,

Josef

