Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42358 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaGDPHV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 11:07:21 -0400
Date: Fri, 4 Jul 2014 08:07:10 -0700
From: Marc MERLIN <marc@merlins.org>
To: Russell Coker <russell@coker.com.au>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Message-ID: <20140704150710.GM26932@merlins.org>
References: <20140704011938.GO11539@merlins.org>
 <53B6486D.9010006@jp.fujitsu.com>
 <20140704142416.GI26932@merlins.org>
 <3262371.bchVJ2xl3c@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3262371.bchVJ2xl3c@xev>
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 05, 2014 at 12:45:55AM +1000, Russell Coker wrote:
> > But the last times I had this OOM problem with 3.15.1 it was happening
> > within 6 hours sometimes, and I was not starting scrub every time the
> > system booted, so scrub may be partially responsible but it's not the
> > core problem.
> 
> It would be a good idea to run a few scrubs and see if this is a repeatable 
> problem.  If it's a repeatable problem then it's something to fix regardless 
> of whether it's the only issue you have.

Fair point. Re-running scrub now. That will take 36H or so :)
 
> If a scrub can reliably trigger the problem it would be good to test 3.14 for 
> the same behavior.  Knowing whether it's a regression would help the 
> developers.
 
I'm already back to 3.14. 3.15 was dying about once a day without scrub,
enough that this was causing me real problems (it's a server that is
supposed to do work :) ).

> Even without much swap 8G should be a plenty.  My main workstation has 4G of 
> RAM and 6G of swap.  I almost never use more than 3G of swap because the 
> system becomes so slow as to be almost unusable when swap gets to 4G (Chromium 
> is to blame).  However that is for a 120G non-RAID filesystem.  Presumably a 
> RAID array will need some more kernel memory and a larger filesystem will also 
> need a little more, but it still shouldn't be that much.

You're correct. I only have more swap than ram, both as a habit in case
I ever want to hibernate a system (I don't with this one) and in case
some userland stuff leaks a lot (I've had versions of Xorg leak and that
would improve the time between which I had to restart X and lose all my
window state :) ).

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
