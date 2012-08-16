Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41087 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab2HPSS6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 14:18:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120816175234.GL11413@one.firstfloor.org>
References: <50299142.2030504@oberhumer.com>
	<20120814123937.GA14756@sig21.net>
	<502B8FE3.7080501@oberhumer.com>
	<20120815144539.GA8300@sig21.net>
	<502C92C3.7090701@oberhumer.com>
	<20120816150647.GA22010@sig21.net>
	<20120816232549.4d14a6aa@natsu>
	<20120816175234.GL11413@one.firstfloor.org>
Date: Thu, 16 Aug 2012 20:18:57 +0200
Message-ID: <CAMuHMdWK_Y=QwkgQD6K8tFBLaO04Fy0yVAzEpb2OYW6Ec0hGoA@mail.gmail.com>
Subject: Re: [GIT PULL] Update LZO compression
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Roman Mamedov <rm@romanrm.ru>, Johannes Stezenbach <js@sig21.net>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        linux-kernel@vger.kernel.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 16, 2012 at 7:52 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> I have locked the Allwinner A10 CPU in my Mele A2000 to 60 MHz using cpufreq-set,
>> and ran your test. rnd.lzo is a 9 MB file from /dev/urandom compressed with lzo.
>> There doesn't seem to be a significant difference between all three variants.
>
> I found that in compression benchmarks it depends a lot on the data
> compressed.
>
> urandom (which should be essentially incompressible) will be handled
> by different code paths in the compressor than other more compressible data.
> It becomes a complicated memcpy then.

In addition, locking the CPU to 60 MHz may improve the memory access penalty,
as a cache miss may cost much less cycles.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
