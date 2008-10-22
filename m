From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 09:38:56 -0400
Message-ID: <48FF2CF0.60708@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com>	 <1224622451.7412.1.camel@telesto> <48FE553D.80501@redhat.com>	 <1224642544.7189.17.camel@telesto> <48FF038A.4010105@redhat.com>	 <48FF0625.6040400@kernel.org> <48FF2343.3070107@redhat.com>	 <48FF276B.6090602@kernel.org> <1224681593.6448.7.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Tejun Heo <tj@kernel.org>, Eric Anopolsky <erpo41@gmail.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224681593.6448.7.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Wed, 2008-10-22 at 22:15 +0900, Tejun Heo wrote:
>   
>> Ric Wheeler wrote:
>>     
>>> I think that we do handle a failure in the case that you outline above
>>> since the FS will be able to notice the error before it sends a commit
>>> down (and that commit is wrapped in the barrier flush calls). This is
>>> the easy case since we still have the context for the IO.
>>>       
>> I'm no FS guy but for that to be true FS should be waiting for all the
>> outstanding IOs to finish before issuing a barrier and actually
>> doesn't need barriers at all - it can do the same with flush_cache.
>>
>>     
>
> We wait and then barrier.  If the barrier returned status that a
> previously ack'd IO had actually failed, we could do something to make
> sure the FS was consistent.
>
> -chris
>
>
>   
As I mentioned in a reply to Tejun, I am not sure that we can count on 
the barrier op giving us status for IO's that failed to destage cleanly.

Waiting and then doing the FLUSH seems to give us the best coverage for 
normal failures (and your own testing shows that it is hugely effective 
in reducing some types of corruption at least :-)).

If you look at the types of common drive failures, I would break them 
into two big groups. 

The first group would be transient errors - i.e., this IO fails (usually 
a read), but a subsequent IO will succeed with or without a sector 
remapping happening.  Causes might be:

    (1) just a bad read due to dirt on the surface of the drive - the 
read will always fail, a write might clean the surface and restore it to 
useful life.
    (2) vibrations (dropping your laptop, rolling a big machine down the 
data center, passing trains :-))
    (3) adjacent sector writes - hot spotting on drives can degrade the 
data on adjacent tracks. This causes IO errors on reads for data that 
was successfully written before, but the track itself is still perfectly 
fine.

All of these first types of errors need robust error handling on IO 
errors (i.e., quickly fail, check for IO errors and isolate the impact 
of the error as best as we can) but do not indicate a bad drive.

The second group would be persistent failures - no matter what you do to 
the drive, it is going to kick the bucket! Common causes might be:

    (1) a few bad sectors (1-5% of the drive's remapped sector table for 
example).
    (2) a bad disk head - this is a very common failure, you will see a 
large amount of bad sectors.
    (3) bad components (say bad memory chips in the write cache) can 
produce consistent errors
    (4) failure to spin up (total drive failure).

The challenging part is to figure out as best as we can how to 
differentiate the causes of IO failures or checksum failures and to 
respond correctly.  Array vendors spend a lot of time pulling out hair 
trying to do predictive drive failure, but it is really, really hard to 
get correct...

ric


