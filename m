Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4707 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751011AbcEJHT6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 03:19:58 -0400
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: About in-band dedupe for v4.7
Message-ID: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
Date: Tue, 10 May 2016 15:19:52 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris, Josef and David,

As merge window for v4.7 is coming, it would be good to hear your ideas 
about the inband dedupe.

We are addressing the ENOSPC problem which Josef pointed out, and we 
believe the final fix patch would come out at the beginning of the merge 
window.(Next week)


If it's fine, would you please consider to merge the in-memory backend 
patchset for v4.7 as an experimental feature?


Most of the patch won't be changed from v10 patchset, only ENOSPC fix 
will be updated, and ioctl patchset will introduce a new Kconfig option 
of "btrfs experimental features" for inband dedupe.
(With explain about unstable ioctl/on-disk format for experimental features)


If you are all OK to merge inband dedupe in-memory backend, I'll prepare 
the new v11 patchset for this merge.

Thanks,
Qu


