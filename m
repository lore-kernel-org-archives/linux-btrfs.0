From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Wed, 26 Jan 2011 22:56:19 +0100
Message-ID: <AANLkTi=nd+445mAH=ijgYeJT+5koUf7dwu9tp_tK6uK9@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
	<AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com>
	<1294416073-sup-5254@think>
	<201101071726.02958.hka@qbs.com.pl>
	<1294428310-sup-9846@think>
	<AANLkTi=PT3+wiAjL7P0=bx7e8_VCXBGD2272PzLgJFu4@mail.gmail.com>
	<AANLkTim8wQuskQT1DsRX-1LY6yx91Ltd+hDz9OsYvjOP@mail.gmail.com>
	<1296069448-sup-2841@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hubert Kario <hka@qbs.com.pl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296069448-sup-2841@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 26, 2011 at 8:30 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> My answer hasn't really changed ;) =C2=A0Replacing file data is a com=
mon
> operation, but it is still surprisingly complex. =C2=A0Again, the tru=
ncate is
> O(size of the file) and it is actually impossible to do this atomical=
ly
> in most filesystems.

Unfortunately life isn't trivial. ;)
Given that it's common, it doesn't make sense to have code duplication
in lots of apps to implement the temp file rename pattern.
If it's too complex to implement in the FS (ATM), would it be possible
to implement it in a higher layer?

> You don't notice this because xfs/ext34/btrfs (and many others) have
> code that makes sure a truncate is restarted if you crash. =C2=A0So, =
it
> appears to be atomic even though we're really just restarting the
> operation. =C2=A0In order to have a truncate + replacement of data op=
eration,
> we'd have to do a disk format change that includes both the truncate =
and
> the new data.

I'm not sure why the disk format would have to change.
Conceptually, just like the temp file case, you'd write the new data
to newly allocated blocks.
After (and I guess that's the complex part) they're safely on disk,
you update the meta data, in an atomic way.

> It would look a lot like echo data > file.new ; truncate file ; mv
> file.new file, but recorded in the FS metadata.
>
> I don't have this in the btrfs roadmap. =C2=A0It would be nice but mo=
st
> people use databases for things that require atomic operations. =C2=A0=
I

Executables and files shouldn't be in a DB.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
