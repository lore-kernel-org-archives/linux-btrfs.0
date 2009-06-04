From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New experimental btrfs branch ready for testing
Date: Thu, 4 Jun 2009 15:05:40 -0400
Message-ID: <20090604190540.GC555@think>
References: <20090601210447.GC3890@think> <4A281A3C.6000006@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A281A3C.6000006@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 04, 2009 at 02:02:20PM -0500, Steven Pratt wrote:
> Chris Mason wrote:
>> Hello everyone,
>>
>> Yan Zheng has been doing some major surgery to the back references and
>> extent allocation code, tackling bottlenecks in the code that tracks
>> extents.  It scales better with many snapshots and performs better in
>> the common case of no snapshots at all.
>>
>> THE NEW CODE IS A FORWARD ROLLING DISK FORMAT CHANGE.  This means it is
>> compatible with the current btrfs disk format, but once you mount a
>> filesystem with the new code, it WILL NO LONGER BE MOUNTABLE FROM OLD
>> KERNELS.  Old kernels spit out an error message when you try them on new
>> format filesystems.
>>
>> This is a large change, and I'm hoping to have it stable in time for the
>> 2.6.31 merge window.  I've been testing it for about a week now, and
>> haven't been able to cause major problems yet.  But, testing the
>> compatibility with old format filesystems is the hard part, and
>> everyone that pulls the new code should backup their data first.
>>
>> I've setup git branches called newformat where you can pull the new code.
>>
>> For the kernel (based on 2.6.30-rc7):
>>
>> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git newformat
>>
>>   
> So I started the performance runs on this. The base tests completed fine  
> on the raid system and I will post results as soon as I can finish  
> postprocessing, but when I tried to do nodatacow that machine it crashed  
> pretty early. Here is console log:

Thanks Steve.  Just to clarify, which commit was the head of your git
tree when you ran these tests?

-chris
