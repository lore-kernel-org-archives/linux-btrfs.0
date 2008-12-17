From: Michele Petrazzo <michele.petrazzo@unipex.it>
Subject: compilation problem on last unstable
Date: Wed, 17 Dec 2008 17:43:50 +0000 (UTC)
Message-ID: <loom.20081217T174132-393@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I just tried to compile the last unstable version, but:

  CC [M]  /home/michele/btrfs-unstable-standalone/inode.o
/home/michele/btrfs-unstable-standalone/inode.c: In function =E2=80=98b=
trfs_new_inode=E2=80=99:
/home/michele/btrfs-unstable-standalone/inode.c:3470: error: implicit
declaration of function =E2=80=98current_fsuid=E2=80=99
/home/michele/btrfs-unstable-standalone/inode.c:3471: error: implicit
declaration of function =E2=80=98current_fsgid=E2=80=99
/home/michele/btrfs-unstable-standalone/inode.c: In function=20
=E2=80=98btrfs_cache_create=E2=80=99:
/home/michele/btrfs-unstable-standalone/inode.c:4527: warning: passing =
argument
5 of =E2=80=98kmem_cache_create=E2=80=99 from incompatible pointer type
/home/michele/btrfs-unstable-standalone/inode.c: At top level:
/home/michele/btrfs-unstable-standalone/inode.c:4966: warning: initiali=
zation
from incompatible pointer type
/home/michele/btrfs-unstable-standalone/inode.c:4970: warning: initiali=
zation
from incompatible pointer type
/home/michele/btrfs-unstable-standalone/inode.c:5024: warning: initiali=
zation
from incompatible pointer type
/home/michele/btrfs-unstable-standalone/inode.c:5030: warning: initiali=
zation
from incompatible pointer type
/home/michele/btrfs-unstable-standalone/inode.c:5040: warning: initiali=
zation
from incompatible pointer type
make[2]: *** [/home/michele/btrfs-unstable-standalone/inode.o] Error 1
make[1]: *** [_module_/home/michele/btrfs-unstable-standalone] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.26-1-686'
make: *** [all] Error 2
michele:~/btrfs-unstable-standalone$=20


michele:~/btrfs-unstable-standalone$ uname -r
2.6.26-1-686

from debian=20

Thanks,
Michele

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
