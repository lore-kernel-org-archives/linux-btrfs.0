From: Jordan Windsor <jordanw2@gmail.com>
Subject: Unable to resize btrfs filesystem
Date: Fri, 4 Nov 2011 13:43:31 +1030
Message-ID: <CACCfv7oMocXjkioTyyz8uZR05swswbfRuGQjeyaCuP=dcZAu+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I'm currently running Linux 3.0.7 (release "-1" under Arch 64bit) and
btrfs-progs-unstable 0.19.20101006-1, I'm trying to resize my btrfs
filesystem on /dev/sdb6, the partition has the room to allow expansion
here's the output of "btrfs fi sh":


failed to read /dev/sr0
Label: none  uuid: db1a36b3-5047-4c14-8f67-262c2d63fcb8
	Total devices 1 FS bytes used 388.51GB
	devid    1 size 477.29GB used 416.29GB path /dev/sda6

Label: none  uuid: d8685e5e-c9ba-4ba5-a147-0c2caf8f4b2d
	Total devices 1 FS bytes used 101.81GB
	devid    1 size 552.08GB used 109.54GB path /dev/md127

Label: 'Storage2'  uuid: 34115fbe-e9e3-4691-a3c6-715f5d30b4e5
	Total devices 1 FS bytes used 196.73GB
	devid    1 size 336.00GB used 336.00GB path /dev/sdb6

The command I'm running to resize the filesystem is "su -c "btrfs fi
re 1:max /home/jordan/Storage/Storage2/"" and here's the output:

Resize '/home/jordan/Storage/Storage2/' of '1:max'
ERROR: unable to resize '/home/jordan/Storage/Storage2/

Thanks.
