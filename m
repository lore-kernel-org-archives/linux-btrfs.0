Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33236 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbcEILw3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 07:52:29 -0400
Received: by mail-ig0-f180.google.com with SMTP id c3so14873872igl.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 04:52:28 -0700 (PDT)
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
To: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>,
        linux-btrfs@vger.kernel.org
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
 <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
 <20160505174854.GA1012@vader.dhcp.thefacebook.com>
 <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
 <2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
 <CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
 <f1dd07efb34a0a110f62566979530944@linuxsystems.it>
Cc: Clemens Eisserer <linuxhippy@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <799cf552-4612-56c5-b44d-59458119e2b0@gmail.com>
Date: Mon, 9 May 2016 07:52:16 -0400
MIME-Version: 1.0
In-Reply-To: <f1dd07efb34a0a110f62566979530944@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-07 12:11, Niccolò Belli wrote:
> Il 2016-05-07 17:58 Clemens Eisserer ha scritto:
>> Hi Niccolo,
>>
>>> btrfs + dmcrypt + compress=lzo + autodefrag = corruption at first boot
>>
>> Just to be curious - couldn't it be a hardware issue? I use almost the
>> same setup (compress-force=lzo instead of compress-force=lzo) on my
>> laptop for 2-3 years and haven't experienced any issues since
>> ~kernel-3.14 or so.
>>
>> Br, Clemens Eisserer
>
> Hi,
> Which kind of hardware issue? I did a full memtest86 check, a full
> smartmontools extended check and even a badblocks -wsv.
> If this is really an hardware issue that we can identify I would be more
> than happy because Dell will replace my laptop and this nightmare will
> be finally over. I'm open to suggestions.
First, some general advice:
1. It is fully possible to have bad RAM that still passes memtest86 
consistently, and in fact, most of the time this will be the case (if 
you're seeing any thing other than the bit-fade test in memtest86 fail, 
then your system probably won't boot fully).  Memtest doesn't replicate 
typical usage patterns very well.  My usual testing for RAM involves not 
just memtest, but also booting into a LiveCD (usually SystemRescueCD), 
pulling down a copy of the kernel source, and then running as many 
concurrent kernel builds as cores, each with as many make jobs as cores 
(so if you've got a quad core CPU (or a dual core with hyperthreading), 
it would be running 4 builds with -j4 passed to make).  GCC seems to 
have memory usage patterns that reliably trigger memory errors that 
aren't caught by memtest, so this generally gives good results. 
Secondarily, if it's a big system and I am not pressed for time, I do a 
quick Gentoo install with Xen, and then spin up twice as many Xen VM's 
as cores and run memtest in those concurrently (this seems to catch 
things a bit more reliably than just a plain memtest).
2. On a similar note, badblocks doesn't replicate filesystem like access 
patterns, it just runs sequentially through the entire disk.  This isn't 
as likely to give bad results, but it's still important to know.  In 
particular, try running it over a dmcrypt volume a couple of times 
(preferably with a different key each time, pulling keys from 
/dev/urandom works well for this), as that will result in writing 
different data.  For what it's worth, when I'm doing initial testing of 
new disks, I always use ddrescue to copy /dev/zero over the whole disk, 
then do it twice through dmcrypt with different keys, copying from the 
disk to /dev/null after each pass.  This gives random data on disk as a 
starting point (which is good if you're going to use dmcrypt), and 
usually triggers reallocation of any bad sectors as early as possible. 
If I have time and access to an existing system I can connect the disk 
to, I often do testing with fio as well.

Now, to slightly more specific advice:
1. If you have an eSATA port, try plugging your hard disk in there and 
see if things work.  If that works but having the hard drive plugged in 
internally doesn't, then the issue is probably either that specific SATA 
port (in which case your chip-set is bad and you should get a new 
system), or the SATA connector itself (or the wiring, but that's not as 
likely when it's traces on a PCB).  Normally I'd suggest just swapping 
cables and SATA ports, but that's not really possible with a laptop.
2. If you have access to a reasonably large flash drive, or to a USB to 
SATA adapter, try that as well, if it works on that but not internally 
(or on an eSATA port), you've probably got a bad SATA controller, and 
should get a new system.
3. Try things without dmcrypt.  Adding extra layers makes it harder to 
determine what is actually wrong.  If it works without dmcrypt, try 
using different parameters for the encryption (different ciphers is what 
I would try first).  If it works reliably without dmcrypt, then it's 
either a bug in dmcrypt (which I don't think is very likely), or it's 
bad interaction between dmcrypt and BTRFS.  If it works with some 
encryption parameters but not others, then that will help narrow down 
where the issue is.
