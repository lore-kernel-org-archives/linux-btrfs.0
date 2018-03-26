Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:47450 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751107AbeCZTpR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 15:45:17 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v2 0/3] Allow rmdir(2) to delete a subvolume
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <ea15ef98-3668-b2bc-079c-439ec512ae76@jp.fujitsu.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <298c2f6e-285e-dfd9-cee4-3d13f8a66719@libero.it>
Date: Mon, 26 Mar 2018 21:45:15 +0200
MIME-Version: 1.0
In-Reply-To: <ea15ef98-3668-b2bc-079c-439ec512ae76@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Misono,

On 03/26/2018 10:28 AM, Misono Tomohiro wrote:
> changelog:
>   v1 -> v2 ... split the patch to hopefully make review easier
> 
> 1st patch is a preparation work just moving the declaration of
> may_destroy_subvol().
> 
> 2nd patch is the main part. New function btrfs_delete_subvolume() is
> introduced and used in btrfs_rmdir() when a direcoty is an empty
> subvolume. The function is almost the copy of second half of
> btrfs_ioctl_snap_destroy().
> The code path for "sub delete" is not changed yet.
> 
> 3rd patch is a cleanup of btrfs_ioctl_snap_destroy() and uses 
> brrfs_delete_subvolume() for "sub delete" too.
> 
> Tomohiro Misono (3):
>   btrfs: move may_destroy_subvol() from ioctl.c to inode.c
>   btrfs: Allow rmdir(2) to delete a subvolume
>   btrfs: cleanup btrfs_ioctl_snap_destroy() by using btrfs_delete_subvolume()
> 
>  fs/btrfs/ctree.h |   5 +-
>  fs/btrfs/inode.c | 199 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/ioctl.c | 185 +--------------------------------------------------
>  3 files changed, 200 insertions(+), 189 deletions(-)
> 

I checked this patch, and it works. You can add
Tested-by: Goffredo Baroncelli <kreijack@inwind.it>

---------

ghigo@venice:/tmp$ btrfs sub cre a
Create subvolume './a'
ghigo@venice:/tmp$ btrfs sub cre a/b
Create subvolume 'a/b'
ghigo@venice:/tmp$ btrfs sub cre a/b/d
Create subvolume 'a/b/d'
ghigo@venice:/tmp$ touch a/b/d/c
ghigo@venice:/tmp$ rm -rf a
ghigo@venice:/tmp$ ls -la
total 4
drwxrwxrwt 1 root  root  492 Mar 26 21:18 .
drwxr-xr-x 1 root  root  196 Mar 14 19:41 ..
drwxrwxrwt 1 root  root    0 Mar 26 21:17 .font-unix
drwxrwxrwt 1 root  root    8 Mar 26 21:18 .ICE-unix
drwxrwxrwt 1 root  root    0 Mar 26 21:17 .Test-unix
-r--r--r-- 1 root  root   11 Mar 26 21:17 .X0-lock
drwxrwxrwt 1 root  root    4 Mar 26 21:17 .X11-unix
drwxrwxrwt 1 root  root    0 Mar 26 21:17 .XIM-unix



ghigo@venice:/tmp$ btrfs sub crea a
Create subvolume './a'
ghigo@venice:/tmp$ touch a/b
ghigo@venice:/tmp$ rmdir a
rmdir: failed to remove 'a': Directory not empty
ghigo@venice:/tmp$ rm a/b 
ghigo@venice:/tmp$ rmdir a



ghigo@venice:/tmp$ btrfs sub cre d
Create subvolume './d'
ghigo@venice:/tmp$ su - pippo
Password: 
pippo@venice:~$ cd /tmp/
pippo@venice:/tmp$ rmdir d
rmdir: failed to remove 'd': Operation not permitted
pippo@venice:/tmp$ sudo chown pippo d
[sudo] password for pippo: 
pippo@venice:/tmp$ rmdir d

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
