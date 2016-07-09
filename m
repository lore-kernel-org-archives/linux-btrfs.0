Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35974 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbcGIFxx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Jul 2016 01:53:53 -0400
Received: by mail-lf0-f67.google.com with SMTP id a2so8684238lfe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 22:53:53 -0700 (PDT)
Subject: Re: [PATCH v2] btrfs-progs: du: fix to skip not btrfs dir/file
To: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <5780916E.3040508@gmail.com>
Date: Sat, 9 Jul 2016 08:53:50 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

07.07.2016 12:43, Wang Shilong пишет:
> 'btrfs file du' is a very useful tool to watch my system
> file usage information with snapshot aware.
> 
> when trying to run following commands:
> [root@localhost btrfs-progs]# btrfs file du /
>      Total   Exclusive  Set shared  Filename
> ERROR: Failed to lookup root id - Inappropriate ioctl for device
> ERROR: cannot check space of '/': Unknown error -1
> 
> and My Filesystem looks like this:
> [root@localhost btrfs-progs]# df -Th
> Filesystem     Type      Size  Used Avail Use% Mounted on
> devtmpfs       devtmpfs   16G     0   16G   0% /dev
> tmpfs          tmpfs      16G  368K   16G   1% /dev/shm
> tmpfs          tmpfs      16G  1.4M   16G   1% /run
> tmpfs          tmpfs      16G     0   16G   0% /sys/fs/cgroup
> /dev/sda3      btrfs      60G   19G   40G  33% /
> tmpfs          tmpfs      16G  332K   16G   1% /tmp
> /dev/sdc       btrfs     2.8T  166G  1.7T   9% /data
> /dev/sda2      xfs       2.0G  452M  1.6G  23% /boot
> /dev/sda1      vfat      1.9G   11M  1.9G   1% /boot/efi
> tmpfs          tmpfs     3.2G   24K  3.2G   1% /run/user/1000
> 
> So I installed Btrfs as my root partition, but boot partition
> can be other fs.
> 
> We can Let btrfs tool aware of this is not a btrfs file or
> directory and skip those files, so that someone like me
> could just run 'btrfs file du /' to scan all btrfs filesystems.
> 
> After patch, it will look like:
>    Total   Exclusive  Set shared  Filename
>      0.00B       0.00B           -  //root/.bash_logout
>      0.00B       0.00B           -  //root/.bash_profile
>      0.00B       0.00B           -  //root/.bashrc
>      0.00B       0.00B           -  //root/.cshrc
>      0.00B       0.00B           -  //root/.tcshrc
> 

Can you avoid double slashes?


