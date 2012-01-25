From: Andi Kleen <andi@firstfloor.org>
Subject: Re: ANN: linux-kernel-lzo-2.06.20120123 - update LZO to v2.06
Date: Wed, 25 Jan 2012 02:36:18 +0100
Message-ID: <20120125013618.GA11715@one.firstfloor.org>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org> <4F16DFB0.2060404@oberhumer.com> <4F1D889C.2050706@oberhumer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	Nitin Gupta <ngupta@vflare.org>,
	Richard Purdie <rpurdie@openedhand.com>,
	David Sterba <dave@jikos.cz>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F1D889C.2050706@oberhumer.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2012 at 05:19:40PM +0100, Markus F.X.J. Oberhumer wrote:
> Hi,
> 
> I've prepared a small package that updates the LZO version in the Linux
> kernel to LZO v2.06.

I ran benchmarks on the new miniLZO and LZ4 on 64bit. LZ4 is generally slower 
than snappy/lzo in the micro benchmarks. The new LZO is better than the old
one, but still loses to snappy most of the time (but often by very
small amounts only)

Will be worth checking the new LZO will the full distribution boot test.

I agree it's definitely a good idea to update the kernel version.
However I must say it would be a major project to bring it up
to kernel coding standards.

snappy is still interesting, but much less so than it was before.

-Andi
