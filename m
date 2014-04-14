Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbaDNQzU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 12:55:20 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DEE7FAB0E
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 16:55:19 +0000 (UTC)
Date: Mon, 14 Apr 2014 18:55:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix lockdep warning with reclaim lock inversion
Message-ID: <20140414165519.GR29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5345BA4B.5010007@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5345BA4B.5010007@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 09, 2014 at 05:23:23PM -0400, Jeff Mahoney wrote:
> 2 locks held by kswapd0/169:
>  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff81159e8a>] shrink_slab+0x3a/0x160
>  #1:  (&type->s_umount_key#27){++++..}, at: [<ffffffff811bac6f>] grab_super_passive+0x3f/0x90
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

The first version of patch has been merged meanwhile, can you please
send an incremental? (the 3rd hunk)
