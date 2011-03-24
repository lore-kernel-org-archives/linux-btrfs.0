From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: recurring "btrfs csum failed"
Date: Thu, 24 Mar 2011 11:12:26 +0100
Message-ID: <4D8B190A.9080002@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I had a system freeze for some reason with 2.6.38.

I made a hard reboot, just to discover some of the files (KVM images, were in use when the crash happened) on btrfs RAID-1 filesystem are corrupted:

btrfs csum failed ino 257 off 120180736 csum 4246715593 private 48329
btrfs csum failed ino 257 off 120180736 csum 4246715593 private 48329
btrfs csum failed ino 257 off 120180736 csum 4246715593 private 48329


Not being in mood if btrfs should try the other device from the mirror, I decided to remove the corrupted file and copy a previous version stored on a ext3 filesystem.

The file copied fine, but to my surprise, the new file is still corrupted:

# md5sum vm-113-disk-1.raw 
md5sum: vm-113-disk-1.raw: Input/output error


Errors reported by btrfs are slightly different now:

btrfs csum failed ino 260 extent 21968855040 csum 582168802 wanted 1727644489 mirror 1
btrfs csum failed ino 260 extent 21948932096 csum 582168802 wanted 1727644489 mirror 2
btrfs csum failed ino 260 extent 21968855040 csum 582168802 wanted 1727644489 mirror 1
btrfs csum failed ino 260 extent 21968855040 csum 582168802 wanted 1727644489 mirror 1
btrfs csum failed ino 260 extent 21948932096 csum 582168802 wanted 1727644489 mirror 2
btrfs csum failed ino 260 extent 21968855040 csum 582168802 wanted 1727644489 mirror 1
btrfs csum failed ino 260 extent 21948932096 csum 582168802 wanted 1727644489 mirror 2



btrfs is mounted with these flags:

/dev/sdc on /mnt/btrfs type btrfs (rw,noatime,compress-force=lzo,device=/dev/sdc,device=/dev/sdd)


I don't need to recover the file, just trying to signal something doesn't work well here!

-- 
Tomasz Chmielewski
http://wpkg.org
