Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:50858 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab3DJKId (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 06:08:33 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp1) (RZmta 31.24 OK)
	with ESMTP id X070cep39GENd7 for <linux-btrfs@vger.kernel.org>;
	Wed, 10 Apr 2013 12:08:31 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/17 v2] Btrfs-progs: Set the root-id for received subvols in btrfs receive
Date: Wed, 10 Apr 2013 12:08:31 +0200
Message-Id: <416a130f234f59012ec1ee751e31bff09ee455c7.1365588404.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1365524492.git.sbehrens@giantdisaster.de>

When an entry was added to the subvol search tree, the root_id was
always 0 (not set at all) and therefore only the first one was
added, all the others had been ignored. This commit sets the root_id
before the entry is added.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
v1 -> v2:
- Wang Shilong noticed that a similar subfunction to retrieve the root-id
  for a subvolume was already there. This subfunction is now used instead
  of introducing a new one.

 cmds-receive.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index dc72e9e..9ad05e1 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -45,6 +45,7 @@
 #include "commands.h"
 #include "utils.h"
 #include "list.h"
+#include "btrfs-list.h"
 
 #include "send.h"
 #include "send-stream.h"
@@ -125,6 +126,9 @@ static int finish_subvol(struct btrfs_receive *r)
 		goto out;
 	}
 
+	ret = btrfs_list_get_path_rootid(subvol_fd, &r->cur_subvol->root_id);
+	if (ret < 0)
+		goto out;
 	subvol_uuid_search_add(&r->sus, r->cur_subvol);
 	r->cur_subvol = NULL;
 	ret = 0;
-- 
1.8.2.1

