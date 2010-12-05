From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: 800 GByte free, but "no space left"
Date: 05 Dec 2010 13:21:00 +0100
Message-ID: <BbJOijui1uB@helmut.hullen.de>
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

>>> If the smallest device defines the capacity then I should use
>>> 2*1.35 TiByte, but my system tells "no space left" at about 2.4
>>> TiByte - where are (at least) 300 GiByte hidden?

>>>>>       devid    2 size 1.35TB used 1.35TB path /dev/sdc3
>>>>>       devid    1 size 1.81TB used 1.35TB path /dev/sdf2

>> Here devid 2 is at 100%, and hence you are getting the no more space
>> left errors. So, the 300 TB is on the bigger disk, and not usable
>> for you right now.

>    I _think_ that a balance is all that's needed at this point. It
> can't hurt, anyway (other than taking quite a long time).


It's just running - tomorrow I'll know more.

        grep relocating /var/log/messages

(counting down the groups) tells the proceedings.

Viele Gruesse!
Helmut
