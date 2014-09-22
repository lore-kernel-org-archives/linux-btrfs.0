Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:56698 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVPmE (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 22 Sep 2014 11:42:04 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/2] Btrfs: add missing end_page_writeback on submit_extent_page failure
Date: Mon, 22 Sep 2014 17:41:04 +0100
Message-Id: <1411404065-767-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If submit_extent_page() fails in write_one_eb(), we end up with the current
page not marked dirty anymore, unlocked and marked for writeback. But we never
end up calling end_page_writeback() against the page, which will make calls to
filemap_fdatawait_range (e.g. at transaction commit time) hang forever waiting
for the writeback bit to be cleared from the page.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3af4966..91f866c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3668,6 +3668,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		if (ret) {
 			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
 			SetPageError(p);
+			end_page_writeback(p);
 			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
 				end_extent_buffer_writeback(eb);
 			ret = -EIO;
-- 
1.9.1

