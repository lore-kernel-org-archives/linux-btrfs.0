From: "Liu Hui" <onlyflyer@gmail.com>
Subject: [PATCH]Fix typo in clear_state_cb
Date: Tue, 23 Dec 2008 20:44:09 +0800
Message-ID: <2c3b11250812230444k31bc3686g611aa013f66504c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
In clear_state_cb, we should check 'tree->ops->clear_bit_hook' instead
of 'tree->ops->set_bit_hook'.

-- 
Thanks & Best Regards
Liu Hui
--

diff --git a/extent_io.c b/extent_io.c
index 25ce2d1..0bf7684 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -340,7 +340,7 @@ static void clear_state_cb(struct extent_io_tree *tree,
 			   struct extent_state *state,
 			   unsigned long bits)
 {
-	if (tree->ops && tree->ops->set_bit_hook) {
+	if (tree->ops && tree->ops->clear_bit_hook) {
 		tree->ops->clear_bit_hook(tree->mapping->host, state->start,
 					  state->end, state->state, bits);
 	}
