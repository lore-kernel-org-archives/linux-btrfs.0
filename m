Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34550 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaJAFDw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Oct 2014 01:03:52 -0400
Date: Tue, 30 Sep 2014 22:03:39 -0700
From: Marc MERLIN <marc@merlins.org>
To: Elliot Wolk <elliot.wolk@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20141001050339.GL26729@merlins.org>
References: <20140927201941.GL26729@merlins.org>
 <loom.20140930T202206-887@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20140930T202206-887@post.gmane.org>
Subject: Re: 3.16.3 btrfs receive dies with rename o4736059-335172-0 ->
 merlin/RC/OSD failed. Directory not empty machine
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 30, 2014 at 06:24:24PM +0000, Elliot Wolk wrote:
> > After I moved directories around, and since then my hourly 
> > btrfs backup is failing.
> > ...
> > ERROR: rename o4736059-335172-0 -> merlin/RC/OSD failed. Directory not empty
> > 
> 
> i have the exact same problem, also 3.16-3. i did something along these lines:
> mv Music/2/VideoGamesLive Music/2/VolumeOne
> mkdir Music/2/VideoGamesLive
> mv Music/2/VolumeOne Music/2/VideoGamesLive
> 
> and got:
> ERROR: rename o3854555-52412-0 -> Music/2/VideoGamesLive failed. Directory
> not empty

I worked around it by moving the directory up one level, getting that
sync, and then moving it back to where I wanted it to be.
As expected, that worked.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
