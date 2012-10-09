Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab2JIHUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 03:20:11 -0400
Date: Tue, 9 Oct 2012 08:20:02 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121009072002.GJ24071@rhmail.home.annexia.org>
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
 <20121008150419.GE4132@shiny>
 <20121008151513.GE24071@rhmail.home.annexia.org>
 <20121008212230.GA13692@rhmail.home.annexia.org>
 <20121009000051.GA12735@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121009000051.GA12735@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 08:00:51PM -0400, Chris Mason wrote:
> On Mon, Oct 08, 2012 at 03:22:30PM -0600, Richard W.M. Jones wrote:
> > 
> > I have now reproduced this bug locally.
> > 
> > Adding sync() + fsync of each /dev/sd* device after the mkfs command
> > does appear to fix the problem.
> > 
> > However it's a little bit difficult to know for sure because I might
> > just be changing the timing of things by adding these calls.
> 
> Ok, what's a rough idea of the mainline git equiv of the buggy kernel?

On my local machine, I'm reproducing this with what Fedora calls
3.7.0-0.rc0.git2.4.fc19.x86_64 (note I found an unrelated but very
serious bug in this kernel:
http://marc.info/?l=linux-kernel&m=134973394826408&w=2 )

In Fedora we apply several patches on top, but none of them
appear as if they would affect btrfs or sync/invalidate paths:

http://pkgs.fedoraproject.org/cgit/kernel.git/tree/

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
