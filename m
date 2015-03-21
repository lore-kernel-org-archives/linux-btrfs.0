Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43193 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbbCUDUn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 23:20:43 -0400
Received: from athena.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 2AA5BEB9E
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Mar 2015 14:20:41 +1100 (AEDT)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Subject: Re: syntax for deleting subvolumes?
Date: Sat, 21 Mar 2015 03:20:39 +0000
References: <5509E34F.6010504@graphitesystems.com> <550A08AC.7070506@graphitesystems.com> <m49y4mtfoai.fsf@coffee.modeemi.fi>
In-Reply-To: <m49y4mtfoai.fsf@coffee.modeemi.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201503210320.39413.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 19 Mar 2015 07:18:29 AM Erkki Seppala wrote:
> > But as a user level facility, I want to be able to snapshot before
> > making a change to a tree full of source code and (re)building it all
> > over again.  I may want to keep my new build, but I may want to flush
> > it and return to known good state.
> 
> You may want to check out cp --reflink=always (different from cp
> --link), which creates copy-on-write copy of the data. It isn't quite as
> fast as snapshots to create, but it's still plenty fast and without the
> downsides of subvolumes.

In which situations is --reflink=always expected to fail on BTRFS?

I recently needed to move /home on one system to a subvol (instead of being in 
the root subvol) and used cp --reflink=always which gave a few errors when 
running with BTRFS on kernel 3.16.7-ckt7-1.  I was in a hurry and didn't try 
to track down the caue, I just ran it again with --reflink=auto which gave no 
errors and completed very quickly (obviously the files which couldn't be 
reflinked were small).

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
