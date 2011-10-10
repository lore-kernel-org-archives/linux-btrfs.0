From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: read error: how to fix?
Date: 10 Oct 2011 15:28:00 +0200
Message-ID: <Bv$Fe34y1uB@helmut.hullen.de>
References: <20111010114809.GH17912@twin.jikos.cz>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111010114809.GH17912@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, David,

Du meintest am 10.10.11:

>> Oct  7 18:16:55 Arktur kernel: ata5.00: exception Emask 0x0 SAct 0x0
>> SErr 0x0 action 0x0
>> Oct  7 18:16:55 Arktur kernel: ata5.00: BMDMA2 stat 0x80d2009
>> Oct  7 18:16:55 Arktur kernel: ata5.00: failed command: READ DMA
>> Oct  7 18:16:55 Arktur kernel: ata5.00: cmd
>> c8/00:40:57:d0:34/00:00:00:00:00/ee tag 0 dma 32768 in Oct  7
>> 18:16:55 Arktur kernel:          res
>> 51/40:40:57:d0:34/00:03:0e:00:00/fe Emask 0x9 (media error) Oct  7
>> 18:16:55 Arktur kernel: ata5.00: status: { DRDY ERR } Oct  7
>> 18:16:55 Arktur kernel: ata5.00: error: { UNC } Oct  7 18:16:55
>> Arktur kernel: ata5.00: configured for UDMA/100 Oct  7 18:16:55
>> Arktur kernel: ata5: EH complete
>>
>> (repeating every 3 seconds)
>>
>> The files contain no valuable data (*.mpeg files, reproducable). But
>> how can I tell the disk not to use the damaged sector(s)?
>>
>> On an ext2/3 system I used "badblocks" - is there some comparable
>> tool for btrfs?

> No there isn't, but it's a good topic for a btrfs project :)

> (I see lots of interesting problems like relocating superblocks,
> damaged allocator structures, ...)

I've just worked again with the 2 unreadable files.

Copying them to another partition stopped somewhere, one time/file at  
about 98%, the other time at about 2%.

I had to kill the "cp" order with "killall cp".

The same problem with deleting: I had to use "killall rm". "I'm not  
amused" ...

And I'm curious what the system will do with the 2 unreadable sectors.  
In about 1 year I have to add the next 2 TByte disk, with "add" and  
"balance". Maybe I have to copy the 3-disks cluster to a 4-disks-cluster  
...

Viele Gruesse!
Helmut
