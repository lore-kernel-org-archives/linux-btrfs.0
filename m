From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Thu, 16 Jul 2009 13:38:24 -0400
Message-ID: <4A5F6590.9000006@zytor.com>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: David Woodhouse <dwmw2@infradead.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Dan Williams wrote:
> On Mon, Jul 13, 2009 at 7:11 AM, David Woodhouse<dwmw2@infradead.org> wrote:
>> We'll want to use these in btrfs too.
>>
>> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> 
> Do you suspect that btrfs will also want to perform these operations
> asynchronously?  I am preparing an updated release of the raid6
> offload patch kit, but the previous WIP release can be browsed at:
> 
> http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=raid6
> 
> The routines are housed in crypto/async_tx/async_pq.c and
> crypto/async_tx/async_raid6_recov.c.
> 
> I also wonder if the raid6 algos are a better fit under crypto/ alongside xor?
> 

I am also sitting on a set of synchronous (CPU) acceleration patches for 
RAID-6 recovery, just waiting for the APIs to stabilize.

	-hpa

