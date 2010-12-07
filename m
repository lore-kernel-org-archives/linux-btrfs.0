From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: The value displayed by 'ls -s' command is strange.
Date: Tue, 7 Dec 2010 12:07:08 -0800
Message-ID: <AANLkTinwa=H3ge_bb0r5JgV=wPf0viCDXZGwNYftoqu4@mail.gmail.com>
References: <4CFDE978.9050407@jp.fujitsu.com>
	<1291743093-sup-2051@think>
	<AANLkTi=yQGxx7P=EoAP1sOg5rakmSmb-y+5OTeGbJnyx@mail.gmail.com>
	<1291750008-sup-1758@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291750008-sup-1758@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 7, 2010 at 11:29 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Mike Fedyk's message of 2010-12-07 14:16:55 -0500:
>> On Tue, Dec 7, 2010 at 10:44 AM, Chris Mason <chris.mason@oracle.com=
> wrote:
>> > Excerpts from Tsutomu Itoh's message of 2010-12-07 02:59:52 -0500:
>> >> Hi,
>> >>
>> >> I think that the disk allocation size of each file becomes a mono=
tone increase
>> >> when the file is made.
>> >> But, it sometimes return to 0. =C2=A0Is it correct?
>> >
>> > Well, there's a window during the processing of delayed allocation=
 where
>> > we don't have the bytes recorded as delalloc and we don't have the=
 bytes
>> > recorded in the inode yet. =C2=A0That's why they are showing up as=
 zero.
>> >
>> > We don't call inode_add_bytes() until after we insert the extent, =
but we
>> > drop the delalloc byte count on the file before the IO is done.
>> >
>> > Fixing it will be a little tricky because all the extent accountin=
g
>> > assumes the inode_add_bytes happens at extent insertion time.
>> >
>>
>> How does opening the inode with O_APPEND during this window know whe=
re
>> to write the bytes? =C2=A0If it's a pointer/cursor to the EOF then t=
hat
>> size could be used during the window. =C2=A0Is that right?
>
> This counter records the number of blocks allocated to the file, and
> reading it with ls -l or stat is somewhat racey by nature. =C2=A0Most=
 of the
> time its fine, btrfs just has a really big window where the results f=
rom
> ls -l seem wrong.
>

I see.  Is it using per-cpu vars or something similar?

> But, the counter really means nothing to the btrfs internals. =C2=A0W=
hen we
> do file operations we go based on the extent pointers we find in the
> tree and i_size (i_size is strictly maintained).
>

Would it be too heavy of an operation to have stat walk the btrfs tree
to get its data?

> The incorrect results are confusing but they don't hurt the metadata
> itself.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
