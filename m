Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:32958 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbbDZTcJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Apr 2015 15:32:09 -0400
Date: Sun, 26 Apr 2015 12:32:04 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-ID: <20150426193204.GA5904@merlins.org>
References: <20150426152007.GA27173@merlins.org>
 <20150426153226.GA18187@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150426153226.GA18187@carfax.org.uk>
Subject: Re: raid0 needs mounting alternate device every boot? open_ctree
 failed (3.19.5)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 26, 2015 at 03:32:26PM +0000, Hugo Mills wrote:
>    The usual reason for this is that btrfs dev scan isn't being run
> properly. It's usually handled by udev -- most distributions will put
> the appropriate hooks in their udev configuration if you have the
> distribution's btrfs-progs package installed. If you have only a
> self-built btrfs-progs from git installed, then the udev hooks
> probably aren't there, and you'll need to configure it yourself (or
> arrange to have btrfs dev scan run after the cryptsetup open
> operation).

Ah, yes, that makes more sense.

I do have package and the rules:
gargamel:~# dpkg -L btrfs-tools 
/.
/lib
/lib/udev
/lib/udev/rules.d
/lib/udev/rules.d/80-btrfs-lvm.rules
/lib/udev/rules.d/70-btrfs.rules

But it's very possible that udev isn't working properly or timely on
this system.

I added "btrfs device scan" to /etc/init.d/cryptdisks

Thanks for the help.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
