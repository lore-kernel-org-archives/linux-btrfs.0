Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61667 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751815AbbKIK1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:27:32 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Chris Mason'" <clm@fb.com>
CC: "'btrfs'" <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Fujitsu for 4.4
Date: Mon, 9 Nov 2015 18:27:26 +0800
Message-ID: <03be01d11ad9$3b385cf0$b1a916d0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

This is collection of some bug fix and cleanup from fujitsu against btrfs in v4.3,
the main patch is these 2:
 Fix lost-data-profile caused by auto removing bg
 Fix lost-data-profile caused by balance bg
It can solve the problem of 'lost all data profile by balance and auto-remove-bg',
discussed in btrfs maillist.

Plus some enhancement and cleanup in scrub.

Would you please consider merging the following fixes to integration-4.4 branch?

REPO is:
https:// github.com/zhaoleidd/btrfs.git integration-4.4

Custom tests are done for patch of "Fix lost-data-profile", and I have queued
xfstests(btrfs/generic with all mountopt) for this branch,
(need about 4~5 days), and no error found until now(1 days).

--
Zhao Lei (9):
  btrfs: scrub: set error stats when tree block spanning stripes
  btrfs: scrub: setup all fields for sblock_to_check
  btrfs: Reset sblock->xxx_error stats before calling
    scrub_recheck_block_checksum
  btrfs: Use scrub_checksum_data and scrub_checksum_tree_block for
    scrub_recheck_block_checksum
  btrfs: Reduce unnecessary arguments in scrub_recheck_block
  btrfs: Remove len argument from scrub_find_csum
  btrfs: Fix lost-data-profile caused by auto removing bg
  btrfs: Fix lost-data-profile caused by balance bg
  btrfs: Use fs_info directly in btrfs_delete_unused_bgs

 fs/btrfs/extent-tree.c |  11 +--
 fs/btrfs/scrub.c       | 179 ++++++++++++++++++-------------------------------
 fs/btrfs/volumes.c     |  21 ++++++
 3 files changed, 93 insertions(+), 118 deletions(-)

Thanks
Zhaolei


