From: Avi Kivity <avi@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 16:40:28 +0200
Message-ID: <48FF3B5C.8000908@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com>	 <20081021171513.GA8799@infradead.org> <48FE11F9.7040700@gmail.com>	 <20081022142759.ac33a16c.skraw@ithnet.com>	 <1224681345.6448.4.camel@think.oraclecorp.com> <48FF2A5B.80108@redhat.com>	 <48FF396B.1020700@redhat.com> <1224686215.6448.49.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	Christoph Hellwig <hch@infradead.org>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224686215.6448.49.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
>> You want to have spare capacity, enough for one or two (or fifteen) 
>> drives' worth of data.  When a drive goes bad, you rebuild into the 
>> spare capacity you have.
>>
>>     
>
> You want spare capacity that does not degrade your raid levels if you
> move the data onto it.  In some configs, this will be a hot spare, in
> others it'll just be free space.
>   

What kind of configuration would prefer a spare disk to spare capacity?  
RAID6 with a small number of disks?

-- 
error compiling committee.c: too many arguments to function

