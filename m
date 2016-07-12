Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbcGLQrH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 12:47:07 -0400
Date: Tue, 12 Jul 2016 18:47:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Hello world, python-btrfs
Message-ID: <20160712164715.GH10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <57647351.4010603@mendix.com>
 <20160623142648.GE4915@twin.jikos.cz>
 <d97ae16c-3348-9952-2416-acc60b5eb817@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d97ae16c-3348-9952-2416-acc60b5eb817@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 01:29:22AM +0200, Hans van Kranenburg wrote:
> > I can imagine creating scripts to
> > craft images for testing or verifying results of fsck, so it would be
> > more convenient to keep them in one place (but using a git submodule
> > instead would not be a big deal).
> 
> python-btrfs is just a library. You can just clone the git somewhere, 
> start hacking on it and put it in your python path, or pip install or 
> apt-get install python-btrfs etc...

So it sounds more appropriate to keep them separate.

> Programs that use it can be anywhere. What I have in examples/ now 
> should probably end up either in howto style documentation or in proper 
> tests for the lib (which requires keeping known-state filesystem images 
> to test on etc, exploding into a new level of whoa).
> 
> > I'm mostly interested in the object representation of the filesystem
> > objects and basic API around that, so if you have other plans with
> > python-btrfs, we can at least share some of the code. My python-fu is
> > not that strong so I'd rely on you or others to maintain that if you're
> > interested.
> 
> Ok, I added a little TODO:
> https://github.com/knorrie/python-btrfs/blob/master/TODO.md
> 
> There's a few things I want to do first at least, which are completing 
> to support the full set of data structures using the kernel API, 
> finishing to move existing code that I have lying around to use the new 
> lib and a bit of extra info to help interested sysadmin/programmers to 
> start using the library to peek around in their own filesystem a bit to 
> see what's going on.

So this will be mostly ioctl based.

> I haven't looked at how the btrfs-progs treat disks directly, but would 
> certainly be interested in learning about that.

The core work lies in the b-tree item manipulation, free block
allocation and maybe more.

>  From what you say, I feel that you're thinking about not only looking 
> around in filesystems, but having ways to manipulate them?

Yes. Initially it can be only in-place modification, like rewrite a
specific member of an item and recalculate the block checksum. We can do that
with btrfs-corrupt-block but the command line interface is not that great.

> Can you provide a more concrete example of "craft images for testing" or 
> related ideas about how this project could help during regular btrfs 
> development?

With a good support of python interface to btrfs structures, we can eg.
lookup specific extent items, swap some pointers and see how fsck
survives.  Writing that as a C code is possible, but IMO more tedious
compared to python.
