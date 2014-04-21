Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41194 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaDUFsg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 01:48:36 -0400
Date: Sun, 20 Apr 2014 22:48:29 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20140421054829.GT7884@merlins.org>
References: <20140420194627.GO7884@merlins.org>
 <5B1404BF-F985-4201-87FD-CBB3E6776531@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5B1404BF-F985-4201-87FD-CBB3E6776531@colorremedies.com>
Subject: Re: Planning for subvolumes of subvolumes and btrfs send/receive
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 20, 2014 at 11:39:22PM -0600, Chris Murphy wrote:
> 
> On Apr 20, 2014, at 1:46 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
> > Can you help me design this right?
> > 
> > Long story short, I'm wondering if I can use btrfs send to copy sub
> > subvolumes (by snapshotting a parent subvolume, and hopefully getting
> > all the children underneath). My reading so far, says no.
> 
> That's my understanding thus far also. Seems like first a recursive read-only snapshot creation is a pre-requisite, since a read-only snapshot is needed first in order to send it.
> 
> I think the seed device method is a better way to do this, though I'm not sure what state its in.

Thank you both for the confirmation.

This indeed makes it too much of a pain for me, so I think I will go
back to making hardlinks like I did with ext4
That way I won't need subvolumes of subvolumes and will be able to do
snapshots and replication more easily.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
