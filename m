Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38655 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaHMOv4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 10:51:56 -0400
Date: Wed, 13 Aug 2014 07:51:55 -0700
From: Marc MERLIN <marc@merlins.org>
To: Rasmus Abrahamsen <me@rasmusa.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: delete missing /dev/sdd which is now added as /dev/sdd1
Message-ID: <20140813145155.GA20611@merlins.org>
References: <53EAF935.4040605@rasmusa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53EAF935.4040605@rasmusa.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 13, 2014 at 07:35:49AM +0200, Rasmus Abrahamsen wrote:
> I added the /dev/sdd1 to my raid and deleted the missing. Now the
> /dev/sdd does not show up anymore and I have a /dev/sdd1. But I still
> have the **** Some devices missing and the command btrfs delete missing
> /mnt does not actually do anything. I tried btrfs delete /dev/sdd /mnt
> but it said that /dev/sdd was busy.

Have you tried
btrfs device delete missing /mnt/mountpoint ?
 
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
