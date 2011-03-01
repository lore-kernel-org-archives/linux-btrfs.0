From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs wishlist
Date: Tue, 01 Mar 2011 13:39:58 -0500
Message-ID: <1299004651-sup-1713@think>
References: <28499638.308.1299004542529.JavaMail.root@zimbra>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <28499638.308.1299004542529.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Roy Sigurd Karlsbakk's message of 2011-03-01 13:35:42 -0500:
> Hi all
> 
> Having managed ZFS for about two years, I want to post a wishlist.
> 
> INCLUDED IN ZFS
> 
> - Mirror existing single-drive filesystem, as in 'zfs attach'

This one is easy, we do plan on adding it.

> - RAIDz-stuff - single and hopefully multiple-parity RAID configuration with block-level checksumming

We'll have raid56, but it won't be variable stripe size.  There will be
one stripe size for data and one for metadata but that's it.

> - Background scrub/fsck

These are in the works

> - Pool-like management with multiple RAIDs/mirrors (VDEVs)

We have a pool of drives now....I'm not sure exactly what the vdevs are.

> - Autogrow as in ZFS autoexpand

We grow to the available storage now.

> 
> NOT INCLUDED IN CURRENT ZFS
> 
> - Adding/removing drives from VDEVs

We can add and remove drives on the fly today

> - Rebalancing a pool

We can rebalance space between drives today.

> - dedup

ZFS does have dedup we don't yet.  This one has a firm maybe.


-chris
