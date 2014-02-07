Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41167 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaBGFvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 00:51:35 -0500
Received: by mail-pa0-f51.google.com with SMTP id ld10so2741736pab.10
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 21:51:35 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: user creation/deletion of snapshots permissions bug
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <2524068.SeylZtQnKR@russell.coker.com.au>
Date: Fri, 7 Feb 2014 13:51:31 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <215B90D2-64B9-4A94-BE76-89260704EBB7@gmail.com>
References: <2524068.SeylZtQnKR@russell.coker.com.au>
To: russell@coker.com.au
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> $ /sbin/btrfs subvol create /tmp/test
> Create subvolume '/tmp/test'
> $ /sbin/btrfs subvol delete /tmp/test
> Delete subvolume '/tmp/test'
> ERROR: cannot delete '/tmp/test' - Operation not permitted

That is a little strange anyway. Looking into codes, i found
For sub-volume creation, we don't check CAP_SYS_ADMIN while
For sub-voule deletion, we do check CAP_SYS_ADMIN, however, we still have
a mount option "user_rm_subvol_allowed" to delete a sub-volume by regular users!

IMO, this is a little confusing and arguable. i see there are some discussion by googling, for example:

http://unix.stackexchange.com/questions/88932/why-cant-a-regular-user-delete-a-btrfs-subvolume

Thanks,
Wang
> 
> The above is when running Debian kernel 3.12 based on Linux upstream 3.12.8.  
> I believe that the BTRFS kernel code should do a capabilities check for 
> CAP_SYS_ADMIN (which is used for mount/umount among many other things) before 
> creating a snapshot.  Currently it appears that the only access control is 
> write access to the parent directory.
> 
> There is some possibility of debate about the access control needed for 
> creating a subvol.  I want to use capabilities set by SE Linux policy to 
> prevent unwanted actions by hostile root processes and I think that such use 
> of capabilities (which is used by more than just SE Linux) should be 
> supported.  I don't think that there is any downside to such checks.
> 
> In any case allowing a subvol to be created but not deleted with the same 
> level of access is obviously a bug.
> 
> -- 
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

