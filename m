From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] a couple of i_nlink fixes in btrfs
Date: Mon, 21 Mar 2011 07:37:02 -0400
Message-ID: <1300707383-sup-9821@think>
References: <20110304171353.GU22723@ZenIV.linux.org.uk> <1299517070-sup-1687@think> <20110321051725.GS22723@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110321051725.GS22723@ZenIV.linux.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Al Viro's message of 2011-03-21 01:17:25 -0400:
> On Mon, Mar 07, 2011 at 11:58:13AM -0500, Chris Mason wrote:
> 
> > Thanks, these both look good but I'll test here as well.  Are you
> > planning on pushing for .38?
> 
> No, but .39 would be nice ;-)  Do you want that to go through btrfs tree
> or through vfs one?

I'll take them in mine, it'll be easier to put in with all these other
changes.

-chris
