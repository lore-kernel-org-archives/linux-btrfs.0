From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: "Appending" data to the middle of a file using btrfs-specific features
Date: Tue, 7 Dec 2010 10:50:06 +0300
Message-ID: <AANLkTi=Y2Qed7pCncMQ4H9b-fPy9n1f79KOuqX3u90up@mail.gmail.com>
References: <AANLkTinXfbKmXYy52JF-QuJr0WTzgvbMXHAw-tYK4i5X@mail.gmail.com> <1291651254-sup-4263@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291651254-sup-4263@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 6, 2010 at 7:05 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> Excerpts from Nirbheek Chauhan's message of 2010-12-06 07:41:16 -0500=
:
>> Hello,
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
>> I've been told that the problem is somewhat difficult to solve
>> properly under block-based representation of data, but I was hoping
>> that btrfs' reflink mechanism and its space-efficient packing of sma=
ll
>> files might make it doable.
>>
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

Tis doesn't seem to be interesting, looking just like traditional COW o=
verwrite.

>
> For #2 and #3, all of the file pointers past the bytes you want to ad=
d
> or remove need to be updated with a new file offset. =C2=A0I'd say fo=
r an
> initial implementation to use the IOC_CLONE_RANGE code, and after
> everything is working we can look at optimizing it with a shift ioctl=
 if
> it makes sense.

Not sure how btrfs implements versioned B-trees, but other
snapshot-capable file-systems I'm aware of utilize DITTO B-tree entry
that says "for tis range, consult previous version tree". One can
imagine DITTO(n) extension that would tell "subtract n from look-up
key and then consult previous version tree", effectively achieving
range shift behavior. FWIW.

Regards,
Andrey


>
> Of the use cases you list, video editors seems the most useful.
> Databases already have things pretty much under control, and delta
> patching wants to go to a new file anyway. =C2=A0Video editing softwa=
re has
> long been looking for ways to do this.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
