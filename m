Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34134 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab3IIRNb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Sep 2013 13:13:31 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id ED89C9A040D
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Sep 2013 11:13:30 -0600 (MDT)
Date: Mon, 9 Sep 2013 13:13:28 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <dsterba@suse.cz>, Josef Bacik <jbacik@fusionio.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: add make test framework
Message-ID: <20130909171328.GA2446@localhost.localdomain>
References: <1378493456-5382-1-git-send-email-jbacik@fusionio.com>
 <20130909163204.GR32382@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130909163204.GR32382@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 09, 2013 at 06:32:04PM +0200, David Sterba wrote:
> On Fri, Sep 06, 2013 at 02:50:56PM -0400, Josef Bacik wrote:
> > We need to start adding some sanity tests to btrfs-progs to make sure we aren't
> > breaking things with our patches.  The most important of these tools is btrfsck.
> > This patch gets things started by adding a basic btrfsck test that makes sure we
> > can fix a corruption problem we know we can fix.  Thanks,
> 
> That's great. I hope we're going to gather more tests so let's separate
> them to more categories from the beginning (mkfs, options coverage,
> corrupt-block, restore maybe, dunno what else).
> 
> This makes it possible to do a quick run a subset of the tests (eg. mkfs
> related) after a fix is committed.
> 
> >  tests/bad-file-extent-bytenr.img |  Bin 0 -> 4096 bytes
> >  tests/fsck-tests.sh              |   34 ++++++++++++++++++++++++++++++++++
> 
> I suggest to put them into a subdirectory (eg.) 'fsck' and prefix the
> images with numbers (just a sequence number).

I'm not prefixing with numbers, I want to make it easy to tell what each image
is testing for.  I will move them into a fsck directory tho.

> 
> > --- /dev/null
> > +++ b/tests/fsck-tests.sh
> > @@ -0,0 +1,34 @@
> > +#!/bin/bash
> > +#
> > +# loop through all of our bad images and make sure fsck repairs them properly
> > +#
> > +# It's GPL, same as everything else in this tree.
> > +#
> > +
> > +TEST_DEV=""
> 
> I found the current test hard to use, eg. I can't just do 'make test'
> from the toplevel dir. The script fsck-tests.sh expects TEST_DEV to be
> set, but there's no way to do that, because it's set unconditionally to
> empty string.

Yeah I wasn't sure how I wanted to do this.  At first I thought about making the
fsck tester just make a loop device, but I didn't want to override something if
people were already using a loop device.  But maybe I'll just default to using
loop5 or something big like that and then if the user wants to change it they
can go into the script and change it themselves.  How does that sound?  Thanks,

Josef
