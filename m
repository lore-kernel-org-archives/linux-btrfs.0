Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:35520 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933916AbbDWMSb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 08:18:31 -0400
Received: by labbd9 with SMTP id bd9so11189446lab.2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 05:18:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150423115056.GA28566@gardel-login>
References: <CAK1hC9ujeQs_pv6nD6C689hMFQNjMMQdUgt7RFOz0gHjdeSz_A@mail.gmail.com>
	<20150423115056.GA28566@gardel-login>
Date: Thu, 23 Apr 2015 14:18:30 +0200
Message-ID: <CAK1hC9unKak9ffbwJthki38te5PDB+28iJTN10++gRGLZpfoiA@mail.gmail.com>
Subject: Re: [systemd-devel] install Fedora systemd-nspawn container on btrfs
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: Lennart Poettering <lennart@poettering.net>
Cc: systemd <systemd-devel@lists.freedesktop.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 1:50 PM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Thu, 23.04.15 13:45, arnaud gaboury (arnaud.gaboury@gmail.com) wrote:
>
>> Not sure what I did wrong, but I can't install/boot my nspawn container.
>> Here is my setup:
>>
>> Archlinux box- updated
>>
>> 1- created 3 btrfs subvol on /dev/sdb1 (SSD). The goal is to manage
>> snapshots easily.
>> no nested subvol.
>> ------------------------------------------
>> # btrfs subvolume list .
>> ID 266 gen 39 top level 5 path rootvol
>> ID 268 gen 41 top level 5 path var
>> ID 269 gen 42 top level 5 path etc
>> # btrfs filesystem show
>> Label: 'poppy-root'  uuid: ef1b44cd-e7b0-4166-b933-e7d4d20a1171
>>     Total devices 1 FS bytes used 64.00KiB
>>     devid    1 size 80.00GiB used 12.00MiB path /dev/sdb1
>> --------------------------------------------------
>>
>> 2 - mount btrfs subvol
>> -------------------------------------------------------------------
>> # mount -t btrfs -o subvol=rootvol /dev/sdb1 /var/lib/machines/enl
>> # mkdir /var/lib/machines/enl/var
>> # mkdir /var/lib/machines/enl/etc
>> # mount -t btrfs -o subvol=etc /dev/sdb1 /var/lib/machines/enl/etc
>> # mount -t btrfs -o subvol=var /dev/sdb1 /var/lib/machines/enl/var
>> --------------------------------------------------------------------
>
> THis isn't really how one would normally use subvolumes. No need to
> mount each subvolume explicitly, they are just special directories...
>
>>
>> 3- install fedora minimal and boot it
>> -------------------------------------------------
>> #  machinectl pull-raw --verify=no
>> http://ftp.halifax.rwth-aachen.de/fedora/linux/releases/22/Cloud/Images/x86_64/Fedora-Cloud-Base-22_Beta-20150415-x86_64.raw.xz
>> $ tar ....
>> # systemd-nspawn -M Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw
>> Spawning container Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw on
>> /var/lib/machines/Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw.
>> Press ^] three times within 1s to kill container.
>> [root@Fedora-Cloud-Base-22_Beta-20150415 ~]#
>> ------------------------------------------------------------
>>
>> 4- install Fedora on /var/lib/machines/enl
>> --------------------------------------------------------------
>> [root@Fedora-Cloud-Base-22_Beta-20150415 ~]# dnf -y --releasever=22
>> --nogpg --installroot=/var/lib/machines/MyContainer --disablerepo='*'
>> --enablerepo=fedora install systemd passwd dnf fedora-release-server
>> vim-minimal
>> ..........................
>> INSTALL
>> ...........................
>> Complete!
>> ----------------------------------------------------------
>
>
> Hmm? With this command you installed another fedora inside the raw
> fedora image you downloaded. You now have three linuxes, installed
> within each other...

I suspected such kind of thing indeed. In the container,
/var/lib/machines is in fact inside the container and not on my host!
Stupid.
>
> Pick one:
>
> a) download the raw image and use that, but it will be a loopback file
> with its own file system inside
>
> or:
>
> b) do the dnf/yum install root thing, and install it into a directory
> tree.

I installed yum package on Arch but couldn't manage to do the install.

# yum -y --releasever=22 --nogpg --installroot=/var/lib/machines/enl
--disablerepo='*' --enablerepo=fedora install systemd passwd dnf
fedora-release-server
Error getting repository data for fedora, repository not found
# yum repolist all
repolist: 0

In fact, /etc/yum/repos.d is empty, so I am not surprised.



>
> Do either of those in the host, not in the container.
>
> Lennart
>
> --
> Lennart Poettering, Red Hat



-- 

google.com/+arnaudgabourygabx
