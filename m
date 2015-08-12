Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:34869 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbHLTrz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 15:47:55 -0400
Received: by qgj62 with SMTP id 62so17959868qgj.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 12:47:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$2bbc7$72b8aa61$ae5f57d7$55005ae7@cox.net>
References: <CAMoY8LpmhQtSvW-sWbGKDFKNN3xaKPwe+QxU5wCMg2Wcz3ObWA@mail.gmail.com>
	<pan$2bbc7$72b8aa61$ae5f57d7$55005ae7@cox.net>
Date: Wed, 12 Aug 2015 21:47:54 +0200
Message-ID: <CAMoY8Lpivh5=uAD_8nz33gF-LFuDeOFPtEqjRxAbVTngskMv+A@mail.gmail.com>
Subject: Re: raid1 on uneven-sized disks
From: Jim MacBaine <jmacbaine@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 10, 2015 at 6:13 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> We do recommend that you stay relatively current on both kernel and
> userspace, however.  So a current 4.1 series kernel and btrfs-progs 4.1.2
> are excellent, but consider another filesystem if you're the type who was
> still on a 2.x kernel thru 3.12 or so. =:^)

Thank you for the good reminder.

I'm using btrfs for a few years on less important systems. And it has
been quite some time since I last had to throw away and restore an
unrecoverable btrfs filesystem. And I am comfortable with building a
custom kernel for my machines from kernel.org sources.

But that backup system I was talking about is neither a playground
nor the right place for experiments. It is deliberately a minimal system
running Debian Stable (which is currently at a 3.16 kernel) without
any modifications.

Sacrificing ease of use, comfort or even availability is not a big deal.
But sacrificing the durability of the data is not an option. The single
purpose of this system is to keep the data reliably.

So I think I'll start slow with easy-to-recover data. And give it some
more time before I start storing the important stuff on btrfs.

Cheers,
Jim
