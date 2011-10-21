From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: btrfs still looks for not existing devices
Date: 21 Oct 2011 10:21:00 +0200
Message-ID: <BwGl7u5T1uB@helmut.hullen.de>
References: <20111014140516.GJ21931@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111014140516.GJ21931@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 14.10.11:

>>         btrfs filesystem show
>>
>> On my system (Slackware 13.37, self made, without "udev") it still
>> shows a lot of non existent devices (I have shortened the list ...):

>    This is not a kernel issue, it's a purely userspace issue. Try the
> latest integration branch from git.darksatanic.net, which should have
> a fix for it.

When I use

        btrfs filesystem show

with the "integration branch" then the non existing devices in "/dev/*"  
are not shown - fine.

It shows (p.e.)

        devid ... /dev/sdb1
        devid ... /dev/sdc1
        devid ... /dev/sdd1

But when I use

        btrfsk /dev/sdb1

then btrfsck still shows all nonexisting devices.

Viele Gruesse!
Helmut
