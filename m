Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:36740 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469AbbDWLpa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 07:45:30 -0400
Received: by lagv1 with SMTP id v1so10570982lag.3
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 04:45:28 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Apr 2015 13:45:28 +0200
Message-ID: <CAK1hC9ujeQs_pv6nD6C689hMFQNjMMQdUgt7RFOz0gHjdeSz_A@mail.gmail.com>
Subject: install Fedora systemd-nspawn container on btrfs
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: systemd <systemd-devel@lists.freedesktop.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not sure what I did wrong, but I can't install/boot my nspawn container.
Here is my setup:

Archlinux box- updated

1- created 3 btrfs subvol on /dev/sdb1 (SSD). The goal is to manage
snapshots easily.
no nested subvol.
------------------------------------------
# btrfs subvolume list .
ID 266 gen 39 top level 5 path rootvol
ID 268 gen 41 top level 5 path var
ID 269 gen 42 top level 5 path etc
# btrfs filesystem show
Label: 'poppy-root'  uuid: ef1b44cd-e7b0-4166-b933-e7d4d20a1171
    Total devices 1 FS bytes used 64.00KiB
    devid    1 size 80.00GiB used 12.00MiB path /dev/sdb1
--------------------------------------------------

2 - mount btrfs subvol
-------------------------------------------------------------------
# mount -t btrfs -o subvol=rootvol /dev/sdb1 /var/lib/machines/enl
# mkdir /var/lib/machines/enl/var
# mkdir /var/lib/machines/enl/etc
# mount -t btrfs -o subvol=etc /dev/sdb1 /var/lib/machines/enl/etc
# mount -t btrfs -o subvol=var /dev/sdb1 /var/lib/machines/enl/var
--------------------------------------------------------------------

3- install fedora minimal and boot it
-------------------------------------------------
#  machinectl pull-raw --verify=no
http://ftp.halifax.rwth-aachen.de/fedora/linux/releases/22/Cloud/Images/x86_64/Fedora-Cloud-Base-22_Beta-20150415-x86_64.raw.xz
$ tar ....
# systemd-nspawn -M Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw
Spawning container Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw on
/var/lib/machines/Fedora-Cloud-Base-22_Beta-20150415.x86_64.raw.
Press ^] three times within 1s to kill container.
[root@Fedora-Cloud-Base-22_Beta-20150415 ~]#
------------------------------------------------------------

4- install Fedora on /var/lib/machines/enl
--------------------------------------------------------------
[root@Fedora-Cloud-Base-22_Beta-20150415 ~]# dnf -y --releasever=22
--nogpg --installroot=/var/lib/machines/MyContainer --disablerepo='*'
--enablerepo=fedora install systemd passwd dnf fedora-release-server
vim-minimal
..........................
INSTALL
...........................
Complete!
----------------------------------------------------------

5- Now, nothing !!
----------------------------------------------------
% ls -a /var/lib/machines/enl
./  ../  etc/  var/

# systemd-nspawn -bD /var/lib/machines/enl
[sudo] password for root:
Directory /var/lib/machines/enl doesn't look like an OS root directory
(os-release file is missing). Refusing.
-------------------------------------------------------

Not sure if my issue comes from a wrong Btrfs setup, or if I missed
something when installing from the cloud minimal Fedora.

Thank you for hints







-- 

google.com/+arnaudgabourygabx
