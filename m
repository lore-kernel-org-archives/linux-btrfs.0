Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:34120 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbcCQBZW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 21:25:22 -0400
Subject: A good "Boot Maintenance" scheme (WAS: New file system with same
 issue)
To: Marc Haber <mh+linux-btrfs@zugschlus.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <20160314120703.GD2334@torres.zugschlus.de> <56E6B312.30903@googlemail.com>
 <20160314201306.GH2334@torres.zugschlus.de>
From: Robert White <rwhite@pobox.com>
Message-ID: <56EA058E.7060108@pobox.com>
Date: Wed, 16 Mar 2016 18:17:02 -0700
MIME-Version: 1.0
In-Reply-To: <20160314201306.GH2334@torres.zugschlus.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/14/2016 01:13 PM, Marc Haber wrote:
> This was not asked, and I didn't try. Since this is an encrypted root
> filesystem, is it a workable way to add clear_cache to /etc/fstab,
> rebuild initramfs and reboot? Or do you recommend using a rescue system?


You should be able to boot to single user mode and man-handle the 
filesystem from there.

but if that's a problem...

I have a small (woefully incomplete) pre-alpha project on Sourceforge 
called "underdog".

I currently use it to build the initramfs to boot all my systems.

So even if yo don't use it for production you can use it to make the 
initramfs you'll need to have full BTRFS maintenance before any of your 
filesystems are mounted.

You want this tool if you want to do pre-boot surgery without hassles. 
(or you want a nice way to convert from extN to btrfs and back without 
having a bunch of co-variant CDs.)

There's a README.txt, it's long... But basically:


(1) use git to download project

(2) go to your kernel build directory

(3) run /path/utility/make_initramfs_description.bash > .initramfs

where "path" is the path to the download location

(4) set CONFIG_INITRAMFS_SOURCE=".initramfs" in your kernel config

(5) build new kernel.

This creates a kernel which:

(A) Booted with a normal initramfs will run as if you didn't do the above.

(B1) Booted _without_ another initramfs will _probably_ boot normally as 
long as all your disk related drivers are not kernel modules. (It 
handles most layouts I've tried but some hosts have "the UID problem" 
described below

(B2) Booted _without_ another initramfs but _with_ "bash" on the kernel 
command line results in several opportunities to execute arbitrary 
commands during the boot sequence, and provides the commands you need.

You are after mode B2.

So during a normal boot without another initramfs the system will 
recursively examine all the disk block devices, identifying and 
attaching cryptsetup, mdadm, and lvm2, and btrfs devices as it finds them.

Some of the prompting will get lost in the kernel boot messages because, 
you know, multi-threading and all that.

Prompts:

"pre-loop#"; you've used "bash" option and it's about to start the disk 
search.

A password prompt for a device; it's found a cryptsetup device it wants 
to open. It'll give you three tries before moving on.

"post-loop#"; After the recursive search. _hopefully_ your root device 
is mounted as "/root". The FS is (hopefully) mounted but the system is 
completely independent of the mount.

So either use "pre-loop#" to do all your maintenance by hand, or go 
through to "post-loop#" and unmount /root and then do as you must.

These prompts are from the uber-priviliged PID1 and you can exec into 
other things (like an alternate init) as well as just running programs.

(control-d from "pre-loop#" or "post-loop#" will continue the script.

If you drop out to a bash shell prompt in B1 or B2 at the end then the 
script could not deduce your layout. You can then do fixups and 
whatever, and then mount anything as /root and then do the "exec busybox 
switch_root /root /sbin/init" (or /init or whatever) to continue the 
boot. That emergency bash prompt is still PID #1 and all the initramfs 
conditions for init are still in force.

Anyway, having used "bash" you can use the pre- or post- loop prompts to 
do any maintenance you wish. Up-arrow/history is _not_ available. But 
you have btrfs, btrfsck, fsck, mount, blkid, mdadm, and lvm available to 
you. (you can also issue "busybox --instal" to get all of the commands 
like cp and vi and such).

Other simple emergency commands can be added to the foundational list by 
creating/editing a utility/something.mod file or the script itself.

The magic of the script is that it will scour the system for dependent 
interpreters and libraries for whatever commands you add to the 
initramfs so you don't have to have "staticly linked" or otherwise 
special utilities built.

Notes:

I've been using the kernel-inbuilt initramfs this creates in all my 
development systems for years, it's quite stable... except where it's 
not. 8-)

DO NOT USE "utility/make_initramfs.bash", it's depricated. If you want 
to make a not-inbuilt initramfs image then follow the README.txt 
instructions from item 3b (which is also easier).

Full Disclosure: It's a little wonky about using UIDs to find 
filesystems right now because BASH likes to try to do math near the 
minuses in the UIDs when looking up arrays. /sigh
