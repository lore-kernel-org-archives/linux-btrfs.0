From: C Anthony Risinger <anthony@extof.me>
Subject: Re: list subvolumes with new btrfs command
Date: Sun, 25 Apr 2010 21:47:31 -0500
Message-ID: <z2tbe6460751004251947ve533479ax174cc4f8bff50c01@mail.gmail.com>
References: <g2kbe6460751004251127tbdf980b6q867cf1b98fc562dc@mail.gmail.com>
	 <q2j9bd6b5361004251909j8dcf6ccbzd978d627e137fadb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <q2j9bd6b5361004251909j8dcf6ccbzd978d627e137fadb@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> need super root? in my ubuntu10.04 with latest btrfs-progs:
>
> $ ./btrfs subvolume list /media/sda3-100g/
> ERROR: can't perform the search
> $ sudo ./btrfs subvolume list /media/sda3-100g/
> ID 258 top level 5 path misc/snap/snap-4-26

ah sorry, i forgot to mention that it doesn't work as super user
either, same result:

$ sudo btrfs subvolume list /
ERROR: can't perform the search

the btrfs-progs in ubuntu is probably slightly behind git HEAD (what
i'm using in Arch package), maybe it broke recently, i might try to
bisect and see it i can pinpoint to problem commit.  i am also using
kernel 2.6.33 (ubuntu is .32 i think) that's why i thought maybe there
was an issue there; it seems like the ioctl() call is failing no
matter what in my case.

other details i can think of:
1) filesystem was created by a 2.6.31 kernel

i will use loopback + BTRFS to test what is happening here and report
back; maybe i can't scan / ...?  thanks for the response, any other
input is very much appreciated.

thanks,
C Anthony
