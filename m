Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751443AbcJZNjo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 09:39:44 -0400
Date: Wed, 26 Oct 2016 15:38:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: fsck: Add support to clear v1 free
 space cache.
Message-ID: <20161026133856.GB12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161013092227.19761-1-quwenruo@cn.fujitsu.com>
 <20161025140934.GQ22935@twin.jikos.cz>
 <6845d4d0-c276-31b4-a8d7-21c6b5303adf@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6845d4d0-c276-31b4-a8d7-21c6b5303adf@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 09:07:25AM +0800, Qu Wenruo wrote:
> At 10/25/2016 10:09 PM, David Sterba wrote:
> > On Thu, Oct 13, 2016 at 05:22:26PM +0800, Qu Wenruo wrote:
> >> Kernel clear_cache mount option will only rebuilt free space cache if
> >> used space of that chunk has changed.
> >>
> >> So it won't ensure any corrupted free space cache get cleared.
> >>
> >> So add a new option "--clear-space-cache v1|v2" to btrfsck, to
> >> completely wipe out free space cache.
> >> So kernel won't complain again.
> >>
> >> Reported-by: Ivan P <chrnosphered@gmail.com>
> >> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> >
> > Applied with the attached diff, use it as a review feedback.
> >
> >
> Thanks for the diff, quite helpful.
> 
> But I'm a little concerned about the minor coding styling.
> 
> 1) For non-zero comparison
> -				if (strcmp(optarg, "v1")) {
> +				if (strcmp(optarg, "v1") != 0) {
> 
> Is it recommended to use "!= 0" other than hiding it?
> I often see code hiding the "!= 0", so I'm a little curious about this.

The strcmp return value is inverse to what the name suggests. Sure
everybody know that, but I find it a bit more readable.

> 2) Long string indent
> -			error("failed to locate free space cache extent for block group %llu",
> -			      bg->key.objectid);
> +			error(
> +	"failed to locate free space cache extent for block group %llu: %d",
> +				bg->key.objectid, ret);
> 
> Kernel coding style allows us to use string longer than 80 chars, so we 
> don't need to break long string.

We don't want to break the string and the lines should fit to 80 chars
per line, small overflow is acceptable (in btrfs-progs).

> But I'm not sure if we should change the indent.
> Normally I just keep the string at the same line of error()/warning(), 
> as we have no 80 chars limit.

Yeah, and I'm moving it to the next line and un-indenting back until the
string end is below 80 chars.

> Or we should change indent to allow them fit in 80 chars?
> IIRC I did it several times in kernel or btrfs-progs, but it seems to be 
> modified to same line version.

It's not a big deal, but preferred to keep it under 80. Why? To view
more columns, and see the whole code, not just part of the line. I use
vertically split window in the diff mode (in vim) during reviews, also
the merge conflict resolution using vimdiff tries to fit 3 views on the
screen. And maybe just personal preference, when scrolling the code down
does not need to move eyes left and right when the code fits under 80.
Small things but when multiplied by number of patches I process, quite
improves effectivity and patch throughput.
