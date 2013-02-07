Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57258 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499Ab3BGQEr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2013 11:04:47 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1E1B29A04E0
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Feb 2013 09:04:47 -0700 (MST)
Date: Thu, 7 Feb 2013 11:04:44 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: "dsterba@suse.cz" <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: [PATCH 2/2, RFC] btrfs-progs: overhaul mkfs.btrfs -r option
Message-ID: <20130207160444.GD14518@shiny>
References: <510831DC.4070709@redhat.com>
 <510833E4.6080609@redhat.com>
 <20130207000812.GE12339@twin.jikos.cz>
 <5113CDCB.7010802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5113CDCB.7010802@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 08:52:43AM -0700, Eric Sandeen wrote:
> On 2/6/13 6:08 PM, David Sterba wrote:
> > On Tue, Jan 29, 2013 at 02:41:08PM -0600, Eric Sandeen wrote:
> >> The manpage for the "-r" option simply says that
> >> it will copy the path specified to -r into the newly
> >> made filesystem.
> >>
> >> There's not a lot of reason to treat that option as differently
> >> as it is now - today it ignores discard, fs size, and mixed
> >> options, for example.  It also failed to check whether the
> >> target device was mounted before proceeding.  Etc...
> >>
> >> Rework things so that we really follow the same paths whether
> >> or not -r is specified, but with one special case for -r:
> >>
> >> * If the device does not exist, it will be created as
> >>   a regular file of the minimum size to hold the -r path,
> >>   or of size specified by the -b option.
> >>
> >> This also changes a little behavior; it does not pre-fill
> >> the new file with zeros, but allows it to be sparse, and does
> >> not truncate an existing device file.  If you want to start
> >> with an empty file, just don't point it at an existing
> >> file...
> > 
> > Fixes numerous bugs and I find the changes in behaviour sane and
> > reasonable. A quick test failed for me when the image file does not
> > exist:
> > 
> > $ rm image
> > $ ./mkfs.btrfs -r . image
> > ...
> > not enough free space
> > add_file_items failed
> > unable to traverse_directory
> > Making image is aborted.
> > ret = -1
> > mkfs.btrfs: mkfs.c:1533: main: Assertion `!(ret)' failed.
> > 
> > seems that the estimated size is not sufficient.
> 
> ho hum, thanks for checking.  I guess I only tried it on a very small
> source directory.  For now, figuring out btrfs space usage for a given
> set of files is above my pay grade and experience, I'm afraid.  :(

We should probably make a way to compact a given FS down to minimal
size.  Then we don't have to worry about size estimates at all.

In other words, two passes instead of one.

-chris
