From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: v0.19-35-g1b444cd btrfsck says snapshots have errors
Date: Thu, 20 Jan 2011 17:52:56 -0500
Message-ID: <20110120225256.GA4161@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Still getting btrfsck errors with this:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git

# ./btrfstest.sh 
Using /mnt/sdb1 /dev/sdb1 on /dev/sdb
+ mkfs.btrfs -L BTRFStest /dev/sdb1

WARNING! - Btrfs v0.19-35-g1b444cd IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label BTRFStest on /dev/sdb1
	nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
Btrfs v0.19-35-g1b444cd
+ mount -o noatime /dev/sdb1 /mnt/sdb1
+ btrfs subvolume snapshot /mnt/sdb1 /mnt/sdb1/snap1
Create a snapshot of '/mnt/sdb1' in '/mnt/sdb1/snap1'
+ btrfs subvolume snapshot /mnt/sdb1/snap1 /mnt/sdb1/snap2
Create a snapshot of '/mnt/sdb1/snap1' in '/mnt/sdb1/snap2'
+ btrfs subvolume snapshot /mnt/sdb1/snap2 /mnt/sdb1/snap3
Create a snapshot of '/mnt/sdb1/snap2' in '/mnt/sdb1/snap3'
+ btrfs subvolume snapshot /mnt/sdb1/snap3 /mnt/sdb1/snap4
Create a snapshot of '/mnt/sdb1/snap3' in '/mnt/sdb1/snap4'
+ btrfs subvolume snapshot /mnt/sdb1/snap4 /mnt/sdb1/snap5
Create a snapshot of '/mnt/sdb1/snap4' in '/mnt/sdb1/snap5'
+ umount /dev/sdb1
+ btrfsck /dev/sdb1
fs tree 256 refs 6 
	unresolved ref root 256 dir 256 index 2 namelen 5 name snap1 error 600
	unresolved ref root 257 dir 256 index 2 namelen 5 name snap1 error 600
	unresolved ref root 258 dir 256 index 2 namelen 5 name snap1 error 600
	unresolved ref root 259 dir 256 index 2 namelen 5 name snap1 error 600
	unresolved ref root 260 dir 256 index 2 namelen 5 name snap1 error 600
found 49152 bytes used err is 1
total csum bytes: 0
total tree bytes: 49152
total fs tree bytes: 28672
btree space waste bytes: 39360
file data blocks allocated: 0
 referenced 0
Btrfs v0.19-35-g1b444cd

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
