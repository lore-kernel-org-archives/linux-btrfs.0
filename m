Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52695 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751131AbdEIIeZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 04:34:25 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, jeffm@suse.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] space_info update/creation refactoring 
Date: Tue,  9 May 2017 11:34:17 +0300
Message-Id: <1494318859-7555-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here are two patches which aim to disentangle and make more explicit 
the situation when a space_info has to be created VS when space_info values 
are being updated. 

It survived multiple xfstest runs with additional ASSERTs which I have removed
in this posting. One such assert which didn't trigger was in 
btrfs_make_block_group. Despite that I haven't changed the logic of the code
to try and allocate a space_info if one can't be found. However, I'd like 
someone more knowledgble of the internals of bg lifecycle to tell me if 
in fact btrfs_make_block_group can be called with flags for non-existant 
struct space_info. 



Nikolay Borisov (2):
  btrfs: Separate space_info create/update
  btrfs: Refactor update_space_info

 fs/btrfs/extent-tree.c | 172 +++++++++++++++++++++----------------------------
 1 file changed, 73 insertions(+), 99 deletions(-)

-- 
2.7.4

