From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: abysmal performance
Date: Tue, 03 May 2011 13:30:36 +0200
Message-ID: <4DBFE75C.2000104@birkenwald.de>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com> <20110430235539.6205.qmail@stuge.se> <ipolll$2h0$1@dough.gmane.org> <1304420831-sup-4737@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304420831-sup-4737@think>
List-ID: <linux-btrfs.vger.kernel.org>

Am 03.05.2011 13:08, schrieb Chris Mason:

>> defragging btrfs does not seem to work for me. I have run the filefrag
>> command over the whole fs and (manually) tried to defrag a few heavily
>> fragmented files, but I don't get it to work (it still has the same
>> number of extends and they are horrently uncorrelated)
>>
>> root@schleppi:~# filefrag
>> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
>> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1: 72 extents found
>> root@schleppi:~# btrfs filesystem defrag
>> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
>> root@schleppi:~# filefrag
>> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
>> /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1: 72 extents found
>>
>> I'm using Ubuntu Natty (2.6.38.4) and tried both btrfs-tools from Natty
>> (201006xx) and from Debian experimental (git from 20101101). Both show
>> the same symptoms. I don't think fragmentation is bad on this box (due
>> to having an SSD), but my system at home is getting dog slow and I'd
>> like to try that when I come home end of the week.
> 
> Do you have compression on?

Yes. lzo to be exact.

> The file the defrag ioctl works is that it schedules things for defrag
> but doesn't force out the IO immediately unless you use -f.
> 
> So, to test the result of the defrag, you need to either wait a bit or
> run sync.

Did so, no change. See my reply to cwillu for the data.

I usually mount my / without any compression option and did "mount -o
remount,compress=lzo /" before. I cannot reboot at the moment and I did
not find any option to disable compression again. There does not seem to
be a "nocompress" or "compress=[none|off]" option. Is this correct?

Bernhard
