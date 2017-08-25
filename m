Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56709 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757365AbdHYSFP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 14:05:15 -0400
Date: Fri, 25 Aug 2017 20:03:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Buchbinder <abuchbinder@google.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Enable ThreadSanitizer, using D=tsan.
Message-ID: <20170825180348.GK2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712200449.18638-1-abuchbinder@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712200449.18638-1-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 01:04:49PM -0700, Adam Buchbinder wrote:
> Tested with clang-3.9.
> 
> Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
> ---
>  Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 81598df..8948301 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -17,6 +17,7 @@
>  #                  abort   - call abort() on first error (dumps core)
>  #                  all     - shortcut for all of the above
>  #                  asan    - enable address sanitizer compiler feature
> +#                  tsan    - enable thread sanitizer compiler feature
>  #                  ubsan   - undefined behaviour sanitizer compiler feature
>  #                  bcheck  - extended build checks
>  #   W=123          build with warnings (default: off)
> @@ -157,6 +158,11 @@ ifneq (,$(findstring asan,$(D)))
>    DEBUG_CFLAGS_INTERNAL += -fsanitize=address
>  endif
>  
> +ifneq (,$(findstring tsan,$(D)))
> +  DEBUG_CFLAGS_INTERNAL += -fsanitize=thread -fPIE
> +  LD_FLAGS += -fsanitize=thread -ltsan -pie

I did not notice that first, but there's no variable LD_FLAGS, it's
LDFLAGS. So either clang assumes this variable and used it or this
magically worked independent of the flags you set here.

The LDFLAGS should be set in a similar way as DEBUG_CFLAGS_INTERNAL,
I'll fix that myself. Then the linker flags are then passed and it also
works with gcc.

The libbtrfs library still fails to build, complaining about the missing
fPIC flags, which is a bit puzzling as the flags are there.

    [CC]     send-stream.o
gcc -g -O1 -Wall -D_FORTIFY_SOURCE=2 -std=gnu90 -include config.h -DBTRFS_FLAT_INCLUDES -D_XOPEN_SOURCE=700 -fno-strict-aliasing -fPIC -I/labs/dsterba/gits/btrfs-progs -I/labs/dsterba/gits/btrfs-progs/kernel-lib  -O0 -U_FORTIFY_SOURCE -ggdb3  -fsanitize=thread -fPIE  -c send-stream.c -o send-stream.o
    [LD]     libbtrfs.so.0.1
gcc -g -O1 -Wall -D_FORTIFY_SOURCE=2 -std=gnu90 -include config.h -DBTRFS_FLAT_INCLUDES -D_XOPEN_SOURCE=700 -fno-strict-aliasing -fPIC -I/labs/dsterba/gits/btrfs-progs -I/labs/dsterba/gits/btrfs-progs/kernel-lib  -O0 -U_FORTIFY_SOURCE -ggdb3  -fsanitize=thread -fPIE  send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o kernel-lib/crc32c.o messages.o uuid-tree.o utils-lib.o rbtree-utils.o  -rdynamic -L/labs/dsterba/gits/btrfs-progs -fsanitize=thread -ltsan -pie  -luuid -lblkid -L. -pthread \
        -shared -Wl,-soname,libbtrfs.so.0 -o libbtrfs.so.0.1
/usr/lib64/gcc/x86_64-suse-linux/7/../../../../x86_64-suse-linux/bin/ld: send-stream.o: relocation R_X86_64_PC32 against symbol `stderr@@GLIBC_2.2.5' can not be used when making a shared object; recompile with -fPIC
/usr/lib64/gcc/x86_64-suse-linux/7/../../../../x86_64-suse-linux/bin/ld: final link failed: Bad value
collect2: error: ld returned 1 exit status
make: *** [Makefile:347: libbtrfs.so.0.1] Error 1
