Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58826 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab2EYLbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 07:31:10 -0400
Received: by pbbrp8 with SMTP id rp8so1648739pbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 04:31:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB9VWqAcuCSE8=Kr6+P6vUPjY4TXNmz7ExHhQYSge=jcCoC+8A@mail.gmail.com>
References: <CAB9VWqAcuCSE8=Kr6+P6vUPjY4TXNmz7ExHhQYSge=jcCoC+8A@mail.gmail.com>
Date: Fri, 25 May 2012 13:31:09 +0200
Message-ID: <CAB9VWqCTLAiwYV9XPoKp6HuCZ9hLHB-TU1WJ2MGxBS4s9w8Awg@mail.gmail.com>
Subject: Re: [BUG] atime on ro snapshots is updated when it should not
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David just pointed me to the update_time patches from Josef. When these
get into the kernel, the RO snapshot + atime problem could be easily fixed.

Any idea when those get into the kernel?

On Thu, May 24, 2012 at 7:12 PM, Alexander Block
<ablock84@googlemail.com> wrote:
> Hello,
>
> if a snapshot was created with -r and thus is read only, accessing
> files in it will update the atime. I would expect that atime is not
> updated on ro snapshots.
>
> I tried to find out where the ro check is missing. The problem seems
> to be that the vfs is only checking the mount, super block and
> i_flags.
> As it has no clue about subvolumes, it never checks them. My temporary
> solution for me to continue working is atm the patch at the end of
> this mail.
> Is anyone with more vfs experience able to fix this in a better way?
>
> Thanks,
> Alex.
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 3524978..6f126e0 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -115,6 +115,10 @@ void btrfs_update_iflags(struct inode *inode)
>                inode->i_flags |= S_NOATIME;
>        if (ip->flags & BTRFS_INODE_DIRSYNC)
>                inode->i_flags |= S_DIRSYNC;
> +
> +       if (btrfs_root_readonly(ip->root)) {
> +               inode->i_flags |= S_NOATIME;
> +       }
>  }
