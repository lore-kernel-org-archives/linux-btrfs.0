Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56726 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752165AbeGDQ0p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 12:26:45 -0400
Date: Wed, 4 Jul 2018 18:26:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Ethan Lien <ethanlien@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use correct compare function of
 dirty_metadata_bytes
Message-ID: <20180704162643.GZ3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180702074458.16270-1-ethanlien@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180702074458.16270-1-ethanlien@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 03:44:58PM +0800, Ethan Lien wrote:
> We use customized, nodesize batch value to update dirty_metadata_bytes.
> We should also use batch version of compare function or we will easily
> goto fast path and get false result from percpu_counter_compare().
> 
> Signed-off-by: Ethan Lien <ethanlien@synology.com>

This looks like it could have some observable effects. The default batch
is 32 * cpus online, while the one supplied by btrfs is much higher as
it's a multiple of nodesize.

The BTRFS_DIRTY_METADATA_THRESH is 32MiB so the comparision is likely to
be off scale in some if not most cases. I got lost in the callchains and
how the return values of writepage are interpreted.

The effect I see is: there are many pages batched (by the _add_batch
calls) but none of the compare calls dects that and exits early. So
there are more metadata being built up in memory and will have to be
synced later.

The change looks correct to me, we have to compare the numbers of the
same units. I'll add it to misc-next for testing, maybe the 0day bot
would detect some changes in performance.

Please let me know if you have further insights or clarifications to
what's written above, the changelog could use some update as the change
has some unobvious consequences.
