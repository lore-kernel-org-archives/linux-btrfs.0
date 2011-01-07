From: Massimo Maggi <massimo@mmmm.it>
Subject: Re: Atomic file data replace API
Date: Fri, 07 Jan 2011 17:32:34 +0100
Message-ID: <4D274022.5070507@mmmm.it>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>	<1294412141-sup-1734@think>	<AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>	<1294412553-sup-9058@think>	<AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>	<1294412980-sup-1924@think> <AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Are you suggesting to do:
1)fopen with O_TRUNC, O_ATOMIC: returns fd to a temporary file
2)application writes to that fd, with one or more system calls, in a
short time or in long time, at his will.
3)at fclose (or even at fsync ) atomically swap "data pointer" of "real
file" with "temp file", then delete temp.In a transparent mode to
userland.  (something similar to e4defrag).
Is this sum up correct?

Massimo Maggi

Il 07/01/2011 16:17, Olaf van der Spek ha scritto:
> On Fri, Jan 7, 2011 at 4:13 PM, Chris Mason <chris.mason@oracle.com> wrote:
>>> That's not what I asked. ;)
>>> I asked to wait until the first write (or close). That way, you don't
>>> get unintentional empty files.
>>> One step further, you don't have to keep the data in memory, you're
>>> free to write them to disk. You just wouldn't update the meta-data
>>> (yet).
>> Sorry ;) Picture an application that truncates 1024 files without closing any
>> of them.  Basically any operation that includes the kernel waiting for
>> applications because they promise to do something soon is a denial of
>> service attack, or a really easy way to run out of memory on the box.
> I'm not sure why you would run out of memory in that case.
>
> O_ATOMIC would be the solution for the rename workaround: write temp
> file, rename
> With advantages like a way simpler API, no issues with resetting
> meta-data, no issues with temp file and maybe better performance.
>
> Olaf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

