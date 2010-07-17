From: Brian Rogers <brian@xyzw.org>
Subject: Re: csum errors
Date: Fri, 16 Jul 2010 21:55:53 -0700
Message-ID: <4C4137D9.80003@xyzw.org>
References: <201007081627.24654.johannes.hirte@fem.tu-ilmenau.de> <201007152030.18431.johannes.hirte@fem.tu-ilmenau.de> <20100715190309.GI8623@think> <201007152132.13701.johannes.hirte@fem.tu-ilmenau.de> <20100715193551.GM8623@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100715193551.GM8623@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/15/2010 12:35 PM, Chris Mason wrote:
> On Thu, Jul 15, 2010 at 09:32:12PM +0200, Johannes Hirte wrote:
>    
>> Am Donnerstag 15 Juli 2010, 21:03:09 schrieb Chris Mason:
>>      
>>> On Thu, Jul 15, 2010 at 08:30:17PM +0200, Johannes Hirte wrote:
>>>        
>>>> Am Dienstag 13 Juli 2010, 14:23:58 schrieb Johannes Hirte:
>>>>          
>>>>> ino 1959333 off 898342912 csum 4271223884 private 4271223883
> Great.   The bad csums are all just one bit off, that can't be an
> accident.  When were they written (which kernel?).  Did you boot a 32
> bit kernel on there at any time?
>    

I've seen this as well, with three files. In all instances, csum == 
*private + 1. Here are the unique lines from dmesg:

[32700.980806] btrfs csum failed ino 320113 off 55889920 csum 2415136266 
private 2415136265
[32735.751112] btrfs csum failed ino 1731630 off 24776704 csum 
1385284137 private 1385284136
[32738.777624] btrfs csum failed ino 2495707 off 171790336 csum 
1385781806 private 1385781805

All three files are from when I first transitioned to btrfs (or more 
accurately, they are clones of those files I made to hold onto a copy of 
the corrupted version). Since the vast majority of my disk usage comes 
from the transition anyway, I can't be sure this is due to a problem 
only present at that time. I believe I was running 2.6.34 when I copied 
my files over to my new btrfs partition, but I'm going from memory here.

My btrfs partition has never been touched by a 32-bit kernel.

