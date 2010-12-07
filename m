From: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Subject: Re: "Appending" data to the middle of a file using btrfs-specific features
Date: Tue, 7 Dec 2010 16:59:44 +0530
Message-ID: <AANLkTim6AJbZPwjU-M6-M2NU8DxsqdSmo9hdUnxCezoy@mail.gmail.com>
References: <AANLkTinXfbKmXYy52JF-QuJr0WTzgvbMXHAw-tYK4i5X@mail.gmail.com> <4CFE0A81.9040102@electric-spoon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: David Pottage <david@electric-spoon.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CFE0A81.9040102@electric-spoon.com>
List-ID: <linux-btrfs.vger.kernel.org>

[I think the mail was sent to just me due to a reply-accident, I've
re-added the mailing list for this reply]

On Tue, Dec 7, 2010 at 3:50 PM, David Pottage <david@electric-spoon.com=
> wrote:
> On 06/12/10 12:41, Nirbheek Chauhan wrote:
>>
>> I'd like to know if there has been any discussion about adding a new
>> feature to write (add) data at an offset, but without overwriting
>> existing data, or re-writing the existing data. Essentially, in-plac=
e
>> addition/removal of data to a file at a place other than the end of
>> the file.
>>
>> Some possible use-cases of such a feature would be:
>>
>> (a) Databases (currently hack around this by allocating sparse files=
)
>> (b) Delta-patching (rsync, patch, xdelta, etc)
>> (c) Video editors (especially if combined with reflink copies)
>>
>> Besides I/O savings, it would also have significant space savings if
>> the current subvolume being written to has been snapshotted (a commo=
n
>> use-case for incremental backups).
>>
>
> This idea was discussed back in June. (Search the archives for "Compl=
ex
> filesystem operations: split and join"
>
> Back then the idea was to achieve insertion and removal of data by sp=
litting
> and joining existing files, so to insert data in the middle of a file=
, you
> would cut it in two, append data to the first file and then re-join i=
t.
>

Aha, I searched the archives and I found the thread in question[1],
thanks! The original thread seems to have gone for a split/join
implementation that would work with vfat along with a new syscall.

> I think that direct insertion and removal of data is a cleaner idea, =
though
> it may result in a more complex API. You could still achieve cutting =
files
> into two by creating a COW copy of the file and truncating one, and r=
emoving
> a block of bytes from the start of the other.
>

I agree, being able to manipulate file stream in a way similar to
inserting/deleting in linked lists would introduce new possibilities
(and challenges, I'm sure). As you mentioned in the original thread,
it's quite strange that there's no way to do this with current file
API.

> I still think it would be a good idea to be able to join files togeth=
er with
> a file system API call, so the equivalent of:
>
> =C2=A0 =C2=A0cat track1.mp3 track2.mp3 track3.mp3 > mix_tape.mp3
>
> Could be done as a filesystem call to create mix_tape.mp3 as a de-dup=
licated
> copy of the contents of the three source files, without many megabyte=
s of
> I/O.
>

Ah, this is relatively straightforward with the clone_range ioctl.
There was some talk about a reflink() or clone() syscall a while
ago[2], perhaps that could be extended as reflink_range() so that it
could be used with other filesystems which support reflinks as well.

1. http://thread.gmane.org/gmane.linux.kernel/996835
2. http://lwn.net/Articles/333783/

--=20
~Nirbheek Chauhan

Gentoo GNOME+Mozilla Team
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
