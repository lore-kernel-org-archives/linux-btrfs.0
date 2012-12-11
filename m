Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:39683 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab2LKPBU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 10:01:20 -0500
Date: Tue, 11 Dec 2012 10:01:17 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: no full sync flag on new inode when we do not
 reuse inode id
Message-ID: <20121211150117.GD3126@localhost.localdomain>
References: <1354849914-14123-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1354849914-14123-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 06, 2012 at 08:11:54PM -0700, Liu Bo wrote:
> When we are not with inode_cache option, we won't reuse inode id, which
> means all of inodes will own different inode id, thus we don't worry
> about "reuse of inode id leads to log tree's corruption" thing.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

With the new fsync stuff I have I still need to make sure all new xattrs and
such are on disk so this needs to stay the way it is.  Thanks,

Josef
