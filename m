From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New experimental btrfs branch ready for testing
Date: Fri, 5 Jun 2009 20:20:21 -0400
Message-ID: <20090606002021.GE3824@think>
References: <20090601210447.GC3890@think> <4A281A3C.6000006@austin.ibm.com> <20090605142008.GB6942@think> <4A294194.6050006@austin.ibm.com> <4A298DDB.6070002@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A298DDB.6070002@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 05, 2009 at 04:27:55PM -0500, Steven Pratt wrote:
> Steven Pratt wrote:
>> Chris Mason wrote:
>>> On Thu, Jun 04, 2009 at 02:02:20PM -0500, Steven Pratt wrote:
>>>  
>>>> Chris Mason wrote:
>>>>    
>>>>> Hello everyone,
>>>>>
>>>>> Yan Zheng has been doing some major surgery to the back references and
>>>>> extent allocation code, tackling bottlenecks in the code that tracks
>>>>> extents.  It scales better with many snapshots and performs better in
>>>>> the common case of no snapshots at all.
>>>>>
>>>>> THE NEW CODE IS A FORWARD ROLLING DISK FORMAT CHANGE.  This means 
>>>>> it is
>>>>> compatible with the current btrfs disk format, but once you mount a
>>>>> filesystem with the new code, it WILL NO LONGER BE MOUNTABLE FROM OLD
>>>>> KERNELS.  Old kernels spit out an error message when you try them 
>>>>> on new
>>>>> format filesystems.
>>>>>
>>>>> This is a large change, and I'm hoping to have it stable in time  
>>>>> for the
>>>>> 2.6.31 merge window.  I've been testing it for about a week now, and
>>>>> haven't been able to cause major problems yet.  But, testing the
>>>>> compatibility with old format filesystems is the hard part, and
>>>>> everyone that pulls the new code should backup their data first.
>>>>>
>>>>> I've setup git branches called newformat where you can pull the 
>>>>> new code.
>>>>>
>>>>> For the kernel (based on 2.6.30-rc7):
>>>>>
>>>>> git pull  
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git 
>>>>> newformat
>>>>>
>>>>>         
>>>> So I started the performance runs on this. The base tests completed 
>>>> fine  on the raid system and I will post results as soon as I can  
>>>> finish  postprocessing, but when I tried to do nodatacow that  
>>>> machine it crashed  pretty early. Here is console log:
>>>>     
>>>
>>> Hi Steve,
>>>
>>> Thanks again for hammering on these.  Yan Zheng and I have both been
>>> trying to reproduce problems with nodatacow and with the database random
>>> write run.
>>>   
>> So now that the raid machine is actually up, I discovered it got  
>> further than I thought on nodatacow. It did all the read tests, but  
>> appeared to died on 16 thread random write(not odirect). There were no  
>> messages logged to var/log/messages at all. Last I saw was :
>>
>> Jun  4 03:14:24 btrfs1 kernel: [65856.065491] btrfs: setting nodatacow
>> Jun  4 15:24:45 btrfs1 syslogd 1.4.1: restart.
>>
>> Just dead until we rebooted machine later that day.
>
> So the raid system complete the re-run of the nodatacow runs without  
> error.  So still no idea what happened on this box the first time  
> around.  As for the single disk system, it died during the random write  
> test again, but it now looks like we might have a real HW failure.  This  
> time we see SCSI error messages.  I have replaced the test disks and  
> will try one more time.
>
> The net is, I would hold off digging too much into this as even I don't  
> have any repeatable errors.

Thanks for rerunning all of this, appreciate the update.

-chris

