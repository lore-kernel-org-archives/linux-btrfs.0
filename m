Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52651 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751572AbdHRMRm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 08:17:42 -0400
Date: Fri, 18 Aug 2017 14:16:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: use btrfsic_submit_bio instead of submit_bio in
 write_dev_flush
Message-ID: <20170818121617.GT2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170818083807.12572-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170818083807.12572-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 18, 2017 at 04:38:07PM +0800, Lu Fengqi wrote:
> Although this bio has no data attached, it will reach this condition
> (bio->bi_opf & REQ_PREFLUSH) and then update the flush_gen of dev_state
> in __btrfsic_submit_bio. So we should still submit it through integrity
> checker. Otherwise, the integrity checker will throw the following warning
> when I mount a newly created btrfs filesystem.

Right, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
