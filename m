Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbcAWWLR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 17:11:17 -0500
Date: Sat, 23 Jan 2016 14:11:16 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: James Hogarth <james.hogarth@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Query about proposed dedup patches and behaviours
Message-ID: <20160123221116.GD24672@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2016 at 04:13:00PM +0000, James Hogarth wrote:
> The duperemove[1] tool is in the process for packaging for Fedora at
> present but I was wondering what future this may have with the 4.5
> dedup patches being proposed.
> 
> WIll the btrfs command have the ability to out-of-line dedup files
> similar to duperemove (thus negating the need for it) or will this
> only control in-line dedup with a tool like duperemove still being
> required for periodic only (or restricted path) dedup?

Similar to dupremove, I doubt it. Duperemove is about 12,000 lines at this
point and very little of it is duplicated from btrfs-progs. Much of it is
concerned with efficiently scanning files, making extents from duplicated
blocks, managing a sqlite db, etc. Things that the btrfs command doesn't
need to handle.

Also Ocfs2 should be able to support extent-same at some point and
duperemove will want to run on that FS as well.

We could always have a small wrapper to the ioctl but again the difference
between 'hey dedupe a couple of files' and 'scan terabytes of data to
dedupe' is pretty big if you care about getting it done efficiently.


> To avoid memory usage bloat if the btrfs command can order dedup  of X
> files on the path correctly can it be passed a path to carry the hash
> map in some form (similar to how dupeemeove can use sqlite for this)
> or is this another use case for the external tool?

I'm not totally clear on what you're asking here. Do you want the duperemove
hashes passed into the kernel? There's no point since we just use that map
to call our ioctl...


> Finally what's the present situation with regards to defragmentation
> and deduplication? Is it safe to turn on autodefrag now when using
> snapshots and duperemove? What should the behaviour be with the
> proposed 4.5 dedup patches if both inline dedup and autodefrag are
> enabled as mount options?

Was there ever a reason it was unsafe to do dedupe + autodefrag? To my
knowledge this should be fine.

Thanks,
	--Mark

--
Mark Fasheh
