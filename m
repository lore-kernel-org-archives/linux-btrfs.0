Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41589 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaCYA2g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 20:28:36 -0400
Date: Mon, 24 Mar 2014 17:28:35 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Cannot add device "is mounted" for unmounted drive that used to be in raidset that is mounted
Message-ID: <20140325002835.GE11533@merlins.org>
References: <20140323180907.GA22171@merlins.org> <20140323185816.GA3732@merlins.org> <pan$22ecd$ee1c4b0f$48d0cc59$d02dd1ad@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$22ecd$ee1c4b0f$48d0cc59$d02dd1ad@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 24, 2014 at 07:19:14PM +0000, Duncan wrote:
> Marc MERLIN posted on Sun, 23 Mar 2014 11:58:16 -0700 as excerpted:
> 
> > On Sun, Mar 23, 2014 at 11:09:07AM -0700, Marc MERLIN wrote:
> >> I found out that a drive that used to be part of a raid system that is
> >> mounted and running without it, btrfs apparently decides that the drive
> >> is part of the mounted raidset and in use.
> >> As a result, I had to eventually dd 0's over it, btrfs device scan, and
> >> finally I was able to use it again.
> > 
> > I filed a bug for this, it's a bit more minor, but worth fixing
> > eventually https://bugzilla.kernel.org/show_bug.cgi?id=72771
> 
> The reason for this is the device-scanning that btrfs does, detecting 
> btrfs superblocks in ordered to assemble filesystems from multiple 
> devices, etc.

Yep, and thanks for reminding me of wipefs.
However this was still a bug to say that a device was mounted when it sure
wasn't :)

I'm ok using -f because I didn't use wipefs, but being told "no you can't
reformat this because it's mounted", spending too long looking what in the
kernel would make it think so, and then realizing the check is wrong, isn't
as user friendly :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
