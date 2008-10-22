From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 15:59:13 -0400
Message-ID: <48FF8611.4050600@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com>	 <1224622451.7412.1.camel@telesto>  <48FE553D.80501@redhat.com> <1224642544.7189.17.camel@telesto> <48FF038A.4010105@redhat.com> <48FF0625.6040400@kernel.org> <48FF2343.3070107@redhat.com> <48FF276B.6090602@kernel.org> <48FF296F.9060009@redhat.com> <48FF515B.2030209@kernel.org> <48FF71BA.8040206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Tejun Heo <tj@kernel.org>, Eric Anopolsky <erpo41@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF71BA.8040206@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Avi Kivity wrote:
> Tejun Heo wrote:
>> For most SATA drives, disabling write back cache seems to take high
>> toll on write throughput.  :-(
>>
>>   
>
> I measured this yesterday.  This is true for pure write workloads; for 
> mixed read/write workloads the throughput decrease is negligible.
>
Depends on your workload, I have measured (back at Centera) a 
significant win for mixed read/write as well (at least 20%) depending on 
file size.

>> As long as the error status is sticky, it doesn't have to hold on to
>> the data, it's not gonna be able to write it anyway.  The drive has to
>> hold onto the failure information only.  Yeah, but fully agreed on
>> that it's most likely dependent on the specific firmware.  There isn't
>> any requirement on how to handle write back failure in the ATA spec.
>> It wouldn't be too surprising if there are some drives which happily
>> report the old data after silent write failure followed by flush and
>> power loss at the right timing.
>
> I got flamed for this on another list, but let's disable the write 
> cache and live with the performance drop.
>

Won't ever happen, no one wants to lose 50% of their performance :-)

ric


