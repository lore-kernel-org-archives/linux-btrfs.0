Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57996 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752694AbeDSNEI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 09:04:08 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 840AFAF0D
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 13:04:07 +0000 (UTC)
Date: Thu, 19 Apr 2018 15:01:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: print-tree: Add locking status output for
 debug build
Message-ID: <20180419130136.GC21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180411090813.19495-1-wqu@suse.com>
 <20180411090813.19495-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180411090813.19495-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 05:08:13PM +0800, Qu Wenruo wrote:
> It's pretty handy if we can get debug output for locking status of an
> extent buffer, specially for race related debugging.
> 
> So add the following output for btrfs_print_tree() and
> btrfs_print_leaf():
> - refs
> - write_locks (as w:%u)
> - read_locks (as r:%u)
> - blocking_writers (as bw:%u)
> - blocking_readers (as br:%u)
> - spinning_writers (as sw:%u)
> - spinning_readers (as sr:%u)
> - lock_owner
> - current->pid

Useful, but atomic is 'int' (%d), and pid_t is also int in disguise
(maybe there's a special printk specifier for that).
