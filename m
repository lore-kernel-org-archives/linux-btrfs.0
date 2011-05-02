From: Arne Jansen <sensille@gmx.net>
Subject: Re: btrfs raid health status
Date: Mon, 02 May 2011 16:20:51 +0200
Message-ID: <4DBEBDC3.1080003@gmx.net>
References: <BANLkTikkK=Y7yZ5u_mH7AQTkV_sd9u0FiQ@mail.gmail.com> <BANLkTimePgK+NGUnBpdgaB+NWGSo8sp3ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimePgK+NGUnBpdgaB+NWGSo8sp3ig@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02.05.2011 15:13, Roman Kapusta wrote:
> I have unmounted and again mounted btrfs filesystem, now I can see
> errors in dmesg.
> Is there also some error/health summary, like in btrfs fi show?

There is no error accounting or reparing yet, but you can check out the
scrub patches. They'll read and repair (if there's a second copy
available) all on-disk data. You can pull it here:

git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne.git
scrub
  and
git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-progs-unstable-arne.git
 scrub

-Arne

> 
> On Mon, May 2, 2011 at 15:07, Roman Kapusta <roman.kapusta@gmail.com> wrote:
>> I'm playing with mkfs.btrfs -m raid1 -d raid1. I put som data there
>> and now I write random data on one of physical disks directly.
>>
>> Filesystem and file contents looks fine but I cannot see any errors,
>> is there any way to see that one disk from raid1 is failing?
>>
>> Thanks
>>
>> Roman Kapusta
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

