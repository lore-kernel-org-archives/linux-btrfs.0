From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: INSTALL hint: create device btrfs-control
Date: 05 Aug 2011 12:19:00 +0200
Message-ID: <BrHgMJyi1uB@helmut.hullen.de>
References: <20110804204219.GB8970@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110804204219.GB8970@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 04.08.11:

>>>    What are the symptoms of not having the device node? (i.e. how
>>> would I diagnose this particular problem?)

>> If I remember correct: mounting works, writing works, reading works.
>> And adding another partition works.
>>
>> But there are strange messages when I try to resize or delete.
>>
>> I'll try to reproduce these messages ...

>    Thanks. We can add those as symptoms to the solution later.

Maybe I've found the place of the (unique?) problem.


Partitions:

        sdb1    2 GByte
        sdb2    3 GByte
        sdb3    4 Gbyte

   mkfs.btrfs -L Probe -m raid0 -d raid1 /dev/sdb1
   mount LABEL=Probe /mnt/Probe
     filling with about 600 MByte (1 *.iso)

   btrfs device add /dev/sdb2 /mnt/Probe
   btrfs filesystem balance /mnt/Probe
     (ok)
   btrfs device add /dev/sdb3 /mnt/Probe
     filling with a DVD *.iso (more than 4 GByte)
   btrfs filesystem balance /mnt/Probe
     (ok)

And then:

   btrfs device delete /dev/sdb2 /mnt/Probe

works fine, if /dev/btrfs-control exists

crashes (shown with "dmesg") if this device doesn't exist.

Viele Gruesse!
Helmut
