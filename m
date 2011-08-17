From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: cant mount degraded (it worked in kernel 2.6.38.8)
Date: Wed, 17 Aug 2011 10:24:22 +0800
Message-ID: <4E4B2656.7010402@cn.fujitsu.com>
References: <CAJ1PRSnLKGkmbx3EY=DdSvont_3hUTmSzmmXpL4gi4Aw0KY4pQ@mail.gmail.com>	 <4E49E330.6060402@cn.fujitsu.com> <1313480854.2029.2.camel@pluto>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "krzf83@gmail.com" <krzf83@gmail.com>, linux-btrfs@vger.kernel.org
To: Niklas Schnelle <niklas@komani.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313480854.2029.2.camel@pluto>
List-ID: <linux-btrfs.vger.kernel.org>

Niklas Schnelle wrote:
> On Tue, 2011-08-16 at 11:25 +0800, Li Zefan wrote:
>> krzf83@gmail.com wrote:
>>> # uname -a
>>> Linux dhcppc1 3.0.1-xxxx-std-ipv6-64 #1 SMP Sun Aug 14 17:06:21 CEST
>>> 2011 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> mkdir test5
>>> cd test5
>>> dd if=/dev/null of=img5 bs=1 seek=2G
>>> dd if=/dev/null of=img6 bs=1 seek=2G
>>> losetup /dev/loop2 img5
>>> losetup /dev/loop3 img6
>>> mkfs.btrfs -d raid1 -m raid1 /dev/loop2 /dev/loop3
>>> btrfs device scan
>>> btrfs filesystem show
>>>
>>> Label: none  uuid: d7ba6c4e-04ed-49f5-88cd-8432c948e822
>>>         Total devices 2 FS bytes used 28.00KB
>>>         devid    1 size 2.00GB used 437.50MB path /dev/loop4
>>>         devid    2 size 2.00GB used 417.50MB path /dev/loop5
>>>
>>> mkdir dir
>>> mount -t btrfs /dev/loop2 dir
>>> umount dir
>>> losetup -d /dev/loop3
>>> mount -t btrfs -o degraded /dev/loop2 dir
>>>
>>> mount: wrong fs type, bad option, bad superblock on /dev/loop2,
>>>        missing codepage or other error
>>>        In some cases useful info is found in syslog - try
>>>        dmesg | tail  or so
>>
>> It works on latest kernel (3.1.0-rc2)
>>
>> --
>> Li Zefan
> 
> Shouldn't we really really have some test case for this in the test
> suite? I mean it's kinda uaccepabtle even for an experimental system to
> brake this way in a release, also will there be backports? 
> That would be helpful especially since some of the big distros will be
> stuck with 3.0 for months to come and this will (rightfully so) make
> btrfs look really bad!
> 

The situation is being improved. We're adding btrfs-specific test cases
to xfstests. I'll consider adding new ones for degraded feature.

We rarely have btrfs patches backported. I think Chris has not enough
time to do this time-consuming work, and it's not considered very
important in the current status (under heavy development and not quite
production-ready).

But if you want a specific bug to be fixed in older kernels, I think
you can find out the git commit that fixes it and send it to -stable
mailing list? See Documentation/stable_kernel_rules.txt

--
Li Zefan
