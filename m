From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Fri, 7 Jan 2011 17:19:50 +0100
Message-ID: <AANLkTimCBZpu4QMcdFf51yUCTCH2+BqvcEXeVijrzRnZ@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
	<1294412141-sup-1734@think>
	<AANLkTi=Z1RCwMKSMRzg4fwN55ZQs4F91nNjdEfv6veyb@mail.gmail.com>
	<1294412553-sup-9058@think>
	<AANLkTimB-gpHFJMXY3TRcfxGJjwo94ffEVZSPw6746bC@mail.gmail.com>
	<1294412980-sup-1924@think>
	<AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>
	<1294416073-sup-5254@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294416073-sup-5254@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 5:12 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
>> I'm not sure why you would run out of memory in that case.
>
> Well, lets make sure I've got a good handle on the proposed interface=
:
>
> 1) fd =3D open(some_file, O_ATOMIC)

No, O_TRUNC should be used in open. Maybe it works with a separate trun=
cate too.

> 2) truncate(fd, 0)
> 3) write(fd, new data)
>
> The semantics are that we promise not to let the truncate hit the dis=
k
> until the application does the write.
>
> We have a few choices on how we do this:
>
> 1) Leave the disk untouched, but keep something in memory that says t=
his
> inode is really truncated
>
> 2) Record on disk that we've done our atomic truncate but it is still
> pending. =C2=A0We'd need some way to remove or invalidate this record=
 after a
> crash.
>
> 3) Go ahead and do the operation but don't allow the transaction to
> commit until the write is done.
>
> option #1: keep something in memory. =C2=A0Well, any time we have a
> requirement to pin something in memory until userland decides to do a
> write, we risk oom.

Since the file is open, you have to keep something in memory anyway,
right? Adding a bit (or bool) does not make a difference IMO.
Isn't this comparable to opening a temp file?

> option #2: disk format change. =C2=A0Actually somewhat complex becaus=
e if we
> haven't crashed, we need to be able to read the inode in again withou=
t
> invalidating the record but if we do crash, we have to invalidate the
> record. =C2=A0Not impossible, but not trivial.
>
> option #3: Pin the whole transaction. =C2=A0Depending on the FS this =
may be
> impossible. =C2=A0Certain operations require us to commit the transac=
tion to
> reclaim space, and we cannot allow userland to put that on hold witho=
ut
> deadlocking.

#1 is the only one that makes sense.

> What most people don't realize about the crash safe filesystems is th=
ey
> don't have fine grained transactions. =C2=A0There is one single trans=
action
> for all the operations done. =C2=A0This is mostly because it is less =
complex
> and much faster, but it also makes any 'pin the whole transaction' ty=
pe
> system unusable.

AFAIK the cost is mostly more complex code / runtime. The cost is not
disk performance.

--=20
Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
