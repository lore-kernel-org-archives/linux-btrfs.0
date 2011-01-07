From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Fri, 7 Jan 2011 16:17:31 +0100
Message-ID: <AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
	<1294412141-sup-1734@think>
	<AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>
	<1294412553-sup-9058@think>
	<AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>
	<1294412980-sup-1924@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294412980-sup-1924@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 4:13 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
>> That's not what I asked. ;)
>> I asked to wait until the first write (or close). That way, you don'=
t
>> get unintentional empty files.
>> One step further, you don't have to keep the data in memory, you're
>> free to write them to disk. You just wouldn't update the meta-data
>> (yet).
>
> Sorry ;) Picture an application that truncates 1024 files without clo=
sing any
> of them. =C2=A0Basically any operation that includes the kernel waiti=
ng for
> applications because they promise to do something soon is a denial of
> service attack, or a really easy way to run out of memory on the box.

I'm not sure why you would run out of memory in that case.

O_ATOMIC would be the solution for the rename workaround: write temp
file, rename
With advantages like a way simpler API, no issues with resetting
meta-data, no issues with temp file and maybe better performance.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
