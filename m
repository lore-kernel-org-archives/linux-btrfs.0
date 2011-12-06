From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH] xfstests: check if qa user can execute commands
Date: Tue,  6 Dec 2011 10:56:29 +0100
Message-ID: <1323165389-5419-1-git-send-email-list.btrfs@jan-o-sch.net>
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

_require_user only checks if the qa user exists in /etc/passwd. It may exist
though still not be able to execute anything (e.g. with a /bin/false shell).

_user_do cannot determine failure to execute the given command, as it uses
_user_do_filter for post-processing which succeeds even if the command
fails. Thus, the check should be performed by _require_user.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 common.rc |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index cab0b64..f540a79 100644
--- a/common.rc
+++ b/common.rc
@@ -897,6 +897,8 @@ _require_user()
     qa_user=fsgqa
     _cat_passwd | grep -q $qa_user
     [ "$?" == "0" ] || _notrun "$qa_user user not defined."
+    echo /bin/true | su $qa_user
+    [ "$?" == "0" ] || _notrun "$qa_user cannot execute commands."
 }
 
 _filter_user_do()
-- 
1.7.2.2

