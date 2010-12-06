From: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Subject: Re: "Appending" data to the middle of a file using btrfs-specific features
Date: Tue, 7 Dec 2010 00:44:59 +0530
Message-ID: <AANLkTi=1z3kPVyYxW1njwMfXyxoBPqHSZ2NQUG4X8uXN@mail.gmail.com>
References: <AANLkTinXfbKmXYy52JF-QuJr0WTzgvbMXHAw-tYK4i5X@mail.gmail.com> <1291651254-sup-4263@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291651254-sup-4263@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 6, 2010 at 9:35 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Excerpts from Nirbheek Chauhan's message of 2010-12-06 07:41:16 -0500=
:
[snip]
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
[snip]
>> A hack I can think of is to do a BTRFS_IOC_CLONE_RANGE into a new fi=
le
>> (upto the offset), writing whatever data is required, and then doing
>> another BTRFS_IOC_CLONE_RANGE with an offset for the rest of the
>> original file. This can be followed by a rename() over the original
>> file. Similarly for removing data from the middle of a file. Would
>> this work? Would it be cleaner to implement something equivalent
>> internally?
>
> It would work yes. =C2=A0The operation has three cases:
>
> 1) file size doesn't change
> 2) extend the file with new bytes in the middle
> 3) make the file smaller removing bytes in the middle
>
> #1 is the easiest case, you can just use the clone range ioctl direct=
ly
>
> For #2 and #3, all of the file pointers past the bytes you want to ad=
d
> or remove need to be updated with a new file offset. =C2=A0I'd say fo=
r an
> initial implementation to use the IOC_CLONE_RANGE code, and after
> everything is working we can look at optimizing it with a shift ioctl=
 if
> it makes sense.
>

Alrighty, I'll try this and report back any bugs and/or suggestions.

> Of the use cases you list, video editors seems the most useful.
> Databases already have things pretty much under control, and delta
> patching wants to go to a new file anyway. =C2=A0Video editing softwa=
re has
> long been looking for ways to do this.
>

As an aside, my primary motivation for this was that doing an
incremental backup of things like git bare repositories and databases
using btrfs subvolume snapshots is expensive w.r.t. disk space. Even
though rsync calculates a binary delta before transferring data, it
has to write everything out (except if just appending). So in that
case, each "incremental" backup is hardly so.

Thanks for your help! :)

--=20
~Nirbheek Chauhan

Gentoo GNOME+Mozilla Team
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
