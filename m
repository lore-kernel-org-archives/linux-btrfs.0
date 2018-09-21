Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728365AbeIUU2i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 16:28:38 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5CAC2AEAE
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 14:39:27 +0000 (UTC)
Date: Fri, 21 Sep 2018 16:39:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: Factor out loop processing all refs of a head
Message-ID: <20180921143926.GI5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534318796-23111-1-git-send-email-nborisov@suse.com>
 <1534318796-23111-3-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534318796-23111-3-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 15, 2018 at 10:39:55AM +0300, Nikolay Borisov wrote:
> This patch introduces a new helper encompassing the implicit inner loop
> in __btrfs_run_delayed_refs which processes all the refs for a given
> head. The code is mostly copy/paste, the only difference is that if we
> detect a newer reference then -EAGAIN is returned so that callers can
> react correctly. Also at the end of the loop the head is relocked and
> btrfs_merge_delayed_refs is run again to retain the pre-refactoring
> semantics.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
