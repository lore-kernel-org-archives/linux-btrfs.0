From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: labelling
Date: 10 Nov 2010 19:23:00 +0100
Message-ID: <B$bIhyBi1uB@helmut.hullen.de>
References: <20101110111811.GA15973@vlad.carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101110111811.GA15973@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 10.11.10:

>>         findfs LABEL=MM2
>>
>> shows "/dev/sdd2" (the first partition)
>>
>>         file -s /dev/sdd2
>>         file -s /dev/sdc3
>>
>> shows "LABEL=MM2" for both partitions

[...]

>> Unmounting "/srv/MM" and
>>
>>         mount LABEL=MM2 /srv/MM
>>
>> doesn't work now, it tries to mount /dev/sdd2 and mourns.

>    What's the error message? What do you get in your kernel logs when
> you do this? This should work, so there's something wrong, but it's
> (probably) not to do with disk labels.

Strange - very strange ...

Today in the morning it didn't work. Now it works.

I'll see tomorrow if this strange behaviour is related somehow to cold  
start or some other commands before invoking "mount".

Viele Gruesse!
Helmut
