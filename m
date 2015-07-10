Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33837 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922AbbGJU6G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 16:58:06 -0400
Received: by obbkm3 with SMTP id km3so198387954obb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 13:58:05 -0700 (PDT)
MIME-Version: 1.0
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Fri, 10 Jul 2015 15:57:46 -0500
Message-ID: <CAC=t97A0eR34GyMLC_XhdWMVAf1YaCgX=qrXGkip991znH5N9A@mail.gmail.com>
Subject: Did btrfs filesystem defrag just make things worse?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If I'm reading this right, my most fragmented file
(Training-flat.vmdk) is now almost 3x more fragmented?

[root@san01 tank]# filefrag
/mnt2/tank/virtual_machines/virtual_machines/Training/*
/mnt2/tank/virtual_machines/virtual_machines/Training/Training-flat.vmdk:
1444 extents found
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.nvram:
1 extent found
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmdk: 1
extent found
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmsd: 0
extents found
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmx: 1
extent found
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmxf: 1
extent found
/mnt2/tank/virtual_machines/virtual_machines/Training/vmware-1.log: 4
extents found
/mnt2/tank/virtual_machines/virtual_machines/Training/vmware.log: 3
extents found
[root@san01 tank]# lsattr /mnt2/tank/virtual_machines/virtual_machines/Training/
--------c------C
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmxf
--------c------C
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmsd
--------c------C
/mnt2/tank/virtual_machines/virtual_machines/Training/Training-flat.vmdk
--------c------C
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmdk
--------c------C
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.nvram
--------c------C
/mnt2/tank/virtual_machines/virtual_machines/Training/vmware-1.log
--------c------C
/mnt2/tank/virtual_machines/virtual_machines/Training/vmware.log
--------c------C
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmx
[root@san01 tank]# cd ~
[root@san01 ~]# cd git
[root@san01 git]# cd btrfs-progs/
[root@san01 btrfs-progs]# ./btrfs fi defragment
btrfs filesystem defragment: too few arguments
usage: btrfs filesystem defragment [options] <file>|<dir> [<file>|<dir>...]

    Defragment a file or a directory

    -v             be verbose
    -r             defragment files recursively
    -c[zlib,lzo]   compress the file while defragmenting
    -f             flush data to disk immediately after defragmenting
    -s start       defragment only from byte onward
    -l len         defragment only up to len bytes
    -t size        minimal size of file to be considered for defragmenting

[root@san01 btrfs-progs]# ./btrfs fi defragment -vr /mnt2/tank/virtual_machines
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmxf
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmsd
/mnt2/tank/virtual_machines/virtual_machines/Training/Training-flat.vmdk
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmdk
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.nvram
/mnt2/tank/virtual_machines/virtual_machines/Training/vmware-1.log
/mnt2/tank/virtual_machines/virtual_machines/Training/vmware.log
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmx
/mnt2/tank/virtual_machines/no_vms_here!
/mnt2/tank/virtual_machines/archived/DonW7/DonW7-disk1.vmdk
/mnt2/tank/virtual_machines/archived/DonW7/DonW7.mf
/mnt2/tank/virtual_machines/archived/DonW7/DonW7.ovf
btrfs-progs v4.1
[root@san01 btrfs-progs]# filefrag
/mnt2/tank/virtual_machines/virtual_machines/Training/*
/mnt2/tank/virtual_machines/virtual_machines/Training/Training-flat.vmdk:
4090 extents found
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.nvram:
1 extent found
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmdk: 1
extent found
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmsd: 0
extents found
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmx: 1
extent found
/mnt2/tank/virtual_machines/virtual_machines/Training/Training.vmxf: 1
extent found
/mnt2/tank/virtual_machines/virtual_machines/Training/vmware-1.log: 4
extents found
/mnt2/tank/virtual_machines/virtual_machines/Training/vmware.log: 2
extents found
