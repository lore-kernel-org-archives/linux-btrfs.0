From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Multi-device update
Date: Wed, 16 Apr 2008 20:10:28 +0200
Message-ID: <48064114.5080304@firstfloor.org>
References: <200804161134.19237.chris.mason@oracle.com> <200804161254.09414.chris.mason@oracle.com> <87fxtlitle.fsf@basil.nowhere.org> <200804161404.04202.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804161404.04202.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Wednesday 16 April 2008, Andi Kleen wrote:
>> Chris Mason <chris.mason@oracle.com> writes:
>>> On Wednesday 16 April 2008, Andi Kleen wrote:
>>>> Chris Mason <chris.mason@oracle.com> writes:
>>>>> The async work queues include code to checksum data pages without the
>>>>> FS mutex
>>>> Are they able to distribute work to other cores?
>>> Yes, it just uses a workqueue.
>> Unfortunately work queues don't do that by default currently. They
>> tend to process on the current CPU only.
> 
> Well, I see multiple work queue threads using CPU time, but I haven't spent 
> much time optimizing it.  There's definitely room for improvement.

That's likely because you submit from multiple CPUs. But with a single
submitter running on a single CPU there shouldn't be any load balancing
currently.

-Andi
