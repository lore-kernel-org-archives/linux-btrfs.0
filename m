From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: New data=ordered code pushed out to btrfs-unstable
Date: Fri, 18 Jul 2008 18:35:43 -0400
Message-ID: <48811ABF.5010606@gmail.com>
References: <1216398992.6932.36.camel@think.oraclecorp.com>	 <4880F87B.7020908@gmail.com> <1216411969.6932.70.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216411969.6932.70.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Fri, 2008-07-18 at 16:09 -0400, Ric Wheeler wrote:
> 
>> Just to kick the tires, I tried the same test that I ran last week on 
>> ext4. Everything was going great, I decided to kill it after 6 million 
>> files or so and restart.
>>
>> The unmount has taken a very, very long time - seems like we are 
>> cleaning up the pending transactions at a very slow rate:
>>
> 
> This is a known problem, Yan will take care of it next week.  You've got
> the right idea, cleaning old snapshots does more IO than it should.
> 
> The good news is that if you hit reset and mount again, it'll pick up
> where it left off.  The bad news is it'll be be just as slow as last
> time around ;)
> 
>> Jul 18 16:06:04 localhost kernel: cleaner awake
>> Jul 18 16:06:04 localhost kernel: cleaner done
>> Jul 18 16:06:34 localhost kernel: trans 188 in commit
>> Jul 18 16:06:35 localhost kernel: trans 188 done in commit
> 
> And these I meant to get rid of
> 
> -chris
> 
> 

I will just restart it to get the timings. It was looking quite good in the 
initial few data points,

ric

