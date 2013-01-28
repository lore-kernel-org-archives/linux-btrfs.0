Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab3A1WDK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 17:03:10 -0500
Date: Mon, 28 Jan 2013 23:03:08 +0100
From: David Sterba <dsterba@suse.cz>
To: polack christian <baobab874@gmail.com>
Cc: mailing list linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck and ctree version
Message-ID: <20130128220308.GI16977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAC6BJd=gbiV+14yk=ghyUozp99Q6QCE6ip_FAp2WoPZTNYNVvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC6BJd=gbiV+14yk=ghyUozp99Q6QCE6ip_FAp2WoPZTNYNVvw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 03:07:13PM +0100, polack christian wrote:
> i did use btrfsck to recover it
> i got the tool from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> 
> and i got this error message:
> ...
> Check tree block failed, want=294555648, have=0
> Check tree block failed, want=294559744, have=0
> Check tree block failed, want=294559744, have=0
> btrfsck: ctree.c:1690: leaf_space_used: Assertion `!(data_len < 0)' failed.
> Aborted (core dumped)
> 
> looking at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git

but this is a kernel source repository, not progs, I wonder

> this error in ctree.c have been corrected by this commit
> 
> http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-next.git;a=commit;h=41be1f3b40b87de33cd2e7463dce88596dbdccc4

how this could happen. I have looked at the whether it does not silently
fix a bug, nothing wrong I can see now.  How did you verify that the
patch fixes the fsck problem?

david
