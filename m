Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32451 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaBLDhm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 22:37:42 -0500
Message-ID: <52FAEC7F.4050707@oracle.com>
Date: Wed, 12 Feb 2014 11:37:35 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs multiple mounts stacked on the same mount point
References: <52F9DCBA.1010002@oracle.com> <pan$9211b$42bef7b0$dd1350ae$978558c5@cox.net>
In-Reply-To: <pan$9211b$42bef7b0$dd1350ae$978558c5@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Thanks.

  In the context of btrfs,
   what is the critical need of this feature ?
    OR
   what is that it can't do without this feature ?

Thanks, Anand


On 02/12/14 04:57 AM, Duncan wrote:
> Anand Jain posted on Tue, 11 Feb 2014 16:18:02 +0800 as excerpted:
>
>> per mount(2)
>>
>>    ---
>>     multiple mounts can be stacked on the same mount point.
>>    ---
>>
>>    In this situation how could ioctl communicate (using mount point) with
>>    each FS stacked on the same mount point ?
>>
>>    BTW I don't understand the need for multiple mounts on the same mount
>>    point ?
>
> The most common case of multiple over-mounts is almost certainly the
> kernel's built-in rootfs in RAM, usually as an initramfs or initrd, with
> real-root often directly over-mounted the same mountpoint, tho it can
> also be mounted elsewhere on the initramfs.
>
> The various union-filesystem solutions also directly use over-mounting,
> with the read-only mount often directly over-mounted with the writable
> but semi-transparent overlay, such that if a file hasn't changed from the
> read-only version on the under-mount, that's the version that gets used.
>
> Otherwise, over-mounts generally obscure what's underneath them, making
> direct access to it impossible, unless that underneath filesystem is bind-
> mounted elsewhere.
>
> (Which is actually how I backup my root filesystem, using a bind-mount to
> mount it elsewhere for the backup, so for instance the /dev/console and
> /dev/null device nodes located directly on root get copied over to my
> backup root as well, instead of the devtmpfs content otherwise over-
> mounted on /dev.)
>
> That principle of over-mount obscuring what's beneath it should apply to
> the ioctls as well.  They will always communicate with the top mounted
> layers.  To communicate with anything underneath, the over-mounting
> layers will either need umounted, or (if it's not the exact same
> mountpoint, which might have been your point) a bind-mount of the under-
> mount can be used.
>
> But an over-mount obscuring under-mounts is how Linux (and I believe POSIX
> in general) normally works.  (The semi-transparent union-filesystem
> solutions mentioned above thus being exceptions with those exceptions
> being the hairy bits, that explaining the several implementations with
> their various limitations and bugs.)  So not being able to access under-
> mounts is the normal state of affairs. =:^)
>
