Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33839 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaCUF5e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Mar 2014 01:57:34 -0400
Date: Thu, 20 Mar 2014 22:57:33 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Understanding btrfs and backups => automatic snapshot script
Message-ID: <20140321055733.GC28005@merlins.org>
References: <loom.20140306T191655-366@post.gmane.org> <pan$ee422$4703cdfd$58fec22b$1a891275@cox.net> <20140317054224.GD6143@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140317054224.GD6143@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 16, 2014 at 10:42:24PM -0700, Marc MERLIN wrote:
> On Thu, Mar 06, 2014 at 09:33:24PM +0000, Duncan wrote:
> > However, best snapshot management practice does progressive snapshot 
> > thinning, so you never have more than a few hundred snapshots to manage 
> > at once.  Think of it this way.  If you realize you deleted something you 
> > needed yesterday, you might well remember about when you deleted it and 
> > can thus pick the correct snapshot to mount and copy it back from.  But 
> > if you don't realize you need it until a year later, say when you're 
> > doing your taxes, how likely are you to remember the specific hour, or 
> > even the specific day, you deleted it?  A year later, getting a copy from 
> > the correct week, or perhaps the correct month, will probably suffice, 
> > and even if you DID still have every single hour's snapshots a year 
> > later, how would you ever know which one to pick?  So while a day out, 
> > hourly snapshots are nice, a year out, they're just noise.
> 
> I'm happy to share my script with others if that helps:
> http://marc.merlins.org/linux/scripts/btrfs-snaps

Now added to
http://marc.merlins.org/perso/btrfs/post_2014-03-21_Btrfs-Tips_-How-To-Setup-Netapp-Style-Snapshots.html
(mostly to seed google and the archives)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
