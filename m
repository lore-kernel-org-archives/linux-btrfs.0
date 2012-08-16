Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:56237 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030194Ab2HPQU6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 12:20:58 -0400
Date: Thu, 16 Aug 2012 18:20:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] Update LZO compression
Message-ID: <20120816162051.GK11413@one.firstfloor.org>
References: <50299142.2030504@oberhumer.com> <20120814123937.GA14756@sig21.net> <502B8FE3.7080501@oberhumer.com> <20120815144539.GA8300@sig21.net> <502C92C3.7090701@oberhumer.com> <502D100D.2030609@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <502D100D.2030609@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> If you think a little bit, I bet you could come up with a solution that 
> operates at cacheline-aligned granularity, something that would be _even 
> faster_ than simply fixing the code to do aligned accesses.

Cache aligned compression is unlikely to compress anything at all.
Compression algorithms are usually by definition unaligned.

-Andi
