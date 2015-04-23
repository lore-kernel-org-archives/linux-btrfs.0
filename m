Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:58565 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbDWLu7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 07:50:59 -0400
Date: Thu, 23 Apr 2015 13:50:56 +0200
From: Lennart Poettering <lennart@poettering.net>
To: arnaud gaboury <arnaud.gaboury@gmail.com>
Cc: systemd <systemd-devel@lists.freedesktop.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] install Fedora systemd-nspawn container on btrfs
Message-ID: <20150423115056.GA28566@gardel-login>
References: <CAK1hC9ujeQs_pv6nD6C689hMFQNjMMQdUgt7RFOz0gHjdeSz_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK1hC9ujeQs_pv6nD6C689hMFQNjMMQdUgt7RFOz0gHjdeSz_A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 23.04.15 13:45, arnaud gaboury (arnaud.gaboury@gmail.com) wrote:

> Not sure what I did wrong, but I can't install/boot my nspawn container.
> Here is my setup:
> 
> Archlinux box- updated
> 
> 1- created 3 btrfs subvol on /dev/sdb1 (SSD). The goal is to manage
> snapshots easily.
> no nested subvol.
> ------------------------------------------
> # btrfs subvolume list .
> ID 266 gen 39 top level 5 path rootvol
> ID 268 gen 41 top level 5 path var
> ID 269 gen 42 top level 5 path etc
> # btrfs filesystem show
> Label: 'poppy-root'  uuid: ef1b44cd-e7b0-4166-b933-e7d4d20a1171
>     Total devices 1 FS bytes used 64.00KiB
>     devid    1 size 80.00GiB used 12.00MiB path /dev/sdb1
> --------------------------------------------------
> 
> 2 - mount btrfs subvol
> -------------------------------------------------------------------
> # mount -t btrfs -o subvol=rootvol /dev/sdb1 /var/lib/machines/enl
> # mkdir /var/lib/machines/enl/var
> # mkdir /var/lib/machines/enl/etc
> # mount -t btrfs -o subvol=etc /dev/sdb1 /var/lib/machines/enl/etc
> # mount -t btrfs -o subvol=var /dev/sdb1 /var/lib/machines/enl/var
> --------------------------------------------------------------------

THis isn't really how one would normally use subvolumes. No need to
mount each subvolume explicitly, they are just special directories...

> 
> 3- install fedora minimal and boot it
> -------------------------------------------------
> #  machinectl pull-raw --verify=no
> http://ftp.halifax.rwth-aachen.de/fedora/linux/releases/22/Cloud/Images/x86_64/Fedora-Cloud-Base-22_Beta-20150415-x86_64.raw.xz
> $ tar ....
> # systemd-nspawn -M Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw
> Spawning container Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw on
> /var/lib/machines/Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw.
> Press ^] three times within 1s to kill container.
> [root@Fedora-Cloud-Base-22_Beta-20150415 ~]#
> ------------------------------------------------------------
> 
> 4- install Fedora on /var/lib/machines/enl
> --------------------------------------------------------------
> [root@Fedora-Cloud-Base-22_Beta-20150415 ~]# dnf -y --releasever=22
> --nogpg --installroot=/var/lib/machines/MyContainer --disablerepo='*'
> --enablerepo=fedora install systemd passwd dnf fedora-release-server
> vim-minimal
> ..........................
> INSTALL
> ...........................
> Complete!
> ----------------------------------------------------------


Hmm? With this command you installed another fedora inside the raw
fedora image you downloaded. You now have three linuxes, installed
within each other...

Pick one:

a) download the raw image and use that, but it will be a loopback file
with its own file system inside

or:

b) do the dnf/yum install root thing, and install it into a directory
tree.

Do either of those in the host, not in the container.

Lennart

-- 
Lennart Poettering, Red Hat
