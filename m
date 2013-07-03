Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:50186 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037Ab3GCUgq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 16:36:46 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 7AD489A0320
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jul 2013 14:36:46 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>,
        <bo.li.liu@oracle.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Message-ID: <20130703203644.14981.18637@localhost.localdomain>
Subject: Re: [RFC PATCH 00/12] Btrfs-progs: introduce chunk recover function
Date: Wed, 3 Jul 2013 16:36:44 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Miao Xie (2013-07-03 09:25:08)
> This patchset introduced chunk recover function, which was implemented by
> scanning the whoel disks in the filesystem. Now, we can recover Single,
> Dup, RAID1 chunks, and RAID0, RAID10, RAID5, RAID6 metadata chunks.

Really nice.  I've integrated this with Liu Bo's btrfs-image fixes and
put it into a branch called integration.  I've tested both repair and
image here, but if you could please double check the merge I'd
appreciate it.

-chris
