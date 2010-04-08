From: Avi Kivity <avi@redhat.com>
Subject: Re: Poor performance with qemu
Date: Thu, 08 Apr 2010 18:28:54 +0300
Message-ID: <4BBDF636.5010002@redhat.com>
References: <201003281718.03699.diegocg@gmail.com> <20100330125623.GB13190@think> <4BBDEF09.70306@redhat.com> <20100408152615.GI1400@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100408152615.GI1400@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/08/2010 06:26 PM, Chris Mason wrote:
>>
>>> Once the O_DIRECT read patch is in, you can switch to that, or tell qemu
>>> to use a writeback cache instead.
>>>        
>> Even with writeback qemu will issue a lot of fsyncs.
>>      
> Oh, I didn't see that when I was testing, when does it fsync?
>    

When it updates qcow2 metadata or when the guest issues a barrier.  It's 
relatively new.  I have a patch that introduces cache=volatile somewhere.

-- 
error compiling committee.c: too many arguments to function

