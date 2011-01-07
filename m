From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Fri, 7 Jan 2011 16:08:24 +0100
Message-ID: <AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
	<1294412141-sup-1734@think>
	<AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>
	<1294412553-sup-9058@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294412553-sup-9058@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 4:05 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
>> > The problem is the write() // 0+ times. =C2=A0The kernel has no id=
ea what
>> > new result you want the file to contain because the application is=
n't
>> > telling us.
>>
>> Isn't it safe for the kernel to wait until the first write or close
>> before writing anything to disk?
>
> I'm afraid not. =C2=A0Picture an application that opens a thousand fi=
les and
> writes 1MB to each of them, and then didn't close any. =C2=A0If we wa=
ited
> until close, you'd have 1GB of memory pinned or staged somehow.

That's not what I asked. ;)
I asked to wait until the first write (or close). That way, you don't
get unintentional empty files.
One step further, you don't have to keep the data in memory, you're
free to write them to disk. You just wouldn't update the meta-data
(yet).

>> > This isn't hard, it's on my TODO list.
>>
>> What about a new flag: O_ATOMIC that'd take the guesswork out of the=
 kernel?
>
> We can't guess beyond a single write call. =C2=A0Otherwise we get int=
o
> the problem above where an application can force the kernel to wait
> forever. =C2=A0I'm not against O_ATOMIC to enable the new btrfs
> functionality, but it will still be limited to one write.
>
> -chris
>



--=20
Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
