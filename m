Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:60754 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbcGFNfa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 09:35:30 -0400
Subject: Re: [PATCH] btrfs-progs: du: fix to skip not btrfs dir/file
To: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
References: <1467807934-23403-1-git-send-email-wangshilong1991@gmail.com>
Cc: dsterba@suse.cz
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <577D091F.6020407@applied-asynchrony.com>
Date: Wed, 6 Jul 2016 15:35:27 +0200
MIME-Version: 1.0
In-Reply-To: <1467807934-23403-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/06/16 14:25, Wang Shilong wrote:
> 'btrfs file du' is a very useful tool to watch my system
> file usage with snapshot aware.
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
> skipping not btrfs dir/file: boot
> skipping not btrfs dir/file: dev
> skipping not btrfs dir/file: proc
> skipping not btrfs dir/file: run
> skipping not btrfs dir/file: sys
>      0.00B       0.00B           -  //root/.bash_logout
>      0.00B       0.00B           -  //root/.bash_profile
>      0.00B       0.00B           -  //root/.bashrc
>      0.00B       0.00B           -  //root/.cshrc
>      0.00B       0.00B           -  //root/.tcshrc
> 
> This works for me to analysis system usage and analysis
> performaces.

This is great, but can we please skip the "skipping .." messages?
Maybe it's just me but I really don't see the value of printing them
when they don't contribute to the result.
They also mess up the display. :)

thanks,
Holger

