From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Wed, 15 Jul 2009 12:23:47 -0700
Message-ID: <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>
References: <1247494302.19180.268.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247494302.19180.268.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 13, 2009 at 7:11 AM, David Woodhouse<dwmw2@infradead.org> wrote:
> We'll want to use these in btrfs too.
>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Do you suspect that btrfs will also want to perform these operations
asynchronously?  I am preparing an updated release of the raid6
offload patch kit, but the previous WIP release can be browsed at:

http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=raid6

The routines are housed in crypto/async_tx/async_pq.c and
crypto/async_tx/async_raid6_recov.c.

I also wonder if the raid6 algos are a better fit under crypto/ alongside xor?

--
Dan
