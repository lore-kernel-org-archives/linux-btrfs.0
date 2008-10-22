From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 11:25:34 -0400
Message-ID: <48FF45EE.7010001@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com>	 <20081021171513.GA8799@infradead.org> <48FE11F9.7040700@gmail.com>	 <20081022142759.ac33a16c.skraw@ithnet.com> <1224681345.6448.4.camel@think.oraclecorp.com> <48FF2A5B.80108@redhat.com> <48FF396B.1020700@redhat.com> <48FF3CB9.6070404@redhat.com> <48FF3EB8.6050306@redhat.com> <48FF4082.407@redhat.com> <48FF4302.5030204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	Christoph Hellwig <hch@infradead.org>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF4302.5030204@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Avi Kivity wrote:
> Ric Wheeler wrote:
>>>
>>> Well, btrfs is not about duplicating how most storage works today.  
>>> Spare capacity has significant advantages over spare disks, such as 
>>> being able to mix disk sizes, RAID levels, and better performance.
>>
>> Sure, there are advantages that go in favour of one or the other 
>> approaches. But btrfs is also about being able to use common hardware 
>> configurations without having to reinvent where we can avoid it (if 
>> we have a working RAID or enough drives to do RAID5 with spares or 
>> RAID6, we want to be able to delegate that off to something else if 
>> we can).
>
> Well, if you have an existing RAID (or have lots of $$$ to buy a new 
> one), you needn't tell Btrfs about it.  Just be sure not to enable 
> Btrfs data redundancy, or you'll have redundant redundancy, which is 
> expensive.
>
> What Btrfs enables with its multiple device capabilities is to 
> assemble a JBOD into a filesystem-level data redundancy system, which 
> is cheaper, more flexible (per-file data redundancy levels), and 
> faster (no need for RMW, since you're always COWing).
I think that the btrfs plan is still to push more complicated RAID 
schemes off to MD (RAID6, etc) so this is an issue even with a JBOD. It 
will be interesting to map out the possible ways to use built in 
mirroring, etc vs the external RAID and actually measure the utilized 
capacity and performance (online & during rebuilds).
>
>> The major difficulty with the spare capacity model is that your 
>> recovery is not as simple and well understood as RAID rebuilds. 
>
> That's Chris's problem. :-)
Unless he can pawn it off on some other lucky developer :-)

>
>> If you assume that whole drives fail under btrfs mirroring, you are 
>> not really doing anything more than simple RAID, or do I 
>> misunderstand your suggestion?
>
> I do assume that whole drives fail, but RAIDing and rebuilding is file 
> level.  So one extent on a failed disk might be part of a mirrored 
> file, while another extent can be part of a 14-member RAID6 extent.
>
> A rebuild would iterate over all disk extents (making use of the 
> backref tree), determine which file contains that extent, and rebuild 
> that extent using spare storage on other disks.
>
>> I don't see the point about head seeking. In RAID, you also have the 
>> same layout so you minimize head movement (just move more heads per 
>> IO in parallel).
>
> Suppose you have 5 disks with 1 spare.  Suppose you are reading from a 
> full fs.  On a disk-level RAID, all disks are full.  So you have 5 
> spindles seeking over 100% of the disk surface.  With spare capacity, 
> you have 6 disks which are 5/6 full (retaining the same utilization as 
> old-school RAID).  So you have 6 spindles, each with a seek range that 
> is 5/6 of a whole disk, so more seek heads _and_ faster individual seeks.
>
I think that this is somewhat correct, but most likely offset by the 
performance levels of streaming IO vs IO with any seeks (at least for 
full file systems). Certainly, the spare capacity model is increasingly 
better when you have really light utilized file systems...

Don't think that I am arguing against the model, just saying that it is 
not always as clear cut as you might think....

ric

