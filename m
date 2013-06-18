Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38648 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3FRMXe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 08:23:34 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 725217C069F
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 06:23:34 -0600 (MDT)
Date: Tue, 18 Jun 2013 08:23:28 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Josef Bacik <jbacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix wrong csum clone when doing relocation
Message-ID: <20130618122328.GB19183@localhost.localdomain>
References: <51878334.4000807@cn.fujitsu.com>
 <20130614152712.GA28783@localhost.localdomain>
 <51BFD061.4070404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51BFD061.4070404@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 18, 2013 at 11:13:37AM +0800, Miao Xie wrote:
> From: Josef Bacik <jbacik@fusionio.com>
> 
> Patch "Btrfs: remove btrfs_sector_sum structure" introduced a problem
> that we copied the checksum value to the wrong address when doing
> relocation.
> 
> The reason is:
> It is very likely that one ordered extent has two or more checksum
> structures to keep the relative checksum value, and ->bytenr in each
> checksum structure should point to the start of its extent, not the
> start of the ordered extent. Fix it.
> 

Just fold it into the original patch, since it corrupts the file system I'd
rather people not be able to bisect across them.  Thanks,

Josef
