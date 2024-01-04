Received: from smtp.tiscali.it (michael.mail.tiscali.it [213.205.33.246])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508FC2C1A8
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jan 2024 19:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tiscali.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tiscali.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tiscali.it header.i=@tiscali.it header.b="vLRgprRJ"
Received: from venice.bhome ([84.220.171.3])
	by michael.mail.tiscali.it with 
	id Wjuc2B01704l9eU01jucZR; Thu, 04 Jan 2024 19:54:37 +0000
X-Spam-Final-Verdict: clean
X-Spam-State: 0
X-Spam-Score: -100
X-Spam-Verdict: clean
x-auth-user: kreijack@tiscali.it
From: Goffredo Baroncelli <kreijack@tiscali.it>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>,
	Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH] btrfs-progs: btrfs dev us: don't print uncorrect unallocated data
Date: Thu,  4 Jan 2024 20:53:44 +0100
Message-ID: <f862a81c8ac4b63b2cca2096ffb75907ae899c95.1704398024.git.kreijack@inwind.it>
X-Mailer: git-send-email 2.43.0
Reply-To: Goffredo Baroncelli <kreijack@libero.it>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tiscali.it; s=smtp;
	t=1704398077; bh=htHPWGoPKhqRB2sVODRN5bx0bOzdIkzuoc0PcuCCZYg=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=vLRgprRJLygD74FsNb2yUWxoFzWpI/T1ry5S9KUsu1139qrR5LsUHw3gjkEiJSYQe
	 iZmBs2NH/DbT4QO1I9bkh9KA16X/AY0gSFnHHEWaLLGy8WmbSiEk+I9IaEKhDnJUfl
	 oX9wAFo1tC9S5DzZVuGoan1kT0IfAcl2D0xr/HDM=

From: Goffredo Baroncelli <kreijack@inwind.it>

If "btrfs dev us" is invoked by a not root user, it is imposible to
collect the chunk info data (not enough privileges). This causes
"btrfs dev us" to print as "Unallocated" value the size of the disk.

This patch handle the case where print_device_chunks() is invoked
without the chunk info data, printing "Unallocated N/A":

Before the patch:

$ btrfs dev us t/
WARNING: cannot read detailed chunk info, per-device usage will not be shown, run as root
/dev/loop0, ID: 1
   Device size:             5.00GiB
   Device slack:              0.00B
   Unallocated:             5.00GiB  <-- Wrong

$ sudo btrfs dev us t/
[sudo] password for ghigo:
/dev/loop0, ID: 1
   Device size:             5.00GiB
   Device slack:              0.00B
   Data,single:             8.00MiB
   Metadata,DUP:          512.00MiB
   System,DUP:             16.00MiB
   Unallocated:             4.48GiB  <-- Correct

After the patch:
$ ./btrfs dev us /tmp/t/
WARNING: cannot read detailed chunk info, per-device usage will not be shown, run as root
/dev/loop0, ID: 1
   Device size:             5.00GiB
   Device slack:              0.00B
   Unallocated:                 N/A

$ sudo ./btrfs dev us /tmp/t/
[sudo] password for ghigo:
/dev/loop0, ID: 1
   Device size:             5.00GiB
   Device slack:              0.00B
   Data,single:             8.00MiB
   Metadata,DUP:          512.00MiB
   System,DUP:             16.00MiB
   Unallocated:             4.48GiB

Signed-off-by: Goffredo Baroncelli <kreijack@libero.it>
Reviewed-by: Anand Jain <anand.jain@oracle.com>

---
 cmds/filesystem-usage.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/cmds/filesystem-usage.c b/cmds/filesystem-usage.c
index 015c401e..e88ee323 100644
--- a/cmds/filesystem-usage.c
+++ b/cmds/filesystem-usage.c
@@ -1302,10 +1302,20 @@ void print_device_chunks(const struct device_info *devinfo,
 		allocated += size;
 
 	}
-	pr_verbose(LOG_DEFAULT, "   Unallocated: %*s%10s\n",
-		(int)(20 - strlen("Unallocated")), "",
-		pretty_size_mode(devinfo->size - allocated,
-			unit_mode | UNITS_NEGATIVE));
+
+	/*
+	 * If chunkinfos is empty, we cannot compute the unallocated
+	 * size, so don't print uncorrect data.
+	 */
+	if (chunkinfos->length == 0)
+		pr_verbose(LOG_DEFAULT, "   Unallocated: %*s%10s\n",
+			(int)(20 - strlen("Unallocated")), "",
+			"N/A");
+	else
+		pr_verbose(LOG_DEFAULT, "   Unallocated: %*s%10s\n",
+			(int)(20 - strlen("Unallocated")), "",
+			pretty_size_mode(devinfo->size - allocated,
+				unit_mode | UNITS_NEGATIVE));
 }
 
 void print_device_sizes(const struct device_info *devinfo, unsigned unit_mode)
-- 
2.43.0

