Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab3IJEat (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 00:30:49 -0400
Message-Id: <20130910042408.335071038@suse.com>
Date: Tue, 10 Sep 2013 00:24:08 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clmason@fusionio.com, dsterba@suse.cz
Subject: [patch 0/7] btrfs: Add ability to query/modify feature bits while mounted
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first patch of this series is the ioctl patch I posted before, with the
review comments handled.

The rest of the series is enabling sysfs access to feature bits, similar
to how ext4 publishes that information. Since we already have the online
changing ability via the ioctl patch, we can also enable that via sysfs
as well.

/sys/fs/btrfs/features/ contains attributes for supported features, with the
content indicating if the attribute is settable or clearable while mounted.

/sys/fs/btrfs/<fsid>/features/ contains the attributes enabled on the file
system plus attributes for features that can be changed online. The content
indicates whether the feature is currently enabled. The permissions of
the file also indicate whether it's changeable while online.

I'll post updated tools patches separately.

-Jeff


