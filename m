Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbaBYScx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 13:32:53 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 199B875012
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 18:32:52 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/2] Btrfs send fixup
Date: Tue, 25 Feb 2014 19:32:44 +0100
Message-Id: <cover.1393352970.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A fix for the problem that Filipe pointed out and a cleanup in the same code,
depends on the first patch.

Based on btrfs-next/master.

David Sterba (2):
  btrfs: send: fix old buffer length in fs_path_ensure_buf
  btrfs: send: simplify allocation code in fs_path_ensure_buf

 fs/btrfs/send.c |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

-- 
1.7.9

