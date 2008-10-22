From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 09:27:55 -0400
Message-ID: <48FF2A5B.80108@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com>	 <20081021171513.GA8799@infradead.org> <48FE11F9.7040700@gmail.com>	 <20081022142759.ac33a16c.skraw@ithnet.com> <1224681345.6448.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	Christoph Hellwig <hch@infradead.org>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224681345.6448.4.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Wed, 2008-10-22 at 14:27 +0200, Stephan von Krawczynski wrote:
>   
>> On Tue, 21 Oct 2008 13:31:37 -0400
>> Ric Wheeler <ricwheeler@gmail.com> wrote:
>>
>>     
>>> [...]
>>> If you have remapped a big chunk of the sectors (say more than 10%), you 
>>> should grab the data off the disk asap and replace it. Worry less about 
>>> errors during read, writes indicate more serious errors.
>>>       
>> Ok, now for the bad news: money is invented.
>> If you replace a disk before real failure you won't get replacement from the
>> manufacturer. That may sound irrelevant to someone handling 5 disks, but is
>> significant if handling 500 or more. The replacement rate is indeed much
>> higher than people think from their home pcs.
>>     
>
> Hardware vendors already do replace disks based on policies defined by
> their own array hardware.  These are already predictive.
>
> -chris
>
>
>
>   
One key is not to replace the drives too early - you often can recover 
significant amounts of data from a drive that is on its last legs. This 
can be useful even in RAID rebuilds since with today's enormous drive 
capacities, you might hit a latent error during the rebuild on one of 
the presumed healthy drives.

Of course, if you don't have a spare drive in your configuration, this 
is not practical...

ric


