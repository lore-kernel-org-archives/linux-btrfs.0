Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42284 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbeCNV12 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 17:27:28 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AB38DAD9C
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 21:27:27 +0000 (UTC)
Date: Wed, 14 Mar 2018 22:25:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Remove extra run_delayed_items call
Message-ID: <20180314212505.GV32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1518531409-31625-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1518531409-31625-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 13, 2018 at 04:16:48PM +0200, Nikolay Borisov wrote:
> Before commit 581227d0d2b8 ("Btrfs: remove the time check in
> btrfs_commit_transaction()") there would be a loop in the transaction
> commit path that will go on until all existing writers ended their
> transaction handles. This loop would try and flush as much pending stuff
> as possible before going into the transaction critical section. However,
> the aforementioned commit removed it, yet continued calling this
> "extra" code for the sake of optimisation.
> 
> As it stands the rules for running the delayed items are a bit of
> a mess. First we have the one call which this patch removes, then we
> have another one, acting as a "safety net" by catching any delayed
> items introduced after the previous call is finished and extwriters
> becoming 0 (meaning no more TRANS_START/TRANS_ATTACHS are possible, only
> joins). Then we have the delayed items running as part of creating a
> snapshot (once per pedning snapshot). Finally, delayed items are run
> once more _after_ snapshots have been created. All in all this amounts
> to 3 + N (N = number of snapshots slated for creation). I think this
> could really be reduced to 2 calls - 1 before create_pending_snapshots
> is called and 1 after it's finished. This suffices to ensure consistent
> fs state during snapshot creation and after they are created.
> 
> I did a full xfstest run to ensure no consistency issues came up. Then
> I picked the tests which exhibitted rather long runtimes and looked
> closer to see if it was as a result of this commit - which it wasn't.
> Finally I did an artifical test with fsstres with only those operations
> that put stress on the delayed items code:
> 
> fsstress -z -f mkdir=25% -f rmdir=25% -f creat=25 -f unlink=25%
> -f attr_set=25% -p5 -n 25000 and also didn't observe any performance
> regressions
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

I don't see anything wrong with the patches, but this is touching the
transaction commit, so I'll keep the review open. Running xfstests
might not be enough, this asks for some stress testing. I'll add the
patches to for-next eventually (probably a separate branch as a reminder
for myself to merge it after we're sure it's ok).
