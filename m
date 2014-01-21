Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942AbaAUR4G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 12:56:06 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/2] btrfs: sysfs updates for 3.14
Date: Tue, 21 Jan 2014 18:55:59 +0100
Message-Id: <cover.1390326770.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba (2):
  btrfs: sysfs: don't show reserved incompat feature
  btrfs: sysfs: list the NO_HOLES feature

 fs/btrfs/sysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.9

