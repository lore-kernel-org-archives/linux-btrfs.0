Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:61359 "EHLO
	mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079AbbERRYh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 13:24:37 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2 linux-next] btrfs: use swap() in merge_ref()
Date: Mon, 18 May 2015 19:24:13 +0200
Message-Id: <1431969853-14700-2-git-send-email-fabf@skynet.be>
In-Reply-To: <1431969853-14700-1-git-send-email-fabf@skynet.be>
References: <1431969853-14700-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use kernel.h macro definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/delayed-ref.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 8f8ed7d..97c5a19 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -301,11 +301,7 @@ static int merge_ref(struct btrfs_trans_handle *trans,
 			mod = next->ref_mod;
 		} else {
 			if (ref->ref_mod < next->ref_mod) {
-				struct btrfs_delayed_ref_node *tmp;
-
-				tmp = ref;
-				ref = next;
-				next = tmp;
+				swap(ref, next);
 				done = 1;
 			}
 			mod = -next->ref_mod;
-- 
2.4.0

