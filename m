Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3K1RK3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 12:10:29 -0500
Date: Thu, 28 Nov 2013 18:10:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: Russell Coker <russell@coker.com.au>, 1i5t5.duncan@cox.net,
        linux-btrfs@vger.kernel.org
Subject: Re: NMI from btrfs cron jobs in 3.11.6
Message-ID: <20131128171025.GJ25312@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201311140145.29255.russell@coker.com.au>
 <pan$4655$5629e47b$7d83e5a0$59910e71@cox.net>
 <201311180143.51552.russell@coker.com.au>
 <20131117151618.GG9725@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131117151618.GG9725@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 17, 2013 at 07:16:18AM -0800, Marc MERLIN wrote:
> On Mon, Nov 18, 2013 at 01:43:51AM +1100, Russell Coker wrote:
> > On Thu, 14 Nov 2013, Duncan <1i5t5.duncan@cox.net> wrote:
> > > > It appears that running two scripts that create snapshots at the same
> > > > time as a script that removes maybe 97 snapshots causes an NMI.
> > > 
> > > This is a known bug in 3.11 (and presumably earlier).  Snapshot 
> > > manipulation concurrency evidently wasn't originally well considered, and 
> 
> Not super important, but the bug does go farther back in time, I
> reported it here too some time back (although didn't hear anything back
> at the time).
> 
> But for me I had
> /var/local/scr/btrfs_snaps: line 23: 26017 Segmentation fault      (core dumped) /sbin/btrfs subvolume
> delete "$sub"
> with details on the BT pasted in the mail:
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/28770

Kernel 3.2.5

IIRC there was a fix or two regarding concurrency during snapshot
creation and deletion, roughly matching the kernel 3.2 times.

david
