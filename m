Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53239 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934137AbdLSDgP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 22:36:15 -0500
Date: Tue, 19 Dec 2017 11:35:27 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>, Chris Mason <clm@fb.com>,
        Jan Kara <jack@suse.cz>
Subject: [RFC PATCH btrfs] buffer_head: create_bh_bio() can be static
Message-ID: <20171219033527.GA11542@lkp-wsm-ep2>
References: <201712191101.m5t8a2s4%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201712191101.m5t8a2s4%fengguang.wu@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Fixes: 61b4603b8338 ("buffer_head: separate out create_bh_bio() from submit_bh_wbc()")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index eb15599..b793f6d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3055,8 +3055,8 @@ void guard_bio_eod(int op, struct bio *bio)
 	}
 }
 
-struct bio *create_bh_bio(int op, int op_flags, struct buffer_head *bh,
-                          enum rw_hint write_hint)
+static struct bio *create_bh_bio(int op, int op_flags, struct buffer_head *bh,
+				 enum rw_hint write_hint)
 {
 	struct bio *bio;
 
