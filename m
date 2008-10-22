From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 09:23:59 -0400
Message-ID: <48FF296F.9060009@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com>	 <1224622451.7412.1.camel@telesto>  <48FE553D.80501@redhat.com> <1224642544.7189.17.camel@telesto> <48FF038A.4010105@redhat.com> <48FF0625.6040400@kernel.org> <48FF2343.3070107@redhat.com> <48FF276B.6090602@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Anopolsky <erpo41@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF276B.6090602@kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tejun Heo wrote:
> Ric Wheeler wrote:
>   
>> I think that we do handle a failure in the case that you outline above
>> since the FS will be able to notice the error before it sends a commit
>> down (and that commit is wrapped in the barrier flush calls). This is
>> the easy case since we still have the context for the IO.
>>     
>
> I'm no FS guy but for that to be true FS should be waiting for all the
> outstanding IOs to finish before issuing a barrier and actually
> doesn't need barriers at all - it can do the same with flush_cache.
>   

Waiting for the target to ack an IO is not sufficient, since the target 
ack does not (with write cache enabled) mean that it is on persistent 
storage.

The key is to make your transaction commit insure that the commit block 
itself is not written out of sequence without flushing the dependent IO 
from the transaction.

If we disable the write cache, then file systems effectively do exactly 
the right thing today as you describe :-)
>   
>> It is more challenging  (and kind of related) if the IO done in (4) has
>> been ack'ed by drive, the drive later destages (not as part of the
>> flush) its write cache and then an error happens. In this case, there is
>> nothing waiting on the initiator side to receive the IO error. We have
>> effectively lost the context for that IO.
>>     
>
> IIUC, that should be detectable from FLUSH whether the destaging
> occurred as part of flush or not, no?
>   

I am not sure what happens to a write that fails to get destaged from 
cache. It probably depends on the target firmware, but I imagine that 
the target cannot hold onto it forever (or all subsequent flushes would 
always fail).
>   
>> The only way to detect this is on replay (if the journal has checksums
>> enabled or the error will be flagged as a media error).
>>     
>
> If it's not reported on FLUSH, it basically amounts to silent data
> corruption and only checksums can help.
>
> Thanks.
>
>   

Agreed - checksums (or proper handling of media errors) are the only way 
to detect this.

Ric


