Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33633 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932762AbeFRL7c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 07:59:32 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2D191ACDB
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 11:59:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Cleanups around extent increment 
Date: Mon, 18 Jun 2018 14:59:23 +0300
Message-Id: <1529323166-29931-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

This series improves the functions involved around extent reference increment. 
The first patch just removes a redundant argument, the second one documents the 
parameters of __btrfs_inc_extent_ref. It can be considered v2 of the standalone
version which Jeff had some input to. The final patch fixes a comment in 
lookup_inline_extent_backref which transpired while Jeff was revieweing the 
documentation patch. 

Nikolay Borisov (3):
  btrfs: Remove fs_info argument from __btrfs_inc_extent_ref
  btrfs: Document __btrfs_inc_extent_ref
  btrfs: Fix comment in lookup_inline_extent_backref

 fs/btrfs/extent-tree.c | 51 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 10 deletions(-)

-- 
2.7.4

