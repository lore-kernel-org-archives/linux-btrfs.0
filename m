From: Josef Bacik <josef@redhat.com>
Subject: Weird compile issue on sparc
Date: Mon, 15 Jun 2009 18:00:59 -0400
Message-ID: <20090615220059.GG3085@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

When trying to rebuild fedora for sparc, the btrfs-progs package failed to
compile.  This is what it spit out in the build log

gcc -Wp,-MMD,./.convert.o.d,-MT,convert.o -Wall -fno-strict-aliasing
-D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -O2 -g -pipe -Wall
-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4
-m64 -mcpu=ultrasparc -c convert.c
In file included from /usr/include/ext2fs/ext2_types.h:23,
                 from /usr/include/ext2fs/ext2_fs.h:19,
                 from convert.c:41:
/usr/include/ext2fs/ext2_types-sparc64.h:97: error: conflicting types for
'__u64'
/usr/include/asm-generic/int-ll64.h:28: note: previous declaration of '__u64'
was here
/usr/include/ext2fs/ext2_types-sparc64.h:113: error: conflicting types for
'__s64'
/usr/include/asm-generic/int-ll64.h:27: note: previous declaration of '__s64'
was here

I assume its because we typedef in kerncompat.h and then it gets done elsewhere
via the ext2 headers.  This was just brought to my attention.  I will look at it
tomorrow unless somebody has an idea of how to fix this before then (like say
Yan :) ) then I would be grateful.  Thanks,

Josef
