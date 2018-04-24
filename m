Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56597 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758363AbeDXOSa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 10:18:30 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 338F5ACB3
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 14:18:29 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 0/8] Delayed refs cleanups/streamlining
Date: Tue, 24 Apr 2018 17:18:16 +0300
Message-Id: <1524579504-30304-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchkit aims to simplify and streamline the logic involved in 
initialising and adding delayed refs/delayed head structures which deal with 
modification of the extent tree. Currently the logic for init and add was 
contained in one function for each type of structure. This resulted in very 
awkward interface with shitloads of arguments, this in turn made it really hard
to understand the gist of the code. This series rectifies the situation by 
extracting common parts and using those rather than open coding duplicated
logic for every type of delayed ref (tree or data ref). 

The first 5 patches deal with the delayed_ref structs. Each patch is 
incremental and makes the code bisectable. The last tree factor out the init 
code for delayed_ref_head into a separate function and begin to use it. The 
final completely splits the two. 

The net result is both a cleaner interface as well as somewhat reduced 
critical section under delayed_refs->lock spinlock. 

V2: Rebased the patches on latest misc-next.

Nikolay Borisov (8):
  btrfs: Factor out common delayed refs init code
  btrfs: Use init_delayed_ref_common in add_delayed_tree_ref
  btrfs: Use init_delayed_ref_common in add_delayed_data_ref
  btrfs: Open-code add_delayed_tree_ref
  btrfs: Open-code add_delayed_data_ref
  btrfs: Introduce init_delayed_ref_head
  btrfs: Use init_delayed_ref_head in add_delayed_ref_head
  btrfs: split delayed ref head initialization and addition

 fs/btrfs/delayed-ref.c | 248 ++++++++++++++++++++++++-------------------------
 1 file changed, 121 insertions(+), 127 deletions(-)

-- 
2.7.4

