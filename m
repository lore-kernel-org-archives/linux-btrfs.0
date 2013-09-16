Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab3IPSWR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 14:22:17 -0400
Message-Id: <20130916181910.799140428@suse.com>
Date: Mon, 16 Sep 2013 14:19:10 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clmason@fusionio.com
Subject: [patch 0/9 v3] add ability to query/change feature bits online
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first patch of this series is the ioctl patch I posted before, with the
review comments handled. It now uses the reserved 57 ioctl.

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

The kobj_completion patch is not intended to be applied with this set. It
should be accepted via Greg KH but is needed for testing until then.

I'll post updated tools patches separately.

-Jeff

