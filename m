Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41866 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3JROZ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 10:25:57 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id AE5639A06B3
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 08:25:56 -0600 (MDT)
Date: Fri, 18 Oct 2013 10:25:54 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Sage Weil <sage@inktank.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: transaction commit deadlock on current rc
Message-ID: <20131018142554.GD6924@localhost.localdomain>
References: <alpine.DEB.2.00.1310171059080.5573@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.00.1310171059080.5573@cobra.newdream.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 17, 2013 at 12:56:14PM -0700, Sage Weil wrote:
> Hey,
> 
> I'm seeing the deadlock below under a ceph-osd workload.  There may be a 
> subtle problem with the async transaction sequence (since nobody but ceph 
> uses that that I know of), but not obvious to me why 
> create_pending_snapshots would get stuck on btrfs_tree_lock...
> 

Can you do sysrq+w when this happens so I can see everybody who's blocked?
Thanks,

Josef
