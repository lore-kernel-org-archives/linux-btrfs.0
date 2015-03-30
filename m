Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from oul135-36.netplaza.fi ([80.75.100.36]:37566 "EHLO
	lime.offcode.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751897AbbC3Jfu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 05:35:50 -0400
Message-ID: <551917A3.3080203@offcode.fi>
Date: Mon, 30 Mar 2015 12:30:11 +0300
From: Timo Kokkonen <timo.kokkonen@offcode.fi>
MIME-Version: 1.0
To: Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: prevent deletion of mounted subvolumes
References: <64e28e67cbab0a2cd97411b848911414a743d83f.1427705646.git.osandov@osandov.com>
In-Reply-To: <64e28e67cbab0a2cd97411b848911414a743d83f.1427705646.git.osandov@osandov.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30.03.2015 12:02, Omar Sandoval wrote:
> Before commit bafc9b754f75 ("vfs: More precise tests in d_invalidate"),
> d_invalidate() could return -EBUSY when a dentry for a directory had
> more than one reference to it. This is what prevented a mounted
> subvolume from being deleted, as struct vfsmount holds a reference to
> the subvolume dentry. However, that commit removed that case, and later
> commits in that patch series removed the return code from d_invalidate()
> completely, so we don't get that check for free anymore. So, reintroduce
> it in btrfs_ioctl_snap_destroy().
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=93021
> Reported-by: Timo Kokkonen <timo.kokkonen@offcode.fi>
> Fixes: bafc9b754f75 ("vfs: More precise tests in d_invalidate")
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Tested-by: Timo Kokkonen <timo.kokkonen@offcode.fi>

Thank you

-Timo

> ---
> This applies to 4.0-rc6. To be honest, I'm not sure that this is the most
> correct fix for this bug, but it's equivalent to the pre-3.18 behavior and it's
> the best that I could come up with. Thoughts?
>
>   fs/btrfs/ioctl.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 74609b9..39b0538 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2384,6 +2384,12 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>   		goto out_dput;
>   	}
>
> +	spin_lock(&dentry->d_lock);
> +	err = dentry->d_lockref.count > 1 ? -EBUSY : 0;
> +	spin_unlock(&dentry->d_lock);
> +	if (err)
> +		goto out_dput;
> +
>   	mutex_lock(&inode->i_mutex);
>
>   	/*
>

