Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47298 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755155AbeEAO6k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 May 2018 10:58:40 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A6EEAAF0B
        for <linux-btrfs@vger.kernel.org>; Tue,  1 May 2018 14:58:39 +0000 (UTC)
Date: Tue, 1 May 2018 16:56:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: trace: Allow trace_qgroup_update_counters() to
 record old rfer/excl value
Message-ID: <20180501145604.GV21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180430070444.23837-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180430070444.23837-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2018 at 03:04:44PM +0800, Qu Wenruo wrote:
> Origin trace_qgroup_update_counters() only records qgroup id and its
> reference count change.
> 
> It's good enough to debug qgroup accounting change, but when rescan race
> is involved, it's pretty hard to distinguish which modification belongs
> to which rescan.
> 
> So add old_rfer and old_excl trace output to help distinguishing
> different rescan instance.
> (Different rescan instance should reset its qgroup->rfer to 0)
> 
> For trace event parameter, it just changes from u64 qgroup_id to struct
> btrfs_qgroup *qgroup, so number of parameters is not changed at all.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
