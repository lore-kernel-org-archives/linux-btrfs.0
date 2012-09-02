Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55190 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2IBVUz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Sep 2012 17:20:55 -0400
Received: by pbbrr13 with SMTP id rr13so7200820pbb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Sep 2012 14:20:54 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 2 Sep 2012 17:20:54 -0400
Message-ID: <CAPL5yKea2mRae+29i_TK3Nj4dhgCDFDiJxDfHX=r0QywNQnEgQ@mail.gmail.com>
Subject: Segregate metadata to SSD?
From: Dan Merillat <dan.merillat@gmail.com>
To: BTRFS Mailing list <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is it possible to weight the allocations of data/system/metadata so
that data goes on large, slow drives while system/metadata goes on a
fast SSD?  I don't have exact numbers, but I'd guess a vast majority
of seeks during operation are lookups of tiny bits of data, while data
reads&writes are done in much larger chunks.

Obviously a database load would be a different balance, but for most
systems it would seem to be a rather vast improvement.

Data: total=5625880576k (5.24TB), used=5455806964k (5.08TB)
System, DUP: total=32768k (32.00MB), used=724k (724.00KB)
System: total=4096k (4.00MB), used=0k (0.00)
Metadata, DUP: total=117291008k (111.86GB), used=13509540k (12.88GB)

Out of my nearly 6tb setup I could trivially accelerate the whole
thing with a 128mb SSD.

On a side note,  that's a nearly 10:1 metadata overusage and I've
never had more than 3
snapshots at a given time - current, rollback1, rollback2 - I think it
grew that large during a
rebalance.  Aside from that, I could get away with a tiny 64gb SSD.


pretty_sizes was too granular to use in monitoring scripts, so:
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b1457de..dc5fea6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -145,8 +145,9 @@ static int cmd_df(int argc, char **argv)

                total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
                used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
-               printf("%s: total=%s, used=%s\n", description, total_bytes,
-                      used_bytes);
+               printf("%s: total=%ldk (%s), used=%ldk (%s)\n", description,
+                       sargs->spaces[i].total_bytes/1024, total_bytes,
+                       sargs->spaces[i].used_bytes/1024, used_bytes);
        }
        free(sargs);
