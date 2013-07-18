Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab3GRRgh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 13:36:37 -0400
Date: Thu, 18 Jul 2013 19:36:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: dsterba@suse.cz, George Amvrosiadis <gamvrosi@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: filebench varmail + scrubber = btrfs_update_root bug
Message-ID: <20130718173635.GO24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CABF9=8i1Bd6mVOR8kNZmQJa2UJLg9tiCojWHbN1HLVWhEh7_0g@mail.gmail.com>
 <20130716113745.GI24343@twin.jikos.cz>
 <51E549C6.1090303@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51E549C6.1090303@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 16, 2013 at 03:25:26PM +0200, Stefan Behrens wrote:
> >> And that root key (18446744073709551610) looks very suspicious. Any ideas?
> > 
> > It translates to key type 250 which is BTRFS_DEV_REPLACE_KEY, plus the
> > parent transid error this looks like broken/unfinished device replace.
> > Have you used the 'btrfs device replace' recently?
> > 
> 
> Where do you see the key type 250?

mis-interpreted the 18446744073709551610 value as key type (-6 -> 250).
