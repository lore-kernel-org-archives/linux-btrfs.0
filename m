Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17778 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbbEUMu7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 08:50:59 -0400
From: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] fsck.btrfs: Fix bashism and bad getopts processing
Date: Thu, 21 May 2015 13:50:55 +0100
Message-Id: <1432212655-6238-1-git-send-email-dimitri.j.ledkov@intel.com>
In-Reply-To: <20150521115651.GP23255@twin.jikos.cz>
References: <20150521115651.GP23255@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First fix == bashism, as that is not accepted by e.g. Debian/Ubuntu
dash.

Secondly shift OPTIND, such that last parameter is checked to exist.

Signed-off-by: Dimitri John Ledkov <dimitri.j.ledkov@intel.com>
---
 fsck.btrfs | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fsck.btrfs b/fsck.btrfs
index f056a7f..20b070a 100755
--- a/fsck.btrfs
+++ b/fsck.btrfs
@@ -26,12 +26,13 @@ do
 	a|A|p|y)	AUTO=true;;
 	esac
 done
+shift $(($OPTIND -1))
 eval DEV=\${$#}
 if [ ! -e $DEV ]; then
 	echo "$0: $DEV does not exist"
 	exit 8
 fi
-if [ "$AUTO" == "false" ]; then
+if ! $AUTO; then
 	echo "If you wish to check the consistency of a BTRFS filesystem or"
 	echo "repair a damaged filesystem, see btrfs(8) subcommand 'check'."
 fi
-- 
2.1.4

