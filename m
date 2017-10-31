Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:51026 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbdJaTH5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 15:07:57 -0400
Received: by mail-io0-f170.google.com with SMTP id 97so1102857iok.7
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 12:07:56 -0700 (PDT)
Subject: Re: Several questions regarding btrfs
To: Andrei Borzenkov <arvidjaar@gmail.com>, ST <smntov@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <1509467017.1662.37.camel@gmail.com>
 <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
 <5f581022-a570-30a8-3e1c-509af88b2a9d@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <71765ea7-8e89-7443-d3c3-f353965b64ec@gmail.com>
Date: Tue, 31 Oct 2017 15:07:53 -0400
MIME-Version: 1.0
In-Reply-To: <5f581022-a570-30a8-3e1c-509af88b2a9d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-31 14:51, Andrei Borzenkov wrote:
> 31.10.2017 20:45, Austin S. Hemmelgarn пишет:
>> On 2017-10-31 12:23, ST wrote:
>>> Hello,
>>>
>>> I've recently learned about btrfs and consider to utilize for my needs.
>>> I have several questions in this regard:
>>>
>>> I manage a dedicated server remotely and have some sort of script that
>>> installs an OS from several images. There I can define partitions and
>>> their FSs.
>>>
>>> 1. By default the script provides a small separate partition for /boot
>>> with ext3. Does it have any advantages or can I simply have /boot
>>> within / all on btrfs? (Note: the OS is Debian9)
>> It depends on the boot loader.  I think Debian 9's version of GRUB has
>> no issue with BTRFS, but see the response below to your question on
>> subvolumes for the one caveat.
>>>
>>> 2. as for the / I get ca. following written to /etc/fstab:
>>> UUID=blah_blah /dev/sda3 / btrfs ...
>>> So top-level volume is populated after initial installation with the
>>> main filesystem dir-structure (/bin /usr /home, etc..). As per btrfs
>>> wiki I would like top-level volume to have only subvolumes (at least,
>>> the one mounted as /) and snapshots. I can make a snapshot of the
>>> top-level volume with / structure, but how can get rid of all the
>>> directories within top-lvl volume and keep only the subvolume
>>> containing / (and later snapshots), unmount it and then mount the
>>> snapshot that I took? rm -rf / - is not a good idea...
>> There are three approaches to doing this, from a live environment, from
>> single user mode running with init=/bin/bash, or from systemd emergency
>> mode.  Doing it from a live environment is much safer overall, even if
>> it does take a bit longer.  I'm listing the last two methods here only
>> for completeness, and I very much suggest that you use the first (do it
>> from a live environment).
>>
>> Regardless of which method you use, if you don't have a separate boot
>> partition, you will have to create a symlink called /boot outside the
>> subvolume, pointing at the boot directory inside the subvolume, or
>> change the boot loader to look at the new location for /boot.
>>
>>  From a live environment, it's pretty simple overall, though it's much
>> easier if your live environment matches your distribution:
>> 1. Create the snapshot of the root, naming it what you want the
>> subvolume to be called (I usually just call it root, SUSE and Ubuntu
>> call it @, others may have different conventions).
>> 2. Delete everything except the snapshot you just created.  The safest
>> way to do this is to explicitly list each individual top-level directory
>> to delete.
>> 3. Use `btrfs subvolume list` to figure out the subvolume ID for the
>> subvolume you just created, and then set that as the default subvolume
>> with `btrfs subvolume set-default /path SUBVOLID`.  Once you do this,
>> you will need to specify subvolid=5 in the mount options to get the real
>> top-level subvolume.
> 
> Note that current grub2 works with absolute paths (relative to
> filesystem root). It means that if a) /boot/grub is on btrfs and b) it
> is part of snapshot that becomes new root, $prefix (that points to
> /boot/grub) in the first-stage grub2 image will be wrong. So to be on
> safe side you would want to reinstall grub2 after this change.
> 
Generally yes, though you can also make a symlink pointing to the boot 
directory under the new subvolume (snapshot), and things should work 
correctly as far as I know (this works on Gentoo, not sure about other 
distros though).
