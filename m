Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52835 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379Ab2JKL0a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 07:26:30 -0400
Date: Thu, 11 Oct 2012 07:26:28 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
CC: Chris Mason <clmason@fusionio.com>, David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121011112628.GE687@shiny>
References: <20121008212230.GA13692@rhmail.home.annexia.org>
 <20121009000051.GA12735@shiny>
 <20121009072002.GJ24071@rhmail.home.annexia.org>
 <20121009073357.GB13692@rhmail.home.annexia.org>
 <20121009090012.GJ4405@twin.jikos.cz>
 <20121010123808.GA31317@shiny>
 <20121010193853.GV24071@rhmail.home.annexia.org>
 <20121010194113.GA687@shiny>
 <20121010194641.GW24071@rhmail.home.annexia.org>
 <20121011072821.GA4605@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20121011072821.GA4605@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 11, 2012 at 01:28:21AM -0600, Richard W.M. Jones wrote:
> Well the bad news is that the bug happened again overnight, even
> though we were definitely using btrfs-progs with the 6eba90029 patch
> added, _and_ it was doing a sync + fsync between the mkfs and the
> mount.

This is good just because it makes the most sense.  The only thing worse
than a bug is a bug that disappears for the wrong reasons ;)

> 
> Here is the log:
> [   17.943272] btrfs bad tree block start 0 135168
> [   17.955270] btrfs: open_ctree failed

This is also good because it really points to the invalidate.  You've
got zeros where we wrote 135168, and pretty much the only way to get
zeros on a disk block is if the kernel did a memset.  Sure some app
could have written the zeros there, but that block offset is unlikely to
get allocated as a data block by the other filesystems.

So, I'll go back to the invalidate code ;)

-chris

