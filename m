Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41171 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3CRDjH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Mar 2013 23:39:07 -0400
Message-ID: <51468C84.2060204@oracle.com>
Date: Mon, 18 Mar 2013 11:39:48 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3 v4] btrfs-progs: disable using backup superblock by
 default
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-1-git-send-email-anand.jain@oracle.com> <1363230357-7438-4-git-send-email-anand.jain@oracle.com> <514153B0.7020100@redhat.com> <514190AA.2080405@oracle.com> <5141E31B.30407@redhat.com> <5141E36C.10905@redhat.com> <51430E10.5070807@oracle.com> <51434DAC.9000206@redhat.com>
In-Reply-To: <51434DAC.9000206@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> # mkfs.btrfs /dev/sdb /dev/sdc -f && mount /dev/sdb /btrfs
>> # ./check-mounted /dev/sdc
>> its btrfs
>> /dev/sdc is currently mounted. Aborting.
>> # dd if=/dev/zero of=/dev/sdc count=8 seek=$(((64 * 1024)/512))
>> # ./check-mounted /dev/sdc
>
> what is "./check-mounted?"

  sorry forgot to mention.. check-mounted is small prog it unit-tests
  check_mounted() function (Find the diff below.)

>> Not mounted
>> # cat /proc/mounts | egrep btrfs
>> /dev/sdb /btrfs btrfs rw,seclabel,relatime,noacl,space_cache 0 0
>>
>>
>>   So we have to set BTRFS_SCAN_BACKUP_SB for check_mounted()
>>   But the above scenario is not simple enough to be practical though.
>
> (Seems like a mount check would be best implemented by asking the kernel
> which devices are in use for mounted btrfs filesystems, rather than
> scanning the block devices directly, but maybe that's a different issue.)
>
> I guess I need to stop & think more carefully about this, it seems like
> I am not seeing the whole picture.
>
> The overall goal here is to not discover "btrfs" devices which actually
> only have stale backup superblocks present, right?
>
> The loop in btrfs_read_dev_super() might be ok for verifying backups,
> but it should probably fail outright on the first bad one it finds,
> or at least if the primary is bad; the user would be notified of the
> inconsistency and could take corrective action w/ fsck or whatnot, right?

  This logic is not be suitable for the function check_mounted().
  The above test case just demonstrates that. This is about btrfs
  on multi-dev and we use one dev to mount and another dev to check
  if its mounted, now if the primary SB is corrupted on this (latter)
  dev we still need to find its mounted by reading from the backup SB,
  so setting the BTRFS_SCAN_BACKUP_SB will help.

Thanks,  Anand

---------------------------------------------------------------------
diff --git a/Makefile b/Makefile
index d102dee..c97e6b7 100644
--- a/Makefile
+++ b/Makefile
@@ -159,6 +159,10 @@ btrfs-select-super: $(objects) $(libs) 
btrfs-select-super.o
         @echo "    [LD]     $@"
         $(Q)$(CC) $(CFLAGS) -o btrfs-select-super $(objects) 
btrfs-select-super.o $(LDFLAGS) $(LIBS)

+check-mounted: $(objects) $(libs) check-mounted.o
+       @echo "    [LD]     $@"
+       $(Q)$(CC) $(CFLAGS) -o check-mounted $(objects) check-mounted.o 
$(LDFLAGS) $(LIBS)
+
  btrfstune: $(objects) $(libs) btrfstune.o
         @echo "    [LD]     $@"
         $(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o 
$(LDFLAGS) $(LIBS)
@@ -205,7 +209,7 @@ clean :
         @echo "Cleaning"
         $(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert 
btrfs-image btrfs-select-super \
               btrfs-zero-log btrfstune dir-test ioctl-test quick-test 
send-test btrfs.static btrfsck \
-             version.h \
+             version.h check-mounted\
               $(libs) $(lib_links)
         $(Q)$(MAKE) $(MAKEOPTS) -C man $@

diff --git a/check-mounted.c b/check-mounted.c
new file mode 100644
index 0000000..781edec
--- /dev/null
+++ b/check-mounted.c
@@ -0,0 +1,31 @@
+
+#define _XOPEN_SOURCE 500
+#define _GNU_SOURCE 1
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include "kerncompat.h"
+#include "ctree.h"
+#include "disk-io.h"
+#include "print-tree.h"
+#include "transaction.h"
+#include "list.h"
+#include "version.h"
+#include "utils.h"
+
+int main(int ac, char **av)
+{
+       int ret;
+
+       if((ret = check_mounted(av[optind])) < 0) {
+               fprintf(stderr, "Could not check mount status: %s\n", 
strerror(-ret));
+               return ret;
+       } else if(ret) {
+               fprintf(stderr, "%s is currently mounted. Aborting.\n", 
av[optind]);
+               return -EBUSY;
+       }
+       printf("Not mounted\n");
+       return 0;
+}
------------------------------------------------------------------------------





