From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH][RFC] btrfs: fix potential overflow in leafsize accounting
Date: Fri, 17 Jun 2011 15:18:43 -0400
Message-ID: <1308338282-sup-4067@shiny>
References: <1307986264-5707-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1307986264-5707-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from David Sterba's message of 2011-06-13 13:31:04 -0400:
> smatch reported a dead code. It seems to allow wrong item size counting
> in leaves, as the first for loop does not adjust the maximum number for
> items that would fit in BTRFS_LEAF_DATA_SIZE, and the rest of the code
> works with the wrong value. The value of 'nr' is accompanied with
> accumulating total_data and total_size, which are compared to the leaf
> size and probably prevent this bug to do more harm, but the errorneously
> computed value of 'nr' is later used in moving existing items and lastly
> for setting up the item for new data.
> 
> The bug has a potential to silently corrupt data when leaves are near to
> full, though I'm not aware of any related reports so far.

btrfs_insert_some_items is actually dead code.  I've just deleted it
instead, but you're completely right that this is a bug.

-chris
