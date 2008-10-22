From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 06:42:18 -0400
Message-ID: <48FF038A.4010105@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com>	 <1224622451.7412.1.camel@telesto>  <48FE553D.80501@redhat.com> <1224642544.7189.17.camel@telesto>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org, Tejun Heo <tj@kernel.org>
To: Eric Anopolsky <erpo41@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224642544.7189.17.camel@telesto>
List-ID: <linux-btrfs.vger.kernel.org>

Eric Anopolsky wrote:
> On Tue, 2008-10-21 at 18:18 -0400, Ric Wheeler wrote:
>   
>> Eric Anopolsky wrote:
>>     
>>> On Tue, 2008-10-21 at 09:59 -0400, Chris Mason wrote:
>>>   
>>>       
>>>>>     - power loss at any time must not corrupt the fs (atomic fs modification)
>>>>>       (new-data loss is acceptable)
>>>>>       
>>>>>           
>>>> Done.  Btrfs already uses barriers as required for sata drives.
>>>>     
>>>>         
>>> Aren't there situations in which write barriers don't do what they're
>>> supposed to do?
>>>
>>> Cheers,
>>> Eric
>>>
>>>   
>>>       
>> If the drive effectively "lies" to you about flushing the write cache, 
>> you might have an issue. I have not seen that first hand with recent 
>> disk drives (and I have seen a lot :-))
>>     
>
> That does not match the understanding I get from reading the
> notes/caveats section of Documentation/block/barrier.txt:
>
> "Note that block drivers must not requeue preceding requests while
> completing latter requests in an ordered sequence.  Currently, no
> error checking is done against this."
>
> and perhaps more importantly:
>
> "[a technical scenario involving disk writes]
> The problem here is that the barrier request is *supposed* to indicate
> that filesystem update requests [2] and [3] made it safely to the
> physical medium and, if the machine crashes after the barrier is
> written, filesystem recovery code can depend on that.  Sadly, that
> isn't true in this case anymore.  IOW, the success of a I/O barrier
> should also be dependent on success of some of the preceding requests,
> where only upper layer (filesystem) knows what 'some' is.
>
> This can be solved by implementing a way to tell the block layer which
> requests affect the success of the following barrier request and
> making lower lever drivers to resume operation on error only after
> block layer tells it to do so.
>
> As the probability of this happening is very low and the drive should
> be faulty, implementing the fix is probably an overkill.  But, still,
> it's there."
>
> Cheers,
> Eric
>
>   
The cache flush command for ATA devices will block and wait until all of 
the device's write cache has been written back.

What I assume Tejun was referring to here is that some IO might have 
been written out to the device and an error happened when the device 
tried to write the cache back (say due to normal drive microcode cache 
destaging). The problem with this is that there is no outstanding IO 
context between the host and the storage to report the error to (i.e., 
the drive has already ack'ed the write).

If this is what is being described, there is a non-zero chance that this 
might happen, but it is extremely infrequent.  The checksumming that we 
have in btrfs will catch these bad writes when you replay the journal 
after a crash (or even when you read data blocks) so I would contend 
that this is about as good as we can do.

Tejun, Chris, does this match your understanding?

Thanks!

Ric


