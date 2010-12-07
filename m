From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: The value displayed by 'ls -s' command is strange.
Date: Tue, 7 Dec 2010 14:06:51 -0800
Message-ID: <AANLkTinwzdjw4oCa9ZjGg6mRSputs9s1vCSx5jDq3U8q@mail.gmail.com>
References: <4CFDE978.9050407@jp.fujitsu.com>
	<1291743093-sup-2051@think>
	<AANLkTi=yQGxx7P=EoAP1sOg5rakmSmb-y+5OTeGbJnyx@mail.gmail.com>
	<1291750008-sup-1758@think>
	<AANLkTinwa=H3ge_bb0r5JgV=wPf0viCDXZGwNYftoqu4@mail.gmail.com>
	<1291752549-sup-5932@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291752549-sup-5932@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 7, 2010 at 12:15 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Mike Fedyk's message of 2010-12-07 15:07:08 -0500:
>> On Tue, Dec 7, 2010 at 11:29 AM, Chris Mason <chris.mason@oracle.com=
> wrote:
>> > Excerpts from Mike Fedyk's message of 2010-12-07 14:16:55 -0500:
>> >> On Tue, Dec 7, 2010 at 10:44 AM, Chris Mason <chris.mason@oracle.=
com> wrote:
>> >> > Excerpts from Tsutomu Itoh's message of 2010-12-07 02:59:52 -05=
00:
>> >> >> Hi,
>> >> >>
>> >> >> I think that the disk allocation size of each file becomes a m=
onotone increase
>> >> >> when the file is made.
>> >> >> But, it sometimes return to 0. =C2=A0Is it correct?
>> >> >
>> >> > Well, there's a window during the processing of delayed allocat=
ion where
>> >> > we don't have the bytes recorded as delalloc and we don't have =
the bytes
>> >> > recorded in the inode yet. =C2=A0That's why they are showing up=
 as zero.
>> >> >
>> >> > We don't call inode_add_bytes() until after we insert the exten=
t, but we
>> >> > drop the delalloc byte count on the file before the IO is done.
>> >> >
>> >> > Fixing it will be a little tricky because all the extent accoun=
ting
>> >> > assumes the inode_add_bytes happens at extent insertion time.
>> >> >
>> >>
>> >> How does opening the inode with O_APPEND during this window know =
where
>> >> to write the bytes? =C2=A0If it's a pointer/cursor to the EOF the=
n that
>> >> size could be used during the window. =C2=A0Is that right?
>> >
>> > This counter records the number of blocks allocated to the file, a=
nd
>> > reading it with ls -l or stat is somewhat racey by nature. =C2=A0M=
ost of the
>> > time its fine, btrfs just has a really big window where the result=
s from
>> > ls -l seem wrong.
>> >
>>
>> I see. =C2=A0Is it using per-cpu vars or something similar?
>

Ok, so to make sure I fully understand I'm going to make some psuedo
code based on your description.

> Our stat function returns the block count in the inode plus the numbe=
r
> of bytes we have accounted as delayed allocation.
>

stat =3D inode_a1.bytes + inode_a1_delayed_allocation_bytes

> As we do writes to the file, the delayed allocation count goes up and
> then eventually we decide we need to do some IO.
>
> Before we do the IO, we have to decide where on the disk to write the
> extents.

inode_a2 =3D inode_a1

inode_a1 and inode_a2 are the same inode, but inode_a2 has a different
list of extents and is not written yet (in the case of appending, most
of the extents will be the same in the two extent lists, but inode_a2
will have more extents for the newly appended data)

> Once that is decided, we decrement the count of delayed
> allocation bytes.
>
> This is when stat starts returning the wrong answer.
>

inode_a2.bytes +=3D inode_a1_delayed_allocation_bytes
inode_a1_delayed_allocation_bytes -=3D inode_a1_delayed_allocation_byte=
s
stat =3D inode_a1.bytes + inode_a1_delayed_allocation_bytes

Is it possible to have stat read from inode_a2 during this window?

So it would be instead:

stat =3D inode_a2.bytes

> Then we do the IO, and when the IO is done we actually insert the fil=
e
> extents into the file metadata. =C2=A0This is when stat starts return=
ing the
> right answer again.
>

/* implicit when write completes */
inode_a1 =3D inode_a2
kfree(inode_a2)
stat =3D inode_a1.bytes + inode_a1_delayed_allocation_bytes

> The whole setup sounds strange, but this is how btrfs implements the
> semantics from data=3Dordered. =C2=A0We don't update the file to poin=
t to
> the new blocks until after the IO is done, so we never have to wait o=
n
> the data IO before we can do a transaction commit. =C2=A0It avoids al=
l kinds
> of latencies with fsync and other problems.
>
> One easy solution is to just add another counter in the in-memory ino=
de
> for the number of bytes in flight that aren't accounted for in other
> places. =C2=A0But I'd rather not make the inode any bigger, so I'll h=
ave to
> think if we can solve this another way.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
