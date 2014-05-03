Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56826 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaECN5H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 May 2014 09:57:07 -0400
Date: Sat, 3 May 2014 06:57:05 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "csum failed" that was not detected by scrub
Message-ID: <20140503135705.GH15326@merlins.org>
References: <CAOwjQU4GP5PjdPZx8HPihS7GQOA74M+DexwMWoh1FOQP0tCTcw@mail.gmail.com> <pan$ba09e$4b80fc30$5f891c70$5774c32f@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$ba09e$4b80fc30$5f891c70$5774c32f@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 02, 2014 at 10:20:03AM +0000, Duncan wrote:
> The raid5/6 page (which I didn't otherwise see conveniently linked, I dug 

It's linked off
https://btrfs.wiki.kernel.org/index.php/FAQ#Can_I_use_RAID.5B56.5D_on_my_Btrfs_filesystem.3F

> it out of the recent changes list since I knew it was there from on-list 
> discussion):
> 
> https://btrfs.wiki.kernel.org/index.php/RAID56
> 
> 
> @ Marc or Hugo or someone with a wiki account:  Can this be more visibly 

@ Marc relies on a lot for me to see this, never mind at the bottom of a
message when my inbox is over 900 and I'm boarding a plane in a few hours ;)

More seriously, please Cc me (and I'd say generally others) if you're trying
to get their attention. I typically also put one liner at the top to tell
the Cced person to look for a bit with their name.

> linked from the user-docs contents, added to the user docs category list, 
> and probably linked from at least the multiple devices and (for now) the 
> gotchas pages?

I added it here
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices
note that it's first result on google for raid56.
Also raid5 btrfs brings you to
https://btrfs.wiki.kernel.org/index.php/FAQ#Case_study:_btrfs-raid_5.2F6_versus_MD-RAID_5.2F6
which also links to the raid56 page.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
