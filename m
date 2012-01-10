From: Michal Suba <michal.suba@pantheon.sk>
Subject: real free space on btrfs volume (performance impact)
Date: Tue, 10 Jan 2012 15:13:28 +0100
Message-ID: <4F0C4788.50806@pantheon.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1250; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello

  we are currently investigating performance issue on system runing 
above btrs filesystem. Is it possible, that performance is impacted by 
lack of free space? Also, how to get info about real free space on btrfs 
volume?

# btrfs-show /dev/sdb1
Label: opt  uuid: 28a55827-e677-47a9-98d5-d31eb3d71436
     Total devices 1 FS bytes used 167.83GB
     devid    1 size 240.00GB used *229.25GB* path /dev/sdb1

Btrfs Btrfs v0.19

# btrfs filesystem df /opt
Data: total=213.23GB, used=165.26GB
System, DUP: total=8.00MB, used=40.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=8.00GB, used=2.57GB

# df -h /opt
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb1             240G  171G   59G  75% /opt

How come that there is difference detween btrfs-show and df .. 40GB Is 
the space really usead or can I claim it back? (there are no snapshots)

# btrfs subvolume list /opt
#

  Thanks
michal

