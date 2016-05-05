Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbcEEQg3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 May 2016 12:36:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CCA11AC60
	for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2016 16:36:27 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Improve compression workspaces memory management
Date: Thu,  5 May 2016 18:36:10 +0200
Message-Id: <cover.1462460924.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the compression workspaces are allocated as needed an this could fail if
there's no free memory. Moreover, as we might be flushing data from the
restricted contexts we should try our best not to fail.

This patchset preallocates one workspace for each compression type at module
load time (and tries to get one if that fails later). If any further request
for new workspace fails, there's still that one to make progress. IOW workspace
allocation will not fail at writeback time.

I have tested this by instrumenting the code to limit the number of workspaces
to one and did some stress tests.

David Sterba (4):
  btrfs: rename and document compression workspace members
  btrfs: preallocate compression workspaces
  btrfs: make find_workspace always succeed
  btrfs: make find_workspace warn if there are no workspaces

 fs/btrfs/compression.c | 85 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 24 deletions(-)

-- 
2.7.1

