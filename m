Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:40723 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaDUTNV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 15:13:21 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so3867067eek.34
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Apr 2014 12:13:19 -0700 (PDT)
Received: from [192.168.1.229] (188-195-1-249-dynip.superkabel.de. [188.195.1.249])
        by mx.google.com with ESMTPSA id a4sm106027462eep.12.2014.04.21.12.13.17
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Apr 2014 12:13:17 -0700 (PDT)
Message-ID: <53556DCC.3000108@gmail.com>
Date: Mon, 21 Apr 2014 21:13:16 +0200
From: Andreas Reis <andreas.reis@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Bug: "corrupt leaf. slot offset bad": root subvolume unmountable,
 "btrfs check" crashes
References: <53554469.5070503@gmail.com>
In-Reply-To: <53554469.5070503@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alright, turns out the partition does actually mount on 3.15-rc2 (error 
messages remain, of course).

But systemd will fail to continue booting as /bin/mount returns "exit 
status 32" and / thus ends as ro, yet can be manually remounted as rw.

Another error message I've spotted with 3.15 is

BTRFS error (device sdc5): error loading props for ino 1810424 (root 
257): -5

I've now tried to mount with -o recovery and clear_cache, no effect.

On 21.04.2014 18:16, Andreas Reis wrote:
> Kernel 3.15.0-rc2, btrfs-progs 3.14.1
>
> While doing some minor package updates my btrfs root partition [*]
> decided to corrupt itself. There was no system crash, although I had
> plenty of these (due to an USB-related regression) in recent weeks that
> resulted in no trouble.
>
> First only one of a package's folders was corrupted, any access to files
> within (incl. attempts to delete) printed
>
> btrfs: corrupt leaf, slot offset bad: block=842924032,root=1, slot=88
>
> to dmesg (I'm actually not sure about the numbers, but that was indeed
> the error message). After moving the folder out of the way the partition
> continued to appear working as normal, one reboot also worked fine.
>
> Now I can't boot at all (beyond loading the kernel image located on
> another partition), neither with 3,15-rc2 nor 3.14.1. Attempting to
> mount the __current/ROOT subvolume on ArchLinux's current Live-CD
> (kernel 3.13.7) prints
>
> btrfs: device label Linux devid 1 transid 55586 /dev/sdc5
> btrfs: use ssd allocation scheme
> btrfs: disk space caching is enabled
> btrfs: checking UUID tree
> btrfs: corrupt leaf, slot offset bad: block=842924032,root=1, slot=88
> btrfs: corrupt leaf, slot offset bad: block=842924032,root=1, slot=88
> BTRFS error (device sdc5): Error removing orphan entry, stopping orphan
> cleanup
> BTRFS critical (device sdc5): could not do orphan cleanup -22
>
> Doing "btrfs check /dev/sdc5" merely first prints ten
>
> free space inode generation (0) did not match free space cache
> generation ([different transids between 40010 and 55578])
>
> to then abort with
>
> checking fs roots
> btrfs: cmds-check.c:1151: procecss_file_extent: Assertion `!(rec->ino !=
> key->objectid || rec->refs > 1)' failed.
>
> I'm reluctant to try any of "btrfs check" options (or mount with -o
> recovery) since the last three times I did this (with other partitions)
> it resulted in the partition becoming entirely trashed, while before at
> least "btrfs restore" still managed to extract some data each time.
>
> The affected folder was one within /usr/include/qt4 (which I then moved
> to /usr/BROKEN, to successfully reinstall the package), ie. on the
> __current/ROOT subvolume.
>
> Which seems the only subvolume affected (yet). Mounting & accessing the
> other three (__current/{var,home,opt}) still works.
>
> [*] Organised following
> http://blog.fabio.mancinelli.me/2012/12/28/Arch_Linux_on_BTRFS.html
>
> (Also posted on https://bugzilla.kernel.org/show_bug.cgi?id=74611 )

