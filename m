From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 11:02:26 -0400
Message-ID: <48FF4082.407@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com>	 <20081021171513.GA8799@infradead.org> <48FE11F9.7040700@gmail.com>	 <20081022142759.ac33a16c.skraw@ithnet.com> <1224681345.6448.4.camel@think.oraclecorp.com> <48FF2A5B.80108@redhat.com> <48FF396B.1020700@redhat.com> <48FF3CB9.6070404@redhat.com> <48FF3EB8.6050306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	Christoph Hellwig <hch@infradead.org>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF3EB8.6050306@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Avi Kivity wrote:
> Ric Wheeler wrote:
>>> You want to have spare capacity, enough for one or two (or fifteen) 
>>> drives' worth of data.  When a drive goes bad, you rebuild into the 
>>> spare capacity you have.
>>
>> That is a different model (and one that makes sense, we used that in 
>> Centera for object level protection schemes). It is a nice model as 
>> well, but not how most storage works today.
>
> Well, btrfs is not about duplicating how most storage works today.  
> Spare capacity has significant advantages over spare disks, such as 
> being able to mix disk sizes, RAID levels, and better performance.

Sure, there are advantages that go in favour of one or the other 
approaches. But btrfs is also about being able to use common hardware 
configurations without having to reinvent where we can avoid it (if we 
have a working RAID or enough drives to do RAID5 with spares or RAID6, 
we want to be able to delegate that off to something else if we can).
>
>>>
>>> When you replace the drive, the filesystem moves data into the new 
>>> drive to take advantage of the new spindle.
>>>
>>
>> When you buy a storage solution (hardware or software), the key here 
>> is "utilized capacity." If you have an enclosure that can host say 
>> 12-15 drives in a 2U enclosure, people normally leave one drive as 
>> spare.  RAID6 is another way to do this. You can do a 4+2 and 4+2 
>> with 66% utilized capacity in RAID 6 or possibly a RAID5 scheme using 
>> like 5+1 and 4+1 with one global spare (75% utilized capacity).
>>
>> That gives you the chance to do  rebuild your RAID group without 
>> having to physically visit the data center. You can also do fancy 
>> stuff with the spare (like migrate as many blocks as possible before 
>> the RAID rebuild to that spare) which reduces your exposure to the 
>> 2nd drive failure and speeds up your rebuild time.
>>
>> In the end, whether you use a block based RAID solution or an object 
>> based solution, you just need to figure out how to balance your 
>> utilized capacity against performance and data integrity needs.
>
> In both models (spare disk and spare capacity) the storage utilization 
> is the same, or nearly so.  But with spare capacity you get better 
> performance since you have more spindles seeking for your data, and 
> since less of the disk surface is occupied by data, making your seeks 
> shorter.
>
True, you can get more performance if you use all of the hardware you 
have all of the time.

The major difficulty with the spare capacity model is that your recovery 
is not as simple and well understood as RAID rebuilds. If you assume 
that whole drives fail under btrfs mirroring, you are not really doing 
anything more than simple RAID, or do I misunderstand your suggestion?

I don't see the point about head seeking. In RAID, you also have the 
same layout so you minimize head movement (just move more heads per IO 
in parallel).

ric
