Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaE2QBc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 May 2014 12:01:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B3D6CAC50
	for <linux-btrfs@vger.kernel.org>; Thu, 29 May 2014 16:01:29 +0000 (UTC)
Date: Thu, 29 May 2014 18:01:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: free delayed node outside of root->inode_lock
Message-ID: <20140529160129.GF29992@suse.cz>
Reply-To: dsterba@suse.cz
References: <5384D110.1070006@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5384D110.1070006@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 27, 2014 at 01:53:20PM -0400, Jeff Mahoney wrote:
> On heavy workloads, we're seeing soft lockup warnings on
> root->inode_lock in __btrfs_release_delayed_node. The low hanging fruit
> is to reduce the size of the critical section.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
