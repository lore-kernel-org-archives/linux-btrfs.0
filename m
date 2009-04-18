From: Dirk Heinrichs <dirk.heinrichs@online.de>
Subject: "No space left on device" at 69%
Date: Sat, 18 Apr 2009 11:20:41 +0200
Message-ID: <200904181120.41248.dirk.heinrichs@online.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

there's no information about reporting bugs in the btrfs wiki, so I try it 
here.

For testing purposes, I have put all my Gentoo portage (build, distfiles, etc.) 
related LVs  into one 10G btrfs with 4 subvolumes.

While building OpenOffice yesterday, it failed with a "No space left on device" 
error, although the LV was only 69% full in total.

Details (Builds of Gentoo packages happen in /gentoo/build.):

# mount|grep btr
/dev/mapper/gondolin-gentoo on /gentoo/build type btrfs (rw,subvol=build)
/dev/mapper/gondolin-gentoo on /gentoo/distfiles type btrfs 
(rw,subvol=distfiles)
/dev/mapper/gondolin-gentoo on /gentoo/ccache type btrfs (rw,subvol=ccache)
/dev/mapper/gondolin-gentoo on /gentoo/overlays type btrfs 
(rw,subvol=overlays)

# df -h |grep gentoo
/dev/mapper/gondolin-gentoo
                       10G  6,9G  3,2G  69% /gentoo/build
/dev/mapper/gondolin-gentoo
                       10G  6,9G  3,2G  69% /gentoo/distfiles
/dev/mapper/gondolin-gentoo
                       10G  6,9G  3,2G  69% /gentoo/ccache
/dev/mapper/gondolin-gentoo
                       10G  6,9G  3,2G  69% /gentoo/overlays

# uname -a
Linux gondolin 2.6.29.1 #1 SMP PREEMPT Fri Apr 3 22:40:15 CEST 2009 i686 
Intel(R) Core(TM)2 Duo CPU T7300 @ 2.00GHz GenuineIntel GNU/Linux

Bye...

	Dirk
