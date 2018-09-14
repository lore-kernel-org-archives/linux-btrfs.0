Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38306 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727844AbeINVsY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 17:48:24 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B4E7AFC0
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 16:33:08 +0000 (UTC)
Date: Fri, 14 Sep 2018 18:33:07 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs: trim latency improvements
Message-ID: <20180914163307.GV5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180906211816.12121-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180906211816.12121-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2018 at 05:18:13PM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> This patch set fixes a few issues with trim.
> 
> 1) Fix device list iteration.  We're iterating the ->alloc_list while
>    holding the device_list_mutex.  The ->alloc_list is protected by
>    the chunk mutex and we don't want to hold it across the entire
>    trim execution.  Instead, use the ->devices list, which is protected
>    by the device_list_mutex.
> 
> 2) Skip trim on devices that don't support it.  Rather than letting
>    the block layer reject it, bounce out early.
> 
> 3) Don't keep the commit_root_sem locked and the transaction pinned
>    across the block layer component of trim.  We only need these to
>    ensure the pending chunks list doesn't go away underneath us, so
>    it's safe to drop across the trim itself.  Historically, this
>    caused issues when fstrim and balance would run at the same time
>    since balance would produce lots of transactions and would
>    have to wait constantly, causing problems for everything else that
>    wanted to start a transaction.
> 
> -Jeff
> ---
> 
> Jeff Mahoney (3):
>   btrfs: use ->devices list instead of ->alloc_list in btrfs_trim_fs
>   btrfs: don't attempt to trim devices that don't support it
>   btrfs: keep trim from interfering with transaction commits

The patches have been in for-next for some time, I'm moving them to
misc-next now and will probably forward them to the next rc (5) with
other trim fixes from Qu.

Please note that the commit subject in the Fixes: tag should be in
"...", I've fixed that.
