From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 1/4] md: Factor out RAID6 algorithms into lib/
Date: Fri, 17 Jul 2009 10:22:11 -0400
Message-ID: <4A608913.1060808@redhat.com>
References: <1247494302.19180.268.camel@macbook.infradead.org> <e9c3a7c20907151223j1d976ea9gdd224c9e6c2c36e3@mail.gmail.com> <4A5F6590.9000006@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Dan Williams <dan.j.williams@intel.com>,
	David Woodhouse <dwmw2@infradead.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, neilb@suse.de,
	linux-raid@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A5F6590.9000006@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/16/2009 01:38 PM, H. Peter Anvin wrote:
> Dan Williams wrote:
>> On Mon, Jul 13, 2009 at 7:11 AM, David Woodhouse<dwmw2@infradead.org> 
>> wrote:
>>> We'll want to use these in btrfs too.
>>>
>>> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>>
>> Do you suspect that btrfs will also want to perform these operations
>> asynchronously?  I am preparing an updated release of the raid6
>> offload patch kit, but the previous WIP release can be browsed at:
>>
>> http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=shortlog;h=raid6 
>>
>>
>> The routines are housed in crypto/async_tx/async_pq.c and
>> crypto/async_tx/async_raid6_recov.c.
>>
>> I also wonder if the raid6 algos are a better fit under crypto/ 
>> alongside xor?
>>
>
> I am also sitting on a set of synchronous (CPU) acceleration patches 
> for RAID-6 recovery, just waiting for the APIs to stabilize.
>
>     -hpa
>

Worth sharing a pointer to a really neat set of papers that describe 
open source friendly RAID6 and erasure encoding algorithms that were 
presented last year and this at FAST:

http://www.cs.utk.edu/~plank/plank/papers/papers.html

If I remember correctly, James Plank's papers also have implemented and 
benchmarked the various encodings,

Ric


