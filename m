From: Yien Zheng <esprout@gmail.com>
Subject: Re: Entirely unexpected ENOSPC?
Date: Mon, 9 Mar 2009 07:08:16 -0600
Message-ID: <2c259a8f0903090608r36c50773qaa0bc1606beb5065@mail.gmail.com>
References: <2c259a8f0903072332n31d9d20dscad1801b4b468520@mail.gmail.com>
	 <3a7f57190903080035lf10104fq87eca697cc4dfb43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190903080035lf10104fq87eca697cc4dfb43@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>
> This is just a hunch, but maybe the handling of spare files (such as
> .vdi) is not ideal or not what we're used to with extN. Normally
> "skipped" blocks do not count towards the disk full size, but given
> btrfs' nature they may count as a reservation that would certainly
> cause an early ENOSPC.
>

I don't think this is the case, since my .vdi is a dynamically
expanding file, and isn't a sparse file that wants to reserve more
space than it actually is taking up.  So the vdi file is reported to
be 5G by du, and it is indeed taking up 5G (and not 3G).

> You can try to narrow down the problem using qemu-img or dd. Example:
>
> qemu-img create -f raw test.img 16G
>
> See if it counts towards the disk fill count and ENOSPC threshold. See
> if it even completes at all :P
>

I tried a test like this for kicks after deleting my vdi file.  I
tried a while loop:

while [ 1 ]; dd if=/dev/zero of=file.`date +%s` count=2097152; done

My machine subsequently froze.  Repeating the experiment unvieled that
eventually the system get stuck on pdflush taking up 100% CPU.  At
this point, I had to turn off my laptop, as a soft reset was not
possible, even with a "halt" command.

At this point I'm wondering if this is a anomaly or if it has anything
to do with using an SSD.  It seems the pre-2.7.29-rc7 code had a hard
stop at 85%.  But the recent patch doesn't seem to have solve the
issue for me.  Is there another issue that makes btrfs want to reserve
2G free?  I see another email with someone growing their filesystem
from 48G to 70G because they ran out of space on their 50G disk, which
should still have 2G free.
