Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.exactcode.de ([144.76.154.42]:57596 "EHLO mx.exactcode.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752319AbeDPRzx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 13:55:53 -0400
Subject: Re: Kernel unaligned access at ... btrfs_real_readdir+0x51c/0x718
 [btrfs]
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <CF3AC07F-83D7-41FE-ABE5-C442DAB29292@exactcode.com>
 <20180416164805.GQ21272@twin.jikos.cz>
From: =?UTF-8?Q?Ren=c3=a9_Rebe?= <rene@exactcode.com>
Message-ID: <83e9ab82-1ee8-11ac-6987-127722aaba69@exactcode.com>
Date: Mon, 16 Apr 2018 21:55:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180416164805.GQ21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 04/16/2018 06:48 PM, David Sterba wrote:
> The warnings are valid, there's unaligned access introduced by patch
> 
> 23b5ec74943f44378b68c0edd8e210a86318ea5e
> btrfs: fix readdir deadlock with pagefault
> 
> The directory entries (struct dir_entry) are copied to a temporary
> buffer as they fit, ie. no alignment, and the members accessed in
> several places.
> 
> The following patch adds the proper unaligned access, only compile-tested.
> Please test and let me know, thanks!
Would have loved to immediately give it a try, however, sorry,
I forgot to mention I'm on the latest stable release -4.16.2-
on a first glance this does not look like it does just apply.

I would re-base myself if I would not also have a glibc initialization 
bug to hunt and debug, too :-/

If you happen to also rebase it for current -stable, ... ;-)

-- 
   René Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10789 Berlin
   https://exactcode.com | https://t2sde.org | https://rene.rebe.de
