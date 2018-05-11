Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38379 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752925AbeEKK1i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 06:27:38 -0400
Date: Fri, 11 May 2018 12:24:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/3] Btrfs: stop abusing current->journal_info for direct
 I/O
Message-ID: <20180511102459.GT6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1525933432.git.osandov@fb.com>
 <16e0b655-3778-990d-2cb9-abf34ea9e3ad@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <16e0b655-3778-990d-2cb9-abf34ea9e3ad@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 12:53:36PM +0300, Nikolay Borisov wrote:
> 
> 
> On 11.05.2018 09:30, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > Hi, everyone,
> > 
> > Btrfs currently abuses current->journal_info in btrfs_direct_IO() in
> > order to pass around some state to get_block() and submit_io(). This
> > hack is ugly and unnecessary because the data we pass around is only
> > used in one call frame. Robbie Ko also pointed out [1] that it could
> > potentially cause a crash if we happen to end up in start_transaction()
> > (e.g., from memory reclaim calling into btrfs_evict_inode(), which can
> > start a transaction). I'm not convinced that Robbie's case can happen in
> > practice since we are using GFP_NOFS for allocations during direct I/O,
> > but either way it's fragile and nasty.
> 
> When I worked initially on btrfs-over-swap I managed to hit a case where
> ext4 stacked on top of btrfs would crash since btrfs will overwrite
> journal_info which was set by ext4. So this change is indeed welcome :)

And also this, https://lkml.org/lkml/2017/12/14/165.
