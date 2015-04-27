Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35013 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbbD0Njm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 09:39:42 -0400
Received: by widdi4 with SMTP id di4so99753227wid.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 06:39:35 -0700 (PDT)
MIME-Version: 1.0
From: Ermanno Baschiera <ebaschiera@gmail.com>
Date: Mon, 27 Apr 2015 15:39:14 +0200
Message-ID: <CAGMbsDWrzYi5jQTKhSfTn0YAbFKfcQzsMktuw5rM9yK17j3Urw@mail.gmail.com>
Subject: help on broken file system
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I have a 3 disks file system configured in RAID1, created with Ubuntu
13.10 (if I recall correctly). Last friday I upgraded my system from
Ubuntu 14.10 (kernel 3.16.0) to 15.04 (kernel 3.19.0). Then I started
to notice some malfunctions (errors on cron scripts, my time machine
asking to perform a full backup, high load, etc.). On saturday I
rebooted the system and it booted in readonly. I tried to reboot it
and it didn't boot anymore, stuck at mounting the disks.
So I booted with a live Ubuntu 15.05 which could not mount my disks,
even with "-o recovery,". Then I switched to Fedora beta with kernel
4.0.0-0.rc5. I did a "btrfs check" and got a lot of "parent transid
verify failed on 8328801964032 wanted 1568448 found 1561133".
Reading on docs and Stack Exchange, I decided to try a "btrfs restore"
to backup my data. Having not a spare disk, and being the file system
a RAID1, I decided to use one of the 3 disks as target for the
restore. I formatted it in EXT4 and tried the restore. The process
stopped after one minute, ending with errors.
Then I tried to "btrfs-zero-log" the file system, but I noticed that
running it multiple times, it was giving me the same amount of
messages, making me think it wasn't fixing anything.
So I run a "btrfs rescue chunk-recover". After that, I still not being
able to mount the system (with parameters -o recovery,degraded,ro).
I'm not sure about what to do now. Can someone give me some advice?
My possible steps are (if I understand correctly):
- try the "btrfs rescue super-recover"
- try the "btrfs check --repair"

Thank you.

-Ermanno Baschiera


I'm posting the output of my commands

[liveuser@localhost ~]$ sudo btrfs fi show
warning, device 1 is missing
warning devid 1 not found already
Label: none  uuid: 32eeac52-699b-4fa2-be61-06206910a37f
    Total devices 3 FS bytes used 3.79TiB
    devid    3 size 2.73TiB used 2.73TiB path /dev/sda
    devid    4 size 2.73TiB used 2.73TiB path /dev/sdc2
    *** Some devices missing

Btrfs v3.18.2




[liveuser@localhost ~]$ sudo btrfs restore /dev/sda /run/media/liveuser/restored
[...]
parent transid verify failed on 8328375693312 wanted 1568448 found 1561131
Ignoring transid failure
leaf parent key incorrect 8328375693312
parent transid verify failed on 8328375693312 wanted 1568448 found 1561131
Ignoring transid failure
leaf parent key incorrect 8328375693312
Error searching -1
Error copying data for
/run/media/liveuser/vai/@/var/lib/apt/lists/partial/security.ubuntu.com_ubuntu_dists_vivid-security_multiverse_binary-amd64_Packages.bz2
Error searching
/run/media/liveuser/vai/@/var/lib/apt/lists/partial/security.ubuntu.com_ubuntu_dists_vivid-security_multiverse_binary-amd64_Packages.bz2
Error searching
/run/media/liveuser/vai/@/var/lib/apt/lists/partial/security.ubuntu.com_ubuntu_dists_vivid-security_multiverse_binary-amd64_Packages.bz2
Error searching
/run/media/liveuser/vai/@/var/lib/apt/lists/partial/security.ubuntu.com_ubuntu_dists_vivid-security_multiverse_binary-amd64_Packages.bz2
Error searching
/run/media/liveuser/vai/@/var/lib/apt/lists/partial/security.ubuntu.com_ubuntu_dists_vivid-security_multiverse_binary-amd64_Packages.bz2
Error searching
/run/media/liveuser/vai/@/var/lib/apt/lists/partial/security.ubuntu.com_ubuntu_dists_vivid-security_multiverse_binary-amd64_Packages.bz2
Error searching
/run/media/liveuser/vai/@/var/lib/apt/lists/partial/security.ubuntu.com_ubuntu_dists_vivid-security_multiverse_binary-amd64_Packages.bz2




[liveuser@localhost ~]$ uname -a
Linux localhost 4.0.0-0.rc5.git4.1.fc22.x86_64 #1 SMP Fri Mar 27
13:51:23 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux



[liveuser@localhost ~]$ btrfs version
Btrfs v3.18.2
