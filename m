Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab3COMrr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 08:47:47 -0400
Date: Fri, 15 Mar 2013 13:47:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Remco Hosman <remco@yerf-it.nl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: converting to raid5
Message-ID: <20130315124744.GF7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <19DDB13F-E8EC-4751-A916-E83555347D7E@hosman.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19DDB13F-E8EC-4751-A916-E83555347D7E@hosman.xs4all.nl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 09:15:44PM +0100, Remco Hosman wrote:
> first, i did the following: `btrfs val start -dconvert=raid5,usage=1` to convert the mostly empty chunks.
> This resulted in a lot of allocated space (10's of gigs), with only a few 100 meg used.

Matches my expectation, converting to the new profile needs to allocate
full 1G chunks, but the usage=1 filter allows to fill them partially.

After this step, several ~empty raid1 chunks should disappear.

> i did `btrfs val start -dusage=75` to clean things up.
> 
> then i ran `btrfs bal start -dconvert=raid5,soft`.
> I noticed how the difference between total and used for raid5 kept growing. 

Do you remember if this was temporary or if the difference was
unexpectedly big after the whole operation finished?

> My guess is that its taking 1 raid1 chunk (2x1 gig disk space, 1 gig
> data), and moving it to 1 raid5 chunk (4gig disk space, 3gig data),
> leaving all chunks 33% used.

Why 3G of data in raid5 case? I assume you talk about the actually used
data and this should be the same as in raid1 case, but spread over 3x
1GB chunks and leaving them 33% utilized, that makes sense, but is not
clear from your description.

> This is what 3 calls of `btrfs file df /` looks like a few minutes after each other, with the balance still running:

> Data, RAID1: total=807.00GB, used=805.70GB
> Data, RAID5: total=543.00GB, used=192.81GB
> --
> Data, RAID1: total=800.00GB, used=798.70GB
> Data, RAID5: total=564.00GB, used=199.30GB
> --
> Data, RAID1: total=795.00GB, used=793.70GB
> Data, RAID5: total=579.00GB, used=204.81GB

raid1 numbers going down, raid5 going up, all ok.

david
