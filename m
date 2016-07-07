Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:33221 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbcGGKSW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 06:18:22 -0400
Received: by mail-vk0-f44.google.com with SMTP id b192so14289562vke.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 03:18:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS=5Zx_toc3WuOpymyVUYFZMUo=wh+ZmTC=jh6bL3XYXg@mail.gmail.com>
References: <CALLEBqG65hkAd+KyoNZudCKv58OuBm3L5VOjWcvMQ5GfGNCngA@mail.gmail.com>
 <CAJCQCtS=5Zx_toc3WuOpymyVUYFZMUo=wh+ZmTC=jh6bL3XYXg@mail.gmail.com>
From: Stanislaw Kaminski <stasheck.fora@gmail.com>
Date: Thu, 7 Jul 2016 12:18:02 +0200
Message-ID: <CALLEBqF7HZ0VmMpFmoTik0_2FBXp7q5Z4EHxe_fMDY9ni2j44Q@mail.gmail.com>
Subject: Re: Out of space error even though there's 100 GB unused?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
I downgraded to 4.4.1-1 - all fine, 4.5.5.-1 - also fine, then got
back to 4.6.3-2 - and it's still fine. Apparently running under
different kernel somehow fixed the glitch (as far as I can test...).

That leaves me with the other question: before issues, I 1.6 TiB was
used, now all the tools report 1.7 TiB issued (except for btrfs fs du
/home, this reports 1.6 TiB). How is that possible?

Cheers,
Stan

2016-07-06 19:42 GMT+02:00 Chris Murphy <lists@colorremedies.com>:
> On Wed, Jul 6, 2016 at 3:55 AM, Stanislaw Kaminski
> <stasheck.fora@gmail.com> wrote:
>
>>     Device unallocated:           97.89GiB
>
> There should be no problem creating any type of block group from this
> much space. It's a bug.
>
> I would try regression testing. Kernel 4.5.7 has some changes that may
> or may not relate to this (they should only relate when there is no
> unallocated space left) so you could try 4.5.6 and 4.5.7. And also
> 4.4.14.
>
> But also the kernel messages are important. There is this obscure
> enospc with error -28, so either with or without enospc_debug mount
> option is useful to try in 4.6.3 (I think it's less useful in older
> kernels).
>
> But do try nospace_cache first. If that works, you could then mount
> with clear_cache one time and see if that provides an enduring fix. It
> can take some time to rebuild the cache after clear_cache is used.
>
>
>
> --
> Chris Murphy
