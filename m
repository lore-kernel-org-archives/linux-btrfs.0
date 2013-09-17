Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab3IQOyL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 10:54:11 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 0462DA535C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 16:54:10 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/2] nodiscard for device add
Date: Tue, 17 Sep 2013 16:53:59 +0200
Message-Id: <cover.1379429392.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba (2):
  btrfs-progs: use better name for nodiscard variable and flip the logic
  btrfs-progs: add nodiscard option to device add

 cmds-device.c  | 34 +++++++++++++++++++++++++++++-----
 man/btrfs.8.in | 11 +++++++++--
 mkfs.c         |  8 ++++----
 utils.c        |  6 ++++--
 utils.h        |  2 +-
 5 files changed, 47 insertions(+), 14 deletions(-)

-- 
1.8.3.1

