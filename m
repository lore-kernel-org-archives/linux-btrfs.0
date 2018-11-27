Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC8CC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C3F22086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:38:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C3F22086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbeK0Tfk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 14:35:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:38466 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728823AbeK0Tfk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 14:35:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1FC24AC15
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 08:38:31 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/5] btrfs-progs: image: Fix error when restoring multi-disk image to single disk
Date:   Tue, 27 Nov 2018 16:38:23 +0800
Message-Id: <20181127083828.23861-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/image_recover

The base commit is as usual, the latest stable tag, v4.19.


Test case misc/021 will fail if using latest upstream kernel.

This is due to the enhanced code in kernel to check block group <->
chunk <-> dev extent mapping.

This means from the very beginning, btrfs-image can't really restore a
multi-disk image to single-disk one correctly.

The problem is, although we modified chunk item, we didn't modify block
group item's flags or dev extents.

This patch will reset block group flags, then rebuild the whole
dev extents by removing existing ones first, then re-add the correct
dev extents calculated from chunk map.

Now it could pass all misc tests and fsck tests.

Changelog:
v2:
- Parameter list cleanup
  * Use trans->fs_info to remove fs_info parameter
  * Remove trans parameter for function who doesn't need
- Merge dev extents removal code with rebuild code
- Refactor btrfs_alloc_dev_extent() into 2 functions
  * btrfs_insert_dev_extent() for convert and dev extent rebuild
  * btrfs_alloc_dev_extent() for old use case
  
Qu Wenruo (5):
  btrfs-progs: image: Refactor fixup_devices() to
    fixup_chunks_and_devices()
  btrfs-progs: image: Fix block group item flags when restoring
    multi-device image to single device
  btrfs-progs: volumes: Refactor btrfs_alloc_dev_extent() into two
    functions
  btrfs-progs: image: Remove all existing dev extents for later rebuild
  btrfs-progs: misc-tests/021: Do extra btrfs check before mounting

 image/main.c                                  | 200 ++++++++++++++++--
 .../021-image-multi-devices/test.sh           |   3 +
 volumes.c                                     |  48 +++--
 volumes.h                                     |   3 +
 4 files changed, 220 insertions(+), 34 deletions(-)

-- 
2.19.2

