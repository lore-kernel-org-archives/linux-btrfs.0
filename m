Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab2J2Oww (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 10:52:52 -0400
Date: Mon, 29 Oct 2012 14:52:45 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121029145245.GA3346@rhmail.home.annexia.org>
References: <20121009000051.GA12735@shiny>
 <20121009072002.GJ24071@rhmail.home.annexia.org>
 <20121009073357.GB13692@rhmail.home.annexia.org>
 <20121009090012.GJ4405@twin.jikos.cz>
 <20121010123808.GA31317@shiny>
 <20121010193853.GV24071@rhmail.home.annexia.org>
 <20121010194113.GA687@shiny>
 <20121010194641.GW24071@rhmail.home.annexia.org>
 <20121011072821.GA4605@rhmail.home.annexia.org>
 <20121011112628.GE687@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121011112628.GE687@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 11, 2012 at 07:26:28AM -0400, Chris Mason wrote:
> On Thu, Oct 11, 2012 at 01:28:21AM -0600, Richard W.M. Jones wrote:
> > Well the bad news is that the bug happened again overnight, even
> > though we were definitely using btrfs-progs with the 6eba90029 patch
> > added, _and_ it was doing a sync + fsync between the mkfs and the
> > mount.
> 
> This is good just because it makes the most sense.  The only thing worse
> than a bug is a bug that disappears for the wrong reasons ;)
> 
> > 
> > Here is the log:
> > [   17.943272] btrfs bad tree block start 0 135168
> > [   17.955270] btrfs: open_ctree failed
> 
> This is also good because it really points to the invalidate.  You've
> got zeros where we wrote 135168, and pretty much the only way to get
> zeros on a disk block is if the kernel did a memset.  Sure some app
> could have written the zeros there, but that block offset is unlikely to
> get allocated as a data block by the other filesystems.
> 
> So, I'll go back to the invalidate code ;)

Any luck on this?  It's still happening in the latest kernels.  If
there's anything / patch you want me to try, let me know.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming blog: http://rwmj.wordpress.com
Fedora now supports 80 OCaml packages (the OPEN alternative to F#)
http://cocan.org/getting_started_with_ocaml_on_red_hat_and_fedora
