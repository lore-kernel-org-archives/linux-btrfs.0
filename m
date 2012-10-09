Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab2JIHeC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 03:34:02 -0400
Date: Tue, 9 Oct 2012 08:33:57 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121009073357.GB13692@rhmail.home.annexia.org>
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
 <20121008150419.GE4132@shiny>
 <20121008151513.GE24071@rhmail.home.annexia.org>
 <20121008212230.GA13692@rhmail.home.annexia.org>
 <20121009000051.GA12735@shiny>
 <20121009072002.GJ24071@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121009072002.GJ24071@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 09, 2012 at 08:20:02AM +0100, Richard W.M. Jones wrote:
> On Mon, Oct 08, 2012 at 08:00:51PM -0400, Chris Mason wrote:
> > On Mon, Oct 08, 2012 at 03:22:30PM -0600, Richard W.M. Jones wrote:
> > > 
> > > I have now reproduced this bug locally.
> > > 
> > > Adding sync() + fsync of each /dev/sd* device after the mkfs command
> > > does appear to fix the problem.
> > > 
> > > However it's a little bit difficult to know for sure because I might
> > > just be changing the timing of things by adding these calls.
> > 
> > Ok, what's a rough idea of the mainline git equiv of the buggy kernel?
> 
> On my local machine, I'm reproducing this with what Fedora calls
> 3.7.0-0.rc0.git2.4.fc19.x86_64

OK, that's not very helpful is it :-)  AFAIK it should be possible
to reproduce this with Linus's git kernel, but I haven't proven
that yet.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://et.redhat.com/~rjones/virt-df/
