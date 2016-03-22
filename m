Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716AbcCVNim (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 09:38:42 -0400
Date: Tue, 22 Mar 2016 14:38:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework
Message-ID: <20160322133812.GK8095@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2016 at 09:35:25AM +0800, Qu Wenruo wrote:
> This updated version of inband de-duplication has the following features:
> 1) ONE unified dedup framework.
> 2) TWO different back-end with different trade-off

The on-disk format is defined in code, would be good to give some
overview here.

> 3) Support compression with dedupe
> 4) Ioctl interface with persist dedup status

I'd like to see the ioctl specified in more detail. So far there's
enable, disable and status. I'd expect some way to control the in-memory
limits, let it "forget" current hash cache, specify the dedupe chunk
size, maybe sync of the in-memory hash cache to disk.

> 5) Ability to disable dedup for given dirs/files

This would be good to extend to subvolumes.

> TODO:
> 1) Add extent-by-extent comparison for faster but more conflicting algorithm
>    Current SHA256 hash is quite slow, and for some old(5 years ago) CPU,
>    CPU may even be a bottleneck other than IO.
>    But for faster hash, it will definitely cause conflicts, so we need
>    extent comparison before we introduce new dedup algorithm.

If sha256 is slow, we can use a less secure hash that's faster but will
do a full byte-to-byte comparison in case of hash collision, and
recompute sha256 when the blocks are going to disk. I haven't thought
this through, so there are possibly details that could make unfeasible.

The idea is to move expensive hashing to the slow IO operations and do
fast but not 100% safe hashing on the read/write side where performance
matters.

> 2) Misc end-user related helpers
>    Like handy and easy to implement dedup rate report.
>    And method to query in-memory hash size for those "non-exist" users who
>    want to use 'dedup enable -l' option but didn't ever know how much
>    RAM they have.

That's what we should try know and define in advance, that's part of the
ioctl interface.

I went through the patches, there are a lot of small things to fix, but
first I want to be sure about the interfaces, ie. on-disk and ioctl.

Then we can start to merge the patchset in smaller batches, the
in-memory deduplication does not have implications on the on-disk
format, so it's "just" the ioctl part.

The patches at the end of the series fix bugs introduced within the same
series, these should be folded to the patches that are buggy.
