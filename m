Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39915 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaK3EXJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 23:23:09 -0500
Date: Sat, 29 Nov 2014 20:23:06 -0800
From: Marc MERLIN <marc@merlins.org>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20141130042306.GE8916@merlins.org>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 09:03:14AM +0530, Shriramana Sharma wrote:
> IIUC with BtrFS while it is possible to easily undelete a file or
> ordinary directory if a snapshot of the containing subvol exists, it
> seems that it's not elementary to undelete a subvol itself, because
> all subvols are under the root-level subvol (id 0 or 5, see my other
> q) but even snapshotting the root subvol will not snapshot any subvols
> under it.
> 
> So is there any way to undo a subvol delete?

If you didn't snapshot that volume before deleting it, you're SOL.
If you snapshotted it, rename that snapshot to the other name, and
you're done.

Btrfs doesn't offer undelete, it only lets you keep multiple copies of
your data at very little cost, so you can retrieve a snapshot copy if
you deleted your current volume's data.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
