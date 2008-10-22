From: Avi Kivity <avi@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 16:32:11 +0200
Message-ID: <48FF396B.1020700@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com>	 <20081021171513.GA8799@infradead.org> <48FE11F9.7040700@gmail.com>	 <20081022142759.ac33a16c.skraw@ithnet.com> <1224681345.6448.4.camel@think.oraclecorp.com> <48FF2A5B.80108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	Christoph Hellwig <hch@infradead.org>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF2A5B.80108@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote: 
> One key is not to replace the drives too early - you often can recover 
> significant amounts of data from a drive that is on its last legs. 
> This can be useful even in RAID rebuilds since with today's enormous 
> drive capacities, you might hit a latent error during the rebuild on 
> one of the presumed healthy drives.
>
> Of course, if you don't have a spare drive in your configuration, this 
> is not practical...

Why would you have a spare drive?  That's a wasted spindle.

You want to have spare capacity, enough for one or two (or fifteen) 
drives' worth of data.  When a drive goes bad, you rebuild into the 
spare capacity you have.

When you replace the drive, the filesystem moves data into the new drive 
to take advantage of the new spindle.

-- 
error compiling committee.c: too many arguments to function

