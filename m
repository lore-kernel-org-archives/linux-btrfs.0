Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26072 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbbF3CNa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 22:13:30 -0400
To: Chris Mason <clm@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [GIT PULL] Small cleanup and fix from Fujitsu
Message-ID: <5591FB47.3070109@cn.fujitsu.com>
Date: Tue, 30 Jun 2015 10:13:27 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

This is the small cleanup and fixes for 4.2. Compared to the previous 
pull, this one is quite small, only 2 cleanup and one small quota fix.

Yang Dongsheng (1):
   btrfs: qgroup: allow user to clear the limitation on qgroup

Zhao Lei (2):
   btrfs: cleanup noused initialization of dev in btrfs_end_bio()
   btrfs: add error handling for scrub_workers_get()

Please pull these small fixes from my tree
https://github.com/adam900710/linux.git for_chris_4.2_part2

Thanks,
Qu
