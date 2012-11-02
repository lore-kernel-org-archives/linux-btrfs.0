Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from col0-omc4-s10.col0.hotmail.com ([65.55.34.212]:16257 "EHLO
	col0-omc4-s10.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243Ab2KBPys convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Nov 2012 11:54:48 -0400
Message-ID: <COL002-W179CC749A18F35284E4D01B0670@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: Kenneth Johansson <kenneth@southpole.se>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: no space left on device.
Date: Fri, 2 Nov 2012 10:54:47 -0500
In-Reply-To: <50927A9E.70106@southpole.se>
References: <50927A9E.70106@southpole.se>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> So I have ended up in a state where I can't delete files with rm.
>
> the error I get is no space on device. however I'm not even close to empty.
> /dev/sdb1 38G 27G 9.5G 75%
> there is about 800k files/dirs in this filesystem
>
> extra strange is that I can in another directory create and delete files.
>
> So I tried pretty much all I could google my way to but problem
> persisted. So I decided to do a backup and a format. But when the backup
> was done I tried one more time and now it was possible to delete the
> directory and all content?
>
> using the 3.5 kernel in ubuntu 12.10. Is this a known issue ? is it
> fixed in later kernels?
>
> fsck /btrfs scrub and kernel log. nothing indicate any problem of any kind.
>

First let's see the output of:
btrfs fi df /mountpoint

You're probably way over allocated in metadata so a balance should help:
btrfs bal start -m /mountpoint
or omit the -m option to run a full balance. 		 	   		  