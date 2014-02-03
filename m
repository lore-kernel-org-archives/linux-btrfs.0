Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbaBCSVw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 13:21:52 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1BE0FAAD1
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 18:21:51 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/6] Btrfs send updates - reduce memory consumption
Date: Mon,  3 Feb 2014 19:21:46 +0100
Message-Id: <cover.1391447200.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Sorry if you see this twice, first attempt hasn't appeared in the list yet]

This reduces size of the path buffer in common case. Has been tested by
xfstests, but at the moment v3.13 with or without this patch blows, so I'm
sending it anyway.

Based on current btrfs-next/master.

David Sterba (6):
  btrfs: send: remove prepared member from fs_path
  btrfs: send: remove virtual_mem member from fs_path
  btrfs: send: squeeze bitfilelds in fs_path
  btrfs: send: lower memory requirements in common case
  btrfs: send: remove BUG from process_all_refs
  btrfs: send: remove BUG_ON from name_cache_delete

 fs/btrfs/send.c |  153 ++++++++++++++++++++++--------------------------------
 1 files changed, 62 insertions(+), 91 deletions(-)

-- 
1.7.9

