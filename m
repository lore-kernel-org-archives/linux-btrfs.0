Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35535 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbcGFRmF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 13:42:05 -0400
Received: by mail-oi0-f43.google.com with SMTP id r2so280758994oih.2
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 10:42:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALLEBqG65hkAd+KyoNZudCKv58OuBm3L5VOjWcvMQ5GfGNCngA@mail.gmail.com>
References: <CALLEBqG65hkAd+KyoNZudCKv58OuBm3L5VOjWcvMQ5GfGNCngA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 11:42:03 -0600
Message-ID: <CAJCQCtS=5Zx_toc3WuOpymyVUYFZMUo=wh+ZmTC=jh6bL3XYXg@mail.gmail.com>
Subject: Re: Out of space error even though there's 100 GB unused?
To: Stanislaw Kaminski <stasheck.fora@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 3:55 AM, Stanislaw Kaminski
<stasheck.fora@gmail.com> wrote:

>     Device unallocated:           97.89GiB

There should be no problem creating any type of block group from this
much space. It's a bug.

I would try regression testing. Kernel 4.5.7 has some changes that may
or may not relate to this (they should only relate when there is no
unallocated space left) so you could try 4.5.6 and 4.5.7. And also
4.4.14.

But also the kernel messages are important. There is this obscure
enospc with error -28, so either with or without enospc_debug mount
option is useful to try in 4.6.3 (I think it's less useful in older
kernels).

But do try nospace_cache first. If that works, you could then mount
with clear_cache one time and see if that provides an enduring fix. It
can take some time to rebuild the cache after clear_cache is used.



-- 
Chris Murphy
