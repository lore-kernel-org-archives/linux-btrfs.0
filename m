Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbcCOOtV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 10:49:21 -0400
Date: Tue, 15 Mar 2016 15:48:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PULL] Btrfs cleanups for 4.6, part 2
Message-ID: <20160315144856.GD21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1458049397.git.dsterba@suse.com>
 <20160315142448.GA92846@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160315142448.GA92846@clm-mbp.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2016 at 07:24:48AM -0700, Chris Mason wrote:
> On Tue, Mar 15, 2016 at 02:50:14PM +0100, David Sterba wrote:
> > Hi,
> > 
> > a few more cleanups sent recently and some that I found in my inbox marked but
> > not processed. Based on top of current integration. Please pull, thanks.
> 
> Thanks Dave, I'll get these pulled in and restart my long stress run.

I've picked a few more patches to my for-next but they're not reviewed
nor tested. You may want to add them to the long test. In my k.org git in
branch misc-4.6.

Alex Lyakas (2):
      btrfs: csum_tree_block: return proper errno value
      btrfs: do not write corrupted metadata blocks to disk

Jiri Kosina (2):
      btrfs: cleaner_kthread() doesn't need explicit freeze
      btrfs: transaction_kthread() is not freezable

Liu Bo (2):
      Btrfs: make mapping->writeback_index point to the last written page
      Btrfs: cleanup error handling in extent_write_cached_pages
