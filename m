Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41034 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaESBMf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 21:12:35 -0400
Date: Sun, 18 May 2014 18:11:55 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Can a snapshot become a parent subvolume when its parent is
 deleted?
Message-ID: <20140519011155.GJ10566@merlins.org>
References: <20140514135057.GA12849@merlins.org>
 <FA8D4920-8A23-4C8D-848F-EC52BF43311C@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <FA8D4920-8A23-4C8D-848F-EC52BF43311C@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 14, 2014 at 12:09:38PM -0600, Chris Murphy wrote:
> 
> On May 14, 2014, at 7:50 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> > So, I had btrfs_pool1 that was trashed/lost as discussed here recently.
> > 
> > I did btrfs send btrfs_pool2/root_ro.date | btrfs receive /mnt/btrfs_pool1
> > 
> > Then btrfs subvolume snapshot root_ro.date root
> > 
> > Now, after I delete root_ro.date on btrfs_pool1, shouldn't root become a
> > parent subvolume?
> 
> There's no explicit hierarchy like this. There's no state "parent" or "child". 
> 
> If a subvolume is created by snapshotting another subvolume, the new
> subvolume refers to the uuid of its source as the parent uuid. And
> the original subvolume, at least in the UI, contains a list of its
> snapshots but I don't know that this metadata is literally associated
> with the subvolume rather than inferred from its snapshots, all of
> which contain the "parent" subvolume's uuid as a parent_uuid.

Right. So basically the parent UUID can go orphanned, which I found a
bit surprising.

> > Right now, I have:
> > legolas:/mnt/btrfs_pool1# btrfs subvolume list -q . 
> > ID 390 gen 5954 top level 5 parent_uuid faea7df8-d51a-6b4b-994b-887d55267cce path root
> > legolas:/mnt/btrfs_pool1# btrfs subvolume list  -u .  |grep faea7df8-d51a-6b4b-994b-887d55267cce
> > legolas:/mnt/btrfs_pool1#
> > 
> > Is it possible not to have a parent?
> > 
> > If so, shouldn't you become a parent at that time?
> 
> No. The listed subvolume parent_uuid is the subvolume uuid for
> now deleted subvolume root_ro.date. Even though it's deleted, the
> subvolume created from it still retains the parent_uuid reference.

Yep. If you think about daemonized processed that get inherited by init,
shouldn't parent-less snapshots change their parent uuid to '-'
 
> If you snapshot root, you could say it "becomes a parent" but it's
> only a metaphor it's not something that literally happens on disk. All
> I'm aware of that happens is the new subvolume gets its own uuid and
> its parent_uuid is set to match the subvolume uuid it was created
> from.

You are correct. The blocks don't care who is the parent and child
subvolume, they're just references.
But for management purposes by us humans :) it's useful to know what's
going on.

Would a developer agree to making parent less subvolumes have their
parent become '-'?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
