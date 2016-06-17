Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbcFQQW2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 12:22:28 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 99ACAAAB6
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 16:22:21 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Remove bisect fixup
Date: Fri, 17 Jun 2016 18:22:57 +0200
Message-Id: <cover.1466180408.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

two patches to remove bisectability fixups of two independent branches
introduced in 4.7 cycle. We don't need to wait for 4.8 to remove them as I
thought.

David Sterba (2):
      btrfs: use new error message helper in qgroup_account_snapshot
      btrfs: remove build fixup for qgroup_account_snapshot

 fs/btrfs/transaction.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)
