Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37867 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751162AbaDUGIb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 02:08:31 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Planning for subvolumes of subvolumes and btrfs send/receive
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140421054829.GT7884@merlins.org>
Date: Mon, 21 Apr 2014 00:08:30 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <747CE4D2-2D83-474D-8D38-E06FF49ACF04@colorremedies.com>
References: <20140420194627.GO7884@merlins.org> <5B1404BF-F985-4201-87FD-CBB3E6776531@colorremedies.com> <20140421054829.GT7884@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 20, 2014, at 11:48 PM, Marc MERLIN <marc@merlins.org> wrote:

> On Sun, Apr 20, 2014 at 11:39:22PM -0600, Chris Murphy wrote:
>> 
>> On Apr 20, 2014, at 1:46 PM, Marc MERLIN <marc@merlins.org> wrote:
>> 
>>> Can you help me design this right?
>>> 
>>> Long story short, I'm wondering if I can use btrfs send to copy sub
>>> subvolumes (by snapshotting a parent subvolume, and hopefully getting
>>> all the children underneath). My reading so far, says no.
>> 
>> That's my understanding thus far also. Seems like first a recursive read-only snapshot creation is a pre-requisite, since a read-only snapshot is needed first in order to send it.
>> 
>> I think the seed device method is a better way to do this, though I'm not sure what state its in.
> 
> Thank you both for the confirmation.
> 
> This indeed makes it too much of a pain for me, so I think I will go
> back to making hardlinks like I did with ext4
> That way I won't need subvolumes of subvolumes and will be able to do
> snapshots and replication more easily.

I see hard links as completely different to either subvolume/snapshot/reflink. Three hardlinks for a file all point to one file, they're aren't four unique files. But with the latter, three reflinks or snapshots are independent from the parent, including permissions/ACLs, and xattr including selinux labels.

Chris Murphy