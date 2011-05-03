From: Martin Schitter <ms@mur.at>
Subject: btrfs csum failed
Date: Tue, 03 May 2011 23:56:32 +0200
Message-ID: <4DC07A10.7070200@mur.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

since my last debian kernel-update to 2.6.38-2-amd64 i got troubles with 
csum failures. it's a volume full of huge kvm-images on md-RAID1 and 
LVM, so i used the mount options: 'noatime,nodatasum' to maximize the 
performance.

it happened two weeks ago for the fist time. and now again a kvm-image 
isn't readable again. i have to use an older snapshot to substitute the 
virtual machine.

this are the entries in dmesg/kernel-log on any access:
...
  [2412668.409442] btrfs csum failed ino 258 off 2331529216 csum 
3632892464 private 2115348581
...

it's a production machine, so i can not make to much experiments on it.
do you see an obvious way to solve this problem?

thanks!
martin
