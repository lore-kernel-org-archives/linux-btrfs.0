Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36807 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120Ab3DJOVt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Apr 2013 10:21:49 -0400
Date: Wed, 10 Apr 2013 22:21:09 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Miao Xie <miaox@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/2] Btrfs: online data deduplication
Message-ID: <20130410142107.GB11394@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1365340369-23537-1-git-send-email-bo.li.liu@oracle.com>
 <1365340369-23537-2-git-send-email-bo.li.liu@oracle.com>
 <20130408125450.GA2010@localhost.localdomain>
 <20130408141625.GC27988@liubo.jp.oracle.com>
 <20130408203720.GD2010@localhost.localdomain>
 <20130409013427.GA29006@liubo.jp.oracle.com>
 <CAEzrpqf0bEUz+uresigpLA9Jss6sTnm-7YiW9kqj9o9aTySaWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEzrpqf0bEUz+uresigpLA9Jss6sTnm-7YiW9kqj9o9aTySaWw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 08, 2013 at 09:48:16PM -0400, Josef Bacik wrote:
> On Mon, Apr 8, 2013 at 9:34 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > On Mon, Apr 08, 2013 at 04:37:20PM -0400, Josef Bacik wrote:
> >> On Mon, Apr 08, 2013 at 08:16:26AM -0600, Liu Bo wrote:
> >> > On Mon, Apr 08, 2013 at 08:54:50AM -0400, Josef Bacik wrote:
> >> > > On Sun, Apr 07, 2013 at 07:12:48AM -0600, Liu Bo wrote:
> > [...]
> >> > > +       __le64 dedup_hash;
> >> > > > +
> >> > > >  } __attribute__ ((__packed__));
> >> > > >
> >> > >
> >> > > Please don't do this, do like what we do with the crc tree, just lookup based on
> >> > > the disk bytenr when we free the extent and drop refs that way.  Don't further
> >> > > bloat the file extent item, we want it smaller not larger.  Thanks,
> >> > >
> >> > > Josef
> >> >
> >> > So the real trouble is that I take this hash value as the first field of
> >> > btrfs_key, and binary searching without the precise first field is not easy.
> >> >
> >> > Otherwise we may have to add another key type which replaces hash value with
> >> > disk bytenr, ie. (disk bytenr, ANOTHER_KEY_TYPE, hash value), then we'll need to
> >> > search the tree twice to free this one or drop refs.
> >> >
> >> > Either case is tradeoff, but as this is an initial version, we can try all of
> >> > these knobs and choose the better one :)
> >> >
> >>
> >> Why would you need to search twice?  You do something like
> >>
> >> key.objectid = bytenr;
> >> key.type = whatever your type is
> >> key.offset = first 64bits of your hash
> >>
> >> and then you search based on bytenr and you get your hash.  All extents that
> >> share hashes will have the same bytenr so you can just search with
> >>
> >> key.objectid = bytenr
> >> key.type = whatever
> >> key.offset = (u64)-1
> >>
> >> and then walk backwards, or do 0 and walk forwards, whatever your preference is.
> >> Also make it so the item stores the entire sha.  With Sha256 you are wasting
> >> most of the hash result by just storing the first 64bits.  So just use the first
> >> 64bits as the index and then store the full hash in the item so you can do a
> >> proper compare, and then you can have different hash functions later with
> >> different length hash values.  Thanks,
> >
> > This is on freeing extent, what about finding dedup when we don't yet have a
> > disk bytenr but only a hash value from sha256 on file data?
> >
> > That's why (hash, type, disk bytenr) is necessary.
> >
> > Searching twice means that if we do what you've suggested, we'd not only update
> > or free (disk bytenr, type, hash), but also (hash, type, disk bytenr).
> >
> > Or am I missing something?
> >
> 
> No sorry I was putting my son to sleep thinking about this and I
> realized the problem you were having.  So I say do like we do with
> DIR_ITEMs, you have one type indexed by bytenr and one indexed by the
> stop 64bits of the hash value.  You just have an empty item for the
> index by bytenr and for the index by the hash value you have the
> offset of the key be the bytenr and then the item stores the length of
> the full hash value and the hash value.  You don't need ref counting
> since that's taken care of by the extent tree, you just free the
> corresponding dedup items when you free the extent.  It would be nice
> to do everything with just one key but I don't think you are going to
> be able to do it, unless you can figure out some way to stash the hash
> in the extent ref or something.  But growing the file extent item or
> the extent ref isn't an option since it affects anybody who doesn't
> use dedup, so I think the 2 key option is probably the best bet.
> Thanks,
> 
> Josef

Yeah, this makes sense.

All right, I've finished shipping it to two key style(from Josef) and getting
rid of the extra ref(from Josef and Miao).

But I still need to build a framework to enlarge the dedup blocksize rather than
a page size(from Dave).

thanks,
liubo
