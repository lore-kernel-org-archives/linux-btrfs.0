From: Tejun Heo <tj@kernel.org>
Subject: Re: Some very basic questions
Date: Thu, 23 Oct 2008 01:14:19 +0900
Message-ID: <48FF515B.2030209@kernel.org>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com>	 <1224622451.7412.1.camel@telesto>  <48FE553D.80501@redhat.com> <1224642544.7189.17.camel@telesto> <48FF038A.4010105@redhat.com> <48FF0625.6040400@kernel.org> <48FF2343.3070107@redhat.com> <48FF276B.6090602@kernel.org> <48FF296F.9060009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Anopolsky <erpo41@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF296F.9060009@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote:
> Waiting for the target to ack an IO is not sufficient, since the target
> ack does not (with write cache enabled) mean that it is on persistent
> storage.

FS waiting for completion of all the dependent writes isn't too good
latency and throughput-wise tho.  It would be best if FS can indicate
dependencies between write commands and barrier so that barrier
doesn't have to empty the whole queue.  Hmm... Can someone tell me how
much such scheme would help?

> The key is to make your transaction commit insure that the commit block
> itself is not written out of sequence without flushing the dependent IO
> from the transaction.
> 
> If we disable the write cache, then file systems effectively do exactly
> the right thing today as you describe :-)

For most SATA drives, disabling write back cache seems to take high
toll on write throughput.  :-(

>> IIUC, that should be detectable from FLUSH whether the destaging
>> occurred as part of flush or not, no?
>>   
> 
> I am not sure what happens to a write that fails to get destaged from
> cache. It probably depends on the target firmware, but I imagine that
> the target cannot hold onto it forever (or all subsequent flushes would
> always fail).

As long as the error status is sticky, it doesn't have to hold on to
the data, it's not gonna be able to write it anyway.  The drive has to
hold onto the failure information only.  Yeah, but fully agreed on
that it's most likely dependent on the specific firmware.  There isn't
any requirement on how to handle write back failure in the ATA spec.
It wouldn't be too surprising if there are some drives which happily
report the old data after silent write failure followed by flush and
power loss at the right timing.

Thanks.

-- 
tejun
