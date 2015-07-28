Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbbG1Ouf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 10:50:35 -0400
Date: Tue, 28 Jul 2015 16:50:21 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 00/14] Yet Another In-band(online) deduplication
 implement
Message-ID: <20150728145021.GI6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438072250-2871-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 28, 2015 at 04:30:36PM +0800, Qu Wenruo wrote:
> Although Liu Bo has already submitted a V10 version of his deduplication
> implement, here is another implement for it.

What's the reason to start another implementation?

> [[CORE FEATURES]]
> The main design concept is the following:
> 1) Controllable memory usage
> 2) No guarantee to dedup every duplication.
> 3) No on-disk format change or new format
> 4) Page size level deduplication

1 and 2) are good goals, allow usability tradeoffs

3) so the dedup hash is stored only for the mount life time. Though it
avoids the on-disk format changes, it also reduces the effectivity. It
is possible to "seed" the in-memory tree by reading all files that
contain potentially duplicate blocks but one would have to do that after
each mount.

4) page-sized dedup chunk is IMHO way too small. Although it can achieve
high dedup rate, the metadata can potentially explode and cause more
fragmentation.

> Implement details includes the following:
> 1) LRU hash maps to limit the memory usage
>    The hash -> extent mapping is control by LRU (or unlimited), to
>    get a controllable memory usage (can be tuned by mount option)
>    alone with controllable read/write overhead used for hash searching.

In Liu Bo's series, I rejected the mount options as an interface and
will do that here as well. His patches added a dedup ioctl to (at least)
enable/disable the dedup.

> 2) Reuse existing ordered_extent infrastructure
>    For duplicated page, it will still submit a ordered_extent(only one
>    page long), to make the full use of all existing infrastructure.
>    But only not submit a bio.
>    This can reduce the number of code lines.

> 3) Mount option to control dedup behavior
>    Deduplication and its memory usage can be tuned by mount option.
>    No need to indicated ioctl interface.

I'd say the other way around.

>    And further more, it can easily support BTRFS_INODE flag like
>    compression, to allow further per file dedup fine tunning.
> 
> [[TODO]]
> 3. Add support for per file dedup flags
>    Much easier, just like compression flags.

How is that supposed to work? You mean add per-file flags/attributes to
mark a file so it fills the dedup hash tree and is actively going to be
deduped agains other files?

> Any early review or advice/question on the design is welcomed.

The implementation is looks simpler than the Liu Bo's, but (IMHO) at the
cost of reduced funcionality.

Ideally, we merge one patchset with all desired functionality. Some kind
of control interface is needed not only to enable/dsiable the whole
feature but to affect the trade-offs (memory consumptin vs dedup
efficiency vs speed), and that in a way that's flexible according to
immediate needs.

The persistent dedup hash storage is not mandatory in theory, so we
could implement an "in-memory tree only" mode, ie. what you're
proposing, on top of Liu Bo's patchset.
