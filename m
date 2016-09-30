Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4952 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753598AbcI3BLd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 21:11:33 -0400
Subject: Re: [RFC][PATCH] btrfs-progs: move sources shared with kernel to own
 directory
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1475167106-18054-1-git-send-email-dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a0920b31-3dad-5253-7d6f-938bb7bedb0b@cn.fujitsu.com>
Date: Fri, 30 Sep 2016 09:11:30 +0800
MIME-Version: 1.0
In-Reply-To: <1475167106-18054-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/30/2016 12:38 AM, David Sterba wrote:
> Hi,
>
> I've started to reorganize the souces in progs so we can split the files and
> group them. At the moment there's the kernel library (crc, list, radix, ...) as
> the files are almost exactly the same as provided by kernel.
>
> This patch moves btrfs-specific sources to own directory. As this is a bigger
> change I could use some feedback if there are better alternatives (*). The
> makefile is still global, object files are put next to the sources.

+1 for global makefile. We don't need to bother several makefile, that's 
nice.

>
> To current state and plans to continue the split:
>
> - kernel-lib/     - as described in the first paragraph

Already using devel branch. Seems good to me.

> - kernel-shared/  - dtto, second
> - cmds/           - (planned) cmds-*.[ch]

Sounds good, so we can skip the "cmds-" prefix then.

> - convert/        - move as-is, split later, eg. per filsystem
> - image/          - move as-is, split if needed
> - check/          - split from cmds-check

