Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41989 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab3HOAX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 20:23:56 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so41209bkb.10
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 17:23:54 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1376508521-8666-1-git-send-email-jbacik@fusionio.com>
References: <1376508521-8666-1-git-send-email-jbacik@fusionio.com>
Date: Thu, 15 Aug 2013 01:23:53 +0100
Message-ID: <CAL3q7H4EO+SXXDfRJHw4Zg+Lbg8b4VAby2=b43r3v2K7mLUseg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: separate out tests into their own directory
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 14, 2013 at 8:28 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> The plan is to have a bunch of unit tests that run when btrfs is loaded when you
> build with the appropriate config option.  My ultimate goal is to have a test
> for every non-static function we have, but at first I'm going to focus on the
> things that cause us the most problems.  To start out with this just adds a
> tests/ directory and moves the existing free space cache tests into that
> directory and sets up all of the infrastructure.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Josef this seems to have broke compilation when sanity checks are not enabled.
The following patch fixes it for me at least. Thanks.


>From d35b256737dd53245c223692a4c16165a0196a5e Mon Sep 17 00:00:00 2001
From: Filipe David Borba Manana <fdmanana@gmail.com>
Date: Thu, 15 Aug 2013 01:19:53 +0100
Subject: [PATCH] Btrfs: fix compilation when sanity tests aren't enabled
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Error was:

  CC [M]  fs/btrfs/super.o
  CC [M]  fs/btrfs/ctree.o
  CC [M]  fs/btrfs/extent-tree.o
  CC [M]  fs/btrfs/print-tree.o
fs/btrfs/super.c: In function ‘btrfs_run_sanity_tests’:
fs/btrfs/super.c:1771:2: error: implicit declaration of function
‘btrfs_test_free_space_cache’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [fs/btrfs/super.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [fs/btrfs] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [fs] Error 2
make: *** Waiting for unfinished jobs....

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/super.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8c2d650..e859b4a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -57,9 +57,7 @@
 #include "dev-replace.h"
 #include "free-space-cache.h"

-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 #include "tests/btrfs-tests.h"
-#endif

 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
-- 
1.7.9.5
