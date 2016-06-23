Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbcFWO0Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 10:26:25 -0400
Date: Thu, 23 Jun 2016 16:26:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Hello world, python-btrfs
Message-ID: <20160623142648.GE4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <57647351.4010603@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <57647351.4010603@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 18, 2016 at 12:01:53AM +0200, Hans van Kranenburg wrote:
> proof-of-concept level scripts to be able to debug my btrfs file
> systems, the inevitable happened:
> 
> https://github.com/knorrie/python-btrfs/
> 
> Currently, the primary goal of this module is to be able to inspect the
> internals of an existing filesystem for educational purposes.

Looks great, I like. Python is better language for prototyping various
things, also more convenient to write one-shot scripts to do specific
rescue tasks.

> The python module acts as a wrapper around the low level kernel calls
> and btrfs data structures, presenting them as python objects with
> interesting attributes and references to other objects.

I guess it could be extended to read the filesystem objects directly
from the image, so it's not only built around the search ioctl.

> Why?!
> 
> * Because it's fun!

Best reason ever!

> * Because I get sick of using horrible ducttape regex solutions to
> programmatically parse human readable output of external tools to
> implement monitoring tools~~!11one.
> * Because I might to be able to help other people that also want to
> learn the internals of btrfs.
> * Much more...
> 
> How?
> 
> * It's a python library, so the code will have a decent level of
> pythonicity. The ioctl search returns a generator, the search key is a
> nice object you can just increment etc...
> * This is a work in progress. I can only add support for parts of btrfs
> that I understand myself first.

My question is whether it sounds like a good idea to host the python
bindings inside btrfs-progs or not. I can imagine creating scripts to
craft images for testing or verifying results of fsck, so it would be
more convenient to keep them in one place (but using a git submodule
instead would not be a big deal).

I'm mostly interested in the object representation of the filesystem
objects and basic API around that, so if you have other plans with
python-btrfs, we can at least share some of the code. My python-fu is
not that strong so I'd rely on you or others to maintain that if you're
interested.
