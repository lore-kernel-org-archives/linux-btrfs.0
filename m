Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbcFOWuJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 18:50:09 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 0/2] btrfs-progs: qgroup verification update
Date: Wed, 15 Jun 2016 15:50:00 -0700
Message-Id: <1466031002-14533-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

The following two patches update the qgroup verification code in btrfsck to
understand entire qgroup hierarchies.  The first patch is a simple bugfix
for some leaked objects and can be taken separately if you like.  The 2nd
patch implements the actual verification update.

If you prefer to pull via git there is a branch at:

https://github.com/markfasheh/btrfs-progs-patches qgroup-hierarchy

Review and comments are welcome.

Thanks,
	--Mark
