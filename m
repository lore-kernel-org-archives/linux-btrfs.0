From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Poor read performance on high-end server
Date: Sun, 08 Aug 2010 07:04:38 -0400
Message-ID: <4C5E8F46.5010706@kernel.dk>
References: <4C5AC52D.9030906@sara.nl> <20100805145138.GJ29846@think>	<4C5BF829.3020200@kernel.dk> <87r5i98tdf.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Freek Dijkstra <Freek.Dijkstra@sara.nl>,
	linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87r5i98tdf.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/08/2010 03:18 AM, Andi Kleen wrote:
> Jens Axboe <axboe@kernel.dk> writes:
>>
>> Also, I didn't see Chris mention this, but if you have a newer intel box
>> you can use hw accellerated crc32c instead. For some reason my test box
>> always loads crc32c and not crc32c-intel, so I need to do that manually.
> 
> I have a patch for that, will post it later: autoloading of modules
> based on x86 cpuinfo.

Great, it is pretty annoying to have to do it manually. Sometimes
you forget. And it's not possible to de-select CRC32C and have
the intel variant loaded.

-- 
Jens Axboe

