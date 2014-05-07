Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37601 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaEGI4U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 04:56:20 -0400
Date: Wed, 7 May 2014 01:56:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does Suse do live filesystem revert with btrfs?
Message-ID: <20140507085612.GB19238@merlins.org>
References: <20140504005257.GF9061@merlins.org>
 <20140504232645.GQ9061@merlins.org>
 <20140505003639.GO24298@carfax.org.uk>
 <20140505050459.GF10159@merlins.org>
 <pan$4eac3$a2d76a4$a81e0fed$b4b18c9e@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$4eac3$a2d76a4$a81e0fed$b4b18c9e@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 06, 2014 at 04:26:48PM +0000, Duncan wrote:
> Marc MERLIN posted on Sun, 04 May 2014 22:04:59 -0700 as excerpted:
> 
> > On Mon, May 05, 2014 at 01:36:39AM +0100, Hugo Mills wrote:
> >>    I'm guessing it involves reflink copies of files from the snapshot
> >> back to the "original", and then restarting affected services. That's
> >> about the only other thing that I can think of, but it's got load of
> >> race conditions in it (albeit difficult to hit in most cases, I
> >> suspect).
> > 
> > Aaah, right, you can use a script to see the file differences between
> > two snapshots, and then restore that with reflink if you can truly get a
> > list of all changed files.
> > However, that is indeed not atomic at all, even if faster than rsync.
> 
> Would send/receive help in such a script?

Not really, you still end up with a new snapshot that you can't live
switch to.

It's really either
1) reboot
2) use cp --reflink to copy a list of changed files (as well as rm to
delete the ones that were removed).

I'm currently using btrfs-diff (below) which shows changed files but it
doesn't show files deleted.

Is there something better that would show me which files changed and how
between 2 snapshots?

btrfs-diff:
-------------------------------------------------------------
#!/bin/bash

usage() { echo $@ >2; echo "Usage: $0 <older-snapshot> <newer-snapshot>" >2; exit 1; }

[ $# -eq 2 ] || usage "Incorrect invocation";
SNAPSHOT_OLD=$1;
SNAPSHOT_NEW=$2;

[ -d $SNAPSHOT_OLD ] || usage "$SNAPSHOT_OLD does not exist";
[ -d $SNAPSHOT_NEW ] || usage "$SNAPSHOT_NEW does not exist";

OLD_TRANSID=`btrfs subvolume find-new "$SNAPSHOT_OLD" 9999999`
OLD_TRANSID=${OLD_TRANSID#transid marker was }
[ -n "$OLD_TRANSID" -a "$OLD_TRANSID" -gt 0 ] || usage "Failed to find generation for $SNAPSHOT_NEW"

btrfs subvolume find-new "$SNAPSHOT_NEW" $OLD_TRANSID | sed '$d' | cut -f17- -d' ' | sort | uniq
-------------------------------------------------------------

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
