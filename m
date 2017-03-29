Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35806 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752457AbdC2TnB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Mar 2017 15:43:01 -0400
Date: Wed, 29 Mar 2017 21:42:51 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: warn about RAID5/6 being experimental at
 mount time
Message-ID: <20170329194251.n72zt6dejbezrqhp@angband.pl>
References: <20170329043940.23655-1-kilobyte@angband.pl>
 <1490815652.16829.3.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1490815652.16829.3.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 29, 2017 at 09:27:32PM +0200, Christoph Anton Mitterer wrote:
> On Wed, 2017-03-29 at 06:39 +0200, Adam Borowski wrote:
> > Too many people come complaining about losing their data -- and indeed,
> > there's no warning outside a wiki and the mailing list tribal knowledge. 
> > Message severity chosen for consistency with XFS -- "alert" makes dmesg
> > produce nice red background which should get the point across.
> 
> Wouldn't it be much better to disallow:
> - creation
> AND
> - mounting
> of btrfs unless some special swtich like:
> --yes-i-know-this-is-still-extremely-experimental
> is given for the time being?

I have no preference here.

> Normal users typically don't look at any such kernel log messages - and
> expert users (who do) anyway know, that it's still unstable.

My previous attempt here was https://patchwork.kernel.org/patch/9450035/
in btrfs-progs.  This time I'm submitting a kernel variant, as it won't be
out of sync if you use a modern kernel on a 10 years old RHEL userland.

I can revive that -progs patch, and fix code issues (ie, printing the
message during parsing); I'd like to hear whether kernel or -progs is
better.  We can even do both.

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
