Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab3GHVMK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jul 2013 17:12:10 -0400
Date: Mon, 8 Jul 2013 23:12:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Paul Richards <paul.richards@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Does balance implicitly defrag?
Message-ID: <20130708211208.GF18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAMoswei+L-kH_O9uRecOorpS6Kf5hnZ9j3nxZ36kzFR6G9uXeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMoswei+L-kH_O9uRecOorpS6Kf5hnZ9j3nxZ36kzFR6G9uXeg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 02, 2013 at 02:28:25PM +0100, Paul Richards wrote:
> When I run "btrfs filesystem balance", does this implicitly
> defragment the filesystem?  (Assuming there is plenty free space)

In some sense it defragments the filesystem. The blockgroups are moved
around based on the balance filter. Here a blockgroup consists of
various and unrelated file extents. Extents representing a single file
are not made contiguous, this is done by 'btrfs file defrag'.

I think that the final layout of the 1G-chunks is not necessarily
contiguous, ie. it depends on the chunk-allocator, the time of the
allocation request and there's nothing like "preallocate 30G for whole
balance and put all data together because the space is available".

david
