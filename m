From: Eric Griffith <egriffith92@gmail.com>
Subject: Btrfs default subvolume, /home
Date: Sat, 5 Nov 2011 22:22:39 -0400
Message-ID: <CALHG4fEBDSNOVZhHRJdRzZzaLcvYc5dAPtig03ic4ZE9Ex40sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey guys, I've been trying out BTRFS the last couple days, just to
kind of see what to expect and what I can do with it once its
finalized and we have a working fsck. I do have a couple question that
neither the Arch Wiki, The Fedora WIki, Ubuntu wiki or the kernel.org
wiki could answer. So here goes;


When I installed fedora (F16 Beta) I made root be an ext4 partition,
with /home as BTRFS. Ubuntu wiki states that any BTRFS partition has a
default subvolume called "default," I cant find it for /home.

/etc/fstab:

#
# /etc/fstab
# Created by anaconda on Thu Nov 3 15:24:14 2011
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=e5021a48-c961-4e73-98a5-beee06355f46 / ext4 defaults 1 1
UUID=97ac420f-2818-4833-b7b6-4ac497716e3b /home btrfs
defaults,autodefrag,compress 1 2
UUID=0d275462-1ad3-46af-a1b8-637ca5efeca6 swap swap defaults 0 0


btrfs --help says. "btrfs subvolume list <path> : List the
snapshot/subvolume of a filesystem." I'd expect it to spit out
"default" at some point.

Couple outputs

[eric@eric-laptop ~]$ sudo btrfs subvolume list /
ERROR: '/' is not a subvolume
[eric@eric-laptop ~]$ sudo btrfs subvolume list /home
[eric@eric-laptop ~]$

What i wanted was an easy; reliable way to keep a backup of my home
using btrfs instead of just rsync. Unfortunately, in order to use
snapshot, it needs to be on, or be a, subvolume.

proof:

[eric@eric-laptop ~]$ sudo btrfs subvolume snapshot /home/eric /home/eric/test
ERROR: '/home/eric' is not a subvolume
[eric@eric-laptop ~]$


So; I rebooted into single user, mv'ed /home/eric to /home/eric-btrfs,
made a subvolume in /home/ named 'eric' to take the place of my home,
and cp'ed all of my files from eric-btrfs to eric, a quick chown, and
chmod to get the file permissions right.

Rebooted, tried to login... error messages, lots of error messages.
"Cant switch out from /" "/home/eric/.kde/share/config/knotifyrc is
not writable" despite having read and write permission, and ownership.

Can anyone figure out what the heck is going on? I know BTRFS is still
experimental, but I thought the layout and implementation was
finalized. OR; what do I have to do to make Btrfs work as a /home as
it should? (see ZFS / LVM )
