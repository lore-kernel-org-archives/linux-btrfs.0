Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34005 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaEaVyi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 17:54:38 -0400
Date: Sat, 31 May 2014 14:54:24 -0700
From: Marc MERLIN <marc@merlins.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140531215424.GG12384@merlins.org>
References: <pan.2014.05.20.15.30.48@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.05.20.15.30.48@googlemail.com>
Subject: Re: Better handling of stale scrub status
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 20, 2014 at 03:30:48PM +0000, Holger Hoffstätte wrote:
> As Marc Merlin recently wrote in his blog [1] scrub can sometimes leave a 
> stale state file behind, making cancel/resume complain. I took a peek at 
> the code and found most of the scrub state file handling fairly 
> straightforward, so before I go off and start hacking, what would a 
> better behaviour look like?
> 
> - delete the stale file?
> - fix the file by setting the "finished" flag?
> - something else entirely?

So while writing the workaround I was also indeed thinking we should
just fix the tool, I just haven't had time to look at it myself yet.

Basically once you have a way to confirm that indeed there is no scrub
running, I'd say the best is to set the finished flag, as if someone has
cancelled the scrub before shutting down the machine.

> I currently lean towards fixing (and not printing an error?), but maybe 
> someone else has different ideas about how this should be handled.
> Any suggestions welcome..

Yeah, it's a spurious error, auto fixing is the right solution.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
