Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbbFKM3Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 08:29:24 -0400
Date: Thu, 11 Jun 2015 14:29:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Chris Mason <clm@fb.com>,
        kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [btrfs:integration-4.2 29/57] fs/btrfs/disk-io.c:2325:17-30:
 ERROR: reference preceded by free on line 2324
Message-ID: <20150611122921.GE6761@suse.cz>
Reply-To: dsterba@suse.cz
References: <201506110750.oOHGNTQE%fengguang.wu@intel.com>
 <alpine.DEB.2.02.1506110800020.2014@localhost6.localdomain6>
 <20150611062319.GA9634@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150611062319.GA9634@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 11, 2015 at 02:23:20PM +0800, Liu Bo wrote:
> From de72ac1c6612441bd5e1a314a05c38d727e12121 Mon Sep 17 00:00:00 2001
> From: Liu Bo <bo.li.liu@oracle.com>
> Date: Thu, 11 Jun 2015 14:16:44 +0800
> Subject: [PATCH] Btrfs: fix use-after-free in btrfs_replay_log
> 
> @log_root_tree should be referenced after kfree.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
