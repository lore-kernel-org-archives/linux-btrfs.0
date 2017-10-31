Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:49428 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932831AbdJaSvU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 14:51:20 -0400
Received: by mail-lf0-f44.google.com with SMTP id w21so20238076lfc.6
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 11:51:19 -0700 (PDT)
Subject: Re: Several questions regarding btrfs
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, ST <smntov@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <1509467017.1662.37.camel@gmail.com>
 <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <5f581022-a570-30a8-3e1c-509af88b2a9d@gmail.com>
Date: Tue, 31 Oct 2017 21:51:16 +0300
MIME-Version: 1.0
In-Reply-To: <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

31.10.2017 20:45, Austin S. Hemmelgarn пишет:
> On 2017-10-31 12:23, ST wrote:
>> Hello,
>>
>> I've recently learned about btrfs and consider to utilize for my needs.
>> I have several questions in this regard:
>>
>> I manage a dedicated server remotely and have some sort of script that
>> installs an OS from several images. There I can define partitions and
>> their FSs.
>>
>> 1. By default the script provides a small separate partition for /boot
>> with ext3. Does it have any advantages or can I simply have /boot
>> within / all on btrfs? (Note: the OS is Debian9)
> It depends on the boot loader.  I think Debian 9's version of GRUB has
> no issue with BTRFS, but see the response below to your question on
> subvolumes for the one caveat.
>>
>> 2. as for the / I get ca. following written to /etc/fstab:
>> UUID=blah_blah /dev/sda3 / btrfs ...
>> So top-level volume is populated after initial installation with the
>> main filesystem dir-structure (/bin /usr /home, etc..). As per btrfs
>> wiki I would like top-level volume to have only subvolumes (at least,
>> the one mounted as /) and snapshots. I can make a snapshot of the
>> top-level volume with / structure, but how can get rid of all the
>> directories within top-lvl volume and keep only the subvolume
>> containing / (and later snapshots), unmount it and then mount the
>> snapshot that I took? rm -rf / - is not a good idea...
> There are three approaches to doing this, from a live environment, from
> single user mode running with init=/bin/bash, or from systemd emergency
> mode.  Doing it from a live environment is much safer overall, even if
> it does take a bit longer.  I'm listing the last two methods here only
> for completeness, and I very much suggest that you use the first (do it
> from a live environment).
> 
> Regardless of which method you use, if you don't have a separate boot
> partition, you will have to create a symlink called /boot outside the
> subvolume, pointing at the boot directory inside the subvolume, or
> change the boot loader to look at the new location for /boot.
> 
> From a live environment, it's pretty simple overall, though it's much
> easier if your live environment matches your distribution:
> 1. Create the snapshot of the root, naming it what you want the
> subvolume to be called (I usually just call it root, SUSE and Ubuntu
> call it @, others may have different conventions).
> 2. Delete everything except the snapshot you just created.  The safest
> way to do this is to explicitly list each individual top-level directory
> to delete.
> 3. Use `btrfs subvolume list` to figure out the subvolume ID for the
> subvolume you just created, and then set that as the default subvolume
> with `btrfs subvolume set-default /path SUBVOLID`.  Once you do this,
> you will need to specify subvolid=5 in the mount options to get the real
> top-level subvolume.

Note that current grub2 works with absolute paths (relative to
filesystem root). It means that if a) /boot/grub is on btrfs and b) it
is part of snapshot that becomes new root, $prefix (that points to
/boot/grub) in the first-stage grub2 image will be wrong. So to be on
safe side you would want to reinstall grub2 after this change.
