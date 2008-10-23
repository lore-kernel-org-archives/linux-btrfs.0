From: Tejun Heo <tj@kernel.org>
Subject: Re: Some very basic questions
Date: Thu, 23 Oct 2008 12:59:36 +0900
Message-ID: <48FFF6A8.3000305@kernel.org>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com>	 <1224622451.7412.1.camel@telesto>  <48FE553D.80501@redhat.com> <1224642544.7189.17.camel@telesto> <48FF038A.4010105@redhat.com> <48FF0625.6040400@kernel.org> <48FF2343.3070107@redhat.com> <48FF276B.6090602@kernel.org> <48FF296F.9060009@redhat.com> <48FF515B.2030209@kernel.org> <48FF5621.6020902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Anopolsky <erpo41@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF5621.6020902@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote:
>> FS waiting for completion of all the dependent writes isn't too good
>> latency and throughput-wise tho.  It would be best if FS can indicate
>> dependencies between write commands and barrier so that barrier
>> doesn't have to empty the whole queue.  Hmm... Can someone tell me how
>> much such scheme would help?
>>
>>   
> I think that this is where SCSI ordered tags come in (or similar
> schemes). The idea would be to have tag all IO. You bump the tag, for
> example after you send down the journal data blocks to a new tag which
> is used for the commit block data sequence.
> 
> The ordering would require that lower ranked tags must all be destaged
> to persistent storage before a subsequent tag is written out.
> 
> The T13 had a microsoft proposal that is in this area:
> 
> http://www.t13.org/Documents/UploadedDocuments/docs2007/e07174r0-Write_Barrier_Command_Proposal.doc

Yeah, that's one thing although it still has the
undetected-write-errors in front of barrier problem (SCSI spec doesn't
have a way to detect that).

There's another queue, which can be considerably larger than the
on-device buffer - the block elevator queue.  Currently, as the
elevator doesn't know what's dependent on what, it has to dump the
whole content of elevator before doing barrier.  I don't know how much
it would help to do it selectively tho.

Thanks.

-- 
tejun
