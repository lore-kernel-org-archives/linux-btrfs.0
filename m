From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Wed, 15 Jul 2009 15:11:18 -0700
Message-ID: <e9c3a7c20907151511j1997b58al4d103733f1a68404@mail.gmail.com>
References: <1247494302.19180.268.camel@macbook.infradead.org>
	 <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com>
	 <20090715201658.GC23967@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090715201658.GC23967@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 15, 2009 at 1:16 PM, Chris Mason<chris.mason@oracle.com> wr=
ote:
> On Wed, Jul 15, 2009 at 12:23:47PM -0700, Dan Williams wrote:
>> On Mon, Jul 13, 2009 at 7:11 AM, David Woodhouse<dwmw2@infradead.org=
> wrote:
>> > We'll want to use these in btrfs too.
>> >
>> > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>>
>> Do you suspect that btrfs will also want to perform these operations
>> asynchronously? =A0I am preparing an updated release of the raid6
>> offload patch kit, but the previous WIP release can be browsed at:
>
> The short answer is that we'll definitely want to use the async code
> where it is available. =A0Btrfs is already wired up to hand off CPU
> intensive parts of IO submission (compression, checksumming) to helpe=
r
> threads. =A0There's some extra ordering so that we can have N threads
> checksumming but still send down the actual bios in the proper order.
>
> Once the btrfs raid5/6 is working well, I'll wire it into the helper
> threads as well. =A0Are the raid offload engines fast enough that we =
won't
> want the helper threads when they are available?

The api is such that you will not be able to tell ahead of time if the
operation is to be offloaded or carried out synchronously (unless of
course you disable offload by CONFIG_ASYNC_TX_DMA=3Dn).  The current
channel allocator hands out channels on a percpu basis so the
scheduling of the helper threads can be used as a proxy for scheduling
the offload engines.  I have considered allowing overloaded channels
to spill work back on to the cpu[1], but I need more data on whether
this is worthwhile.

--
Dan

[1]: http://www.intel.com/design/iio/iop341_42.htm
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
