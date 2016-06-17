Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbcFQUh5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 16:37:57 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 0/2] btrfs-progs: qgroup verification update V2
Date: Fri, 17 Jun 2016 13:37:47 -0700
Message-Id: <1466195869-28109-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

The following two patches update the qgroup verification code in btrfsck to
understand entire qgroup hierarchies.  We now also write out corrected
qgroups when btrfsck is run with the --repair option (this is new from V1).

If you prefer to pull via git there is a branch at:

https://github.com/markfasheh/btrfs-progs-patches qgroup-hierarchy

Review and comments are welcome.

Changes from V1-V2:
  - Added a patch to write out corrected qgroup info
  - Update verifier patch from David's review comments

Thanks,
	--Mark
