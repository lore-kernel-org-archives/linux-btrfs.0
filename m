Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34981 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbcAXWQR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 17:16:17 -0500
Received: by mail-ob0-f174.google.com with SMTP id zv1so1170364obb.2
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 14:16:16 -0800 (PST)
Date: Sun, 24 Jan 2016 15:16:14 -0700
From: Tom Hunt <tomdicksonhunt@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Chicken-egg: uncorrectable checksum error prevents RAID1
 rebalancing
Message-ID: <20160124221614.GH908@breitenfeld.lan>
References: <20160124175258.GD908@breitenfeld.lan>
 <CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
 <20160124205832.GE908@breitenfeld.lan>
 <CAJCQCtQfpnis+m0QqSJ28wHidNCm2tAt8UXZuwrPg6fdrLohNw@mail.gmail.com>
 <20160124211700.GF908@breitenfeld.lan>
 <CAJCQCtQjCgvHqfbuKF+E0xhEydu1SdwZ3uLyq+aDL=+Yrrkm4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQjCgvHqfbuKF+E0xhEydu1SdwZ3uLyq+aDL=+Yrrkm4w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I get "currently mounted, aborting".

If I must bring down the machine over this, I can, but I'd prefer not to.

On Sun, Jan 24, 2016 at 03:04:25PM -0700, Chris Murphy wrote:
> On Sun, Jan 24, 2016 at 2:17 PM, Tom Hunt <tomdicksonhunt@gmail.com> wrote:
> > My arrangement is two subvolumes, 'root' and 'home', directly under the root
> > subvolume. The 'root' subvolume is mounted on /, the 'home' subvolume on /home.
> > I've tried both pointing the find command at /, and mounting the root subvolume
> > on a mount directory and pointing it there. Neither show any file or directory
> > with inum 515.
> 
> Inode 515 isn't special as far as I can tell. That you get zero
> results for 'find <mp> -inum 515' and yet it appears with an error
> during a scrub is weird.
> 
> What do you get for btrfs check without --repair?
> 
> 
> 
> -- 
> Chris Murphy

-- 
Tom Hunt
