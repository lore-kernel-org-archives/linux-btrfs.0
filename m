From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Btrfs experimental branch updates
Date: Tue, 17 Mar 2009 15:57:28 -0500
Message-ID: <49C00EB8.6050200@austin.ibm.com>
References: <1236959774.17095.3.camel@think.oraclecorp.com>	 <49BAE39F.8050102@austin.ibm.com>	 <1236994421.17095.7.camel@think.oraclecorp.com>	 <49BD12E4.4070505@austin.ibm.com> <1237253089.31273.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1237253089.31273.4.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Sun, 2009-03-15 at 09:38 -0500, Steven Pratt wrote:
>   
>>> Thanks for running this, but the main performance fixes for your test
>>> are still in testing locally.  One thing that makes a huge difference on
>>> the random write run is to mount -o ssd.
>>>
>>>   
>>>       
>> Tried a run with -o ssd on the raid system. It made some minor 
>> improvements in random write performance. Helps more on odirect, but 
>> mainly at the 16thread count. Single and 128 threads it doesn't make 
>> much difference.
>>
>> Results syncing now to history boxacle
>> http://btrfs.boxacle.net/repository/raid/history/History.html
>>     
>
> Well, still completely different from my test rig ;)  For the random
> write run, yours runs at 580 trans/sec for btrfs and mine is going along
> at 8000 trans/sec.
>   
That is odd.  However, I think I have found 1 factor.  In rerunning with 
blktrace and sysrq an interesting thing happened.  The results got a lot 
faster.  What I did was just run the 128 thread odirect random write 
test.  Instead of 2.8MB/sec, I got 17MB/sec. Still far below the 100+ of 
ext4 and JFS, but one heck of a difference.  Here is what I think is 
going on.  We make use of a flag in FFSB to reuse the existing fileset 
if the fileset meets the setup criteria exactly.  For the test I am 
running that is 1024 100MB files.  Since all of the random write test 
are doing overwrites within the file, the file sizes do not change and 
therefore the fileset is valid for reuse.  For most Filesystems this is 
fine, but with BTRFS COW, this will result in a very different file 
layout at the start of each variation of the random write test.  The 
latest 128 thread was on a newly formatted FS. So...., I will do 2 new 
runs tonight.  First, I will re-mkfs before each random write test and 
otherwise run as usual.  Second, I plan on running the 128 threads test 
multiple times (5 minute runs each) to see if it does really degrade 
over time.  What worries me is that for the case describer above, we 
only have about 25 minutes of aging on the filesystem by the time we 
execute th last random write test, which is not a whole lot.

> The part that confuses me is that you seem to have some big gaps where
> just a single CPU is stuck in IO wait, and not much CPU time is in use.
>   
Yes, I have noticed that.

> Do you happen to have the blktrace logs for any of the btrfs runs?  I'd
> be interested in a script that did sysrq-w every 5s and captured the
> output.
>   
No, but as I mentioned above, I ran this today.  Had a bug collecting 
the sysrq, so I'll re-run tonight and post as soon as I can.

Steve


> -chris
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

