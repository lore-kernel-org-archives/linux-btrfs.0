Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40884 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2LMIWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Dec 2012 03:22:32 -0500
Message-ID: <50C99065.9070402@cn.fujitsu.com>
Date: Thu, 13 Dec 2012 16:23:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Sylvain Alain <d2racing911@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Kernel 3.7 + slower snapshot then usual
References: <CACR_K2tqKJQMSG-h3RaH4nSbrQLdJqxr-JVXfU5pbwfRHeqRZg@mail.gmail.com>
In-Reply-To: <CACR_K2tqKJQMSG-h3RaH4nSbrQLdJqxr-JVXfU5pbwfRHeqRZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 12 Dec 2012 23:26:02 -0500, Sylvain Alain wrote:
> Hi guys, I noticed that now my snapshot take a long time to process :
> 
> sylvain@gentootux ~ $ df -h
> Sys. de fichiers Taille Utilisé Dispo Uti% Monté sur
> rootfs             112G    4,0G  103G   4% /
> /dev/sda4          112G    4,0G  103G   4% /
> tmpfs              7,9G    596K  7,9G   1% /run
> udev                10M       0   10M   0% /dev
> none               7,9G       0  7,9G   0% /dev/shm
> cgroup_root         10M       0   10M   0% /sys/fs/cgroup
> tmpfs               12G       0   12G   0% /var/tmp/portage
> /dev/sdb2          224G     52G  173G  23% /mnt/win_c
> /dev/sdc2          912G    412G  500G  46% /mnt/win_d
> 
> sylvain@gentootux ~ $ su -
> Mot de passe :
> 
> gentootux ~ # mount /dev/sda4 -o
> noatime,ssd,discard,compress=lzo,noacl,space_cache,subvolid=0
> /mnt/disklayout/
> 
> gentootux ~ # cd /mnt/disklayout/
> 
> gentootux disklayout # ls
> @backup  @racine
> 
> gentootux disklayout # time btrfs subvolume delete @backup
> Delete subvolume '/mnt/disklayout/@backup'
> 
> real 0m0.020s
> user 0m0.001s
> sys 0m0.002s
> gentootux disklayout # ls
> @racine
> 
> gentootux disklayout # time btrfs subvolume snapshot @racine @backup
> Create a snapshot of '@racine' in './@backup'
> 
> real 6m9.122s
> user 0m0.000s
> sys 0m0.523s
> 
> more then 6 minutes to snapshot 4 gigs of data, that's twice slower
> then kernel 3.6.
> 
> Is there any log or something that I look after ?
> 
> sylvain@gentootux ~ $ sudo dmesg | grep -i btrfs
> [    0.371528] Btrfs loaded
> [    0.784593] btrfs: disk space caching is enabled
> [    0.788680] Btrfs detected SSD devices, enabling SSD mode
> [    0.789757] VFS: Mounted root (btrfs filesystem) readonly on device 0:12.
> [    4.881241] btrfs: use ssd allocation scheme
> [    4.881244] btrfs: use lzo compression
> [    4.881245] btrfs: disk space caching is enabled
> [  496.982616] btrfs: unlinked 14 orphans

What kind of kernel did you use? mainline kernel?

Thanks
Miao
