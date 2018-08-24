Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726891AbeHXPUw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 11:20:52 -0400
Date: Fri, 24 Aug 2018 13:46:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: ctree.h: Fix suspicious rcu usage warning in
 btrfs_debug_in_rcu()
Message-ID: <20180824114622.GP24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <22614.1535039351@warthog.procyon.org.uk>
 <450873e0-2a8a-d757-4c68-f24e6a0466a1@jp.fujitsu.com>
 <c79f9ff1-e451-d2b4-a800-738053e47df8@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c79f9ff1-e451-d2b4-a800-738053e47df8@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 24, 2018 at 11:35:28AM +0900, Misono Tomohiro wrote:
> commit 672d599041c8 ("btrfs: Use wrapper macro for rcu string to remove
> duplicate code") replaces some open coded rcu string handling with macro.
> 
> It turns out that btrfs_debug_in_rcu() is used for the first time and
> the macro lacks lock/unlock of rcu string for non debug case
> (i.e. when message is not printed), leading suspicious RCU usage warning
> when CONFIG_PROVE_RCU is on.
> 
> Fix this by adding a wrapper to call lock/unlock for non debug case too.
> 
> Fixes: 672d599041c8 ("btrfs: Use wrapper macro for rcu string to remove
> duplicate code")
> Reported-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>

Thanks, I'll add it to the 4.19 queue, expected to appear in rc2.
