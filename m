Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3AULpe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 06:45:34 -0500
Date: Mon, 21 Jan 2013 12:45:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Neil Schemenauer <neil@python.ca>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: scrub fails, any way to recover?
Message-ID: <20130121114531.GF19967@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130120155438.GA5111@python.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130120155438.GA5111@python.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 20, 2013 at 09:54:38AM -0600, Neil Schemenauer wrote:
> I have a ~350 GB Btrfs filesystem that is corrupted.  I think the
> damage was caused by a bad SATA cable.  I can mount the filesystem
> and read most of the data (I already have backups of most everything).
> 
> The scrub is aborted after a few seconds with the following error in
> the kernel log:
> 
>     parent transid verify failed on 795639808 wanted 102145 found 101462
>     parent transid verify failed on 795639808 wanted 102145 found 101462
>     verify_parent_transid: 16273 callbacks suppressed

the difference between 102145 and 101462 is small and looks like a bunch
lost writes (ie. not a random corruption), this supports the 'bad cable'
root cause.

>From '16273 callbacks suppressed', there is a large number of broken
b-tree connections.

So far the rescue operation is to run btrfs-restore and copy the data
out.

> I've tried btrfsck but it fails as well.  Is there some way I can
> remove the damaged data and save the good or is a re-format the only
> solution?

IIRC removing the damaged data hasn't been proposed yet, there was a
patch to ignore the failures in a read-only mount

https://patchwork.kernel.org/patch/913642/
(probably does not apply today)

I think that the -o recovery mode could be extended in a way that a
read-only + recovery would ignore the failures.

I see two ways how to fix the on-disk b-tree structure (via fsck):

1) wipe the broken blocks and unlink from b-tree -- but a broen node on
   high level would kill lots of data unpredictably

2) in some cases it would be possible to promote the old transids to the
   current ones (to satisfy the transid verify check), however there may
   be some blocks already overwritten so it only pushes the problem
   farther

Level of success depends on amount of data lost during the cable unplug
and whether data or metadata were affected. It's more likely to rescue
the filesystem if less metadata were affected.

david
