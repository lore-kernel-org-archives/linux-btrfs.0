Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33884 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbbHSMRz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 08:17:55 -0400
From: mhocko@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fortification for GFP_NOFS allocations
Date: Wed, 19 Aug 2015 14:17:39 +0200
Message-Id: <1439986661-15896-1-git-send-email-mhocko@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
these two patches were sent as a part of a larger RFC which aims at
allowing GFP_NOFS allocations to fail to help sort out memory reclaim
issues bound to the current behavior
(http://marc.info/?l=linux-mm&m=143876830616538&w=2).

It is clear that move to the GFP_NOFS behavior change is a long term
plan but these patches should be good enough even with that change in
place. It also seems that Chris wasn't opposed and would be willing to
take them http://marc.info/?l=linux-mm&m=143991792427165&w=2 so here we
come. I have rephrased the changeslogs to not refer to the patch which
changes the NOFS behavior.

Just to clarify. These two patches allowed my particular testcase
(mentioned in the cover referenced above) to survive it doesn't mean
that the failing GFP_NOFS are OK now. I have seen some other places
where GFP_NOFS allocation is followed by BUG_ON(ALLOC_FAILED). I have
not encountered them though.

Let me know if you would prefer other changes.

