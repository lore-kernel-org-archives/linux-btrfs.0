Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S967717AbeBNNP4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 08:15:56 -0500
Date: Wed, 14 Feb 2018 14:13:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Add enospc_debug printing in
 metadata_reserve_bytes
Message-ID: <20180214131339.GD3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1513332337-7068-1-git-send-email-nborisov@suse.com>
 <fd31d262-3b22-dbc0-6315-3ce734334625@suse.com>
 <b905db35-f6c6-2de3-f1fb-154d697cc747@gmx.com>
 <4317cffa-e7ef-6ded-dfd8-68ccfb84fe55@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4317cffa-e7ef-6ded-dfd8-68ccfb84fe55@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 06, 2018 at 11:18:41AM +0200, Nikolay Borisov wrote:
> >> On 15.12.2017 12:05, Nikolay Borisov wrote:
> >>> Currently when enoscp_debug mount option is turned on we do not print
> >>> any debug info in case metadata reservation failures happen. Fix this
> >>> by adding the necessary hook in reserve_metadata_bytes.
> >>>
> >>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > 
> > Looks good.
> > 
> > Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> Yeah you already reviewed it back in December, I was bumping it to make
> sure David won't miss it since it's a rather old patch :)

Added to next, thanks.

