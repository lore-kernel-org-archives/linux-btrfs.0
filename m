From: Xavier Nicollet <nicollet@jeru.org>
Subject: some issues with lots of snapshots
Date: Tue, 26 Oct 2010 12:28:53 +0200
Message-ID: <20101026102853.GX13205@jeru.org>
Reply-To: nicollet@jeru.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I can't reproduce this right know, but it seems that creating lots of
snapshots, one per minute (keeping only a dozens of them) may block the
system. Every btrfs snap processes stay idle and the load skyrockets to 900.

I use an old version: 2.6.34.5 kernel, and the system is still very
responsive (web and mysql server).

I would apreciate if somebody could tell me about the current kernel (I
had stability issues with 2.6.35 series).

# btrfs filesys show
Label: 'btrfs'  uuid: e13357f4-c40c-4940-87bd-4f5142d32c49
        Total devices 2 FS bytes used 8.67GB
        devid    1 size 1.81TB used 12.03GB path /dev/sda2
        devid    2 size 1.81TB used 12.01GB path /dev/sdb2

# btrfs filesys df /var
Data, RAID1: total=11.00GB, used=8.24GB
Metadata, RAID1: total=1.00GB, used=436.21MB
System, RAID1: total=8.00MB, used=4.00KB
Data: total=8.00MB, used=0.00
Metadata: total=8.00MB, used=0.00
System: total=4.00MB, used=0.00

Regards,

PS: extract from dmesg if somebody is interested.
http://pastebin.com/8zE4GKXu

-- 
Xavier Nicollet
