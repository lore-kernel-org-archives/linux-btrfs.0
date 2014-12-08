Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:39002 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbaLHXRm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Dec 2014 18:17:42 -0500
Message-ID: <5486318F.8050704@pobox.com>
Date: Mon, 08 Dec 2014 15:17:35 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Konstantin <newsbox1026@web.de>, Phillip Susi <psusi@ubuntu.com>,
        MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de> <547E10BA.6000707@ubuntu.com> <5484F198.3070206@web.de> <5485DDC7.2080500@pobox.com> <54862854.9070808@web.de>
In-Reply-To: <54862854.9070808@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/08/2014 02:38 PM, Konstantin wrote:
> For more important systems there are high availability
> solutions which alleviate many of the problems you mention of but that's
> not the point here when speaking about the major bug in BTRFS which can
> make your system crash.

I think you missed the part where I told you that you could use GRUB2 
and then you could use the 1.2 metadata on your raid and then have you 
system work as desired.

Trying to make this all about BTRFS is more than a touch disingenuous as 
you are doing things that can make many systems fail in exactly the same 
way.

Undefined behavior is undefined.

The MDADM people made the latter metadata layouts to address your issue, 
and its up to you to use it. Need it to boot, GRUB2 will boot it, and 
it's up to you to use it.

New software fixes problems evident in the old, but once you decide to 
stick with the old despite the new, your problem becomes uninteresting 
because it was already fixed.

So yes, if you use the woefully out of date metadata and boot loader you 
will have problems. If you use the distro scripts that scan the volumes 
you don't want scanned, you will have problems. People are working on 
making sure that those problems have work arounds. And sometimes the 
work around for "doctor, it hurts when I do this" is "don't do that any 
more".

It is multiplicatively impossible to build BTRFS such that it can dance 
through the entire Cartesian Product of all possible storage management 
solutions. Just as it was impossible for LVM and MDADM before them. If 
your system is layered, _you_ bear the burden of making sure that the 
layers are applied. Each tool is evolving to help you, but its still you 
doing the system design.

GRUB has put in modules for everything you need (so far) to boot. mdadm 
has better signatures if you use them. LVM always had device offsets 
built into its metadata block.

But answering the negative. The sort of question that might be phrased 
"how do you know it's _not_ mdadm old style signatures" is an unbounded 
coding, not because any one is impossible to code, but because an 
endless stream of possibilities is coming in the pipe. A striped storage 
controller might make a system look like /dev/sdb is a stand-alone BTRFS 
file system if the controller doesn't start and the mdadm and lvm 
signatures are on /dev/sda and take up "just the right amount of room".

If I do an mkfs.ext2 on a media, then do a cryptsetup luksCreate on that 
same media, I can mount it either way, with disastrous consequences for 
the other semantic layout.

The bad combinations available are virtually limitless.

There comes a point where the System Architect that decided how to build 
the individual system has to take responsibility for his actions.

Note that the same "it didn't protect me" errors can happen _easily_ 
with other filesystems. Try building an NTFS on a disk, then build an 
ext4 on the same disk then mount as either or both. (though now days you 
may need to build the ext4 then the NTFS since I think mkfs.ext4 may now 
have a little dedicated wiper to de-NTFS a disk after that went sour a 
few too many times).

When storage signatures conflict you will get "exciting" outcomes. It 
will always be that way, and its not an "error" in any of that 
filesystem code. You, the System Architect, bear a burden here.

The system isn't shooting "itself" when you do certain things. The 
System Architect is shooting the system with a bad layout bullet.

You don't want some LV to be scanned... don't scan it... If your tools 
scan it automatically, don't use those tools that way. "But my distro 
automatically" is just a reason to look twice at your distro or your design.


