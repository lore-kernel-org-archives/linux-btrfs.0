Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44462 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbaAHICN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2014 03:02:13 -0500
Date: Wed, 8 Jan 2014 00:02:06 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is anyone using btrfs send/receive howto?
Message-ID: <20140108080206.GV10936@merlins.org>
References: <20131228171943.GE19863@merlins.org>
 <20131228173730.GA7234@carfax.org.uk>
 <20131228180758.GF19863@merlins.org>
 <20140107104951.GL10936@merlins.org>
 <20140107105329.GE15634@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140107105329.GE15634@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 07, 2014 at 10:53:29AM +0000, Hugo Mills wrote:
>    You need to move /mnt/btrfs_pool2/tmp_read_only_new to a different
> name as well. The send stream contains the name of the subvolume it
> wants to create, so it's trying to create a subvolume called
> "tmp_read_only_new" in /mnt/btrfs_pool2, and there's one there already.

Aaah, got it, thanks.

I'll contribute back a shell script that makes this much easier when I'm
done with it.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
