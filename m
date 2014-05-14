Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37384 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750741AbaENSJo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 14:09:44 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can a snapshot become a parent subvolume when its parent is deleted?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140514135057.GA12849@merlins.org>
Date: Wed, 14 May 2014 12:09:38 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <FA8D4920-8A23-4C8D-848F-EC52BF43311C@colorremedies.com>
References: <20140514135057.GA12849@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 14, 2014, at 7:50 AM, Marc MERLIN <marc@merlins.org> wrote:

> So, I had btrfs_pool1 that was trashed/lost as discussed here recently.
> 
> I did btrfs send btrfs_pool2/root_ro.date | btrfs receive /mnt/btrfs_pool1
> 
> Then btrfs subvolume snapshot root_ro.date root
> 
> Now, after I delete root_ro.date on btrfs_pool1, shouldn't root become a
> parent subvolume?

There's no explicit hierarchy like this. There's no state "parent" or "child". 

If a subvolume is created by snapshotting another subvolume, the new subvolume refers to the uuid of its source as the parent uuid. And the original subvolume, at least in the UI, contains a list of its snapshots but I don't know that this metadata is literally associated with the subvolume rather than inferred from its snapshots, all of which contain the "parent" subvolume's uuid as a parent_uuid.


> 
> Right now, I have:
> legolas:/mnt/btrfs_pool1# btrfs subvolume list -q . 
> ID 390 gen 5954 top level 5 parent_uuid faea7df8-d51a-6b4b-994b-887d55267cce path root
> legolas:/mnt/btrfs_pool1# btrfs subvolume list  -u .  |grep faea7df8-d51a-6b4b-994b-887d55267cce
> legolas:/mnt/btrfs_pool1#
> 
> Is it possible not to have a parent?
> 
> If so, shouldn't you become a parent at that time?

No. The listed subvolume parent_uuid is the subvolume uuid for now deleted subvolume root_ro.date. Even though it's deleted, the subvolume created from it still retains the parent_uuid reference.

If you snapshot root, you could say it "becomes a parent" but it's only a metaphor it's not something that literally happens on disk. All I'm aware of that happens is the new subvolume gets its own uuid and its parent_uuid is set to match the subvolume uuid it was created from.




Chris Murphy