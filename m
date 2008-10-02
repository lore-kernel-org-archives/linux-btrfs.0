From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Btrfs: avoid NULL deref after failed allocation
Date: Thu, 02 Oct 2008 17:15:30 +0200
Message-ID: <87y717ni3x.fsf@basil.nowhere.org>
References: <87abdnt62c.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87abdnt62c.fsf@rho.meyering.net> (Jim Meyering's message of "Thu, 02 Oct 2008 16:39:07 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Jim Meyering <jim@meyering.net> writes:

> However, in some places, the trend is
> to BUG_ON(!ptr), so I've done that, too.

Even if it's a trend, it's wrong.  Better don't add more. 
And also unnecessary because next reference will obviously oops anyways.

-Andi
