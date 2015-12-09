Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m.nv-systems.net ([176.9.99.115]:49091 "EHLO m.nv-systems.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbbLIXO4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 18:14:56 -0500
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1833! [btrfs]
To: fdmanana@gmail.com,
        =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
References: <CABXGCsMgw7NH5VzPvOVKrkd03CH7Dmjhg1xizwhknLDg9Vk2AA@mail.gmail.com>
 <CAL3q7H5kiPdR0N2k=q92MFS-gcCE4A==yB2TLBgze43haARvaQ@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Gerald Hopf <gerald.hopf@nv-systems.net>
Message-ID: <5668B3BE.60500@nv-systems.net>
Date: Thu, 10 Dec 2015 00:05:34 +0100
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5kiPdR0N2k=q92MFS-gcCE4A==yB2TLBgze43haARvaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> kernel BUG at fs/btrfs/extent-tree.c:1833!
> We got this fixed in 4.4-rc1:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2c3cf7d5f6105bb957df125dfce61d4483b8742d
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b06c4bf5c874a57254b197f53ddf588e7a24a2bf
>
> Patches were tagged for stable releases but weren't yet backported to
> 4.2 and 4.3 (the issue affects all 4.2 and 4.3 releases at the
> moment).
>
> cheers
Could someone please backport this important fix and merge it into the 
stable kernels?
Today Kernel 4.2.7 and 4.3.1 were finally released and as far as I can 
see in the changelog no btrfs fixes were included in these updates.
=> still can't do balance without crashing the system

Gerald

