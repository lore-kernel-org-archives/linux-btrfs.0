Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:56330 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab2HPRwi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 13:52:38 -0400
Date: Thu, 16 Aug 2012 19:52:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Roman Mamedov <rm@romanrm.ru>
Cc: Johannes Stezenbach <js@sig21.net>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] Update LZO compression
Message-ID: <20120816175234.GL11413@one.firstfloor.org>
References: <50299142.2030504@oberhumer.com> <20120814123937.GA14756@sig21.net> <502B8FE3.7080501@oberhumer.com> <20120815144539.GA8300@sig21.net> <502C92C3.7090701@oberhumer.com> <20120816150647.GA22010@sig21.net> <20120816232549.4d14a6aa@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120816232549.4d14a6aa@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I have locked the Allwinner A10 CPU in my Mele A2000 to 60 MHz using cpufreq-set,
> and ran your test. rnd.lzo is a 9 MB file from /dev/urandom compressed with lzo.
> There doesn't seem to be a significant difference between all three variants.

I found that in compression benchmarks it depends a lot on the data
compressed.

urandom (which should be essentially incompressible) will be handled
by different code paths in the compressor than other more compressible data.
It becomes a complicated memcpy then.

But then there are IO benchmarks which also only do zeroes, which
also gives an unrealistic picture.

Usually it's best to use some corpus with different data types, from very
compressible to less so; and look at the aggregate.

For my snappy work I usually had at least large executables (medium) and some
pdfs (already compressed; low) and then uncompressed source code tars (high
compression)

-Andi
