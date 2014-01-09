Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61736 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbaAICLh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 21:11:37 -0500
Message-ID: <52CE051A.101@cn.fujitsu.com>
Date: Thu, 09 Jan 2014 10:10:34 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Felix Blanke <felixblanke@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Problems with incremental send/receive
References: <CAFTPBcJ3HHLm_ecxvjB5+ZnD+_s1uMCef_xAjD7tbp9SXgED8A@mail.gmail.com>
In-Reply-To: <CAFTPBcJ3HHLm_ecxvjB5+ZnD+_s1uMCef_xAjD7tbp9SXgED8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Felix,

It seems some reported this problem before. The problem for your below case
is because you use latest btrfs-progs(v3.12?), which will need kernel 
update,
kernel 3.12 is ok.

However, i think btrfs-progs should keep compatibility, i will send a 
patch to
make things more friendly.

Thanks,
Wang
On 01/09/2014 06:04 AM, Felix Blanke wrote:
> Hi List,
>
> My backup stopped working and I can't figure out why. I'm using
> send/receive with the "-p" switch for incremental backups using the
> last snapshot as a parent snapshot for sending only the changed data.
>
> The problem occurs using my own backup script. After I discovered the
> problem I did a quick test using the exact commands from the wiki with
> the same result: It doesn't work. Here is the output:
>
>
> server ~ # ./test_snapshot.sh
> ++ btrfs subvolume snapshot -r /mnt/root1/@root_home/ /mnt/root1/snapshots/test
> Create a readonly snapshot of '/mnt/root1/@root_home/' in
> '/mnt/root1/snapshots/test'
> ++ sync
> ++ btrfs send /mnt/root1/snapshots/test
> ++ btrfs receive /mnt/backup1/
> At subvol /mnt/root1/snapshots/test
> At subvol test
> ++ btrfs subvolume snapshot -r /mnt/root1/@root_home/
> /mnt/root1/snapshots/test_new
> Create a readonly snapshot of '/mnt/root1/@root_home/' in
> '/mnt/root1/snapshots/test_new'
> ++ sync
> ++ btrfs send -p /mnt/root1/snapshots/test /mnt/root1/snapshots/test_new
> ++ btrfs receive /mnt/backup1/
> At subvol /mnt/root1/snapshots/test_new
> At snapshot test_new
> ERROR: open @/test failed. No such file or directory
>
> I don't get where the "@/" in front of the snapshot name comes from.
> It could be that I had a subvolume named @, but this doesn't exists
> anymore and I don't understand why this would be important for the
> send/receive.
>
> Some more details about the fs:
>
> server ~ # btrfs subvol list /mnt/root1/
> ID 259 gen 568053 top level 5 path @root
> ID 261 gen 568053 top level 5 path @var
> ID 263 gen 568049 top level 5 path @home
> ID 302 gen 568053 top level 5 path @owncloud_chroot
> ID 421 gen 568038 top level 5 path @root_home
> ID 30560 gen 563661 top level 5 path snapshots/home_2014-01-06-19:33_d
> ID 30561 gen 563665 top level 5 path
> snapshots/owncloud_chroot_2014-01-06-19:34_d
> ID 30562 gen 563674 top level 5 path snapshots/root_home_2014-01-06-19:38_d
> ID 30563 gen 563675 top level 5 path snapshots/var_2014-01-06-19:39_d
> ID 30564 gen 563697 top level 5 path snapshots/root_2014-01-06-19:50_d
>
> server ~ # btrfs subvol get-default /mnt/root1/
> ID 5 (FS_TREE)
>
> server ~ # ls -l /mnt/root1/
> total 0
> drwxr-xr-x. 1 root root  30 May 10  2013 @home
> drwxr-xr-x. 1 root root 134 Jan  5 19:27 @owncloud_chroot
> drwxr-xr-x. 1 root root 204 Nov 24 18:16 @root
> drwx------. 1 root root 468 Jan  8 22:47 @root_home
> drwxr-xr-x. 1 root root 114 Oct  7 17:39 @var
> drwx------. 1 root root 420 Jan  8 22:50 snapshots
>
>
> Any ideas? Thanks in advance.
>
>
> Regards,
> Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
>

