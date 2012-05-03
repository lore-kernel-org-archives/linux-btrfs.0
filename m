From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: How file store when using Btrfs on multi-devices? What happen
 when a device fail?
Date: Thu, 3 May 2012 13:56:10 +0700
Message-ID: <CAG1y0sdkgJ9y=1Y=A+n8QAU73TKeBAej9GFJ26w7czOtDNzQ2g@mail.gmail.com>
References: <CAGP-ymNoE1CtSTdYXJMgQ0k2HmRmDxq=zSxNE7pGonoTzrkNHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Chu Duc Minh <chu.ducminh@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGP-ymNoE1CtSTdYXJMgQ0k2HmRmDxq=zSxNE7pGonoTzrkNHw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 3, 2012 at 1:46 PM, Chu Duc Minh <chu.ducminh@gmail.com> wr=
ote:
> Hi, i have some questions when using Btrfs on multi-devices:
> 1. a large file will always be stored wholely on a device or it may
> spread on some devices/partitions?

IIRC:
- in raid1 mode, it will be written on all disks (or was it TWO disks,
regarless how many device in a mirror? can't remember which).
- in raid10 and raid0, it will always be spread, on a minimum of two de=
vices

> Btrfs has option to specify it
> explicitly?

Not that I know of.

> 2. suppose i have a directory tree like that:
> Dir_1
> =A0|--> file_1A
> =A0|--> file_1B
> =A0|--> Dir_2
> =A0=A0=A0=A0=A0=A0=A0=A0 |--> file_2C
> =A0=A0=A0=A0=A0=A0=A0=A0 |--> file_2D
>
> If Dir_2, file_2C=A0 on a failed device, can i still have access to f=
ile_2D?

Unless you're using raid10, my guess is you'll be screwed, as each
file will be spread on multiple devices (including the one that
fails).

> If i use GlusterFS (mirror mode) on two nodes, each nodes run Btrfs o=
n
> multi-device. When a device on a node fail and I replace it, then
> GlusterFS resync it, can i have troubles with data consistency?

This question might be more suitable on glusterfs list. My guess is
that glusterfs will discard all data on the failed node. After you
recreate the storage backend (the btrfs, on a new device), you can
tell glusterfs to copy everything from the good node.

Of course, if you use raid10 mode in btrfs, and only one device fail,
it should be transparent to end users.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
