From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: time for "balance"
Date: 10 Nov 2010 07:51:00 +0100
Message-ID: <B$bGnfwT1uB@helmut.hullen.de>
References: <B$YEgUvD1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <B$YEgUvD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I wrote am 09.11.10:

> I'm working with btrfs for some days.

> btrfs-progs-20101101, kernel 2.6.35.8 (both self compiled).

> First step:

>         mkfs.btrfs /dev/sdd1
>         mount /dev/sdd1 /srv/MM

> for a 2 TByte partition, worked well.

> Copying about 1,5 TByte data to this partition worked well.

> Second step:

>         btrfs device add /dev/sdc1 /srv/MM
>         btrfs filesystem balance /srv/MM

> adds /dev/sdc1 with about 1,5 TByte ("df" tells so), and the system
> works the second line ("balance") since about 12 hours. How much time
> needs this "balance" command?

Now the machine is ready, after working about 2 days ...

Viele Gruesse!
Helmut
