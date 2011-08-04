From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Btrfs Slowdown (due to Memory Handling?)
Date: Thu, 4 Aug 2011 13:40:20 -0500
Message-ID: <CAKcLGm_CGUOmYfs=_qC1UPm+o3OUyreXUeUYGL_1-p2CEmz_tw@mail.gmail.com>
References: <CAKcLGm_VFTjLPJjQXe9Vg2C5Cm3kwx_H8tthXsu+kJb1mxZB0g@mail.gmail.com>
	<1312467261-sup-951@shiny>
	<CAKcLGm_aDZ8L5dnETP_-NH1tkacu=1em59rocX0zTE+WTzTYFw@mail.gmail.com>
	<1312470248-sup-2811@shiny>
	<1312470311-sup-3193@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312470311-sup-3193@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 4, 2011 at 10:05 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Chris Mason's message of 2011-08-04 11:04:54 -0400:
>> Excerpts from Mitch Harder's message of 2011-08-04 10:45:51 -0400:
>> > On Thu, Aug 4, 2011 at 9:22 AM, Chris Mason <chris.mason@oracle.co=
m> wrote:
>> > > Excerpts from Mitch Harder's message of 2011-08-02 10:35:54 -040=
0:
>> > >> I'm running into a significant slowdown in Btrfs (> 10x slower =
than
>> > >> normal) that appears to be due to some issue between how Btrfs =
is
>> > >> allocating memory, and how the kernel is expecting Btrfs to all=
ocate
>> > >> memory.
>> > >>
>> > >> The problem does seem to be somewhat hardware specific. =A0I ca=
n
>> > >> reproduce on two of my computers (an older AMD Athlon(tm) XP 26=
00+
>> > >> with PATA, and a newer ACER Aspire netbook with an Atom CPU). =A0=
My
>> > >> Core2Duo computer with SATA seems unaffected by this slowdown.
>> > >>
>> > >> I've replicated this on 2.6.38, 2.6.39, and 3.0 kernels. =A0The
>> > >> following information was all obtained running on a 3.0 kernel =
merged
>> > >> with the latest 'for-linus' branch of Chris' git repo. =A0I've =
also
>> > >> tested on ext4 (no slow down encountered) to make sure the issu=
e
>> > >> wasn't completely unrelated to Btrfs.
>> > >
>> > > Just to double check, what was the top commit of for-linus when =
you did
>> > > this?
>> > >
>> > > The tracing shows that you're spending your time in mmap'd reada=
head.
>> > > So one of three things is happening:
>> > >
>> > > 1) The VM is favoring our metadata over data pages for the git p=
acked
>> > > file
>> > >
>> > > 2) We're reading ahead too aggressively, or not aggressively eno=
ugh
>> > >
>> > > 3) The git pack file is somehow more fragmented, and this is mak=
ing the
>> > > read ahead much less effective.
>> > >
>> > > The very first thing I'd check is to make sure the .git repo bet=
ween the
>> > > slow machines and the fast machines are identical. =A0Git does a=
 lot of
>> > > packing behind the scenes, and so an older repo that isn't fresh=
ly
>> > > cloned is going to be slower than a new repo.
>> > >
>> > > -chris
>> > >
>> >
>> > The top commit merged for the kernel used to generate the informat=
ion
>> > in this post was:
>> >
>> > Btrfs: make sure reserve_metadata_bytes doesn't leak out strange e=
rrors
>> > 75c195a2cac2c3c8366c0b87de2d6814c4f4d638
>> >
>> > I have since replicated the slowdown with a kernel merged with the
>> > latest 'for-linus' branch, whose top commit was:
>> > Btrfs: don't call writepages from within write_full_page
>> > 0d10ee2e6deb5c8409ae65b970846344897d5e4e
>>
>> Ok, so I'm going to guess that your problem is really with either fi=
le
>> layout or just us using more metadata pages than the others. =A0The =
file
>> layout part is easy to test, just replace your git repo with a fresh
>> clone (or completely repack it).
>
> Sorry, I should have said replace your git repo with a fresh,
> non-hardlinked clone. =A0git clone by default will just make hardlink=
s if
> it can, so it has to be a fresh clone.
>
> -chris
>

Oops, sorry, I let my responses slip off the list.

You are right about there being a potentially huge difference between
a cloned git repo and it's parent.  I didn't realize it could make
such a difference.

This problem now appears to have nothing to do with btrfs.  I can
replicate the problem on an ext4 partition also if I use a copy of the
parent git repository instead of a clone.  The problem seems to lie in
the fragmentation of the git repository.

If I work with a clone of my linux-btrfs repository, subsequent clones
are much faster.  Cloning my parent linux-btrfs repo takes about 90
minutes (when I have restricted free RAM).  Cloning a clone of the
parent drops down to less than 10 minutes.

With there being several other threads relating to btrfs 'slow downs',
I though this issue might be related.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
