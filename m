Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50995 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaL2Ply (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 10:41:54 -0500
Date: Mon, 29 Dec 2014 07:41:44 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 3.16.3: fs/btrfs/delayed-inode.c:1410
 btrfs_assert_delayed_root_empty
Message-ID: <20141229154144.GC17254@merlins.org>
References: <20141228192614.GO17254@merlins.org>
 <20141229010047.7f9b6d43@natsu>
 <20141228213606.GP17254@merlins.org>
 <1419866220.13012.18@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419866220.13012.18@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 29, 2014 at 10:17:00AM -0500, Chris Mason wrote:
> I've hit this recently on my laptop, and haven't yet been able to
> recreate it on a machine where I can debug things.  The messages are
> an error in the log tree replay code, and I don't think they are
> actually related to any corruptions.  Trying to nail it down today.

Thanks for the update and looking at it.

Just to rule things out for me, on your laptop, are you running btrfs
directly on disk, or do you have layers like dmcrypt in the middle?
(having 2 other layers myself, I never know if it's btrfs that could be
to blame, or the other 2 layers not passing data through in atomic bits
like they're supposed to)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
