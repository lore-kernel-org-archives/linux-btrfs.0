Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42209 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753602AbdGUOtY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 10:49:24 -0400
Date: Fri, 21 Jul 2017 16:49:22 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Do not use data_alloc_cluster in ssd mode
Message-ID: <20170721144922.2zriwspqixh7yt3l@angband.pl>
References: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 21, 2017 at 01:47:11PM +0200, Hans van Kranenburg wrote:
> The changes in here do the following:
> 
> 1. Throw out the current ssd_spread behaviour.
> 2. Move the current ssd behaviour to the ssd_spread option.
> 3. Make ssd mode data allocation identical to tetris mode, like nossd.
> 4. Adjust and clean up filesystem mount messages so that we can easily
> identify if a kernel has this patch applied or not, when providing
> support to end users.

> Notes for whoever wants to backport this patch on their 4.9 LTS kernel:
> * First apply commit 8a83665a "btrfs: drop the nossd flag when
>   remounting with -o ssd", or fixup the differences manually.

It's 951e7966 in mainline.  I see no 8a83665a anywhere -- most likely it's
what you got after cherry-picking to 4.9.

-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
