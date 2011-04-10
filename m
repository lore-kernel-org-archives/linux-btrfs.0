From: Christian =?ISO-8859-1?Q?A=DFfalg?= <christian.assfalg@uni-ulm.de>
Subject: Required Kernel version to compile git btrfs with DKMS? Problems
 with Ubuntu 10.10
Date: Sun, 10 Apr 2011 22:50:02 +0200
Message-ID: <1302468602.2077.71.camel@chris-desktop>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-+dHAp3JNBfqmvb+hWB5d"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-+dHAp3JNBfqmvb+hWB5d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hi all,

I'd like to look into btrfs code and try some things, so I followed the
instructions on the wiki (link below) to setup git and get a dkms build
against my kernel. I'm using Ubuntu 10.10 with a 2.6.35 Kernel, which I
assume is too old. What version do I need?

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories

I've followed the guide (skipped initrd) until the dkms build command,
which fails with the following error:

dkms build -m btrfs -v git

root@chris-desktop:/home/chris/workspace/btrfs/git-repo/btrfs-unstable#
cat /var/lib/dkms/btrfs/git/build/make.log
DKMS make.log for btrfs-git for kernel 2.6.35-28-generic (i686)
So 10. Apr 22:05:11 CEST 2011
make: Gehe in Verzeichnis '/usr/src/linux-headers-2.6.35-28-generic'
  LD      /var/lib/dkms/btrfs/git/build/built-in.o
  CC [M]  /var/lib/dkms/btrfs/git/build/super.o
In file included from /var/lib/dkms/btrfs/git/build/super.c:43:
/var/lib/dkms/btrfs/git/build/ctree.h:31: fatal error:
trace/events/btrfs.h: Datei oder Verzeichnis nicht gefunden
compilation terminated.
make[1]: *** [/var/lib/dkms/btrfs/git/build/super.o] Fehler 1
make: *** [_module_/var/lib/dkms/btrfs/git/build] Fehler 2
make: Verlasse Verzeichnis '/usr/src/linux-headers-2.6.35-28-generic'

This seems to be fairly new (related to initial tracepoint support),
from the two Mailing list threads "[PATCH] Btrfs: add initial tracepoint
support for btrfs" and "[GIT PULL] Btrfs updates for 2.6.39". The
attached make.log is when I simply copy the missing file over from the
btrfs git tree (fails with among others
"/var/lib/dkms/btrfs/git/build/super.c:578: error: ‘struct super_block’
has no member named ‘s_d_op’"). So I am guessing that my Ubuntu 10.10
2.6.35 Kernel is too old? Will the 2.6.38 from the next Ubuntu release
work?

Regards,
Christian Aßfalg

--=-+dHAp3JNBfqmvb+hWB5d
Content-Disposition: attachment; filename="make.log"
Content-Type: text/x-log; name="make.log"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

DKMS make.log for btrfs-git for kernel 2.6.35-28-generic (i686)
So 10. Apr 22:15:02 CEST 2011
make: Gehe in Verzeichnis '/usr/src/linux-headers-2.6.35-28-generic'
  LD      /var/lib/dkms/btrfs/git/build/built-in.o
  CC [M]  /var/lib/dkms/btrfs/git/build/super.o
In file included from /var/lib/dkms/btrfs/git/build/super.c:43:
/var/lib/dkms/btrfs/git/build/ctree.h:2237: warning: ‘struct fstrim_range’ declared inside parameter list
/var/lib/dkms/btrfs/git/build/ctree.h:2237: warning: its scope is only this definition or declaration, which is probably not what you want
In file included from include/trace/ftrace.h:285,
                 from include/trace/define_trace.h:73,
                 from include/trace/events/btrfs.h:667,
                 from /var/lib/dkms/btrfs/git/build/super.c:56:
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs_transaction_commit’:
include/trace/events/btrfs.h:47: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:47: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:47: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs__inode’:
include/trace/events/btrfs.h:68: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:68: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:68: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs_get_extent’:
include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:144: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs__ordered_extent’:
include/trace/events/btrfs.h:197: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:197: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:197: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs__writepage’:
include/trace/events/btrfs.h:273: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:273: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:273: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs_writepage_end_io_hook’:
include/trace/events/btrfs.h:332: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:332: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:332: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs_sync_file’:
include/trace/events/btrfs.h:365: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:365: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:365: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs_delayed_tree_ref’:
include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:420: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs_delayed_data_ref’:
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:459: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs__chunk’:
include/trace/events/btrfs.h:541: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:541: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:541: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs_cow_block’:
include/trace/events/btrfs.h:591: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:591: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:591: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h: In function ‘ftrace_raw_output_btrfs__reserved_extent’:
include/trace/events/btrfs.h:626: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:626: warning: large integer implicitly truncated to unsigned type
include/trace/events/btrfs.h:626: warning: large integer implicitly truncated to unsigned type
/var/lib/dkms/btrfs/git/build/super.c: In function ‘btrfs_fill_super’:
/var/lib/dkms/btrfs/git/build/super.c:578: error: ‘struct super_block’ has no member named ‘s_d_op’
/var/lib/dkms/btrfs/git/build/super.c: At top level:
/var/lib/dkms/btrfs/git/build/super.c:1069: error: unknown field ‘mount’ specified in initializer
/var/lib/dkms/btrfs/git/build/super.c:1069: warning: initialization makes integer from pointer without a cast
/var/lib/dkms/btrfs/git/build/super.c:1119: warning: initialization from incompatible pointer type
/var/lib/dkms/btrfs/git/build/super.c:1120: error: unknown field ‘evict_inode’ specified in initializer
make[1]: *** [/var/lib/dkms/btrfs/git/build/super.o] Fehler 1
make: *** [_module_/var/lib/dkms/btrfs/git/build] Fehler 2
make: Verlasse Verzeichnis '/usr/src/linux-headers-2.6.35-28-generic'

--=-+dHAp3JNBfqmvb+hWB5d--

