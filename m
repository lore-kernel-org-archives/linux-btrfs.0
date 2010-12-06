From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 06 Dec 2010 08:43:00 +0100
Message-ID: <BbNQohPi1uB@helmut.hullen.de>
References: <BbJQ3vED1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BbJQ3vED1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I wrote am 05.12.10:

>>>>>>       devid    2 size 1.35TB used 1.35TB path /dev/sdc3
>>>>>>       devid    1 size 1.81TB used 1.35TB path /dev/sdf2

>>> Here devid 2 is at 100%, and hence you are getting the no more
>>> space left errors. So, the 300 TB is on the bigger disk, and not
>>> usable for you right now.

>>    I _think_ that a balance is all that's needed at this point. It
>> can't hurt, anyway (other than taking quite a long time).

> After running "balance" it looks better:

> Label: 'MM2'  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
> 	Total devices 2 FS bytes used 2.39TB
> 	devid    2 size 1.35TB used 1.20TB path /dev/sdc3
> 	devid    1 size 1.81TB used 1.20TB path /dev/sdf2

And now:

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdc3            3400799848 2569770888 831028960  76% /srv/MM

But after copying about 300 MByte (part of a 1.5-GByte *.mpg) I got "no  
space left on device". Looks like balancing has stolen about 300 GByte.

Time to buy a 3-TByte disk ...

Viele Gruesse!
Helmut
