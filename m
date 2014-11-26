Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:43406 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903AbaKZWIR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 17:08:17 -0500
Message-ID: <54764F4E.80405@pobox.com>
Date: Wed, 26 Nov 2014 14:08:14 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS messes up snapshot LV with origin
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>	<546B68F8.6080008@ubuntu.com>	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>	<546BA96D.4050805@ubuntu.com>	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>	<5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org>	<5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org>	<5474FBD9.5070709@inwind.it> <pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net>
In-Reply-To: <pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/25/2014 07:22 PM, Duncan wrote:
>>From my perspective, however, btrfs is simply incompatible with lvm
> snapshots, because the basic assumptions are incompatible.  Btrfs assumes
> UUIDs will be exactly what they say on the label, /unique/, while lvm's
> snapshot feature directly breaks that uniqueness by copying the (former)
> UUID, thus making the former UUID no longer unique and thus no longer
> truly UUID.  Thus, part of the lvm /feature/ of snapshots is in direct
> contradiction to a basic assumption of btrfs, that UUIDs are exactly
> that, unique, making that feature directly incompatible with btrfs on a
> very basic level.

A finer point here. LVM doesn't "copy" the UUID. AN LVM snapshot is a 
copy-on-write entity so it _exposes_ the single sector(s) of the 
superblock(s) in both views of the underlying storage. This is universal 
to the idea of a snapshot. Just as a "btrfs subvol snap /old /new" 
exposes all the "unique" elements of "/old" under the name "/new" (in 
preparation for the user to implement subsequent divergence); "lvmcreate 
--snapshot Old New" causes every block-N of Old to be identically 
available as block-N of New (in preparation for the user to implement 
subsequent divergence).

In point of fact the LVM snapshot operation is a zero-copy operation at 
its heart. After the snapshot is established, when a block in modified 
in Old, it's original content is saved in New. When blocks are written 
in New, they are written in place and the reference to the block content 
in Old is overwritten.

This is the reason that fsfreeze is unnecessary for things above LVM 
snapshots as the instant-in-time divergence is _instant_. It's not that 
LVM goes out and does an fsfreeze equivalent action, its that the switch 
to write-divergence is essentially atomic. A bunch of metatdata is setup 
and then all-at-once one write behavior is switched with another by 
re-mapping the device access routines.

So while you may have a point about btrfs being unprepared for LVM, 
neither party is particularly "at fault" in any way.

The "damn you photocopier for making photocopies so identically" nature 
of your problem with LVM seems to be leading you to misplaced conclusions.

If you need to harmonize these sorts of things, you need to be able to 
re-write blocks in question with disambiguating information (like new 
UUIDS) or restrict your accesses in some other manner.

If you are waiting for someone to "code it up" perhaps you should do so. 
But it will _never_ be automatic because the use cases that don't match 
your expectations may need the founding assumptions to be as they are today.

In other words, your belief that your position is "entirely logical" may 
be a little off, particularly if you think LVM is "Copying" things when 
it does a snapshot.

As previously stated XFS solved this problem by providing a tool that 
would change the UUID of a file system. This tool cold then be pointed 
at either (or both) the original and/or snapshot volumes as needed.

I don't see a "re-make the btrfs" option for changing UUIDs and LVM 
doesn't care _at_ _all_ about what is actually in its volumes (okay, 
lvresize has some fsck nonsense, but that's just messy).

It might even be "wrong" to try to harmonize those features, like trying 
to put a manual clutch into a car with an automatic transmission... it 
may just not fit.

Given that BTRFS want's to play in the same level of abstraction as LVM, 
its kind of a given that they'll butt heads over things like conflicting 
definitions of what it means to take a snapshot.
