Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55071 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3KQPQW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Nov 2013 10:16:22 -0500
Date: Sun, 17 Nov 2013 07:16:18 -0800
From: Marc MERLIN <marc@merlins.org>
To: Russell Coker <russell@coker.com.au>, 1i5t5.duncan@cox.net
Cc: linux-btrfs@vger.kernel.org
Subject: Re: NMI from btrfs cron jobs in 3.11.6
Message-ID: <20131117151618.GG9725@merlins.org>
References: <201311140145.29255.russell@coker.com.au>
 <pan$4655$5629e47b$7d83e5a0$59910e71@cox.net>
 <201311180143.51552.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201311180143.51552.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 18, 2013 at 01:43:51AM +1100, Russell Coker wrote:
> On Thu, 14 Nov 2013, Duncan <1i5t5.duncan@cox.net> wrote:
> > > It appears that running two scripts that create snapshots at the same
> > > time as a script that removes maybe 97 snapshots causes an NMI.
> > 
> > This is a known bug in 3.11 (and presumably earlier).  Snapshot 
> > manipulation concurrency evidently wasn't originally well considered, and 

Not super important, but the bug does go farther back in time, I
reported it here too some time back (although didn't hear anything back
at the time).

But for me I had
/var/local/scr/btrfs_snaps: line 23: 26017 Segmentation fault      (core dumped) /sbin/btrfs subvolume
delete "$sub"
with details on the BT pasted in the mail:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/28770

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
