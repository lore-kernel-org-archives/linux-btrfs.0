Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:52805 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbdKDEtS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 00:49:18 -0400
Date: Sat, 4 Nov 2017 05:49:16 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: updatedb does not index /home when /home is Btrfs
Message-ID: <20171104044916.4mpgaails24rqddz@angband.pl>
References: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtSf1mX0kWCRjfSTwZKwZC6mMN7Vdio0LJdCCY96ifte4g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 03, 2017 at 06:15:53PM -0600, Chris Murphy wrote:
> Ancient bug, still seems to be a bug.
> https://bugzilla.redhat.com/show_bug.cgi?id=906591
> 
> The issue is that updatedb by default will not index bind mounts, but
> by default on Fedora and probably other distros, put /home on a
> subvolume and then mount that subvolume which is in effect a bind
> mount.
> 
> There's a lot of early discussion in 2013 about it, but then it's
> dropped off the radar as nobody has any ideas how to fix this in
> mlocate.

I don't see how this would be a bug in btrfs.  The same happens if you
bind-mount /home (or individual homes), which is a valid and non-rare setup.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ Laws we want back: Poland, Dz.U. 1921 nr.30 poz.177 (also Dz.U. 
⣾⠁⢰⠒⠀⣿⡁ 1920 nr.11 poz.61): Art.2: An official, guilty of accepting a gift
⢿⡄⠘⠷⠚⠋⠀ or another material benefit, or a promise thereof, [in matters
⠈⠳⣄⠀⠀⠀⠀ relevant to duties], shall be punished by death by shooting.
