From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: btrfs for enterprise raid arrays
Date: Fri, 03 Apr 2009 08:02:50 -0400
Message-ID: <49D5FAEA.70805@redhat.com>
References: <B7F26A02AFF8EB44B8635EB1D34BAC2C0536C8BF@USSCCEVS102.corp.hds.com>	 <49D5F679.6060702@redhat.com> <1238759880.3494.5.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Erwin van Londen <erwin.vanlonden@hds.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>,
	James Bottomley <JBottomley@Novell.com>,
	"willy@linux.intel.com" <willy@linux.intel.com>,
	Tom Coughlan <coughlan@redhat.com>
To: David Woodhouse <david.woodhouse@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1238759880.3494.5.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

David Woodhouse wrote:
> On Fri, 2009-04-03 at 12:43 +0100, Ric Wheeler wrote:
>   
>>> New firmware/microcode versions are able to reclaim that space if it
>>> sees a certain number of consecutive zero's and will reclaim that 
>>> space to the volume pool. Are there any thoughts on writing a 
>>> low-priority tread that zeros out those "non-used" blocks?
>>>       
>> Patches have been floating around to support this - see the recent 
>> patches around "DISCARD" on linux-ide and lkml.  It would be great to 
>> get access to a box that implemented the T10 proposed UNMAP commands 
>> that we could test against. 
>>     
>
> We've already made btrfs support TRIM, and Matthew has patches which
> hook it up for ATA/IDE devices. Adding SCSI support shouldn't be hard
> once the dust settles on the spec.
>
> I don't think I've seen anybody talking about deliberately writing
> zeroes instead of just issuing a discard command though. That doesn't
> seem like a massively cunning plan.
>
>   
What the SCSI spec says is that you can use "WRITE SAME" with a discard 
bit set.  What the array would do with that is array dependent - it 
could in fact write that same block out to each of the blocks if it 
chooses to do so. The intention would be, of course, to manipulate 
internal array tracking so that you do no IO.

We should avoid doing that command to arrays that don't really implement 
the unmap part, it could take a long time to complete a single largish 
discard request :-)

The nice part of the write same with unmap flavour of the T10 command is 
that it is very clear about the semantics of what you should get back,

Ric

