From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Defragmentation Not Working with Directory as Argument
Date: Tue, 25 Jan 2011 14:54:40 -0600
Message-ID: <AANLkTimR-RVDoOvyCyk1_uRYs8A+afJXzb=kdqouGTob@mail.gmail.com>
References: <AANLkTi=AtFgMoES1z7jXwwXkZynbBjYbPTJK_4_iULSF@mail.gmail.com>
	<201101241921.59201.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101241921.59201.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 24, 2011 at 12:21 PM, Hubert Kario <hka@qbs.com.pl> wrote:
> On Monday, January 24, 2011 19:11:07 Mitch Harder wrote:
>> Defragmentation is not working when a directory is supplied as the
>> argument. =A0When a file name is supplied as the argument,
>> defragmentation works well.
>>
>> This can be demonstrated as follows:
>>
>> # mount /dev/sdb2 /mnt/btrfs
>> # cd /mnt/btrfs/
>> # cp /usr/src/linux/fs/btrfs/zlib.c =A0. =A0 =A0(any suitable file w=
ill do,
>> small text files seemed appropriate)
>> # cp zlib.c fragmented-zlib.c
>> # btrfs fi sync /mnt/btrfs
>> # cat zlib.c >> fragmented-zlib.c
>> # btrfs fi sync /mnt/btrfs
>> # filefrag zlib.c fragmented-zlib.c
>> zlib.c: 1 extent found
>> fragmented-zlib.c: 2 extents found
>> # btrfs filesystem defragment /mnt/btrfs/
>> # btrfs fi sync /mnt/btrfs
>> # filefrag zlib.c fragmented-zlib.c
>> zlib.c: 1 extent found
>> fragmented-zlib.c: 2 extents found
>>
>> Now, supply a filename as the argument
>>
>> # btrfs filesystem defragment /mnt/btrfs/fragmented-zlib.c
>> # btrfs fi sync /mnt/btrfs
>> # filefrag zlib.c fragmented-zlib.c
>> zlib.c: 1 extent found
>> fragmented-zlib.c: 1 extent found
>>
>> I've also tested defragmentation on my normal btrfs filesystems, and
>> have seen the same results. =A0I've never seen a file defragmented w=
hen
>> using a directory as the argument.
>
> That's because this defragments only directory metadata.
>
>> Also, I was wondering if one of the Btrfs developers could clarify t=
he
>> intended scope of defragmentation when a directory is supplied as th=
e
>> argument.
>
> I submited apropriate patches few days back to update man and help me=
ssages
>
>> I have seen comments on the mailing list indicating that only the
>> directory supplied is intended to be defragmented, and defragmentati=
on
>> will not recurse to subdirectories below.
>
> that's true
>
>> However, if I look at the code, and read the documentation for the
>> older btrfsctl command (which seems to be the basis for the current
>> btrfs command), it seems like the intention is to recursively
>> defragment the entire tree below the directory supplied in the
>> argument.
>
> Then it looks like the userspace part of implementation changed, don'=
t know
> why though.
>

Thanks!  I see where they've added some clarification on this issue to
the wiki in the Problem FAQ.

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#Defragmenting_a_dir=
ectory_doesn.27t_work

I understand now that the function performed when a directory is
supplied as the argument is different than the function performed when
a file or file wildcard is supplied as the argument.

I'm concerned that there will be a vast number of new btrfs users who
have spent their computer life immersed in the command-line syntax
convention where supplying a directory as an argument implies the
files located in that directory.

It might make sense to break out the defragmentation of leaf metadata
into a separate command so that it's clear to users what operation is
being performed.

It will save a lot of frustration from both the new users who are
learning the new Btrfs concepts and the advanced users who have to
field the questions.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
