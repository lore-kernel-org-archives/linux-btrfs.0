Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33876 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbcBPPvZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 10:51:25 -0500
Received: by mail-ig0-f176.google.com with SMTP id g6so34117090igt.1
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 07:51:25 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <56C3428D.1010000@canonical.com>
References: <56C3428D.1010000@canonical.com>
Date: Tue, 16 Feb 2016 15:51:25 +0000
Message-ID: <CAL3q7H7XVLTHrv+tdNiF4W=VZGNQ9S3dNNdh1wvHkPjYZ0QhkQ@mail.gmail.com>
Subject: Re: BZ#101951, Overlayfs on top of btrfs causes kernel oops + freeze
From: Filipe Manana <fdmanana@gmail.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 16, 2016 at 3:38 PM, Colin Ian King
<colin.king@canonical.com> wrote:
> Hi there,
>
> bug: https://bugzilla.kernel.org/show_bug.cgi?id=101951 and also
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1532145
>
> Commit 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 ("overlayfs: Make f_path
> always point to the overlay and f_inode to the underlay") resulted in an
> issue when using a combination of btrfs and overlayfs.  This is
> noticeable when doing a fsync() on a file in a chroot with overlayfs on
> top of btrfs; we hit a kernel oops in btrfs_sync_file() on
> atomic_inc(&root->log_batch) because root is NULL.
>
> I've debugged this further and found that in btrfs_sync_file():
>
>         struct inode *inode = d_inode(dentry);
>
> does not return the inode I expected when using the stacked overlay fs,
> where as:
>
>         struct inode *inode = file_inode(file);
>
> does.

See the discussion at
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg48131.html

You can get along with file_inode() in btrfs_sync_file(), but not
later the fsync code path where we traverse the hierarchy up using
dentries.
More details on that thread.

>
> However, I'm not well at all well versed in btrfs, so I am not confident
> this is a actually correct.  Any comments?
>
> Colin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
