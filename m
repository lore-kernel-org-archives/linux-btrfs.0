From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: failed disk
Date: 09 May 2012 20:49:00 +0200
Message-ID: <C8XJx4seCXB@helmut.hullen.de>
References: <20120509153306.GR8938@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120509153306.GR8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 09.05.12:

>>>    As to the spurious "upgrade" of single to RAID-0, I thought Ilya
>>> had stopped it doing that. What kernel version are you running?

>> 3.2.9, self made.

>    OK, I'm pretty sure that's too old -- it will "upgrade" single to
> RAID-0. You can probably turn it back to "single" using balance
> filters:

> # btrfs fi balance -dconvert=single /mountpoint

> (You may want to write at least a little data to the FS first --
> balance has some slightly odd behaviour on empty filesystems).

"manana" ... the system is just running "balance" after "device delete".  
And that may still need 4 ... 5 hours.

>>>    Out of interest, why did you do the device adds separately,
>>> instead of just this?

>> a) making the first 2 devices: I have tested both versions (one line
>> with 2 devices or 2 lines with 1 device); no big difference.
>>
>> But I had tested the option "-L" (labelling) too, and that makes
>> shit for the oneliner: both devices get the same label, and then
>> "findfs" finds none of them.

>    Umm... Yes, of course both devices will get the same label --
> you're labelling the filesystem, not the devices. (Didn't we have
> this argument some time ago?).

Not with that special case (and that led me to misinterpreting the error  
...).

>    I don't know what "findfs" is doing, that it can't find the
> filesystem by label: you may need to run "sync" after mkfs, possibly.

No - "findfs" works quite simple: if it finds 1 label then it tells the  
partition.
If it finds more or less labels it tells nothing.

>> b) third device: that's my usual test:
>>         make a cluster of 2 deivces
>>         fill them with data
>>         add a third device
>>         delete the smallest device

>    What are you testing? And by "delete" do you mean "btrfs dev
> delete" or "pull the cable out"?

First pure software delete. Tomorrow I'll reboot the system and look at  
the results with

        btrfs fi show

It should tell only 2 devices (that's the part which seems to work as  
described at least since kernel 3.2).

By the way: it seems to be necessary running

        btrfs fi balance ...

after "btrfs device add ..." and after "btrfs device delete ...".

Viele Gruesse!
Helmut
