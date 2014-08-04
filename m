Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:60198 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaHDDbs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Aug 2014 23:31:48 -0400
From: Russell Coker <russell@coker.com.au>
To: Peter Roberts <me@peter-r.co.uk>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Scan not being performed properly on boot
Date: Mon, 04 Aug 2014 13:31:42 +1000
Message-ID: <1704788.vV3kpDkpOK@xev>
In-Reply-To: <53DEF7DD.5070002@peter-r.co.uk>
References: <53DEF7DD.5070002@peter-r.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 4 Aug 2014 04:02:53 Peter Roberts wrote:
> I've just recently started testing btrfs on my server but after just 24 
> hours problems have started. I get booted to a busybox prompt user 
> ubuntu 14.04. I have a multi device FS setup and I can't say for sure if 
> it managed to boot initially or not but it worked fine in regular usage.

What is GRUB (or your boot loader) giving as parameters to the kernel?

What error messages appear on screen?  Sometimes it's helpful to photograph 
the screen and put the picture on a web server to help people diagnose the 
problem.

> I cannot mount my root with anything other than an explicit /dev/sdx 
> reference until I manually run a scan. Then UUID etc all work. I've 

That sounds like a problem with the Ubuntu initrd, probably filing an Ubuntu 
bug report would be the best thing to do.  Is BTRFS supported in that version 
of Ubuntu?

But just changing your boot configuration to use /dev/sdx is probably the best 
option.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

