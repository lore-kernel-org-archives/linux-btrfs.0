Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:36165 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752651AbdKFVsv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 16:48:51 -0500
Reply-To: waxhead@dirtcellar.net
Subject: Re: Several questions regarding btrfs
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
References: <1509467347.1662.40.camel@gmail.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <d553c066-75b4-88d4-1c4f-e1362ce3d97a@dirtcellar.net>
Date: Mon, 6 Nov 2017 22:48:48 +0100
MIME-Version: 1.0
In-Reply-To: <1509467347.1662.40.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ST wrote:
> Hello,
>
> I've recently learned about btrfs and consider to utilize for my needs.
> I have several questions in this regard:
>
> I manage a dedicated server remotely and have some sort of script that
> installs an OS from several images. There I can define partitions and
> their FSs.
>
> 1. By default the script provides a small separate partition for /boot
> with ext3. Does it have any advantages or can I simply have /boot
> within / all on btrfs? (Note: the OS is Debian9)
>
I am on Debian as well and run /boot on multiple systems without any 
issues. Remember to run grub-install on all your disks and update-grub 
if you run it in a redundant setup. That way you can loose a disk and 
still be happy about it.
If you run a redundant setup like raid1 / raid10 make sure you have 
sufficient disks to avoid that the filesystem enters read-only mode. See 
the status page for details.

> 2. as for the / I get ca. following written to /etc/fstab:
> UUID=blah_blah /dev/sda3 / btrfs ...
> So top-level volume is populated after initial installation with the
> main filesystem dir-structure (/bin /usr /home, etc..). As per btrfs
> wiki I would like top-level volume to have only subvolumes (at least,
> the one mounted as /) and snapshots. I can make a snapshot of the
> top-level volume with / structure, but how can get rid of all the
> directories within top-lvl volume and keep only the subvolume
> containing / (and later snapshots), unmount it and then mount the
> snapshot that I took? rm -rf / - is not a good idea...
>
There are some tutorials floating around the web for this stuff. Just be 
careful, after a system update you might run into boot issues.
(I suggest you try playing with this in a VM first to see what happens)

> 3. in my current ext4-based setup I have two servers while one syncs
> files of certain dir to the other using lsyncd (which launches rsync on
> inotify events). As far as I have understood it is more efficient to use
> btrfs send/receive (over ssh) than rsync (over ssh) to sync two boxes.
> Do you think it would be possible to make lsyncd to use btrfs for
> syncing instead of rsync? I.e. can btrfs work with inotify events? Did
> somebody try it already?
> Otherwise I can sync using btrfs send/receive from within cron every
> 10-15 minutes, but it seems less elegant.
Have no idea, but since Debian uses systemd you might be able to cook up 
something with systemd.path 
(https://www.freedesktop.org/software/systemd/man/systemd.path.html

>
> 4. In a case when compression is used - what quota is based on - (a)
> amount of GBs the data actually consumes on the hard drive while in
> compressed state or (b) amount of GBs the data naturally is in
> uncompressed form. I need to set quotas as in (b). Is it possible? If
> not - should I file a feature request?
>
No, you should not file a feature request it seems.
Look what me and Google found for you :)
https://btrfs.wiki.kernel.org/index.php/Quota_support
(hint: read the "using limits" section)

> Thank you in advance!
No worries, good luck!
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
