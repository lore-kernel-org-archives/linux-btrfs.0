From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: labelling
Date: Thu, 11 Nov 2010 09:48:10 +0100
Message-ID: <20101111094810.00001152@unknown>
References: <B$fJyztT1uB@helmut.hullen.de>
	<4CDBAB52.60903@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: helmut@hullen.de, linux-btrfs@vger.kernel.org
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CDBAB52.60903@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 11 Nov 2010 17:37:38 +0900
schrieb Tsutomu Itoh <t-itoh@jp.fujitsu.com>:

> Hi.
> 
> (2010/11/11 16:48), Helmut Hullen wrote:
> > Hallo, Hugo,
> >
> > Du meintest am 10.11.10:
> >
> >>>          findfs LABEL=MM2
> >>>
> >>> shows "/dev/sdd2" (the first partition)
> >>>
> >>>          file -s /dev/sdd2
> >>>          file -s /dev/sdc3
> >>>
> >>> shows "LABEL=MM2" for both partitions
> >
> >>>          mount LABEL=MM2 /srv/MM
> >>>
> >>> doesn't work now, it tries to mount /dev/sdd2 and mourns.
> >>>
> >>>          mount /dev/sdd2 /srv/MM
> >>>
> >>> shows the same error message,
> >
> > # mount LABEL=MM2
> > mount: wrong fs type, bad option, bad superblock on /dev/sdd2,
> >         missing codepage or helper program, or other error
> >         In some cases useful info is found in syslog - try
> >         dmesg | tail  or so
> >
> > # mount /dev/sdd2
> > mount: wrong fs type, bad option, bad superblock on /dev/sdd2,
> >         missing codepage or helper program, or other error
> >         In some cases useful info is found in syslog - try
> >         dmesg | tail  or so
> >
> >>     What's the error message? What do you get in your kernel logs
> >> when you do this? This should work, so there's something wrong,
> >> but it's (probably) not to do with disk labels.
> >
> >>>          mount /dev/sdc3 /srv/MM
> >>>
> >>> (mounting the added partition) works fine, the whole space is
> >>> available.
> >
> > That's the behaviour after a cold boot.
> >
> >          umount /srv/MM
> >          mount LABEL=MM2 /srv/MM
> >
> > then works.
> > Only the first try with LABEL or with "the other" device seems to
> > fail.
> 
> I encountered the same problem, too.
> Please try 'btrfsctl -a' before mounting.
> 
> Thanks.
> Itoh

btrfsctl is deprecated.

Please use "btrfs device scan" instead.


Regards,
Felix


> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

