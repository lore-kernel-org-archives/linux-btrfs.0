Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbbKEWiK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Nov 2015 17:38:10 -0500
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fb.com, clm@fb.com, quwenruo@cn.fujitsu.com, mfasheh@suse.de
Subject: [PATCH 0/3] btrfs: update qgroups in drop snapshot, V2
Date: Thu,  5 Nov 2015 14:37:57 -0800
Message-Id: <1446763080-20235-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The following 3 patches fix a regression introduced in Linux
4.2 where btrfs_drop_snapshot() wasn't updating qgroups, resulting in
them going bad.

The original e-mail pointing this out is below:

http://www.spinics.net/lists/linux-btrfs/msg46093.html

The first patch is from Josef and fix bugs in our counting of
roots (which is critical for qgroups to work correctly). It was previously
sent to the list:

http://www.spinics.net/lists/linux-btrfs/msg47035.html

Truth be told, most of the time fixing this was spent figuring out that and
another issue (which has also been fixed).  Once I realized I was seeing a
bug and we fixed it correctly, my drop snapshot patch got dramatically
smaller.

I also re-added some of the tracing in qgroup.c that we recently
lost. It is again possible to debug qgroup operations on a live
system, allowing us to find issues like the two above by narrowing
down our operations and manually walking through them via
cat sys/debug/tracing.

The entire patch series can be tested in xfstests test btrfs/104.

Thanks,
	--Mark

Changes from V1, thanks to Qu for his comments:
  - lock around call to btrfs_qgroup_insert_dirty_extent()
  - check whether qgroups are enabled in account_leaf_items()
