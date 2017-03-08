Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:47044 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755447AbdCHGr0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 01:47:26 -0500
Date: Wed, 8 Mar 2017 07:47:20 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, demfloro@demfloro.ru
Subject: Re: [PATCH v3 0/7] Chunk level degradable check
Message-ID: <20170308064720.o5j24elapzjc5loz@angband.pl>
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 08, 2017 at 10:41:17AM +0800, Qu Wenruo wrote:
> This patchset will introduce a new per-chunk degradable check for
> btrfs, allow above case to succeed, and it's quite small anyway.

> v3:
>   Remove one duplicated missing device output
>   Use the advice from Anand Jain, not to add new members in btrfs_device,
>   but use a new structure extra_rw_degrade_errors, to record error when
>   sending down/waiting device.
> 
> Sorry Dmitrii Tcvetkov and Adam Borowski, I'm afraid I can't add your
> tested-by tags in v3, as the 4th and 4th patches have quite a big change,
> so you may need to retest the new patchset.

Well, testing stuff is why we're here :)

Re-tested, as far as your patch goes all is well.


Looks like I found an unrelated bug, though, that messed with my testing.
And it looks like a nasty one: once "btrfs dev scan" sees a disk, it stores
its device and will then happily use it without verification even if it's
been pulled out and replaced by something else.  Lemme investigate that
later today.

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
