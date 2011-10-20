From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 5/5] _populate_fs should use OPTIND when getopts is used
Date: Thu, 20 Oct 2011 23:41:22 +0800
Message-ID: <1319125282-17062-6-git-send-email-Anand.Jain@oracle.com>
References: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
 <1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
Cc: Anand Jain <Anand.Jain@oracle.com>
To: hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 common.rc |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index e3c4e67..cab0b64 100644
--- a/common.rc
+++ b/common.rc
@@ -1547,6 +1547,7 @@ _populate_fs()
     root=root       # path of initial root of directory tree
     randomdata=false # -x data type urandom or zero
 
+    OPTIND=1
     while getopts "d:f:n:r:s:v:x" c
     do
         case $c in
-- 
1.7.7

