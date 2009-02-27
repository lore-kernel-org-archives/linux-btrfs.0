From: Josef Bacik <josef@redhat.com>
Subject: Re: BUG: Bonnie++ stresstest with parallel balanceing chunks
	across all devices
Date: Fri, 27 Feb 2009 10:39:14 -0500
Message-ID: <20090227153914.GJ10849@unused.rdu.redhat.com>
References: <20090226203608.GB4024@256bit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Marc Schoechlin <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090226203608.GB4024@256bit.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 26, 2009 at 09:36:08PM +0100, Marc Schoechlin wrote:
> Hello Developers,
> 
> it seems that i discovered another bug in btrfs while testing it on a zSeries
> mainframe :-)
> 
> ## Test environment:
> 
> - IBM System z900 Mainframe
> - Debian SID with 64 Bit Kernel
> - GIT Sources from
>   git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
> - System runs as z/VM guest
> - 3 Virtual CPUs
> - 1 GB RAM Storage
> 
> ## Initial Test Setup
> 
> - Setup a Debian SID System with a 64bit Kernel
>   (i.e. aptitude install linux-image-2.6.26-1-s390x)
> - Restart System and build a kernel with btrfs support from the development sources
>    cd /usr/src
>    git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
>    cd btrfs-unstable
>    cp /boot/config-`uname -r`* .config
>    make oldconfig
>    make-kpkg clean
>    make menuconfig # acticate filesystems/btrfs
>    make-kpkg kernel_image --initrd --revision=marc.1
>    dpkg -i ../*marc.1*.deb
>    reboot
> - Restart System
> 
> ## Initial Test Setup
> 
>  * setup environment variables
>    DEVICES="$(echo /dev/disk/by-path/ccw-0.0.{3320..3327})" # adapt for other platforms
>    TESTMNT="/mnt"
>    DEVNOS="$(echo {3320..3327})" # only needed on system z
>  * Sysrq
>    sysctl -w kernel.sysrq=1
>    In case of a crash do:
>    echo u >/proc/sysrq-trigger
>    echo b >/proc/sysrq-trigger
> 
>  * z/VM test setup (only needed on system z)
>    modprobe vmur
>    chccwdev -e c
>    vmcp "SPOOL C CLASS *"
>    vmur purge
> 
>  * take disks online (only needed on system z)
>    for i in $DEVNOS; do chccwdev -e $i; done
>    for i in $DEVNOS; do lsdasd $i; done
> 
>  * format the disks (only needed on system z)
>    for i in $DEVNOS; do
>     dasdfmt --blocksize=4096 --disk_layout=cdl --label=0x$i -p --device /dev/disk/by-path/ccw-0.0.$i
> 
> ## How to reproduce the problem
> 
> vmcp "sp cons start to *"
> 
> modprobe btrfs
> mkfs.btrfs -m raid10 -d raid10 /dev/disk/by-path/ccw-0.0.{3320..3327}
> sleep 1
> mount -t btrfs /dev/disk/by-path/ccw-0.0.3321 ${TESTMNT}
> sleep 5
> mkdir -p ${TESTMNT}/{1..5}
> for i in {1..5};do
>  bonnie++ -x 10 -u root -d ${TESTMNT}/$i &>${TESTMNT}/$i.log &
> done
> for i in {1..2000}; do
>    btrfs-vol -b ${TESTMNT}
>    btrfs-show
> done
> 
> killall -KILL bonnie++
> umount ${TESTMNT}
> 
> vmcp "sp cons stop close"
> 
> => Crashes after a few minutes
> => System ist still usable
>

Hmm that is definitely a bug, there is still blocks for it to allocate.  I will
run this with my new enospc patches and see how it runs.  Thanks,

Josef 
