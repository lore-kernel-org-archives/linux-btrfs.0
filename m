Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43448 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3ANG2M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 01:28:12 -0500
Date: Sun, 13 Jan 2013 22:28:05 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/volumes.c:3707 still not fixed in 3.7.1
 (btrfs-zero-log required) but shown as "RIP btrfs_num_copies"
Message-ID: <20130114062805.GA9137@merlins.org>
References: <20130108164958.GA2044@merlins.org>
 <20130108171012.GP19051@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130108171012.GP19051@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 08, 2013 at 05:10:12PM +0000, Hugo Mills wrote:
> > If that helps, here's what I got after the fact when trying to mount the
> > broken filesystem before zero'ing logs
> [snip]
> 
>    That information may also be helpful in conjunction with the
> btrfs-image dump of a broken FS. I'm not sure how much help it is on
> its own (but thanks for providing it anyway).
> 
>    Hugo.

Ok, that didn't take long. I had the bug again, and I was able to take a
brtfs-image that completed.
(It was failing earlier because I was taking the image of my root
mounted filesystem, which apparently isn't ok ;) ).

gandalfthegreat:~# btrfs-image -c9 /dev/mapper/root /var/tmp/image
Check tree block failed, want=73949184, have=14419929907352990360
Check tree block failed, want=73949184, have=14419929907352990360
Check tree block failed, want=73949184, have=12288424950725929455
Check tree block failed, want=73949184, have=14419929907352990360
Check tree block failed, want=73949184, have=14419929907352990360
read block failed check_tree_block

Is here:
http://marc.merlins.org/tmp/image
(803M)

Hopefully this helps.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
