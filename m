Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48154 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab3C1Nvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 09:51:41 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4A6607C04E0
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 07:51:41 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        Miao Xie <miaox@cn.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <5153FB3A.10507@cn.fujitsu.com> <51540778.3080602@cn.fujitsu.com>
In-Reply-To: <51540778.3080602@cn.fujitsu.com>
Message-ID: <20130328135139.20484.49150@localhost.localdomain>
Subject: Re: [PATCH V2 3/4] Btrfs: remove unnecessary variant in btrfs_sector_sum,
 structure
Date: Thu, 28 Mar 2013 09:51:39 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Miao Xie (2013-03-28 05:03:52)
> bytenr in btrfs_sector_sum is unnecessary, because the extents that
> btrfs_sector_sum points to are continuous, we can find out the expected
> checksums by btrfs_ordered_sum's bytenr and the offset, so we can
> remove btrfs_sector_sum's bytenr.

I really like these, thanks for speeding up the crcs.

-chris
