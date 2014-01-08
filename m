Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43719 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaAHDXH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2014 22:23:07 -0500
Date: Tue, 7 Jan 2014 19:22:58 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>, Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org, Jim Salter <jim@jrs-s.net>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Message-ID: <20140108032258.GT10936@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140105134425.22063890@ws>
 <8EE40903-FE21-4516-B2D8-4EB8DCE79376@colorremedies.com>
 <pan$6ce5a$53830c0$382c1e0e$7169217c@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 03, 2014 at 09:34:10PM +0000, Duncan wrote:
> IIRC someone also mentioned problems with autodefrag and an about 3/4 gig 
> systemd journal.  My gut feeling (IOW, *NOT* benchmarked!) is that double-
> digit MiB files should /normally/ be fine, but somewhere in the lower 
> triple digits, write-magnification could well become an issue, depending 
> of course on exactly how much active writing the app is doing into the 
> file.
 
When I defrag'ed my 83GB vm file with 156222 extents, it was not in use
or being written to.

> As I said there's more work going into tuning autodefrag ATM, but as it 
> is, I couldn't really recommend making it a global default... tho maybe a 
> distro could enable it by default on a no-VM desktop system (as opposed 
> to a server).  Certainly I'd recommend most desktop types enable it.

I use VMs on my desktop :) but point taken.

On Sun, Jan 05, 2014 at 10:09:38AM -0700, Chris Murphy wrote:
> > gandalfthegreat:/var/local/nobck/VirtualBox VMs/Win7# filefrag Win7.vdi 
> > Win7.vdi: 156222 extents found
> > 
> > Considering how virtualbox works, that's hardly surprising.
> 
> I haven't read anything so far indicating defrag applies to the VM container use case, rather nodatacow via xattr +C is the way to go. At least for now.
 
Yep, I'll convert the file, but since I found a pretty severe
performance problem, does anyone care to get details off my system
before I make the problem go away for me?

> It's better than a panic or corrupt data. So far the best combination

To be honest, I'd have taken a panic, it would have saved me 2H of
waiting for a laptop to recover when it was never going to recover :(
Data corruption, sure, obviously :)

> I've found, open to other suggestions though, is +C xattr on

So you're saying that defragmentation has known performance problems
that can't get fixed for now, and that the solution is not to get
fragmented or recreate the relevant files.
If so, I'll go ahead, I just wanted to make sure I didn't have useful
debug state before clearing my problem.

> This may already be a known problem but it's worth sysrq+w, and then dmesg and posting those results if you haven't already.

No, I had not yet, but I'll do this.

On Sun, Jan 05, 2014 at 01:44:25PM -0700, Duncan wrote:
> [I normally try to reply directly to list but don't believe I've seen
> this there yet, but got it direct-mailed so will reply-all in response.]
 
I like direct Cc on replies, makes my filter and mutt coloring happier
:)
Dupes with the same message-id are what procmail and others were written
for :)

> I now believe the lockup must be due to processing the hundreds of
> thousands of extents on all those snapshots, too, in addition to doing

That's a good call. I do have this:
gandalfthegreat:/mnt/btrfs_pool1# ls var
var/                          var_hourly_20140105_16:00:01/
var_daily_20140102_00:01:01/  var_hourly_20140105_17:00:26/
var_daily_20140103_00:59:28/  var_weekly_20131208_00:02:02/
var_daily_20140104_00:01:01/  var_weekly_20131215_00:02:01/
var_daily_20140105_00:33:14/  var_weekly_20131229_00:02:02/
var_hourly_20140105_05:00:01/ var_weekly_20140105_00:33:14/

> it on the main volume.  I don't actually make very extensive use of
> snapshots here anyway, so I didn't think about that aspect originally,
> but that's gotta be what's throwing the real spanner in the works,
> turning a possibly long but workable normal defrag (O(1)) into a lockup
> scenario (O(n)) where virtually no progress is made as currently
> coded.

That is indeed what I'm seeing, so it's very possible you're right.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
