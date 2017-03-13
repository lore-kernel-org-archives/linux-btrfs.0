Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60597 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750808AbdCMRfb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 13:35:31 -0400
Date: Mon, 13 Mar 2017 18:34:53 +0100
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Fresh Raid-1 setup, dump-tree shows invalid owner id
Message-ID: <20170313173453.GQ14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170130015416.GA5619@giis.co.in>
 <006ecc84-52fb-2b09-0e47-317fa018e9f9@mendix.com>
 <CAKuJGC_x8S-RhnXA+1oVL3zsDkjMaHxixgajxmxvuRw6BZNUHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKuJGC_x8S-RhnXA+1oVL3zsDkjMaHxixgajxmxvuRw6BZNUHA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2017 at 06:07:01PM +0530, Lakshmipathi.G wrote:
> >
> > Yes, the owner is the number of the tree.
> >
> > DATA_RELOC_TREE is -9, but then unsigned 64 bits.
> >
> >>>> -9 + 2**64
> > 18446744073709551607L
> >
> > So the result is a number that's close to the max or 64 bits.
> >
> > You can find those numbers in the kernel source in
> >   include/uapi/linux/btrfs_tree.h
> >
> > e.g.:
> >
> > #define BTRFS_DATA_RELOC_TREE_OBJECTID -9ULL
> >
> 
> Thanks for the details. This owner number looked different from other
> owner ids, so wanted to check on the same, now understood.

Recently, in the commit 6f6b643e44ef7, the known tree ids are printed as
the small negative numbers. We can also do that in progs, however we'd
need some tricks so we don't duplicate all format strings one with %llu
and one with %lld. Something like

format: "%s%llu"
values:
  id > LAST_FREE ? "-" : ""
  id > LAST_FREE ? 2^64 - id : id

and  hidden in helpers etc.

I don't think we should replace all references to tree ids with the
symbolic names as they're used in keys so searching for the numeric
value in the dump output would miss something or make the regexp more
complicated. I won't object against making the tree id output format
selectable by option though.
