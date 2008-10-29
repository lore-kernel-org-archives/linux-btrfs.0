From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: File System Performance results
Date: Wed, 29 Oct 2008 16:49:04 -0500
Message-ID: <4908DA50.5010400@austin.ibm.com>
References: <48FF87CE.2090502@austin.ibm.com> <1225308408.6448.287.camel@think.oraclecorp.com> <4908C21D.5080302@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4908C21D.5080302@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Steven Pratt wrote:
> Chris Mason wrote:
>> On Wed, 2008-10-22 at 15:06 -0500, Steven Pratt wrote:
>>  
>>> We have set up a new page which is intended mainly for tracking the 
>>> performance of BTRFS, but in doing so we are testing other 
>>> filesystems as well (ext3, ext4, xfs and jfs).  Thought some people 
>>> here might find the results useful.
>>>     
>>
>> I think I understand the bad read performance in btrfs.  I was forcing a
>> tiny max readahead size.
>>
>> The current git tree has fixes for it, along with a ton of new code.
>>   
> Ok, we'll kick off some new runs.
>
> Also, just need to push out the data fro odirect random write and mail 
> server with fsync.
> Steve
We have completed testing on the random write tests with odirect.  
Results can be found at:
Single disk:
http://btrfs.boxacle.net/repository/single-disk/Oct28-odirect-random-writes/Oct28-odirect-random-writes.html
Raid:
http://btrfs.boxacle.net/repository/raid/Oct28-odirect-random-writes/Oct28-odirect-random-writes.html

Also, the changes to the mail server emulation to use fsync on the 
creates is also complete:
Single disk:
http://btrfs.boxacle.net/repository/single-disk/Oct28-mail-server-fsync-creates/Oct28-mail-server-fsync-creates.html
Raid:
http://btrfs.boxacle.net/repository/raid/Oct28-mail-server-fsync-creates/mail-server-fsync-creates.html

Steve

>
>> -chris
>>
>>   
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

