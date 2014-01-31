Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35246 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932141AbaAaEFO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 23:05:14 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: =?windows-1252?Q?Re=3A_Snapshots_=96_noob_questions?=
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52EABE29.6080703@gmail.com>
Date: Thu, 30 Jan 2014 21:05:10 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <6429643D-C706-44C2-84E6-9467A3F90137@colorremedies.com>
References: <52E664E0.5070909@gmail.com> <3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com> <52E808CB.9020005@gmail.com> <ABFB6A50-ACAF-4BAA-8A93-4BC4CB6D0D65@colorremedies.com> <52EABE29.6080703@gmail.com>
To: KC <impactoria@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

readded list


On Jan 30, 2014, at 2:03 PM, KC <impactoria@googlemail.com> wrote:

> On 28/01/14 21:16, Chris Murphy wrote:
>> You could also rename /home, create a subvolume home within current subvolume root, then move the files from directory /home_old to the subvolume /home. Now when you snapshot rootfs, /home isn't snapshot. In this case you don't need to separately mount the home subvolume because it's available as if it were a directory. It's an organizational thing I don't know that there's a right or wrong here.
>> 
> 
> So I did
> btrfs subvolume create /home
> 
> and rsynced all the files from old home into it. The system boots and works fine. Now I get:
> 
> $ sudo btrfs subvolume list .
> ID 351 gen 25880 top level 5 path home
> 
> Does this mean that /home is now subvolume of root?

Yes, but more correctly it means it's in the top level of the file system. This also means your layout is mounting the top level of the file system, rather than some other subvolume. I find this layout confusing now that I'm used to a different layout: by default Fedora creates boot [1], root and  home subvolumes, which then in fstab are mounted using subvol=. Therefore the top level of the file system is not mounted.

Naturally I found this quite confusing when I first encountered it, so it's understandable why other distros do things differently. It's perhaps easier to see the fstab, sub list, and the kernel boot param.


UUID=xxxxxx  /                       btrfs   subvol=root,compress=lzo,ssd     0 0
UUID=xxxxxx  /boot                   btrfs   subvol=boot,compress=lzo,ssd     0 0
UUID=yy          /boot/efi               vfat    umask=0077,shortname=winnt 0 0
UUID=xxxxxx  /home                   btrfs   subvol=home,compress=lzo,ssd     0 0
UUID=xxxxxx  /var/log/journal        btrfs   subvol=journald,compress=lzo,ssd 0 0

# btrfs sub list /
ID 256 gen 505 top level 5 path home
ID 258 gen 510 top level 5 path root
ID 259 gen 511 top level 5 path journald
ID 263 gen 507 top level 5 path boot
ID 264 gen 192 top level 5 path boot.clean
ID 265 gen 193 top level 5 path root.clean
ID 266 gen 194 top level 5 path home.clean
ID 269 gen 189 top level 5 path boot.1
ID 270 gen 190 top level 5 path root.1
ID 271 gen 191 top level 5 path home.1
ID 272 gen 192 top level 5 path boot.clean_ro
ID 273 gen 193 top level 5 path root.clean_ro
ID 274 gen 194 top level 5 path home.clean_ro

linuxefi /boot/vmlinuz-3.12.8-300.fc20.x86_64 root=UUID=xxxxxx ro rootflags=subvol=root vconsole.font=latarcyrheb-sun16  elevator=noop 3



The boot param "rootflags=subvol=root" is the same as fstab's mount option subvol=root. This tells the kernel that the root file system isn't merely at UUID=xxxxxx, but it's within subvolume root.


> And how do I take a snapshot of root, if it is not listed in this command?

btrfs sub snaps -r / root.1

At the top level of the file system is a subvolume, ID 5. You can't rename it, and you can't delete it. If the top level subvolume is mounted, then you are snapshotting it by referring to the mount point, in this case /. And in this example root.1 will be a read-only snapshot of /.

I think snapper on opensuse puts snapshots into a subvolume called .snapshots. You could do the same thing, and then with a  file listing of / you won't see a bunch of accumulated snapshots. They could just as well go in a directory called .snapshots, off hand I'm not thinking of an advantage of putting snapshots into a subvolume.


Chris Murphy

