From: Ritesh Raj Sarraf <rsarraf@netapp.com>
Subject: btrfs space handling with multiple block devices
Date: Mon, 27 Sep 2010 00:32:29 +0530
Message-ID: <5vh4n7-hk2.ln1@news.researchut.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

It seems this might be a bug.

00:24:51 rrs@champaran:/mnt/btrfs $ cp /home/rrs/PDds73yDCNo.flv .
cp: writing `./PDds73yDCNo.flv': No space left on device


So, I have an error of no free space.

00:24:56 rrs@champaran:/mnt/btrfs $ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/LocalDisk-ROOT
                      110G   90G   19G  84% /
tmpfs                 1.5G   12K  1.5G   1% /lib/init/rw
udev                  1.5G  364K  1.5G   1% /dev
tmpfs                 1.5G  248K  1.5G   1% /dev/shm
/dev/sda2             942M  121M  812M  13% /boot
/dev/mapper/VgTest-lvol0
                       32G   21G   12G  63% /mnt/btrfs


But that is not what df wants to report.


00:25:01 rrs@champaran:/mnt/btrfs $ sudo btrfs-show 
failed to read /dev/sr0
Label: BTRFS  uuid: cd7fc372-81c8-4c0c-9468-2ee0397489c5
        Total devices 2 FS bytes used 20.06GB
        devid    1 size 20.00GB used 11.03GB path /dev/dm-2
        devid    2 size 12.00GB used 11.01GB path /dev/dm-3

Btrfs Btrfs v0.19


And looks same on btrfs-show.

I am running a 2.6.35 kernel with btrfs-tools version 0.19+20100601-3 on 
Debian.

Ritesh

-- 
Given the large number of mailing lists I follow, I request you to CC me
in replies for quicker response

