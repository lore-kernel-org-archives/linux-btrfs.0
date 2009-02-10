From: Michele Petrazzo <michele.petrazzo@unipex.it>
Subject: Re: [PATCH] Backport to 2.6.27 and 2.6.26
Date: Tue, 10 Feb 2009 13:40:27 +0000 (UTC)
Message-ID: <loom.20090210T133915-506@post.gmane.org>
References: <20090209222630.GA12265@tux64-01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Lee Trager <lt73 <at> cs.drexel.edu> writes:

> 
> This patch will allow btrfs-unstable-standalone to compile cleanly
> against 2.6.27, 2.6.26, and possibly older(I havn't tested older then
> 26).
> 


On 2.6.27 it works, but on debian etch with 2.6.24 (etch-and-half) no:

srv-test:~/btrfs-unstable-standalone# make
make -C /lib/modules/`uname -r`/build M=`pwd` CONFIG_BTRFS_FS=m modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.24-etchnhalf.1-686'
  CC [M]  /root/btrfs-unstable-standalone/super.o
In file included from /root/btrfs-unstable-standalone/super.c:41:
/root/btrfs-unstable-standalone/compat.h: In function 'd_obtain_alias':
/root/btrfs-unstable-standalone/compat.h:15: error: implicit declaration of
function 'ERR_CAST'
/root/btrfs-unstable-standalone/compat.h:15: warning: return makes pointer from
integer without a cast
/root/btrfs-unstable-standalone/super.c: In function 'btrfs_fill_super':
/root/btrfs-unstable-standalone/super.c:356: error: implicit declaration of
function 'save_mount_options'
/root/btrfs-unstable-standalone/super.c: At top level:
/root/btrfs-unstable-standalone/super.c:628: error: 'generic_show_options'
undeclared here (not in a function)
make[2]: *** [/root/btrfs-unstable-standalone/super.o] Error 1
make[1]: *** [_module_/root/btrfs-unstable-standalone] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.24-etchnhalf.1-686'


Modifying and adding the ERR_CAST macro on compat.h

"""static inline void *ERR_CAST(const void *ptr)
{
 return (void *) ptr;
}
"""

make -C /lib/modules/`uname -r`/build M=`pwd` CONFIG_BTRFS_FS=m modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.24-etchnhalf.1-686'
  CC [M]  /root/btrfs-unstable-standalone/super.o
/root/btrfs-unstable-standalone/super.c: In function 'btrfs_fill_super':
/root/btrfs-unstable-standalone/super.c:356: error: implicit declaration of
function 'save_mount_options'
/root/btrfs-unstable-standalone/super.c: At top level:
/root/btrfs-unstable-standalone/super.c:628: error: 'generic_show_options'
undeclared here (not in a function)
make[2]: *** [/root/btrfs-unstable-standalone/super.o] Error 1
make[1]: *** [_module_/root/btrfs-unstable-standalone] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.24-etchnhalf.1-686'



