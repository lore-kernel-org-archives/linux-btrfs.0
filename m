Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60471 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaEIOGJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 10:06:09 -0400
Date: Fri, 9 May 2014 07:06:03 -0700
From: Marc MERLIN <marc@merlins.org>
To: David Pottage <david@chrestomanci.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs snapshot sizes
Message-ID: <20140509140602.GV11401@merlins.org>
References: <20140507111949.GT10159@merlins.org>
 <536C86DE.9090003@chrestomanci.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <536C86DE.9090003@chrestomanci.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 08:42:22AM +0100, David Pottage wrote:
> On 07/05/14 12:19, Marc MERLIN wrote:
> >So have others found a good way to have an idea about how much space is
> >taken by each snapshot?
> >
> >I've tried quota trees, but I'm not sure how to read the output, or if it's
> >correct (including the negative numbers some have mentioned). Are there
> >other options?
> >
> >I think the main problem is that the shared data field is not working,
> >making it harder to know which blocks are only used in a given snapshot.
> 
> In my understanding (devs please correct me if I am wrong), a
> snapshot is just a subvolume that happens to share a lot of data
> with another subvolume. The idea of taking regular snapshots to

Yes.

> This means that suppose you have a subvolume representing your home
> directory that contains around 1Gb of data, and then take daily
> snapshots, asking the kernel how big each snapshot is will not give
> the answer you expect. They all contain roughly 1Gb.
 
Actually want I'm looking for is the size diff compared to the reference
volume they're snapshotted against.

> The question you should be asking, is to compare two subvolumes. (eg
> the current /home and a snapshot taken of it last week), and ask how

Both comparing snapshots against one another in size difference (unique
blocks they don't share) would be useful too.

> The thing is, I don't think there is an easy way to get a report of
> the amount of non shared data without walking the file-systems in
> both subvolumes and building a large data structure of inodes or
> suchlike.

http://bj0z.wordpress.com/2011/04/27/determining-snapshot-size-in-btrfs/
was supposed to do it, but it's not compatible with recent btrfs-tools
anymore.
 
> Measuring the size of snapshots will get even more thorny when you
> take many snapshots. For example suppose you take one every hour,
> and you have just deleted a large file. All your old hourly
> snapshots will contain a reference to that large file, but the data

Yes, I'm very aware of that :)
But showing the size of each compared to the base volume would quickly
show that they are all more than 1GB different and clue me in.

If we could get that code fixed (hint, it needs
http://bj0z.wordpress.com/2011/04/22/fiemap-ioctl-from-python/ ), I
think it'd be in good shape.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
