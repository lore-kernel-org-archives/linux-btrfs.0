Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31850 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751061AbbHXPgB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 11:36:01 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7OFZpD0015989
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2015 23:35:51 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/5] btrfs: scrub: setup all fields for sblock_to_check
Date: Mon, 24 Aug 2015 23:34:15 +0800
Message-ID: <cover.1440430437.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

scrub_setup_recheck_block() isn't setup all necessary fields for
sblock_to_check because history reason.

So current code need more arguments in severial functions,
and more local variables, just to passing these lacked values to
necessary place.

[PATCH 1/5] setup above fields for sblock_to_check, it makes other
code simple(done in [PATCH 2..5]).

Zhao Lei (5):
  btrfs: scrub: setup all fields for sblock_to_check
  btrfs: Reset sblock->xxx_error stats before calling
    scrub_recheck_block_checksum
  btrfs: Use scrub_checksum_data and scrub_checksum_tree_block for
    scrub_recheck_block_checksum
  btrfs: Reduce unnecessary arguments in scrub_recheck_block
  btrfs: Remove len argument from scrub_find_csum

 fs/btrfs/scrub.c | 169 +++++++++++++++++++------------------------------------
 1 file changed, 57 insertions(+), 112 deletions(-)

-- 
1.8.5.1

