From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Btrfs: blocked for more than 120 seconds, made worse by 3.2 rc7
Date: Wed, 28 Dec 2011 21:26:07 +0200
Message-ID: <4EFB6D4F.6070002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all:
I have two machines with btrfs, that give me the "blocked for more than 
120 seconds" message. After that I cannot write anything to disk, i am 
unable to unmount the btrfs filesystem and i can only reboot with 
sysrq-trigger.

It always happens when i write many files with rsync over network. When 
i used 3.2rc6 it happened randomly on both machines after 50-500gb of 
writes. with rc7 it happens after much less writes, probably 10gb or so, 
but only on machine 1 for the time being. machine 2 has not crashed yet 
after 200gb of writes and I am still testing that.

machine 1: btrfs on a 6tb sparse file, mounted as loop, on a xfs 
filesystem that lies on a 10TB md raid5. mount options 
compress=zlib,compress-force

machine 2: btrfs over md raid 5 (4x2TB)=5.5TB filesystem. mount options 
compress=zlib,compress-force

pastebins:

machine1:
3.2rc7 http://pastebin.com/u583G7jK
3.2rc6 http://pastebin.com/L12TDaXa

machine2:
3.2rc6 http://pastebin.com/khD0wGXx
3.2rc7 (not crashed yet)
