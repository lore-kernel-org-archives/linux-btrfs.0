Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob13.myregisteredsite.com ([209.17.115.51]:49722 "EHLO
	atl4mhob13.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754459AbaCOQAe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 12:00:34 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.115])
	by atl4mhob13.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s2FG0Wl6031998
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 12:00:32 -0400
Message-ID: <5324794D.80802@chinilu.com>
Date: Sat, 15 Mar 2014 09:01:17 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
References: <1564384.fRV1HUkfCq@fuchsia> <2106363.nA97oxn4hn@fuchsia> <53224D57.8020308@chinilu.com> <1789445.UA8sCrE2Cn@fuchsia>
In-Reply-To: <1789445.UA8sCrE2Cn@fuchsia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael,  I am currently using rsync INSTEAD of btrfs backup tools.  I 
really don't see anyway that it could be compatible with the backup 
features of btrfs.  As I noted in my post, it is definitely not a 
perfect solution, but it is doing the job for me.  What I REALLY want in 
this regard is n-way mirroring to get me out of the simplex trap 
completely.  At that point, I can have more confidence in btrfs snapshop 
capability.

On 03/15/2014 04:35 AM, Michael Schuerig wrote:
> On Thursday 13 March 2014 17:29:11 George Mitchell wrote:
>> I currently use rsync to a separate drive to maintain a
>> backup copy, but it is not integrated into the array like n-way would
>> be, and is definitely not a perfect solution.
> Could you explain how you're using rsync? I was just about to copy a
> btrfs filesystem to another disk. That filesystem has several subvolumes
> and about 100 snapshots overall. Owing to COW, this amounts to about
> 1.2TB. However, I reckon that rsync doesn't know anything about COW and
> accordingly would blow up my data immensely on the destination disk.
>
> How do I copy a btrfs filesystem preserving its complete contents? How
> do I update such a copy?
>
> Yes, I want to keep the subvolume layout of the original and I want to
> copy all snapshots. I don't think send/receive is the answer, but it's
> likey I don't understand it well enough. I'm concerned, that a
> send/receive-based approach is not robust against mishaps.
>
> Consider: I want to incrementally back-up a filesystem to two external
> disks. For this I'd have to for each subvolume keep a snapshot
> corresponding to its state on the backup disk. If I make any mistake in
> managing these snapshots, I can't update the external backup anymore.
>
> Also, I don't understand whether send/receive would allow me to
> copy/update a subvolume *including* its snapshots.
>
> Things have become a little more complicated than I had hoped for, but
> I've only been using btrfs for a couple of weeks.
>
> Michael
>

