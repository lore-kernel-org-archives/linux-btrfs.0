From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: minor ID for btrfs-control
Date: 03 Apr 2011 11:42:00 +0200
Message-ID: <Bj8m7qCT1uB@helmut.hullen.de>
References: <20110402172936.GA24370@mother.jarsat.pl>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110402172936.GA24370@mother.jarsat.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Tomasz,

Du meintest am 02.04.11:

>> if I've understood some mails in this list correct, then btrfs needs
>> a character device "btrfs-control"  with the ID 10:55
>>
>> When I look for this device in
>>
>>         /sys/class/misc/btrfs-control/dev
>>
>> I see 10:234


> If you do not use udev, you need to synchronise /dev/
> node with /sys/class/misc/btrfs-control/dev manually on each boot.

Solved (something like reverse engineering).

I re-create the (permanent) entry /dev/btrfs-control using the actual  
contents of "/sys/class/misc/btrfs-control/dev", and btrfs is happy (and  
me too).

Works now on two of my machines for the next long time test ...

------------------

I'll watch who changes the data ... some part of some program must have  
defined 234 as minor ID.

Viele Gruesse!
Helmut
