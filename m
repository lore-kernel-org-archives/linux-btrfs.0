From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: scrub: Inappropriate ioctl for device
Date: 01 Nov 2011 22:10:00 +0100
Message-ID: <Bx1GE1Pi1uB@helmut.hullen.de>
References: <20111101200832.GA552@zambezi.lan>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101200832.GA552@zambezi.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Ilya,

Du meintest am 01.11.11:

>> Mounting doesn't work immediately; most times I have to run the
>> "mount" command three times - strange.

> To be able to run mount only once you have to run 'btrfs dev scan' on
> startup (after each reboot or just before mounting).

That command has run, without any error.

There seems to be another problem.

>> When I run
>>
>>        btrfs scrub start -r /dev/sdb1
>>
>> (or another of the three disks) then I only get the error message
>>
>>   ERROR: getting dev info for scrub failed: Inappropriate ioctl for
>>     device

> Scrubber runs on a mounted filesystem.

"df" tells that the bundle of disks is mounted - there too seems to be  
another problem.

But

   btrfs scrub start -r /path/to/mountpoint

works - is there a mistake in the description of the command?

In about 16 hours I'll know more ...

Viele Gruesse!
Helmut
