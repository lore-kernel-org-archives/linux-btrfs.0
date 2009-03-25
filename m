From: jim owens <jowens@hp.com>
Subject: [PATCH] remove unused ftrace include
Date: Wed, 25 Mar 2009 11:21:47 -0400
Message-ID: <49CA4C0B.1060500@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


ftrace does not exist in earlier kernels and requires backport patching

Signed-off-by: jim owens <jowens@hp.com>
---
  fs/btrfs/async-thread.c |    1 -
  fs/btrfs/delayed-ref.c  |    1 -
  2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index c84ca1f..61c7d95 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -20,7 +20,6 @@
  #include <linux/list.h>
  #include <linux/spinlock.h>
  #include <linux/freezer.h>
-#include <linux/ftrace.h>
  #include "async-thread.h"

  #define WORK_QUEUED_BIT 0
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index d513d70..a972584 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -18,7 +18,6 @@

  #include <linux/sched.h>
  #include <linux/sort.h>
-#include <linux/ftrace.h>
  #include "ctree.h"
  #include "delayed-ref.h"
  #include "transaction.h"
-- 
1.5.4.3
