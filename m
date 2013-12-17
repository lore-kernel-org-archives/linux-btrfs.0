Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab3LQPSL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 10:18:11 -0500
Date: Tue, 17 Dec 2013 16:18:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: move the extent buffer radix tree into the fs_info
Message-ID: <20131217151810.GQ6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1387218386-5339-1-git-send-email-jbacik@fb.com>
 <20131217010627.GK6498@twin.jikos.cz>
 <52B06607.9000108@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52B06607.9000108@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 17, 2013 at 09:56:07AM -0500, Josef Bacik wrote:
> >* alloc_extent_buffer uses radix_preload that turns off preepmtion by
> >itself, so the lock here would be pointless
> 
> Except you still need a lock for other inserts.
> >
> >* release_extent_buffer locks around radix_tree_delete, here a rcu
> >locking will be ok as well
> 
> No it won't.  RCU just makes sure readers don't get screwed, you still need
> to have real locking around the insertions/deletions, look at pagecache, we
> have mapping->tree_lock for this even though it uses rcu for the lookups.

Oh, my bad sorry, that would be too easy.
