Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab3IRBvC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 21:51:02 -0400
Message-ID: <52390704.3010902@redhat.com>
Date: Tue, 17 Sep 2013 20:51:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: rongqing.li@windriver.com
CC: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Add dependencies explicitly to fix a parallel
 build issue
References: <1379466661-27973-1-git-send-email-rongqing.li@windriver.com>
In-Reply-To: <1379466661-27973-1-git-send-email-rongqing.li@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/17/13 8:11 PM, rongqing.li@windriver.com wrote:
> From: Roy Li <rongqing.li@windriver.com>
> 
> The dependencies of "all: version.h" or other similar ones can not
> fix the parallel build failure, only reduce the times; In fact,
> many *.o files require version.h file.
> 
> 	#grep '#include "version.h"' ./ -r
> 	./btrfs-corrupt-block.c:#include "version.h"
> 	./btrfs.c:#include "version.h"
> 	./btrfs-image.c:#include "version.h"
> 	./cmds-filesystem.c:#include "version.h"
> 	./btrfs-show-super.c:#include "version.h"
> 	./btrfs-select-super.c:#include "version.h"
> 	./cmds-restore.c:#include "version.h"
> 	./btrfs-find-root.c:#include "version.h"
> 	./mkfs.c:#include "version.h"
> 	./btrfs-zero-log.c:#include "version.h"
> 	./btrfs-defrag.c:#include "version.h"
> 	./cmds-chunk.c:#include "version.h"
> 	./btrfstune.c:#include "version.h"
> 	./btrfs-calc-size.c:#include "version.h"
> 	./btrfs-map-logical.c:#include "version.h"
> 	./cmds-check.c:#include "version.h"
> 	./btrfs-debug-tree.c:#include "version.h"
> 
> Signed-off-by: Roy Li <rongqing.li@windriver.com>
> ---
>  Sorry, The patch [btrfs-progs: fix parallel build] sent by me on Sep 3
> can not fix the build failure, when build enough times on a 16 core cpu,
> the build failure happens again, so I refix it again.
> 
> 
>  Makefile |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index c43cb68..a7c259c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -81,6 +81,12 @@ endif
>  	@echo "    [CC]     $@"
>  	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
>  
> +btrfs-corrupt-block.o btrfs.o btrfs-image.o cmds-filesystem.o:version.h
> +btrfs-show-super.o btrfs-select-super.o cmds-restore.o:version.h
> +btrfs-find-root.o mkfs.o btrfs-zero-log.o btrfs-defrag.o cmds-chunk.o:version.h
> +btrfstune.o btrfs-calc-size.o btrfs-map-logical.o cmds-check.o:version.h
> +btrfs-debug-tree.o:version.h
> +
>  %.static.o: %.c
>  	@echo "    [CC]     $@"
>  	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
> 

I think this can be done more cleanly, I'll send a patch.

-Eric
