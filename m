From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: INSTALL hint: create device btrfs-control
Date: 04 Aug 2011 22:13:00 +0200
Message-ID: <BrDfVHaT1uB@helmut.hullen.de>
References: <20110804173548.GA8970@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110804173548.GA8970@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 04.08.11:

>    What are the symptoms of not having the device node? (i.e. how
> would I diagnose this particular problem?)

The days get shorter and shorter ...

running

        btrfs device scan

produces something like

...
failed to read /dev/hdc
failed to read /dev/hdc8
failed to read /dev/lmscd
failed to read /dev/sdc1
failed to read /dev/sdb4
failed to open /dev/btrfs-control skipping device registration
failed to read /dev/sdd8
failed to read /dev/hdc9
failed to read /dev/sdf8
...

a lot of error messages for not existing devices and 1 error messages on  
behalf of "btrfs-control".

My "/dev" directory has worked (without "udev") without any problem for  
more than 10 years, it contains (has contained) a lot of entries for  
nearly every case of disk. Therefore i had started with

        btrfs device scan 2>/dev/null

and that deleted the "btrfs-control" error message too. And

        btrfs device scan 2>&1 | grep -v 'failed to'

didn't help too.


        btrfs-show

doesn't need "/dev/btrfs-control", it shows the existing btrfs  
partition(s).

If I remember correct: mounting works, writing works, reading works. And  
adding another partition works.

But there are strange messages when I try to resize or delete.

I'll try to reproduce these messages ...

Viele Gruesse!
Helmut
