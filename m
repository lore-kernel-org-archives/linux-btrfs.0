Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35372 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbLIX3s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 18:29:48 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5668B3BE.60500@nv-systems.net>
References: <CABXGCsMgw7NH5VzPvOVKrkd03CH7Dmjhg1xizwhknLDg9Vk2AA@mail.gmail.com>
	<CAL3q7H5kiPdR0N2k=q92MFS-gcCE4A==yB2TLBgze43haARvaQ@mail.gmail.com>
	<5668B3BE.60500@nv-systems.net>
Date: Wed, 9 Dec 2015 23:29:48 +0000
Message-ID: <CAL3q7H5354BV39V36zg60ENrALqDeiqDnoRCvhP2SuBjYeuoSg@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1833! [btrfs]
From: Filipe Manana <fdmanana@gmail.com>
To: Gerald Hopf <gerald.hopf@nv-systems.net>
Cc: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 9, 2015 at 11:05 PM, Gerald Hopf <gerald.hopf@nv-systems.net> wrote:
>
>>> kernel BUG at fs/btrfs/extent-tree.c:1833!
>>
>> We got this fixed in 4.4-rc1:
>>
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2c3cf7d5f6105bb957df125dfce61d4483b8742d
>>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b06c4bf5c874a57254b197f53ddf588e7a24a2bf
>>
>> Patches were tagged for stable releases but weren't yet backported to
>> 4.2 and 4.3 (the issue affects all 4.2 and 4.3 releases at the
>> moment).
>>
>> cheers
>
> Could someone please backport this important fix and merge it into the
> stable kernels?
> Today Kernel 4.2.7 and 4.3.1 were finally released and as far as I can see
> in the changelog no btrfs fixes were included in these updates.
> => still can't do balance without crashing the system

It's up to the stable team (cc'ed) to do that. For some reason, all
patches (at least btrfs ones) tagged for stable haven't been added to
4.3.x and 4.2.x at least for quite some time. Probably just a long
queue and a busy maintainer or on vacations or something like that.

>
> Gerald
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
