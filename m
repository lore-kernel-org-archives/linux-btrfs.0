Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56228 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726133AbeHOKbE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 06:31:04 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EB0C3AED2
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2018 07:39:59 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Refactor delayed refs processing loop 
Date: Wed, 15 Aug 2018 10:39:53 +0300
Message-Id: <1534318796-23111-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is a small series which aims to rectify the eye sore that delayed refs 
processing loop currently is. In fact, it's actually 2 loops in the guise of a 
single 'while' construct. All in all this should bring no functional changes 
and I've verified this with multiple xfstest runs with no problems. 

Patch 1 factors out the code which deals with selecting a ref head which has 
delayed refs pending and locking it. 

Patch 2 introduces a new function which comprises the internal loop aka 
processing delayed refs of a delayed head, which is more or less most of the 
code in __btrfs_run_delayed_refs copied. The only difference is that the 
function can return EAGAIN if we detect a delayed ref which has sequence number
higher than what is currently in the tree mod list. 

Patch 3 Finaly makes the loop in __btrfs_run_delayed_refs use the function 
introduced in the previous patch, meaning deleting most of the code and 
changing the loop to a 'do {} while' construct. I strived to retain all the 
semantics of the old code so there should be no surprises. 

Nikolay Borisov (3):
  btrfs: Factor out ref head locking code in __btrfs_run_delayed_refs
  btrfs: Factor out loop processing all refs of a head
  btrfs: refactor __btrfs_run_delayed_refs loop

 fs/btrfs/extent-tree.c | 210 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 128 insertions(+), 82 deletions(-)

-- 
2.7.4
