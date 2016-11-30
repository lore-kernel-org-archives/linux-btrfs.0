Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933648AbcK3PMw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 10:12:52 -0500
Date: Wed, 30 Nov 2016 16:12:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs, balance convert: warn about RAID5/6
 in fiery letters
Message-ID: <20161130151245.GO12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161128185153.14908-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161128185153.14908-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 28, 2016 at 07:51:53PM +0100, Adam Borowski wrote:
> People who don't frequent IRC nor the mailing list tend to believe RAID 5/6
> are stable; this leads to data loss.  Thus, let's do warn them.
> 
> At this point, I think fiery letters that won't be missed are warranted.
> 
> Kernel 4.9 and its -progs will be a part of LTS of multiple distributions,
> so leaving experimental features without a warning is inappropriate.

I'm ok with adding the warning about raid56 feature, but I have some
comments to how it's implemented.

Special case warning for the raid56 is ok, as it corresponds to the
'mkfs_features' table where the missing value for 'safe' should lead to
a similar warning. This is planned to be more generic, so I just want to
make sure we can adjust it later without problems.

The warning should go last, after the final summary (and respect
verbosity level). If the message were not colored, I'd completely miss
the warning. This also means the warning should not be printed from a
helper function and not during the option parsing phase.

The colors seem a bit too much to me, red text or just emphasize
'warning' would IMHO suffice.
