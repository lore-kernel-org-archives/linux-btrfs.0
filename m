Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab3DVPFN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 11:05:13 -0400
Date: Mon, 22 Apr 2013 17:05:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: make static code static & remove dead code
Message-ID: <20130422150511.GP16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51719932.6010406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51719932.6010406@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 19, 2013 at 12:21:22PM -0700, Eric Sandeen wrote:
> Big patch, but all it does is add statics to functions which
> are in fact static, then remove the associated dead-code fallout.

I support removing dead code, though nearly all of the functions make me
wonder why they're not used. A few samples I see immediatelly:

> btrfs_iref_to_path()

The removed comment looks useful, I'd rather see it transferred to a
function with similar goal (that probably got a different name during
time).

> __btrfs_lookup_delayed_deletion_item()
> __btrfs_search_delayed_insertion_item()
> __btrfs_search_delayed_deletion_item()
> find_eb_for_page()
> btrfs_find_block_group()
> range_straddles_pages()
> extent_range_uptodate()
> btrfs_file_extent_length()
> btrfs_reada_detach()

That's an API for readahead, thhugh maybe not used now as RA is not used
and at all scenarios where it could.

> btrfs_scrub_cancel_devid()

Looks like there's a missing userspace counterpart, cancelling scrub by
device is possible by design.

> btrfs_start_transaction_lflush()

Transcaction API, removing the func does not make sense without removing
BTRFS_RESERVE_FLUSH_LIMIT at the same time.

david
