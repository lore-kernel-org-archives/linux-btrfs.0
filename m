Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:34059 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbbBEC1S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 21:27:18 -0500
Received: by mail-yk0-f170.google.com with SMTP id q9so2206913ykb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Feb 2015 18:27:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <mau7vs$pjj$1@ger.gmane.org>
References: <mau7vs$pjj$1@ger.gmane.org>
Date: Wed, 4 Feb 2015 19:27:17 -0700
Message-ID: <CAJCQCtSXJZ4paKiZBNDOp-yKccrLbizmGDj_8y5k5EC-9DFjXg@mail.gmail.com>
Subject: Re: Btrfs subvolume question
From: Chris Murphy <lists@colorremedies.com>
To: Markus Moeller <huaraz@moeller.plus.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 4, 2015 at 3:54 PM, Markus Moeller <huaraz@moeller.plus.com> wrote:
> Hi ,
>
>   I am new to btrfs and wonder what I need to do to move subvolumes to the
> right filesystem.  I see the following:
>
> df -h
> Filesystem                       Size  Used Avail Use% Mounted on
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /
> devtmpfs                         235M  8.0K  235M   1% /dev
> tmpfs                            242M   84K  242M   1% /dev/shm
> tmpfs                            242M  2.4M  240M   1% /run
> tmpfs                            242M     0  242M   0% /sys/fs/cgroup
> /dev/mapper/system_13.2-usr_lv    18G  6.9G   10G  41% /usr
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /srv
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /.snapshots
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /tmp
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /usr/local
> /dev/sda2                        486M   59M  398M  13% /boot
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32%
> /boot/grub2/x86_64-efi
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /boot/grub2/i386-pc
> /dev/mapper/export_vg-export_lv   20G   18G  2.9G  86% /export
> /dev/mapper/export_vg-src_lv     5.0G  2.6G  2.5G  51% /src
> /dev/mapper/system_13.2-var_lv   4.0G  196M  3.4G   6% /var
> /dev/mapper/system_13.2-opt_lv   6.0G  152M  5.3G   3% /opt
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/spool
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/tmp
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/opt
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/log
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/lib/named
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/lib/mailman
> /dev/mapper/system_13.2-root_lv  5.0G  1.5G  3.2G  32% /var/lib/pgsql
>
>
> and I would like to have all the var subvolumes using the /var filesystem
> space and not root.  The same for /boot/grub2 subvolumes. They should use
> the /boot filesystem.

The giveaway is in the first column. All of these are device mapper
LVM LV's, they are not Btrfs subvolumes, in fact they're separate
Btrfs volumes (unique, unrelated filesystems). What's suspicious,
though, is that a bunch of these LV's have exactly 1.5G Used, which
makes no sense. For example, /boot/grub2/i386-pc has 1.5G used, but
that's not possible, the entire GRUB2 package is maybe 50MB.

Honestly, I suggest reinstalling and don't deal with the tricky task
of converting all of this. It'll take longer for me to explain, and
you to read, how to fix this without reinstalling. I also suggest
making sure that you don't put Btrfs on LVM, there's no good reason to
do this for most use cases.


 I don't know how I got to this and don't know how to
> change.

It's not your fault. This is a pathological side effect of openSUSE
13.2's, quite frankly bizarre, layout. By default it creates a single
Btrfs volume, and makes all of these subvolumes, which is strange
enough on its own because it's overly complicated (just look at
/etc/fstab) for no good reason. But somehow in your case, you ended up
with a bunch of LVM LVs first, and then each of those is a Btrfs
volume. If it were me, I'd file a bug report against 13.2, and then
file a feature request citing the bug report. If you don't want to do
both, then just file the feature request against Factory because
installer related bug reports on openSUSE basically get rejected
seeing as there's nothing that can be done about it in Distribution
now anyway.

-- 
Chris Murphy
