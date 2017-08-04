Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35579 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbdHDGAK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 02:00:10 -0400
Date: Fri, 4 Aug 2017 08:00:07 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Power down tests...
Message-ID: <20170804060007.blgcu5khfo4juwfe@angband.pl>
References: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 04, 2017 at 11:21:15AM +0530, Shyam Prasad N wrote:
> We're running a couple of experiments on our servers with btrfs
> (kernel version 4.4).
> And we're running some abrupt power-off tests for a couple of scenarios:
> 
> 1. We have a filesystem on top of two different btrfs filesystems
> (distributed across N disks). i.e. Our filesystem lays out data and
> metadata on top of these two filesystems. With the test workload, it
> is going to generate a good amount of 16MB files on top of the system.
> On abrupt power-off and following reboot, what is the recommended
> steps to be run. We're attempting btrfs mount, which seems to fail
> sometimes. If it fails, we run a fsck and then mount the btrfs. The
> issue that we're facing is that a few files have been zero-sized. As a
> result, there is either a data-loss, or inconsistency in the stacked
> filesystem's metadata.

Sounds like you want to mount with -o flushoncommit.

> We're mounting the btrfs with commit period of 5s. However, I do
> expect btrfs to journal the I/Os that are still dirty. Why then are we
> seeing the above behaviour.

By default, btrfs does only metadata consistency, like most filesystems. 
This improves performance at the cost of failing use case like yours.

-- 
⢀⣴⠾⠻⢶⣦⠀ What Would Jesus Do, MUD/MMORPG edition:
⣾⠁⢰⠒⠀⣿⡁ • multiplay with an admin char to benefit your mortal
⢿⡄⠘⠷⠚⠋⠀ • abuse item cloning bugs (the five fishes + two breads affair)
⠈⠳⣄⠀⠀⠀⠀ • use glitches to walk on water
