From: Avi Kivity <avi@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 17:43:19 +0200
Message-ID: <48FF4A17.80204@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <48FDD710.5050702@hp.com> <20081021190136.89b2c6af.skraw@ithnet.com>	 <20081021171513.GA8799@infradead.org> <48FE11F9.7040700@gmail.com>	 <20081022142759.ac33a16c.skraw@ithnet.com>	 <1224681345.6448.4.camel@think.oraclecorp.com> <48FF2A5B.80108@redhat.com>	 <48FF396B.1020700@redhat.com> <48FF3CB9.6070404@redhat.com>	 <48FF3EB8.6050306@redhat.com> <48FF4082.407@redhat.com>	 <48FF4302.5030204@redhat.com>  <48FF45EE.7010001@redhat.com> <1224689639.6448.72.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	Christoph Hellwig <hch@infradead.org>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224689639.6448.72.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> One problem with the spare
> capacity model is the general trend where drives from the same batch
> that get hammered on in the same way tend to die at the same time.  Some
> shops will sleep better knowing there's a hot spare and that's fine by
> me.
>   

How does hot sparing help?  All your disks die except the spare.

Of course, I've no objection to disk sparing as an additional option; I 
just feel that capacity sparing is superior.

-- 
error compiling committee.c: too many arguments to function

