Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423394AbbEENUG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 09:20:06 -0400
Date: Tue, 5 May 2015 15:20:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com, clm@fb.com,
        jbacik@fb.com
Subject: Re: [PATCH] btrfs: qgroup: Fix possible leak in
 btrfs_add_qgroup_relation()
Message-ID: <20150505132004.GD5099@suse.cz>
Reply-To: dsterba@suse.cz
References: <1430579995-24551-1-git-send-email-cengelma@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430579995-24551-1-git-send-email-cengelma@gmx.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 02, 2015 at 05:19:55PM +0200, Christian Engelmayer wrote:
> Commit 9c8b35b1ba21 ("btrfs: quota: Automatically update related qgroups or
> mark INCONSISTENT flags when assigning/deleting a qgroup relations.")
> introduced the allocation of a temporary ulist in function
> btrfs_add_qgroup_relation() and added the corresponding cleanup to the out
> path. However, the allocation was introduced before the src/dst level check
> that directly returns. Fix the possible leakage of the ulist by moving the
> allocation after the input validation. Detected by Coverity CID 1295988.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
Reviewed-by: David Sterba <dsterba@suse.cz>
