Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2E0C04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 969892084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:28:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 969892084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbeLEM2w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:28:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:48432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727525AbeLEM2w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:28:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E85DADA9
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:28:50 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 00/10] btrfs: Support for DAX devices
Date:   Wed,  5 Dec 2018 06:28:25 -0600
Message-Id: <20181205122835.19290-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a support for DAX in btrfs. I understand there have been
previous attempts at it. However, I wanted to make sure copy-on-write
(COW) works on dax as well.

Before I present this to the FS folks I wanted to run this through the
btrfs. Even though I wish, I cannot get it correct the first time
around :/.. Here are some questions for which I need suggestions:

Questions:
1. I have been unable to do checksumming for DAX devices. While
checksumming can be done for reads and writes, it is a problem when mmap
is involved because btrfs kernel module does not get back control after
an mmap() writes. Any ideas are appreciated, or we would have to set
nodatasum when dax is enabled.

2. Currently, a user can continue writing on "old" extents of an mmaped file
after a snapshot has been created. How can we enforce writes to be directed
to new extents after snapshots have been created? Do we keep a list of
all mmap()s, and re-mmap them after a snapshot?

Tested by creating a pmem device in RAM with "memmap=2G!4G" kernel
command line parameter.


[PATCH 01/10] btrfs: create a mount option for dax
[PATCH 02/10] btrfs: basic dax read
[PATCH 03/10] btrfs: dax: read zeros from holes
[PATCH 04/10] Rename __endio_write_update_ordered() to
[PATCH 05/10] btrfs: Carve out btrfs_get_extent_map_write() out of
[PATCH 06/10] btrfs: dax write support
[PATCH 07/10] dax: export functions for use with btrfs
[PATCH 08/10] btrfs: dax add read mmap path
[PATCH 09/10] btrfs: dax support for cow_page/mmap_private and shared
[PATCH 10/10] btrfs: dax mmap write

 fs/btrfs/Makefile   |    1 
 fs/btrfs/ctree.h    |   17 ++
 fs/btrfs/dax.c      |  303 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/file.c     |   29 ++++
 fs/btrfs/inode.c    |   54 +++++----
 fs/btrfs/ioctl.c    |    5 
 fs/btrfs/super.c    |   15 ++
 fs/dax.c            |   35 ++++--
 include/linux/dax.h |   16 ++
 9 files changed, 430 insertions(+), 45 deletions(-)


-- 
Goldwyn

