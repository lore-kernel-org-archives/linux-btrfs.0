Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab3DVPYz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 11:24:55 -0400
Message-ID: <5175561C.90709@redhat.com>
Date: Mon, 22 Apr 2013 10:24:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: make static code static & remove dead code
References: <51719932.6010406@redhat.com> <20130422150511.GP16427@twin.jikos.cz>
In-Reply-To: <20130422150511.GP16427@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/22/13 10:05 AM, David Sterba wrote:
> On Fri, Apr 19, 2013 at 12:21:22PM -0700, Eric Sandeen wrote:
>> Big patch, but all it does is add statics to functions which
>> are in fact static, then remove the associated dead-code fallout.
> 
> I support removing dead code, though nearly all of the functions make me
> wonder why they're not used. 

That's still a little above my btrfs pay grade. ;)

> A few samples I see immediatelly:
> 
>> btrfs_iref_to_path()
> 
> The removed comment looks useful, I'd rather see it transferred to a
> function with similar goal (that probably got a different name during
> time).

whoops, yep, it probably belongs on btrfs_ref_to_path(), sorry
about that.

>> __btrfs_lookup_delayed_deletion_item()
>> __btrfs_search_delayed_insertion_item()
>> __btrfs_search_delayed_deletion_item()
>> find_eb_for_page()
>> btrfs_find_block_group()
>> range_straddles_pages()
>> extent_range_uptodate()
>> btrfs_file_extent_length()
>> btrfs_reada_detach()
> 
> That's an API for readahead, thhugh maybe not used now as RA is not used
> and at all scenarios where it could.

Ok, if it's useful to keep it around just for symmetry I could
understand that.  

>> btrfs_scrub_cancel_devid()
> 
> Looks like there's a missing userspace counterpart, cancelling scrub by
> device is possible by design.

Maybe one for Arne to answer?  Yeah, I don't see it in the manpage
or in userspace, so *shrug* where is the design?

>> btrfs_start_transaction_lflush()
> 
> Transcaction API, removing the func does not make sense without removing
> BTRFS_RESERVE_FLUSH_LIMIT at the same time.

Not sure I understand that, btrfs_block_rsv_refill() still uses that macro,
but I'm probably not understanding the code or missing your point.

I'll admit to doing the removal mechanically, hopefully those with
particular affinity to any of the removed functions can speak
up.  :)

Thanks,
-Eric

> david
> 

