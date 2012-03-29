From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "not enough space" with "data raid0"
Date: Thu, 29 Mar 2012 01:07:05 +0000 (UTC)
Message-ID: <pan.2012.03.29.01.07.05@cox.net>
References: <C52pxfli1uB@helmut.hullen.de>
	<20120317121909.GB3172@carfax.org.uk> <4F735AB8.40301@ubuntu.com>
	<loom.20120329T000904-903@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Alex posted on Wed, 28 Mar 2012 22:11:01 +0000 as excerpted:

> Phillip Susi <psusi <at> ubuntu.com> writes:
> 
> 
>> So currently btrfs's concept of raid0 is "stripe across as many disks
>> as possible, with a minimum of 2 disks".  Is there any reason for that
>> minimum?  I don't see why it can't allow only one if that's the best it
>> can manage.
>> 
> That's called "Single". http://btrfs.ipv5.de/index.php?title=Mkfs.btrfs

It's called "single" if you deliberately create it that way, yes.  

However, Phillip's point was, I believe, that if a striped set can start 
with say five devices of varying size and drop one at a time as the 
smallest devices run out of space, there's no reason it should stop at 
two devices.  If the goal is maximum performance, it should insist on 
using only the space available in parallel across all devices and should 
refuse to drop even a single one.  If OTOH, the goal is maximum 
utilization of available space, with a secondary goal of performance if 
at all possible, then it should drop devices all the way down to a single 
device, not stopping at two.

Since btrfs apparently is already content to drop from say five devices 
to two despite the performance drop on the way, there's no fundamental 
reason it should stop there; it should continue all the way down to a 
single device, even tho when it gets to that point it's no longer 
actually striped.

Of course, that's defining the behavior I'd expect of a mature btrfs.  
Right now, it's still experimental, with many missing features.  If at 
this point there's and arbitrary line drawn at two devices minimum, 
that's just the way it is.  But I'd not expect that line to be there when 
the filesystem is declared mature and fully ready for use.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

