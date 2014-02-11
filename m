Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaBKSMA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 13:12:00 -0500
Date: Tue, 11 Feb 2014 19:11:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Frank Kingswood <frank@kingswood-consulting.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send runs out of memory and file handles
Message-ID: <20140211181159.GJ16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52F8D406.7000207@kingswood-consulting.co.uk>
 <20140210134748.GI6490@carfax.org.uk>
 <52F8DB2B.6090902@kingswood-consulting.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52F8DB2B.6090902@kingswood-consulting.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 10, 2014 at 01:59:07PM +0000, Frank Kingswood wrote:
> On 10/02/14 13:47, Hugo Mills wrote:
> >On Mon, Feb 10, 2014 at 01:28:38PM +0000, Frank Kingswood wrote:
> >>I'm attempting to back up a btrfs subvolume
> >> [...]
> >>Doing so runs out of file descriptors on the sending machine (having
> >>over 100k files open) and eventually runs out of memory and gets
> >>killed by the OOM killer.
> >
> >    This sounds like a known bug, and I think it was fixed in 3.13.
> >What kernel version are you using?
> 
> This is on 3.12.5.

The fix went into 3.12.6 stable

> I can build and install 3.13.2 and test it again.

And it's in 3.13.x as well.
