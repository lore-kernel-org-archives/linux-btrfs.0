From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Multi-device update
Date: Wed, 16 Apr 2008 19:43:09 +0200
Message-ID: <87fxtlitle.fsf@basil.nowhere.org>
References: <200804161134.19237.chris.mason@oracle.com>
	<87k5ixixp4.fsf@basil.nowhere.org>
	<200804161254.09414.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804161254.09414.chris.mason@oracle.com> (Chris Mason's message of "Wed, 16 Apr 2008 12:54:09 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> writes:

> On Wednesday 16 April 2008, Andi Kleen wrote:
>> Chris Mason <chris.mason@oracle.com> writes:
>> > The async work queues include code to checksum data pages without the FS
>> > mutex
>>
>> Are they able to distribute work to other cores?
>
> Yes, it just uses a workqueue. 

Unfortunately work queues don't do that by default currently. They
tend to process on the current CPU only.

> The current implemention is pretty simple, it 
> surely could be more effective at spreading the work around.
>
> I'm testing a variant that only tosses over to the async queue for pdflush, 
> inline reclaim should stay inline.

Longer term I would hope that write checksum will be basically free by doing
csum-copy at write() time. The only problem is just where to store the
checksum between the write and the final IO? There's no space in 
struct page.

The same could be also done for read() but that might be a little more
tricky because it would require delayed error reporting and it might
be difficult to do this for partial blocks?

-Andi