Pretty cool.
I'm also moving some code into its own dir doing the user-space scrub work.
(While I'm creating a new dir called fsck/ and put my scrub code into 
it, rename it to check/ won't be a problem though)

While I'm not sure what is going to be in kernel-shared/ dir.

Uapi headers? or things like disk-io.c volumes.c?

For uapi headers, then kernel-shared/ may contain few files.
For disk-io.c/volumes.c, they are not shared with kernel anymore.

Thanks,
Qu

>
> There will be space for code shared potentially by any of the above, that
> should remain in the toplevel directory, we'll see later how to organize.  The
> remaining standalone tools shall remain in the toplevel directory.
>
> The target for kernel-shared split is 4.9, 4.8 will have the kernel-lib split.
>
> Preview can be found in my devel git repos in branch preview/move-shared .
>
> Thanks for feedback.
>
> (*) no automake please
>
> ------>8---8<------
> From: David Sterba <dsterba@suse.com>
>
> All files that share content and purpose with the corresponding file in
> the kernel are moved to a separate directory. There's only some overlap,
> can't be 100% match but many functions are shared. A diff between the
> files can reveal changes that should be applied to the other codebase.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  Makefile.in                                            | 18 +++++++++++-------
>  backref.c => kernel-shared/backref.c                   |  0
>  backref.h => kernel-shared/backref.h                   |  0
>  ctree.c => kernel-shared/ctree.c                       |  0
>  ctree.h => kernel-shared/ctree.h                       |  0
>  dir-item.c => kernel-shared/dir-item.c                 |  0
>  disk-io.c => kernel-shared/disk-io.c                   |  0
>  disk-io.h => kernel-shared/disk-io.h                   |  0
>  extent-tree.c => kernel-shared/extent-tree.c           |  0
>  extent_io.c => kernel-shared/extent_io.c               |  0
>  extent_io.h => kernel-shared/extent_io.h               |  0
>  file-item.c => kernel-shared/file-item.c               |  0
>  file.c => kernel-shared/file.c                         |  0
>  free-space-cache.c => kernel-shared/free-space-cache.c |  0
>  free-space-cache.h => kernel-shared/free-space-cache.h |  0
>  free-space-tree.c => kernel-shared/free-space-tree.c   |  0
>  free-space-tree.h => kernel-shared/free-space-tree.h   |  0
>  inode-item.c => kernel-shared/inode-item.c             |  0
>  inode-map.c => kernel-shared/inode-map.c               |  0
>  inode.c => kernel-shared/inode.c                       |  0
>  print-tree.c => kernel-shared/print-tree.c             |  0
>  print-tree.h => kernel-shared/print-tree.h             |  0
>  root-tree.c => kernel-shared/root-tree.c               |  0
>  ulist.c => kernel-shared/ulist.c                       |  0
>  ulist.h => kernel-shared/ulist.h                       |  0
>  volumes.c => kernel-shared/volumes.c                   |  0
>  volumes.h => kernel-shared/volumes.h                   |  0
>  27 files changed, 11 insertions(+), 7 deletions(-)
>  rename backref.c => kernel-shared/backref.c (100%)
>  rename backref.h => kernel-shared/backref.h (100%)
>  rename ctree.c => kernel-shared/ctree.c (100%)
>  rename ctree.h => kernel-shared/ctree.h (100%)
>  rename dir-item.c => kernel-shared/dir-item.c (100%)
>  rename disk-io.c => kernel-shared/disk-io.c (100%)
>  rename disk-io.h => kernel-shared/disk-io.h (100%)
>  rename extent-tree.c => kernel-shared/extent-tree.c (100%)
>  rename extent_io.c => kernel-shared/extent_io.c (100%)
>  rename extent_io.h => kernel-shared/extent_io.h (100%)
>  rename file-item.c => kernel-shared/file-item.c (100%)
>  rename file.c => kernel-shared/file.c (100%)
>  rename free-space-cache.c => kernel-shared/free-space-cache.c (100%)
>  rename free-space-cache.h => kernel-shared/free-space-cache.h (100%)
>  rename free-space-tree.c => kernel-shared/free-space-tree.c (100%)
>  rename free-space-tree.h => kernel-shared/free-space-tree.h (100%)
>  rename inode-item.c => kernel-shared/inode-item.c (100%)
>  rename inode-map.c => kernel-shared/inode-map.c (100%)
>  rename inode.c => kernel-shared/inode.c (100%)
>  rename print-tree.c => kernel-shared/print-tree.c (100%)
>  rename print-tree.h => kernel-shared/print-tree.h (100%)
>  rename root-tree.c => kernel-shared/root-tree.c (100%)
>  rename ulist.c => kernel-shared/ulist.c (100%)
>  rename ulist.h => kernel-shared/ulist.h (100%)
>  rename volumes.c => kernel-shared/volumes.c (100%)
>  rename volumes.h => kernel-shared/volumes.h (100%)
>
> diff --git a/Makefile.in b/Makefile.in
> index 20b740a0babd..2a08978f8b85 100644
> --- a/Makefile.in
> +++ b/Makefile.in
> @@ -62,6 +62,7 @@ CFLAGS = @CFLAGS@ \
>  	 -fPIC \
>  	 -I$(TOPDIR) \
>  	 -I$(TOPDIR)/kernel-lib \
> +	 -I$(TOPDIR)/kernel-shared \
>  	 $(EXTRAWARN_CFLAGS) \
>  	 $(DEBUG_CFLAGS_INTERNAL) \
>  	 $(EXTRA_CFLAGS)
> @@ -87,12 +88,14 @@ CHECKER_FLAGS := -include $(check_defs) -D__CHECKER__ \
>  	-D__CHECK_ENDIAN__ -Wbitwise -Wuninitialized -Wshadow -Wundef \
>  	-U_FORTIFY_SOURCE
>
> -objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
> -	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
> -	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
> -	  qgroup.o raid6.o free-space-cache.o kernel-lib/list_sort.o props.o \
> -	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
> -	  inode.o file.o find-root.o free-space-tree.o help.o
> +objects = kernel-shared/ctree.o kernel-shared/disk-io.o kernel-lib/radix-tree.o \
> +	  kernel-shared/extent-tree.o kernel-shared/print-tree.o \
> +	  kernel-shared/root-tree.o kernel-shared/dir-item.o \
> +	  kernel-shared/file-item.o kernel-shared/inode-item.o kernel-shared/inode-map.o \
> +	  extent-cache.o kernel-shared/extent_io.o kernel-shared/volumes.o utils.o repair.o \
> +	  qgroup.o raid6.o kernel-shared/free-space-cache.o kernel-lib/list_sort.o props.o \
> +	  kernel-shared/ulist.o qgroup-verify.o kernel-shared/backref.o string-table.o task-utils.o \
> +	  kernel-shared/inode.o kernel-shared/file.o find-root.o kernel-shared/free-space-tree.o help.o
>  cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>  	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
>  	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
> @@ -105,7 +108,7 @@ libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
>  libbtrfs_headers = send-stream.h send-utils.h send.h kernel-lib/rbtree.h btrfs-list.h \
>  	       kernel-lib/crc32c.h kernel-lib/list.h kerncompat.h \
>  	       kernel-lib/radix-tree.h extent-cache.h \
> -	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
> +	       kernel-shared/extent_io.h ioctl.h kernel-shared/ctree.h btrfsck.h version.h
>  TESTS = fsck-tests.sh convert-tests.sh
>
>  udev_rules = 64-btrfs-dm.rules
> @@ -426,6 +429,7 @@ clean: $(CLEANDIRS)
>  	@echo "Cleaning"
>  	$(Q)$(RM) -f $(progs) cscope.out *.o *.o.d \
>  		kernel-lib/*.o kernel-lib/*.o.d \
> +		kernel-shared/*.o kernel-shared/*.o.d \
>  	      dir-test ioctl-test quick-test send-test library-test library-test-static \
>  	      btrfs.static mkfs.btrfs.static \
>  	      $(check_defs) \
> diff --git a/backref.c b/kernel-shared/backref.c
> similarity index 100%
> rename from backref.c
> rename to kernel-shared/backref.c
> diff --git a/backref.h b/kernel-shared/backref.h
> similarity index 100%
> rename from backref.h
> rename to kernel-shared/backref.h
> diff --git a/ctree.c b/kernel-shared/ctree.c
> similarity index 100%
> rename from ctree.c
> rename to kernel-shared/ctree.c
> diff --git a/ctree.h b/kernel-shared/ctree.h
> similarity index 100%
> rename from ctree.h
> rename to kernel-shared/ctree.h
> diff --git a/dir-item.c b/kernel-shared/dir-item.c
> similarity index 100%
> rename from dir-item.c
> rename to kernel-shared/dir-item.c
> diff --git a/disk-io.c b/kernel-shared/disk-io.c
> similarity index 100%
> rename from disk-io.c
> rename to kernel-shared/disk-io.c
> diff --git a/disk-io.h b/kernel-shared/disk-io.h
> similarity index 100%
> rename from disk-io.h
> rename to kernel-shared/disk-io.h
> diff --git a/extent-tree.c b/kernel-shared/extent-tree.c
> similarity index 100%
> rename from extent-tree.c
> rename to kernel-shared/extent-tree.c
> diff --git a/extent_io.c b/kernel-shared/extent_io.c
> similarity index 100%
> rename from extent_io.c
> rename to kernel-shared/extent_io.c
> diff --git a/extent_io.h b/kernel-shared/extent_io.h
> similarity index 100%
> rename from extent_io.h
> rename to kernel-shared/extent_io.h
> diff --git a/file-item.c b/kernel-shared/file-item.c
> similarity index 100%
> rename from file-item.c
> rename to kernel-shared/file-item.c
> diff --git a/file.c b/kernel-shared/file.c
> similarity index 100%
> rename from file.c
> rename to kernel-shared/file.c
> diff --git a/free-space-cache.c b/kernel-shared/free-space-cache.c
> similarity index 100%
> rename from free-space-cache.c
> rename to kernel-shared/free-space-cache.c
> diff --git a/free-space-cache.h b/kernel-shared/free-space-cache.h
> similarity index 100%
> rename from free-space-cache.h
> rename to kernel-shared/free-space-cache.h
> diff --git a/free-space-tree.c b/kernel-shared/free-space-tree.c
> similarity index 100%
> rename from free-space-tree.c
> rename to kernel-shared/free-space-tree.c
> diff --git a/free-space-tree.h b/kernel-shared/free-space-tree.h
> similarity index 100%
> rename from free-space-tree.h
> rename to kernel-shared/free-space-tree.h
> diff --git a/inode-item.c b/kernel-shared/inode-item.c
> similarity index 100%
> rename from inode-item.c
> rename to kernel-shared/inode-item.c
> diff --git a/inode-map.c b/kernel-shared/inode-map.c
> similarity index 100%
> rename from inode-map.c
> rename to kernel-shared/inode-map.c
> diff --git a/inode.c b/kernel-shared/inode.c
> similarity index 100%
> rename from inode.c
> rename to kernel-shared/inode.c
> diff --git a/print-tree.c b/kernel-shared/print-tree.c
> similarity index 100%
> rename from print-tree.c
> rename to kernel-shared/print-tree.c
> diff --git a/print-tree.h b/kernel-shared/print-tree.h
> similarity index 100%
> rename from print-tree.h
> rename to kernel-shared/print-tree.h
> diff --git a/root-tree.c b/kernel-shared/root-tree.c
> similarity index 100%
> rename from root-tree.c
> rename to kernel-shared/root-tree.c
> diff --git a/ulist.c b/kernel-shared/ulist.c
> similarity index 100%
> rename from ulist.c
> rename to kernel-shared/ulist.c
> diff --git a/ulist.h b/kernel-shared/ulist.h
> similarity index 100%
> rename from ulist.h
> rename to kernel-shared/ulist.h
> diff --git a/volumes.c b/kernel-shared/volumes.c
> similarity index 100%
> rename from volumes.c
> rename to kernel-shared/volumes.c
> diff --git a/volumes.h b/kernel-shared/volumes.h
> similarity index 100%
> rename from volumes.h
> rename to kernel-shared/volumes.h
>


