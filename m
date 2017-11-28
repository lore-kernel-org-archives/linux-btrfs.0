Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54751 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752341AbdK1TOc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 14:14:32 -0500
Date: Tue, 28 Nov 2017 20:12:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About 'key type for persistent [...] items'
Message-ID: <20171128191234.GD3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3576cefb-4554-b559-0b26-3679a1e94243@mendix.com>
 <20171128173441.GZ3553@twin.jikos.cz>
 <344ca10c-39eb-0adb-3926-9ba6bf5a7229@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <344ca10c-39eb-0adb-3926-9ba6bf5a7229@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 28, 2017 at 07:00:28PM +0100, Hans van Kranenburg wrote:
> On 11/28/2017 06:34 PM, David Sterba wrote:
> > On Fri, Nov 24, 2017 at 08:16:05PM +0100, Hans van Kranenburg wrote:
> >> Last week, when implementing the automatic classifier to dynamically
> >> create tree item data objects by key type in python-btrfs, I ran into
> >> the following commits in btrfs-progs:
> >>
> >>   commit 8609c8bad68528f668d9ce564b868aa4828107a0
> >>   btrfs-progs: print-tree: factor out temporary_item dump
> >> and
> >>   commit a4b65f00d53deb1b495728dd58253af44fcf70df
> >>   btrfs-progs: print-tree: factor out persistent_item dump
> >>
> >> ...which are related to kernel...
> >>
> >>   commit 50c2d5abe64c1726b48d292a2ab04f60e8238933
> >>   btrfs: introduce key type for persistent permanent items
> >> and
> >>   commit 0bbbccb17fea86818e1a058faf5903aefd20b31a
> >>   btrfs: introduce key type for persistent temporary items
> >>
> >> Afaics the goal is to overload types because there can be only 256 in
> >> total. However, I'm missing the design decisions behind the
> >> implementation of it. It's not in the commit messages, and it hasn't
> >> been on the mailing list.
> > 
> > The reason is avoid wasting key types but still allow to store new types
> > of data to the btrees, if they were not part of the on-disk format.
> > 
> > I'm not sure if this has been discussed or mentioned under some patches
> > or maybe unrelated patches. I do remember that I discussed that with
> > Chris in private on IRC and have the logs, dated 2015-09-02.
> > 
> > At that time the balance item and dev stats item were introduced, maybe
> > also the qgroup status item type. This had me alarmed enough to
> > reconsider how the keys are allocated.
> > 
> >> Before, there was an 1:1 mapping from key types to data structures. Now,
> >> with the new PERSISTENT_ITEM_KEY and TEMPORARY_ITEM_KEY, it seems items
> >> which use this type can be using any data structure they want, so it's
> >> some kind of YOLO_ITEM_KEY.
> > 
> > In some sense it is, so it's key+objectid to determine the structure.
> > 
> >> The print-tree code in progs 8609c8b and a4b65f0 seems incomplete. For
> >> example, for the PERSISTENT_ITEM_KEY, there's a switch (objectid) with
> >> case BTRFS_DEV_STATS_OBJECTID.
> >>
> >> However, BTRFS_DEV_STATS_OBJECTID is just the value 0. So, that means
> >> that if I want to have another tree where BTRFS_MOUTON_OBJECTID is also
> >> 0, and I'm storing a btrfs_kebab_item struct indexed at
> >> (BTRFS_MOUTON_OBJECTID, PERSISTENT_ITEM_KEY, 31337), then print_tree.c
> >> will try to parse the data by calling print_dev_stats?
> > 
> > As answered by Qu, you can't use 0 for BTRFS_MOUTON_OBJECTID in that
> > case.
> 
> (I'm just thinking out loud here, if you think I'm wasting your time
> just say.)
> 
> Yes, so the objectid numbers have to be "registered" / "reserved" in the
> documentation, and they have to be unique over all trees.

Right.

> Maybe the information I was looking for is... in what cases should or
> shouldn't this be used? Because that limits the possible usage quite a
> bit. Or is it only for very very specific things.

The keys are not free for use, they need to have a defined meaning and
are sort of part of the on-disk format. There must be some usecase and
reasoning why it's necessary to be done that way, and not in another.
Like xattr.

I don't have an example now, but I could imagine some per-tree
information that can be tracked and updated at commit time.

> E.g. if I wanted to (just a random idea) add per device statistics, and
> use this, I'd need to use the key also with objectid 1, 2, 3, etc... if
> I have multiple devices. That's already a no go if there's anyone in any
> other tree that is doing anything with any objectid in the range of
> valid device numbers.

In that case there would be a new objectid PER_DEVICE_OBJECTID, with the
persistent key, and all the device ids can go to the offset field. The
objectid field should not be dynamic, by design.

> >> What's the idea behind that? Instead of having the key type field define
> >> the struct and meaning, we now suddenly need the tuple (tree, objectid,
> >> type), and we need all three to determine what's inside the item data?
> >> So, the code in print_tree.c would also need to know about the tree
> >> number and pass that into the different functions.
> > 
> > No, all key types, even the persistent/temporary are independent of the
> > tree type. So it's only type <-> structure mapping, besides
> > persistent/temporary types.
> 
> Yeah, I wasn't explicit about that, I meant only for the
> persistent/temporary case yes.

So for this case it's type + objectid, the tree independence stays.
