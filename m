Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42743 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaEEFNo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 01:13:44 -0400
Date: Sun, 4 May 2014 22:04:59 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: How does Suse do live filesystem revert with btrfs?
Message-ID: <20140505050459.GF10159@merlins.org>
References: <20140504005257.GF9061@merlins.org>
 <20140504232645.GQ9061@merlins.org>
 <20140505003639.GO24298@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140505003639.GO24298@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 01:36:39AM +0100, Hugo Mills wrote:
>    I'm guessing it involves reflink copies of files from the snapshot
> back to the "original", and then restarting affected services. That's
> about the only other thing that I can think of, but it's got load of
> race conditions in it (albeit difficult to hit in most cases, I
> suspect).

Aaah, right, you can use a script to see the file differences between
two snapshots, and then restore that with reflink if you can truly get a
list of all changed files.
However, that is indeed not atomic at all, even if faster than rsync.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
