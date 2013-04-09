Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18402 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935512Ab3DIBeF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2013 21:34:05 -0400
Date: Tue, 9 Apr 2013 09:34:28 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: online data deduplication
Message-ID: <20130409013427.GA29006@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1365340369-23537-1-git-send-email-bo.li.liu@oracle.com>
 <1365340369-23537-2-git-send-email-bo.li.liu@oracle.com>
 <20130408125450.GA2010@localhost.localdomain>
 <20130408141625.GC27988@liubo.jp.oracle.com>
 <20130408203720.GD2010@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130408203720.GD2010@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 08, 2013 at 04:37:20PM -0400, Josef Bacik wrote:
> On Mon, Apr 08, 2013 at 08:16:26AM -0600, Liu Bo wrote:
> > On Mon, Apr 08, 2013 at 08:54:50AM -0400, Josef Bacik wrote:
> > > On Sun, Apr 07, 2013 at 07:12:48AM -0600, Liu Bo wrote:
[...]
> > > +       __le64 dedup_hash;
> > > > +
> > > >  } __attribute__ ((__packed__));
> > > > 
> > > 
> > > Please don't do this, do like what we do with the crc tree, just lookup based on
> > > the disk bytenr when we free the extent and drop refs that way.  Don't further
> > > bloat the file extent item, we want it smaller not larger.  Thanks,
> > > 
> > > Josef
> > 
> > So the real trouble is that I take this hash value as the first field of
> > btrfs_key, and binary searching without the precise first field is not easy.
> > 
> > Otherwise we may have to add another key type which replaces hash value with
> > disk bytenr, ie. (disk bytenr, ANOTHER_KEY_TYPE, hash value), then we'll need to
> > search the tree twice to free this one or drop refs.
> > 
> > Either case is tradeoff, but as this is an initial version, we can try all of
> > these knobs and choose the better one :)
> > 
> 
> Why would you need to search twice?  You do something like
> 
> key.objectid = bytenr;
> key.type = whatever your type is
> key.offset = first 64bits of your hash
> 
> and then you search based on bytenr and you get your hash.  All extents that
> share hashes will have the same bytenr so you can just search with
> 
> key.objectid = bytenr
> key.type = whatever
> key.offset = (u64)-1
> 
> and then walk backwards, or do 0 and walk forwards, whatever your preference is.
> Also make it so the item stores the entire sha.  With Sha256 you are wasting
> most of the hash result by just storing the first 64bits.  So just use the first
> 64bits as the index and then store the full hash in the item so you can do a
> proper compare, and then you can have different hash functions later with
> different length hash values.  Thanks,

This is on freeing extent, what about finding dedup when we don't yet have a
disk bytenr but only a hash value from sha256 on file data?

That's why (hash, type, disk bytenr) is necessary.

Searching twice means that if we do what you've suggested, we'd not only update
or free (disk bytenr, type, hash), but also (hash, type, disk bytenr).

Or am I missing something?

thanks,
liubo
