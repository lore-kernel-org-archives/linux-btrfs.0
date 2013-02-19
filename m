Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700Ab3BSKLa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 05:11:30 -0500
Date: Tue, 19 Feb 2013 11:11:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Brandenburger <filbranden@google.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Integration branch of btrfs-progs 2013-02
Message-ID: <20130219101128.GT12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130212231526.GE12339@twin.jikos.cz>
 <CADU+-uC64KQPys9K3yC3PG11LLCqQtSsRYDAPvKzcwsCn6MoVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADU+-uC64KQPys9K3yC3PG11LLCqQtSsRYDAPvKzcwsCn6MoVQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 12, 2013 at 07:35:31PM -0800, Filipe Brandenburger wrote:
> I really have concerns about the libification, in particular this commit:
> 
> 6fc8b21 btrfs-progs: libify some parts of btrfs-progs
[...]
> I really don't think that all those headers should be exposed to the userspace.
> 
> I think, to do it right, there should be a single or a few header
> files, like /usr/include/btrfs.h or /usr/include/libbtrfs.h or
> /usr/include/btrfs/xyz.h, that export only the parts that are really
> necessary for an application that wants to use libbtrfs. Does it
> really make sense to have btrfs-progs expose things like ctree.h or
> crc32c.h or even list.h to userspace?!
[...]

For the record and public status of the libify patches: after the
discussion on IRC a few days ago there is more work need to clean and
finalize the header interfaces so that two currently proposed and future
users of the library are satisfied.

For that reason I'll not add libify patches into the integration branch
directly, but keep it in a separate branch until all sides are ok, so
that the integration branch is a relatively stable codebase for fixes
and minor updates.

That's my view of the situation, feel free to correct or update the bits
I might have missed.


david
