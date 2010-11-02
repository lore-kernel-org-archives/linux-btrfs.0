From: Christopher Tracey <cptracey1980@warpmail.net>
Subject: raid0 corruption, how to restore?
Date: Tue, 02 Nov 2010 04:14:01 -0400
Message-ID: <4CCFC849.6040407@warpmail.net>
Reply-To: cptracey1980@warpmail.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have two disks that I formatted as btrfs RAID0 on opensuse 11.3.  The 
raid worked well several days until there was a power surge.  The system 
successfully rebooted and the btrfs raid reappeared, but the kernel 
occasionally threw oops.  That was my first experience with oops.  After 
two days, the btrfs raid failed to mount via fstab and when I manually 
tried to mount it, there was a kernel panic.

I would like to recover the data from the btrfs raid.  If I issue the 
command:  btrfs-show, I receive:

Label: HD103SJ_btrfs  uuid: 2ff6e89d-b790-425b-837b-475d1504be69
         Total devices 2 FS bytes used 733.80GB
         devid    1 size 931.51GB used 369.53GB path /dev/sdd
         devid    2 size 931.51GB used 369.51GB path /dev/sde
Btrfs Btrfs v0.19

Obviously the RAID and the filesystems are still there.  I then try to 
fsck the drives:

btrfsck /dev/sde
btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)' 
failed.

I do not understand the error message that is provided.  Can someone 
shed a little light on that message?

Thank you.
