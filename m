From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 05 Dec 2010 21:28:00 +0100
Message-ID: <BbJQ3vED1uB@helmut.hullen.de>
References: <20101205112208.GD4087@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101205112208.GD4087@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 05.12.10:

>>>>>       devid    2 size 1.35TB used 1.35TB path /dev/sdc3
>>>>>       devid    1 size 1.81TB used 1.35TB path /dev/sdf2
>>
>> Here devid 2 is at 100%, and hence you are getting the no more space
>> left errors. So, the 300 TB is on the bigger disk, and not usable
>> for you right now.

>    I _think_ that a balance is all that's needed at this point. It
> can't hurt, anyway (other than taking quite a long time).

After running "balance" it looks better:

Label: 'MM2'  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
	Total devices 2 FS bytes used 2.39TB
	devid    2 size 1.35TB used 1.20TB path /dev/sdc3
	devid    1 size 1.81TB used 1.20TB path /dev/sdf2

Viele Gruesse!
Helmut
