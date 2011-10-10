From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: read error: how to fix?
Date: 10 Oct 2011 17:58:00 +0200
Message-ID: <Bv$GAecT1uB@helmut.hullen.de>
References: <4E92FC35.1040608@suse.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E92FC35.1040608@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Jeff,

Du meintest am 10.10.11:

>>>> Oct  7 18:16:55 Arktur kernel: ata5.00: exception Emask 0x0
>>>> SAct 0x0 SErr 0x0 action 0x0

[...]

>> I've just worked again with the 2 unreadable files.
>>
>> Copying them to another partition stopped somewhere, one time/file
>> at about 98%, the other time at about 2%.

[...]

> I'd try replacing the SATA cable and if that doesn't fix it up, you
> may be out of luck.

There are 2 unreadable sectors (reproducable). Changing or re-mounting  
the cables doesn't help.

> The thing is that marking sectors bad is a
> (pretty poor) band-aid for a much bigger problem: If you're hitting
> persistent read errors and re-writing the blocks doesn't fix it, your
> disk is already close to being completely kaput and no amount of
> software is going to help with that.

The next steps could be:

- adding a new 2-TByte disk (now there are 3 2-TByte disks)
- balancing
- removing the bad 2-TByte disk

But I'm afraid when I run balancing then the bad sectors damage big  
parts of the contents. I've had such bad luck about 1 year ago, losing  
about 2 TByte of data (ok - I had a kind of backup in a neighbout town).  
I don't like to reproduce this experience.

I'm afraid I have to buy 3 (or 4) 2-TByte disks, building them as a new  
raid0-data cluster and copy the complete contents from the old cluster  
to the new one. Doesn't sound good.

-----------------------

2 bad sectors from a total of 4*10^9 sectors is (in another point of  
view) no bad error rate ...

Viele Gruesse!
Helmut
