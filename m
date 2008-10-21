From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 18:18:37 -0400
Message-ID: <48FE553D.80501@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com> <1224622451.7412.1.camel@telesto>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Eric Anopolsky <erpo41@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224622451.7412.1.camel@telesto>
List-ID: <linux-btrfs.vger.kernel.org>

Eric Anopolsky wrote:
> On Tue, 2008-10-21 at 09:59 -0400, Chris Mason wrote:
>   
>>>     - power loss at any time must not corrupt the fs (atomic fs modification)
>>>       (new-data loss is acceptable)
>>>       
>> Done.  Btrfs already uses barriers as required for sata drives.
>>     
>
> Aren't there situations in which write barriers don't do what they're
> supposed to do?
>
> Cheers,
> Eric
>
>   
If the drive effectively "lies" to you about flushing the write cache, 
you might have an issue. I have not seen that first hand with recent 
disk drives (and I have seen a lot :-))

Ric


