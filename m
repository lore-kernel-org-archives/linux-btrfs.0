From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: version
Date: 27 Jan 2011 09:16:00 +0100
Message-ID: <BeetaMKT1uB@helmut.hullen.de>
References: <1296114256-sup-4788@think>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296114256-sup-4788@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Chris,

Du meintest am 27.01.11:

>> crashes with the "dmesg" lines
>>
>> --------------------- dmesg -------------------
>>
>> bio too big device sdc (256 > 240)
>> bio too big device sdc (256 > 240)
>> bio too big device sdc (256 > 240)
>> bio too big device sdc (256 > 240)
>> ------------[ cut here ]------------
>> kernel BUG at fs/btrfs/volumes.c:2097!

> Ugh, this one is an old friend I thought I had fixed up.  The two
> devices have different limits on the max size of the bio, and we're
> using one that is too large.

> I'll get it fixed for the next rc.

Thank you!
The one device is a CF card with 8 GB, the other is a SSD with 40 GByte.  
Maybe it's strange mixing them ... but I don't dare to test my 2 TByte  
disks.

Viele Gruesse!
Helmut
