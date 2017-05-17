Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:39247 "EHLO
        homiemail-a116.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752296AbdEQKep (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 06:34:45 -0400
From: Sahil Kang <sahil.kang@asilaycomputing.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, sahil.kang@asilaycomputing.com
Subject: [PATCH 0/1] Remove unnecessary branching in free-space-tree.c
Date: Wed, 17 May 2017 03:33:44 -0700
Message-Id: <1495017225-8268-1-git-send-email-sahil.kang@asilaycomputing.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Will you merge this patch?
It's a small change that removes an unneeded if statement.

Sahil Kang (1):
  Remove unnecessary branching in free-space-tree.c

 fs/btrfs/free-space-tree.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

-- 
2.1.4

