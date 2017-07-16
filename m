Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37318 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdGPQHE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Jul 2017 12:07:04 -0400
Date: Sun, 16 Jul 2017 09:06:58 -0700
From: Marc MERLIN <marc@merlins.org>
To: Giuseppe Della Bianca <giusdbg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20170716160658.r4uxuqlfe24hgi5n@merlins.org>
References: <20170715004828.f4bom5wq34abe4lz@merlins.org>
 <20170715012216.njq6az3y34qyomtb@merlins.org>
 <20170715231245.GA28281@merlins.org>
 <3161165.SzVyadSXaH@exnet.gdb.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3161165.SzVyadSXaH@exnet.gdb.it>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 16, 2017 at 04:01:53PM +0200, Giuseppe Della Bianca wrote:
> > On Fri, Jul 14, 2017 at 06:22:16PM -0700, Marc MERLIN wrote:
> > > Dear Chris and other developers,
> ]zac[
> > Others on this thread with the same error: did anyone recover from this
> > without wiping the filesystem?
> > 
> > Is there a chance a balance might work around the bug so that whatever
> > layout I have, changes, and stops the bug from occuring?
> ]zac[
> 
> Any attempt, even just delete files, has worsened the situation.
> I advise not to waste time in repairs, and directly recreate the filesystem.
 
I see. So, this is a condition where the filesystem is clear as far as:
- check 
- check lowmem
- scrub
are all concerned (at least in my case), but it's in a state where
touching something around a sensitive area causes the bug.
If so, this blows, and I'm not really wanting to recreate a clean 12TB
filesystem "just because", especially since this could just happen
again after I've rebuilt it.

>  while read proc; do
> 	 if [ $progResult == 0 ]; then
> 		 echo -e \nbtrfs tools already running
> 
> 		 progResult=222
> 	 fi
> 
> 	 echo $proc"
>  done < <(ps -ef | grep -e "btrfs \{1,\}\(subvolume\|send\|receive\|delete\)")

Yeah, I probably hit that. I think you can also add scrub to that list.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
