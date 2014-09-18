Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56206 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbaIRQwS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 12:52:18 -0400
Date: Thu, 18 Sep 2014 09:07:01 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive: could not find parent subvolume
Message-ID: <20140918160701.GO12147@merlins.org>
References: <20140918152718.GA27983@merlins.org>
 <20140918153934.GA9830@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140918153934.GA9830@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 18, 2014 at 04:39:34PM +0100, Hugo Mills wrote:
> > Now it seems that the UUID is different on all my snapshots created by
> > btrfs send, so maybe it doesn't match UUID?
> > 
> > Given that, what is btrfs receive using to get a match?
> 
>    There's a "recieved UUID" field on each subvolume. I posted a patch
> to userspace a couple of weeks ago which adds a -R option to show it.
> I don't think it's filtered through David's backlog yet.

Ah, thanks for that.

Now I wonder why the parent read only snapshot with the same name
on both sides (created by btrfs send) suddenly have a UUID mismatch.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
