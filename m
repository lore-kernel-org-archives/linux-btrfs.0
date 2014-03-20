Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58302 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759880AbaCTUTs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 16:19:48 -0400
Date: Thu, 20 Mar 2014 13:19:43 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: Jakub =?iso-8859-1?Q?Klinkovsk=FD?= <j.l.k@gmx.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub process prevents system suspend
Message-ID: <20140320201943.GD18959@merlins.org>
References: <20140320152131.GA1172@asusntb.lan> <532B0999.3060605@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <532B0999.3060605@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 20, 2014 at 11:30:33AM -0400, Josef Bacik wrote:
> Yeah there's a way to make suspend run commands while it goes down, 
> you'll want to make it do btrfs scrub cancel on your btrfs fses.  If you 
> search the archives you'll see we've covered this recently and the guy 
> posted the script he was using.  Thanks,

I've started putting some of the recent stuff I've written and found out in
blog posts so that google can index them more easily.

This one has my btrfs scrub script and sec.conf to catch errors that btrfs
reports to syslog that that most would miss:
http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair.html
(also explains the different data recovery strategy and why you don't really
need fsck)

Then this one deals specifically with cancelling btrfs scrubs before going
to sleep:
http://marc.merlins.org/perso/btrfs/post_2014-03-20_Btrfs-Tips_-ACPI-S3-Sleep-aka-Suspend-And-Btrfs-Scrub.html
My guess is that pause/resume might be enough, I just haven't spent the time
on doing that yet.

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
