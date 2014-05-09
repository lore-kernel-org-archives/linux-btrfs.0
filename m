Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096AbaEIQtF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 12:49:05 -0400
Date: Fri, 9 May 2014 18:49:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: superfluous " else if ()"
Message-ID: <20140509164902.GA6039@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <535C017C.7060509@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <535C017C.7060509@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 26, 2014 at 08:57:00PM +0200, Toralf Förster wrote:
> /me wonders if this
> 
>         if (ret >= 0) {
>                 /* Add an item for the type for the first time */
>                 eb = path->nodes[0];
>                 slot = path->slots[0];
>                 offset = btrfs_item_ptr_offset(eb, slot);
>         } else if (ret == -EEXIST) {
>                 /*
>                  * An item with that type already exists.
>                  * Extend the item and store the new subid at the end.
>                  */
>                 btrfs_extend_item(uuid_root, path, sizeof(subid_le));
>                 eb = path->nodes[0];
>                 slot = path->slots[0];
>                 offset = btrfs_item_ptr_offset(eb, slot);
>                 offset += btrfs_item_size_nr(eb, slot) - sizeof(subid_le);
>         } else if (ret < 0) {							<-----------------
>                 btrfs_warn(uuid_root->fs_info, "insert uuid item failed %d "
>                         "(0x%016llx, 0x%016llx) type %u!",
>                         ret, (unsigned long long)key.objectid,
>                         (unsigned long long)key.offset, type);
>                 goto out;
>         }
> 
> 
> shouldn't be condensed into just "} else {" ?

It's equivalent to the original code, but is easier to read/understand.
Do you have there other concerns besides readability?
