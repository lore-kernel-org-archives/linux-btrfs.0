From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Hang running fs_mark
Date: Thu, 25 Sep 2008 17:10:37 -0400
Message-ID: <48DBFE4D.6080100@redhat.com>
References: <20080925175643.GA14205@unused.rdu.redhat.com>	 <1222367822.7028.55.camel@think.oraclecorp.com>	 <20080925183435.GB14205@unused.rdu.redhat.com>	 <1222369531.7028.58.camel@think.oraclecorp.com> <48DBF693.20501@redhat.com> <1222376682.7028.80.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1222376682.7028.80.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Thu, 2008-09-25 at 16:37 -0400, Ric Wheeler wrote:
>   
>> Chris Mason wrote:
>>     
>>> On Thu, 2008-09-25 at 14:34 -0400, Josef Bacik wrote:
>>>   
>>>       
>>>> On Thu, Sep 25, 2008 at 02:37:02PM -0400, Chris Mason wrote:
>>>>     
>>>>         
>>>>> On Thu, 2008-09-25 at 13:56 -0400, Josef Bacik wrote:
>>>>>       
>>>>>           
>>>>>> Hello,
>>>>>>
>>>>>> Reporting this on behalf of ric.  He was running the following fs_mark command
>>>>>>
>>>>>> ./fs_mark -d /mnt/test -s 20480 -D 64 -t 8 -F
>>>>>>
>>>>>> Seems it hung and wasn't making any progress.  He managed to get some sysrq-t,
>>>>>> which is at http://people.redhat.com/jwhiter/fs-mark-hang.txt towards the bottom
>>>>>> of the document.  He could ctrl+c and unmount the fs so its not a hard hang.
>>>>>> Looks like we've just locked up behind a page lock somewhere.  I have to run off
>>>>>> to class so I can't look into it too deeply so throwing this out there hoping
>>>>>> somebody else figures it out :).  Thanks,
>>>>>>         
>>>>>>             
>>>>> Which kernel was this?
>>>>>           
>
>   
>> It actually cleaned up very nicely after I killed the fs_mark processes 
>> & unmounted the btrfs file system. Before doing that, the box was 
>> sluggish and had the feeling of a system with something that might have 
>> been spinning (but that is just an observation, not measured in any 
>> strict sense).
>>     
>
> Ok, I have that fs_mark test running here.  How far did yours get before
> it stopped?
>
> -chris
>
>   
I had gone (in heavy fsync mode) up to about 8 million files on a 1TB 
s-ata disk:

    17      8064000        20480          5.6         15301404

This is the new (no system sync() call) Chris special fs_mark.  The rate 
had been quite reasonable, starting out at around 160 20k files/sec, 
went under 100 files/sec at around 3 million files and then fell under 
50 files/sec at around 7.5 million before hitting this really low speed 
at just under 8 million.

Maybe it really was not hung, just extremely slow...

ric




