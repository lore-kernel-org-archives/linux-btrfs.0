From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: Re: btrfs raid health status
Date: Mon, 2 May 2011 15:13:33 +0200
Message-ID: <BANLkTimePgK+NGUnBpdgaB+NWGSo8sp3ig@mail.gmail.com>
References: <BANLkTikkK=Y7yZ5u_mH7AQTkV_sd9u0FiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikkK=Y7yZ5u_mH7AQTkV_sd9u0FiQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I have unmounted and again mounted btrfs filesystem, now I can see
errors in dmesg.
Is there also some error/health summary, like in btrfs fi show?

On Mon, May 2, 2011 at 15:07, Roman Kapusta <roman.kapusta@gmail.com> wrote:
> I'm playing with mkfs.btrfs -m raid1 -d raid1. I put som data there
> and now I write random data on one of physical disks directly.
>
> Filesystem and file contents looks fine but I cannot see any errors,
> is there any way to see that one disk from raid1 is failing?
>
> Thanks
>
> Roman Kapusta
>
