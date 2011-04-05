From: Larry D'Anna <larry@elder-gods.org>
Subject: bug report
Date: Tue, 5 Apr 2011 00:48:57 -0400
Message-ID: <20110405044857.GA31013@cthulhu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

So i made a filesystem image 

 $ dd if=/dev/zero of=root_fs bs=1024 count=$(expr 1024 \* 1024)
 $ mkfs.btrfs root_fs 

Then I put some debian on it (my kernel is 2.6.35-27-generic #48-Ubuntu) 

 $ mkdir root 
 $ mount -o loop root_fs root 
 $ debootstrap sid root 
 $ umount root

Then i run uml.....   (2.6.35-1um-0ubuntu1)

 $ linux single eth0=tuntap,tap0,fe:fd:f0:00:00:01

and then try to apt-get some stuff, and the result is this:

btrfs csum failed ino 17498 off 2412544 csum 491052325 private 446722121
btrfs csum failed ino 17498 off 2416640 csum 2077462867 private 906054605
btrfs csum failed ino 17498 off 2420736 csum 263316283 private 2215839539
btrfs csum failed ino 17498 off 2424832 csum 4177088190 private 2414263107
btrfs csum failed ino 17498 off 2428928 csum 4028205539 private 3560605623
btrfs csum failed ino 17498 off 2433024 csum 1724529595 private 200634979
btrfs csum failed ino 17498 off 2437120 csum 4038631380 private 2927872002
btrfs csum failed ino 17498 off 2441216 csum 2616837020 private 729736037
btrfs csum failed ino 17498 off 2498560 csum 2566472073 private 3417075259
btrfs csum failed ino 17498 off 2502656 csum 2566472073 private 1410567947


 $ find / -mount -inum 17498  
 /var/cache/apt/srcpkgcache.bin

I've gone through this twice now, so it's repeatable at least.  I know 2.6.35 is
kinda old but was this kind of thing to be expected back then?  


      --larry
