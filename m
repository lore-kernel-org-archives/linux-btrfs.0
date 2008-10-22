From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 08:57:29 -0400
Message-ID: <48FF2339.9080106@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com>	 <1224622451.7412.1.camel@telesto>  <48FE553D.80501@redhat.com> <1224642544.7189.17.camel@telesto> <48FF038A.4010105@redhat.com> <48FF0625.6040400@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Anopolsky <erpo41@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF0625.6040400@kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tejun Heo wrote:
> Ric Wheeler wrote:
>   
>> The cache flush command for ATA devices will block and wait until all of
>> the device's write cache has been written back.
>>
>> What I assume Tejun was referring to here is that some IO might have
>> been written out to the device and an error happened when the device
>> tried to write the cache back (say due to normal drive microcode cache
>> destaging). The problem with this is that there is no outstanding IO
>> context between the host and the storage to report the error to (i.e.,
>> the drive has already ack'ed the write).
>>
>> If this is what is being described, there is a non-zero chance that this
>> might happen, but it is extremely infrequent.  The checksumming that we
>> have in btrfs will catch these bad writes when you replay the journal
>> after a crash (or even when you read data blocks) so I would contend
>> that this is about as good as we can do.
>>     
>
> Please consider the following scenario.
>
> 1. FS issues lots of writes which are queued in the block elevator.
> 2. FS issues barrier.
> 3. Elevator pushes out all the writes.
> 4. One of the writes fails for some reason.  Media failure or what
>    not.  Failure is propagated to upper layer.
> 5. Whether there was preceding failure or not, block queue processing
>    continues and writes out all the pending requests.
> 6. Elevator issues FLUSH and it gets executed by the device.
> 7. Elevator issues barrier write and it gets executed by the device.
> 8. *POWER LOSS*
>
> The thing is that currently there is no defined way for FS to take
> action after #4 once happens unless it waits for all outstanding
> writes to complete before issuing the barrier.  One way to solve this
> would be to make the failure status sticky such that any barrier
> following any number of uncleared errors will fail too, so that the
> filesystem can think about what it should do with the write failure.
>
> Thanks.
>   
I think that we do handle a failure in the case that you outline above 
since the FS will be able to notice the error before it sends a commit 
down (and that commit is wrapped in the barrier flush calls). This is 
the easy case since we still have the context for the IO.

It is more challenging  (and kind of related) if the IO done in (4) has 
been ack'ed by drive, the drive later destages (not as part of the 
flush) its write cache and then an error happens. In this case, there is 
nothing waiting on the initiator side to receive the IO error. We have 
effectively lost the context for that IO.

The only way to detect this is on replay (if the journal has checksums 
enabled or the error will be flagged as a media error).

Ric


