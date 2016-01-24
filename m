Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37685 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbcAXWE0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 17:04:26 -0500
Received: by mail-ig0-f180.google.com with SMTP id h5so20169764igh.0
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 14:04:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160124211700.GF908@breitenfeld.lan>
References: <20160124175258.GD908@breitenfeld.lan>
	<CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
	<20160124205832.GE908@breitenfeld.lan>
	<CAJCQCtQfpnis+m0QqSJ28wHidNCm2tAt8UXZuwrPg6fdrLohNw@mail.gmail.com>
	<20160124211700.GF908@breitenfeld.lan>
Date: Sun, 24 Jan 2016 15:04:25 -0700
Message-ID: <CAJCQCtQjCgvHqfbuKF+E0xhEydu1SdwZ3uLyq+aDL=+Yrrkm4w@mail.gmail.com>
Subject: Re: Chicken-egg: uncorrectable checksum error prevents RAID1 rebalancing
From: Chris Murphy <lists@colorremedies.com>
To: Tom Hunt <tomdicksonhunt@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 24, 2016 at 2:17 PM, Tom Hunt <tomdicksonhunt@gmail.com> wrote:
> My arrangement is two subvolumes, 'root' and 'home', directly under the root
> subvolume. The 'root' subvolume is mounted on /, the 'home' subvolume on /home.
> I've tried both pointing the find command at /, and mounting the root subvolume
> on a mount directory and pointing it there. Neither show any file or directory
> with inum 515.

Inode 515 isn't special as far as I can tell. That you get zero
results for 'find <mp> -inum 515' and yet it appears with an error
during a scrub is weird.

What do you get for btrfs check without --repair?



-- 
Chris Murphy
