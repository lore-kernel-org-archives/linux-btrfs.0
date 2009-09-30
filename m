From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Benchmarking btrfs on HW Raid ... BAD
Date: Wed, 30 Sep 2009 10:35:23 -0400
Message-ID: <4AC36CAB.5000208@redhat.com>
References: <alpine.DEB.2.00.0909280955400.11292@sebohet.brgvxre.pu>  <82tyynxz2g.fsf@mid.bfk.de> <6278d2220909280219h5b38577eqc1bee1a26cbc93e1@mail.gmail.com> <alpine.DEB.2.00.0909281124410.11292@sebohet.brgvxre.pu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
	Florian Weimer <fweimer@bfk.de>, linux-btrfs@vger.kernel.org
To: Tobias Oetiker <tobi@oetiker.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0909281124410.11292@sebohet.brgvxre.pu>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/2009 05:39 AM, Tobias Oetiker wrote:
> Hi Daniel,
>
> Today Daniel J Blueman wrote:
>
>    
>> On Mon, Sep 28, 2009 at 9:17 AM, Florian Weimer<fweimer@bfk.de>  wrote:
>>      
>>> * Tobias Oetiker:
>>>
>>>        
>>>> Running this on a single disk, I get the quite acceptable results.
>>>> When running on-top of a Areca HW Raid6 (lvm partitioned)
>>>> then both read and write performance go down by at least 2
>>>> magnitudes.
>>>>          
>>> Does the HW RAID use write caching (preferably battery-backed)?
>>>        
>> I believe Areca controllers have an option for writeback or
>> writethrough caching, so it's worth checking this and that you're
>> running the current firmware, in case of errata. Ironically, disabling
>> writeback will give the OS tighter control of request latency, but
>> throughput may drop a lot. I still can't help thinking that this is
>> down to the behaviour of the controller, due to the 1-disk case
>> working well.
>>      
> it certainly is down to  a behaviour of the controller, or the
> results would be the same as with a single sata disk :-) It would
> be interesting to see what results others get on HW Raid
> Controllers ...
>
>    
>> One way would be to configure the array as 6 or 7 devices, and allow
>> BTRFS/DM to mange the array, then see if performance under write load
>> is better, and with or without writeback caching...
>>      
> I can imagine that this would help, but since btrfs aims to be
> multipurpose, this does not realy help all that much since this
> fundamentally alters the 'conditions' at the moment the RAID
> contains different filesystem and is partitioned using lvm ...
>
> cheers
> tobi
>
> the results for ext3 fs look like this ...
>
>    

I would be more suspicious of the barrier/flushes being issued. If your 
write cache is non-volatile, we really do not want to send them down to 
this type of device. Flushing this type of cache could certainly be 
very, very expensive and slow.

Try "mount -o nobarrier" and see if your performance (write cache still 
enabled on the controller) is back to expected levels,

Ric

