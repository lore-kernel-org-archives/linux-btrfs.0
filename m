Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50250 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3C0N5i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 09:57:38 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2RDvbw9025608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 13:57:37 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2RDvaoJ001037
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 13:57:36 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2RDvaaV006152
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 08:57:36 -0500
Message-ID: <5152FA04.8080400@oracle.com>
Date: Wed, 27 Mar 2013 14:54:12 +0100
From: Koen De Wit <koen.de.wit@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: add quota-related info to usage messages
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extending usage messages with some info on the quota functionality:
     - The -i option of "subvol create" and "subvol snapshot" was not 
documented
     - The -c option of "qgroup limit" is the default option
     - The "qouta rescan" command is not yet implemented, while it should be
       executed after enabling quota on a non-empty filesystem.

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
---
  cmds-qgroup.c    |    3 ++-
  cmds-quota.c     |    4 ++++
  cmds-subvolume.c |   11 ++++++++---
  3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 275f00f..95aca9b 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -326,7 +326,8 @@ static const char * const cmd_qgroup_limit_usage[] = {
      "btrfs qgroup limit [options] <size>|none [<qgroupid>] <path>",
      "Limit the size of a subvolume quota group.",
      "",
-    "-c   limit amount of data after compression",
+    "-c   limit amount of data after compression. This is the default,",
+    "     it is currently not possible to turn off this option.",
      "-e   limit space exclusively assigned to this qgroup",
      NULL
  };
diff --git a/cmds-quota.c b/cmds-quota.c
index 8481514..71cd9f1 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -64,6 +64,9 @@ int quota_ctl(int cmd, int argc, char **argv)
  static const char * const cmd_quota_enable_usage[] = {
      "btrfs quota enable <path>",
      "Enable subvolume quota support for a filesystem.",
+    "Any data already present on the filesystem will not count towards",
+    "the space usage numbers. It is recommended to enable quota for a",
+    "filesystem before writing any data to it.",
      NULL
  };

@@ -92,6 +95,7 @@ static int cmd_quota_disable(int argc, char **argv)
  static const char * const cmd_quota_rescan_usage[] = {
      "btrfs quota rescan <path>",
      "Rescan the subvolume for a changed quota setting.",
+    "Not yet implemented.",
      NULL
  };

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 74e2130..b762470 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -61,10 +61,13 @@ static int test_isdir(char *path)
  }

  static const char * const cmd_subvol_create_usage[] = {
-    "btrfs subvolume create [<dest>/]<name>",
+    "btrfs subvolume create [-i <qgroupid>] [<dest>/]<name>",
      "Create a subvolume",
      "Create a subvolume <name> in <dest>.  If <dest> is not given",
      "subvolume <name> will be created in the current directory.",
+    "",
+    "-i <qgroupid>  add the newly created subvolume to a qgroup. This",
+    "               option can be given multiple times.",
      NULL
  };

@@ -480,12 +483,14 @@ out:
  }

  static const char * const cmd_snapshot_usage[] = {
-    "btrfs subvolume snapshot [-r] <source> [<dest>/]<name>",
+    "btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> [<dest>/]<name>",
      "Create a snapshot of the subvolume",
      "Create a writable/readonly snapshot of the subvolume <source> with",
      "the name <name> in the <dest> directory",
      "",
-    "-r     create a readonly snapshot",
+    "-r             create a readonly snapshot",
+    "-i <qgroupid>  add the newly created snapshot to a qgroup. This",
+    "               option can be given multiple times.",
      NULL
  };

-- 
1.7.2.5

