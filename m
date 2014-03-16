Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46123 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbaCPXRk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 19:17:40 -0400
Date: Sun, 16 Mar 2014 16:17:29 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20140316231729.GA29149@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>
Subject: Re: How to handle a RAID5 arrawy with a failing drive?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20140316222026.GU16946@merlins.org>
 <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>
 <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>

On Sun, Mar 16, 2014 at 05:12:10PM -0600, Chris Murphy wrote:
> 
> On Mar 16, 2014, at 4:55 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> > Then use btrfs replace start.
> 
> Looks like in 3.14rc6 replace isn't yet supported. I get "dev_replace cannot yet handle RAID5/RAID6".
> 
> When I do:
> btrfs device add <new> <mp>
> 
> The command hangs, no kernel messages.

Ok, that's kind of what I thought.
So, for now, with raid5:
- btrfs seems to handle a drive not working 
- you say I can mount with the drive missing in degraded mode (I haven't
  tried that, I will)
- but no matter how I remove the faulty drive, there is no rebuild on a
  new drive procedure that works yet

Correct?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
