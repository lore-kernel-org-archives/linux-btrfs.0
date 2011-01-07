From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Fri, 7 Jan 2011 16:01:59 +0100
Message-ID: <AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
	<1294412141-sup-1734@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294412141-sup-1734@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 3:58 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Excerpts from Olaf van der Spek's message of 2011-01-06 15:01:15 -050=
0:
>> Hi,
>>
>> Does btrfs support atomic file data replaces? Basically, the atomic
>> variant of this:
>> // old stage
>> open(O_TRUNC)
>> write() // 0+ times
>> close()
>> // new state
>
> Yes and no. =C2=A0We have a best effort mechanism where we try to gue=
ss that
> since you've done this truncate and the write that you want the write=
s
> to show up quickly. =C2=A0But its a guess.
>
> The problem is the write() // 0+ times. =C2=A0The kernel has no idea =
what
> new result you want the file to contain because the application isn't
> telling us.

Isn't it safe for the kernel to wait until the first write or close
before writing anything to disk?

> What btrfs can do (but we haven't yet implemented) is make sure that =
the
> results of a single write file are on disk atomically, even if they a=
re
> replacing existing bytes in the file.
>
> Because we cow and because we don't update metadata pointers until th=
e
> IO is complete, we can wait until all the IO for a given write call i=
s
> on disk before we update any of the metadata.
>
> This isn't hard, it's on my TODO list.

What about a new flag: O_ATOMIC that'd take the guesswork out of the ke=
rnel?

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
