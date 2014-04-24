Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43598 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753483AbaDXRWq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 13:22:46 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs send receive, clone
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140424155510.GG2391@carfax.org.uk>
Date: Thu, 24 Apr 2014 11:22:40 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <5FFF69A6-A3E0-439C-8DAE-9DB45441CB26@colorremedies.com>
References: <35B44B63-D139-4E0E-AD6F-2320B79D19B1@colorremedies.com> <20140424155510.GG2391@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 24, 2014, at 9:55 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Apr 24, 2014 at 09:23:28AM -0600, Chris Murphy wrote:
>> 
>> 
>> I don't understand the btrfs send -c <clone-src> man page text, or really even the use case. In part this is what it says:
>> 
>>> You must not specify clone sources unless you
>>> guarantee that these snapshots are exactly in the same state on both
>>> sides, the sender and the receiver.
>> 
>> If the snapshots are the same on both sides, then why would I be using clone in the first place?
> 
>   To copy over another snapshot which shares data with them.
> 
>>> -c <clone-src> Use this snapshot as a clone source for an 
>>> incremental send (multiple allowed)
>> 
>> Incremental send implies the sender and receiver are not in the same state now, but will be after the command is executed. Is one, or both, snapshots rw for -c?
>> 
>> Anyway, I'm lost on the specifics, but clearly I'm even lost when it comes to the basic difference between -p and -c.
> 
> (Note: I've not actually tried the second case in what follows, but
> it's what I think is going on. This may be subject to corrections.)
> 
>   OK, call the sending system "S" and the receiving system "R". Let's
> say we've got three subvolumes on S:
> 
> S:A2, the current /home (say)
> S:A1, a snapshot of an earlier version of S:A2
> S:B, a separate subvolume that's had some CoW copies of files in both
>     S:A1 and S:A2 made into it.
> 
>   If we send S:A1 to R, then we'll have to send the whole thing,
> because R doesn't have any subvolumes yet.
> 
>   If we now want to send S:A2 to R, then we can use -p S:A1, and it
> will send just the differences between those two. This means that the
> send stream can potentially ignore a load of the metadata as well as
> the data. It's effectively saying, "you can clone R:A1, then do these
> things to it to get R:A2".
> 
>   If we now want to send S:B to R, then we can use -c S:A1 -c S:A2.

OK this makes sense now, thanks.

Does the use of -c always require at least two -c instances? Is there an example where -c is used once? From the man page I'm not groking that there must be at least two -c's.


>   I'm trying to think of a case where -c is useful that doesn't
> involve someone having done cp --reflink=always between subvolumes,
> but I can't.

OK.


> So, I think the summary is:
> 
> * Use -p to deal with parent-child reflinks through snapshots
> * Use -c to specify other subvolumes (present on both sides) that
>   might contain reflinked data

I think the key is that -c implies a minimum of five subvolumes: two subvolumes on the source, which have (identical) counterparts on the destination (that's four subvolumes), and then one additional somehow related subvolume B on the source that I want on the destination.

Whereas -p implies three subvolumes (one on the source which is the parent, its counterpart on the destination, and a child on the source which I want on the destination). I necessarily must understand the relationship among them in order to get the desired incremental result on the destination.


Chris Murphy

