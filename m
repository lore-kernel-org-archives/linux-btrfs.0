Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37911 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2LDHFt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2012 02:05:49 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so2623595pbc.19
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2012 23:05:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354246809-32339-2-git-send-email-filbranden@google.com>
References: <1354246809-32339-1-git-send-email-filbranden@google.com>
	<1354246809-32339-2-git-send-email-filbranden@google.com>
Date: Mon, 3 Dec 2012 23:05:49 -0800
Message-ID: <CADU+-uDHx13a1CUJzFEH46OXxyPS4wo74JgxEZbUAQVFt0w=nA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: fix permissions of empty files not affected by umask
From: Filipe Brandenburger <filbranden@google.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Any concerns on this patchset? Any chance it can be integrated in time
for 3.8 or too risky for it? The Bugzilla entry contains some test
cases that reproduce the issue fairly easily by unmounting the
filesystem right after creating an empty file... Let me know if there
are any extra fixes or tests you'd like me to provide.

Thanks,
Filipe

On Thu, Nov 29, 2012 at 7:40 PM, Filipe Brandenburger
<filbranden@google.com> wrote:
> When a new file is created with btrfs_create(), the inode will initially be
> created with permissions 0666 and later on in btrfs_init_acl() it will be
> adapted to mask out the umask bits. The problem is that this change won't make
> it into the btrfs_inode unless there's another change to the inode (e.g. writing
> content changing the size or touching the file changing the mtime.)
>
> This fix adds a call to btrfs_update_inode() to btrfs_create() to make sure that
> the change will not get lost if the in-memory inode is flushed before other
> changes are made to the file.
>
> Signed-off-by: Filipe Brandenburger <filbranden@google.com>
> ---
>  fs/btrfs/inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 95542a1..caf9d76 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4996,6 +4996,12 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
>                 goto out_unlock;
>         }
>
> +       err = btrfs_update_inode(trans, root, inode);
> +       if (err) {
> +               drop_inode = 1;
> +               goto out_unlock;
> +       }
> +
>         /*
>         * If the active LSM wants to access the inode during
>         * d_instantiate it needs these. Smack checks to see
> --
> 1.7.11.7
>
