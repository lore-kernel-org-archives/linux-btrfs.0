Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:39445 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbdCIWWd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Mar 2017 17:22:33 -0500
Date: Thu, 9 Mar 2017 22:56:15 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix a bogus warning when converting only data
 or metadata
Message-ID: <20170309215615.ypotq6xnaahfiyab@angband.pl>
References: <20170307203406.GC12408@lim.localdomain>
 <20170307223444.7526-1-kilobyte@angband.pl>
 <20170309134327.GE14605@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170309134327.GE14605@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 09, 2017 at 02:43:27PM +0100, David Sterba wrote:
> The patch does not apply to current master, there's
> 
>   3861         if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
>   3862                 fs_info->num_tolerated_disk_barrier_failures = min(
>   3863                         btrfs_calc_num_tolerated_disk_barrier_failures(fs_info),
>   3864                         btrfs_get_num_tolerated_disk_barrier_failures(
>   3865                                 bctl->sys.target));
>   3866         }
>   3867
> 
> followed by the line below, I'll merge that manually but slightly wonder
> which branch you have used as a base. No big deal though, I'll add the
> patch to the queue. Thanks.
>
> >       ret = insert_balance_item(fs_info, bctl);

I had Qu's chunk counting patchset in my tree (and some irrelevant stuff,
like tty patches).  But this means there'll be a minor conflict between the
two once you get around to merging Qu's stuff.

It's obvious how they interact; the bogus warning happens with and without
chunk counting.

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
