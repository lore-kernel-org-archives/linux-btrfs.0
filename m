From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Btrfs for mainline
Date: Tue, 6 Jan 2009 22:09:04 +0000
Message-ID: <20090106220904.GA25563@shareable.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1230924749.7538.35.camel@think.oraclecorp.com> <20090102210104.GC496@one.firstfloor.org> <200901052107.43341.chris@csamuel.org> <1231161538.4290.12.camel@think.oraclecorp.com> <20090105163312.GA16883@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090105163312.GA16883@fieldses.org>
List-ID: <linux-btrfs.vger.kernel.org>

J. Bruce Fields wrote:
> Old kernel versions may still get booted after brtfs has gotten a
> reputation for stability.  E.g. if I move my / to brtfs in 2.6.34, then
> one day need to boot back to 2.6.30 to track down some regression, the
> reminder that I'm moving back to some sort of brtfs dark-ages might be
> welcome.

Require a mount option "allow_unstable_version" until it's stable?
The stable version can ignore the option.

In your example, you wouldn't use the option, and in the btrfs dark
ages it would refuse to mount.

-- Jamie
