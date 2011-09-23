From: Erik Jensen <eriksjunk@rkjnsn.net>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 23 Sep 2011 06:51:35 -0700
Message-ID: <CAGh96GHNcKZ50Z3q4SP3NrrT=bsNeW3L72AUanD=u317mSXtKQ@mail.gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
 <1312404713-sup-6548@shiny> <loom.20110818T030824-742@post.gmane.org> <1313700115-sup-2457@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313700115-sup-2457@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

Now that you're back from vacation, I was wondering if you would be
able to provide a revised estimate on how long this will take. Also,
of the four parts, which will be necessary to correct a 'parent
transid verify failed' error?

Thank you for your time,
--Erik

On Thu, Aug 18, 2011 at 1:50 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Yalonda Gishtaka's message of 2011-08-17 21:09:37 -0400=
:
>> Chris Mason <chris.mason <at> oracle.com> writes:
>>
>> >
>> > Aside from making sure the kernel code is stable, btrfsck is all I=
'm
>> > working on right now. =A0I do expect a release in the next two wee=
ks that
>> > can recover your data (and many others).
>> >
>> > Thanks,
>> > Chris
>> > --
>>
>>
>> Chris,
>>
>> We're all on the edge of our seats. =A0Can you provide an updated ET=
A on the
>> release of the first functional btrfsck tool? =A0No pressure or anyt=
hing ;)
>
> Hi everyone,
>
> I've been working non-stop on this. =A0Currently fsck has four parts:
>
> 1) mount -o recovery mode. =A0I've posted smaller forms of these patc=
hes
> in the past that bypass log tree replay. =A0The new versions have cod=
e to
> create stub roots for trees that can't be read (like the extent
> allocation tree) and will allow the mount to proceed.
>
> 2) fsck that scans for older roots. =A0This takes advantage of older
> copies of metadata to look for consistent tree roots on disk. =A0The
> downside is that it is currently very slow. =A0I'm trying to speed it=
 up
> by limiting the search to only the metadata block groups and a few ot=
her
> tricks.
>
> 3) fsck that fixes the extent allocation tree and the chunk tree. =A0=
This
> is where I've been spending most of my time. =A0The problem is that i=
t
> tends to recover some filesystems and badly break others. =A0While I'=
m
> fixing up the corner cases that work poorly, I'm adding an undo log t=
o
> the fsck code so that you can get the FS back into its original state=
 if
> you don't like the result of the fsck.
>
> 4) The rest of the corruptions can be dealt with fairly well from the
> kernel. =A0I have a series of patches to make the extent allocation t=
ree
> less strict about reference counts and other rules, basically allowin=
g
> the FS to limp along instead of crash.
>
> These four things together are basically my minimal set of features
> required for fedora and our own internal projects at Oracle to start
> treating us as production filesystem.
>
> There are always bugs to fix, and I have #1 and #2 mostly ready. =A0I=
 had
> hoped to get #1 out the door before I left on vacation and I still mi=
ght
> post it tonight.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
