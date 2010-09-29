From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: Francis Galiegue would like your help testing a survey
Date: Wed, 29 Sep 2010 08:11:48 -0700
Message-ID: <4CA35734.8080300@noir.com>
References: <201009281427.o8SERvXj025316@84872-app3.sgizmo.com>	<4CA2092A.8020207@noir.com> <AANLkTikoYwSkVyTqX1LLLzCDp_nELVxm7WqJa1ffqkZb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Francis Galiegue <fgaliegue@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikoYwSkVyTqX1LLLzCDp_nELVxm7WqJa1ffqkZb@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  On 9/28/10 11:47 , Francis Galiegue wrote:
> As to file system hardening, what do you mean apart from checksums?
> Fundamental filesystem design?
I specifically mean the intended ability to survive a power failure.

Historically, unix file systems lived in the disk cache such that a 
power failure would result in a polluted file system.  This would 
require an fsck pass to clear out the errors and "recover" the file 
system although data lost was still data lost.

A while back, (some time in the 90's), most unix file systems were 
"hardened" such that a power failure would generally _not_ result in a 
file system pollution.  Ext2 is not hardened.  Ext3 has an optional 
journal which provides file system hardening.

Ext2 is faster than ext3 but also suffers from smaller file system size 
limits.  Btrfs, in "-m single -d single" mode is hardened and competes 
favorably against ext2 for speed.  All other linux file systems are 
either not hardened, slower, or both.  (Although nilfs2 is also hardened 
and somewhere between ext2 and ext3 speeds.)
>> #15 presupposes it's own answer.  While I've had no filesystems fail, every
>> machine I use with btrfs file systems has failed numerous times -
>> pathological behavior, kernel crashes, etc.  In the absence of a btrfsck I
>> can't be sure that the file system has actually failed although rebuilding
>> the file system seems to alleviate the symptoms temporarily.
> I don't really see your point here. Can you elaborate? And yes, I _do_
> mean filesystem failures, not machine failure. I made that explicit.
It's simple.  I can't tell if I've had file system pollution because we 
don't have a functional btrfsck.  I only know that I have file systems 
which have reached a state where the kernel was unable to use them 
constructively.  I can't tell whether this state was due to a data error 
in the file system or a coding error in the file system driver which 
couldn't cope with a valid state of the file system.
>> #16 presupposes a failure mode. Again, my issues have more to do with
>> stability than with clear cases of file system pollution
> Point taken, but again, this is on purpose, I talk here about hosed
> filesystems indeed.
Then I think you need to ask the same question again with respect to 
system failures due to btrfs which aren't necessarily file system failures.

Imagine this for a moment - pretend that any time btrfs were in your 
kernel your kernel were only capable of network speeds of 1Mbps.  Data 
was correct both in your btrfs file systems and in your network 
interfaces - but you were horribly restricted in your network 
interfaces.  This would not represent a polluted btrfs file system and 
yet it would clearly represent a "broken" system by most people's 
definitions.  It's these cases I'm looking to see represented in the 
questionnaire because these are the types of failures I've been seeing.  
And in the absence of a reliable btrfsck, we can't really determine the 
existence of file system pollution anyway - we can only guess that we 
might have polluted file systems.

--rich
