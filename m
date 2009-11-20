From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: [RFC] proposal for a btrfs filesystem layout
Date: Fri, 20 Nov 2009 19:50:06 +0100
Message-ID: <200911201950.06662.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: Chris Ball <cjb@laptop.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

after the Chirs (Ball) email, I thought about a possible btrfs file-system 
layout, which may permit to snapshot the root and mount (if required) an old 
snapshot of the root.

A btrfs file-system has the capability to be partitioned in subvolumes. Every 
subvolume has a name. The root of the btrfs file-system is itself a volume, 
called "." (dot).
At the mount time using the option subvol= it is possible to mount a specific 
subvolume. If nothing is specified the subvol "." (dot) is mounted.

My idea is that the root of the file-system has to be a subvolume of a btrfs 
file-system. Then the subvolume "." is mounted under a subdirectory and is 
used only for managing the snapshot of the root file-system.

In order to be more clear I will use the following nomenclature:

- root of the file-system (or fs root):
	the root of system. This directory contains /bin, /sbin, /usr...

- root of a btrfs files-system (or btrfs root):
	the root of a btrfs file-system which contains the subvolumes. This is
	still a subvolume called "." (dot)

Under the btrfs root a subvolume named "rootfs" is created, this will contain 
the fs root. Also the fs root snapshots are created under the btrfs root.
In order to access the btrfs root and handle the fs root subvolume and its 
snapshots, the btrfs root is mounted under /var/run/btrfs.

To mount the fs root, the option "subvol=rootfs" has to be used used (for 
example in the initramfs). 
# mount -t btrfs -o subvol=rootfs /dev/sdxx /

To mount the btrfs root, the option "subvol=." has to be used . 
# mount -t btrfs -o subvol=. /dev/sdxx /var/run/btrfs

Note 1) the "rootfs" volume is a portion of the real btrfs.
Note 2) if only the "rootfs" volume is mounted is impossible to access to all 
data contained in the btrfs file-system. In order to access to the btrfs root, 
this has to be mounted under a sub-directory of the "rootfs" volume
Note 3) the files contained in the "rootfs" volume appear two times:
 - under / (where the "rootfs" volume is mounted)
 - under /var/run/btrfs/rootfs (if the "." volume is mounted under
    /var/run/btrfs)
Note 4) snapshotting a volume doesn't affect the other volumes, even though 
these volumes are mounted or located under the volume snapshotted.

This is a time for the ascii art:

*Real* btrfs filesystem layout (or the volume called ".")

/  \                  <--- "." volume 
   rootfs \           <--- "rootfs" volume
           !- bin 
           !- sbin
           !- etc
           !- usr
           !- [...]
   snap1  \          <---- 1st snapshot of the rootfs volume
           !- bin
           !- sbin
           !- etc
           !- usr
           !- [...]
   snap1  \          <---- 2st snapshot of the rootfs volume
           !- bin
           !- sbin
           !- etc
           !- usr
           !- [...]


*Effective* file-system layout:

/  \                                              <--- "rootfs" volume
    !- bin 
    !- sbin
    !- etc
    !- usr
    [...]
    !- var \
            !- run \
                   ! - btrfs \                  <--- "." volume
                              ! -  rootfs \     <--- "rootfs" volume(2nd time)
                                          !- bin 
                                          !- sbin
                                          [...]
                              ! -  snap1 \     <--- 1st snapshot
                                          [...]
                              ! -  snap2 \     <--- 1st snapshot
                                          [...]




Below I will show some use cases:
1) system install
2) fs root snapshotting
3) exchange the root with a old snapshot (a reboot is required)



** 1) System install

root@host:/> mkfs.btrfs /dev/sdxx
root@host:/> mount -t btrfs /dev/sdxx /media/btrfs-test
root@host:/ cd /media/btrfs-test
root@host:/media/btrfs-test> btrfsctl -S rootfs .
root@host:/media/btrfs-test> ls -l
drwx------ 1 root root 160 2009-11-20 17:22 rootfs
root@host:/media/btrfs-test> cd rootfs
root@host:/media/btrfs-test/rootfs> debootstrap sid .  # install packages
						       # under the rootfs volume
[... config the system ...]

root@host:/media/btrfs-test/rootfs> ls
bin   dev  home  lib64       media  opt   root  selinux  sys  usr
boot  etc  lib   lost+found  mnt    proc  sbin  srv      tmp  var

root@host:/media/btrfs-test/rootfs> mkdir /var/run/btrfs
root@host:/media/btrfs-test/rootfs> cd /
root@host:/> umount /media/btrfs.test
root@host:/> mount -t btrfs -o subvol=rootfs /dev/sdxx /media/btrfs-test
root@host:/> chroot /media/btrfs-test

root@guest:/> ls /
bin   dev  home  lib64       media  opt   root  selinux  sys  usr
boot  etc  lib   lost+found  mnt    proc  sbin  srv      tmp  var

root@guest:/> mount -t btrfs -o subvol=. /dev/sdxx /var/run/btrfs
root@guest:/> ls /var/run/btrfs
rootfs

root@guest:/> # to mount automatically the btrfs root under /var/run/btrfs
root@guest:/> echo "/dev/sdxx /var/run/btrfs btrfs subvol=. 0 0" >>/etc/fstab 


** 2) system snapshot

root@guest:/> cd /var/run/btrfs
root@guest:/var/run/btrfs> ls
rootfs

root@guest:/var/run/btrfs> btrfsctl -s snap-of-root /.
root@guest:/var/run/btrfs> ls
rootfs snap-of-root
root@guest:/var/run/btrfs> ls snap-of-root
bin   dev  home  lib64       media  opt   root  selinux  sys  usr
boot  etc  lib   lost+found  mnt    proc  sbin  srv      tmp  var

root@guest:/var/run/btrfs> touch /root/old-root-witness
root@guest:/var/run/btrfs> ls rootfs/root
old-root-witness
root@guest:/var/run/btrfs> ls snap-of-root/root
root@guest:/var/run/btrfs>

** 3) exchange the fs root with an its (older) snapshot
root@guest:/var/run/btrfs> ls /root
old-root-witness
root@guest:/var/run/btrfs> ls
rootfs snap-of-root
root@guest:/var/run/btrfs> mv rootfs rootfs-old
root@guest:/var/run/btrfs> mv snap-of-root rootfs
root@guest:/var/run/btrfs> ls
rootfs rootfs-old
root@guest:/var/run/btrfs> reboot
[...]
root@guest:/> ls root
root@guest:/> ls /var/run/btrfs
rootfs rootfs-old


Any comments ? 
BR
G.Baroncelli
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
