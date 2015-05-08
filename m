Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33694 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbbEHKcI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 06:32:08 -0400
Received: by iepj10 with SMTP id j10so56872282iep.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2015 03:32:08 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150507222034.GC18025@hungrycats.org>
References: <20150507222034.GC18025@hungrycats.org>
Date: Fri, 8 May 2015 11:32:07 +0100
Message-ID: <CAL3q7H5XsorEcdG+OdPEz=YaqVoNcmM5GXzs_DFY0yzLQNmaXA@mail.gmail.com>
Subject: Re: Recipe for creating unlink deadlocks
From: Filipe David Manana <fdmanana@gmail.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 7, 2015 at 11:20 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> This is the simplest repro recipe for this that I have found so far.
> It takes only a few minutes for the rm processes to get stuck here:
>
> # cat /proc/28396/stack                                                                                                                                       Thu May  7 18:13:05 2015
>
> [<ffffffff813c8a2d>] lock_extent_bits+0x1ad/0x200
> [<ffffffff813b5dfa>] btrfs_evict_inode+0x17a/0x5e0
> [<ffffffff8123fc68>] evict+0xb8/0x1b0
> [<ffffffff81240813>] iput+0x1f3/0x260
> [<ffffffff81233c68>] do_unlinkat+0x1d8/0x360
> [<ffffffff812346db>] SyS_unlinkat+0x1b/0x40
> [<ffffffff8190024d>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
>
>
> Run these three scripts in a directory that is the top of a subvol:
>
>         # Script #1:  randomly create or delete snapshots
>         while sleep 1; do
>                 if [ $[RANDOM%2] = 0 ]; then
>                         btrfs sub snap . snaps-$RANDOM
>                 else
>                         for x in snaps-*; do
>                                 btrfs sub del $x
>                                 break
>                         done
>                         btrfs sub sync .
>                 fi
>         done
>
>         # Script #2:  create a bunch of files of random sizes
>         while true; do
>                 d=$[RANDOM%9]/$[RANDOM%9]/$[RANDOM%9]/$[RANDOM%9]
>                 mkdir -p ${d%/*}
>                 head -c $[RANDOM%1024]k /usr/share/doc/chromium/copyright > $d
>         done
>
>         # Script #3:  read and immediately delete all the files
>         while date; do
>                 sleep 1
>                 find -type f -exec cat {} \; -exec rm -fv {} \; > /dev/null
>         done

Tried that for over 3 hours, on a 4.1-rc2 kernel with a few patches
from the list, with several combinations of mount options (compress,
autodefrag, nodatacow, etc) and didn't got any issue.

What kernel version are you testing? Any specific combination of mount options?

>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
