Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab3IIXbp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 19:31:45 -0400
Date: Tue, 10 Sep 2013 01:31:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Eric Sandeen <sandeen@redhat.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add make test framework
Message-ID: <20130909233142.GV32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1378493456-5382-1-git-send-email-jbacik@fusionio.com>
 <20130909163204.GR32382@twin.jikos.cz>
 <20130909171328.GA2446@localhost.localdomain>
 <522E1C7F.1010905@redhat.com>
 <20130909195717.GB2446@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130909195717.GB2446@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 09, 2013 at 03:57:17PM -0400, Josef Bacik wrote:
> On Mon, Sep 09, 2013 at 02:07:43PM -0500, Eric Sandeen wrote:
> > On 9/9/13 12:13 PM, Josef Bacik wrote:
> > David might have meant "001-bad-file-extent-bytenr.img" though.
> Oh yeah that may be good then.

Yes that's what I meant. I thought the number could be useful as a
shortcut additional to the human-readable part.

> > > Yeah I wasn't sure how I wanted to do this.  At first I thought about making the
> > > fsck tester just make a loop device, but I didn't want to override something if
> > > people were already using a loop device.  But maybe I'll just default to using
> > > loop5 or something big like that and then if the user wants to change it they
> > > can go into the script and change it themselves.  How does that sound?  Thanks,
> > 
> > Dumb question, can you just point btrfsck at the image itself w/o setting up
> > loopback?  i.e. do something like: 
> > 
> > # btrfs-image -r 001-bad-file-extent-bytenr.img test.img
> > # btrfsck --repair test.img
> 
> Huh, I'm not sure...yes it looks like it, well that solves that problem.
> Thanks,

If you need a blockdevice, you can use

$ losetup -f /the/file
(get a free loopdev)

$ losetup -j /the/file
/dev/loop2: ...

and parse the loop name from the output.
