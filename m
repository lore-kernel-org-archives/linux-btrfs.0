From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs experimental branch rebased
Date: Thu, 19 Feb 2009 15:26:55 -0500
Message-ID: <1235075215.28724.45.camel@think.oraclecorp.com>
References: <1234969860.23031.18.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steven Pratt <slpratt@austin.ibm.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234969860.23031.18.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-02-18 at 10:11 -0500, Chris Mason wrote:
> Hello everyone,
> 
> My experimental performance fixes would occasionally trigger corruptions
> under load, so I've folded an incremental fix back in and rebased the
> experimental branch.  This was done to prevent git bisects later on from
> landing on the bad commit and corrupting some poor tester's FS.
> 

This seems to be a daily operation, which isn't too surprising because
right now I'm trying to use the experimental branch as a way to
integrate Josef's work and mine frequently.

Today's rebase includes some crucial fixes for my delayed reference
modifications, including crash fixes during btrfs-vol -b.

I've got Josef's latest enospc patches, and I reordered them before the
more experimental performance updates.

The goal is to get the enospc work stable for 2.6.29-rc, and pull those
over to the main branch.

-chris


