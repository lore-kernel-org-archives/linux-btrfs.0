From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH 04/37] Remove unneeded version.h
	includes from fs/
Date: Thu, 23 Jun 2011 23:59:32 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1106232358330.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Bob Copeland <me@bobcopeland.com>, Chris Mason <chris.mason@oracle.com>,
	trivial@kernel.org, linux-karma-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-karma-devel-bounces@lists.sourceforge.net>
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-karma-devel>,
	<mailto:linux-karma-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-karma-devel>
List-Post: <mailto:linux-karma-devel@lists.sourceforge.net>
List-Help: <mailto:linux-karma-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-karma-devel>,
	<mailto:linux-karma-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-karma-devel-bounces@lists.sourceforge.net
List-ID: <linux-btrfs.vger.kernel.org>

It was pointed out by 'make versioncheck' that some includes of
linux/version.h were not needed in fs/ (fs/btrfs/ctree.h and
fs/omfs/file.c).
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/btrfs/ctree.h |    1 -
 fs/omfs/file.c   |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3006287..f30ac05 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -19,7 +19,6 @@
 #ifndef __BTRFS_CTREE__
 #define __BTRFS_CTREE__
 
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/fs.h>
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index d738a7e..2c6d952 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -4,7 +4,6 @@
  * Released under GPL v2.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


------------------------------------------------------------------------------
All the data continuously generated in your IT infrastructure contains a 
definitive record of customers, application performance, security 
threats, fraudulent activity and more. Splunk takes this data and makes 
sense of it. Business sense. IT sense. Common sense.. 
http://p.sf.net/sfu/splunk-d2d-c1
