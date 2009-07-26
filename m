From: Giuseppe Scrivano <gscrivano@gnu.org>
Subject: [PATCH] Check the `sectors' vector length before use it
Date: Sun, 26 Jul 2009 23:21:32 +0200
Message-ID: <87d47n9m3n.fsf@master.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I noticed that the "btrfs-debug-tree -e DEVICE" command returns an empty
list.  If it is a normal behaviour then this trivial patch solves a
problem in the show-blocks program, where the `sectors' vector is used
even in the case its length is zero.

Regards,
Giuseppe


>From 7caf73f4a7be8baa1493578c56477d3b279773ec Mon Sep 17 00:00:00 2001
From: Giuseppe Scrivano <gscrivano@gnu.org>
Date: Sun, 26 Jul 2009 23:12:38 +0200
Subject: [PATCH] Check the vector length before use it

---
 show-blocks |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/show-blocks b/show-blocks
index 0164be9..c6cdc12 100755
--- a/show-blocks
+++ b/show-blocks
@@ -228,7 +228,7 @@ shapeit(data)
 sectors = data[:,0]
 sizes = data[:,1]
 datalen = len(data)
-sectormax = numpy.max(sectors)
+sectormax = numpy.max(sectors) if len(sectors) > 0 else 0
 sectormin = 0
 num_cells = 800
 total_cells = num_cells * num_cells
-- 
1.6.3.3

