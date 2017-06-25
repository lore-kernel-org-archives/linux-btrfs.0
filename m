Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:34544 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751354AbdFYVad (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Jun 2017 17:30:33 -0400
Date: Sun, 25 Jun 2017 23:30:22 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nick Terrell <terrelln@fb.com>
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: Add zstd support
Message-ID: <20170625213022.7kaa7agzmzdyw3n4@angband.pl>
References: <20170622220139.2328978-3-terrelln@fb.com>
 <201706260238.qmaHlUAv%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201706260238.qmaHlUAv%fengguang.wu@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 03:03:17AM +0800, kbuild test robot wrote:
> Hi Nick,
> 
> url:    https://github.com/0day-ci/linux/commits/Nick-Terrell/lib-Add-xxhash-module/20170625-214344
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
> >> ERROR: "__udivdi3" [lib/zstd/zstd_compress.ko] undefined!
>    ERROR: "__udivdi3" [fs/ufs/ufs.ko] undefined!

Just to save you time to figure it out:
for division when one or both arguments are longer than the architecture's
word, gcc uses helper functions that are included when compiling in a hosted
environment -- but not in freestanding.

Thus, you want do_div() instead of /; do check widths and signedness of
arguments.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
