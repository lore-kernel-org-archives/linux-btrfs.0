From: Cyrille =?ISO-8859-1?Q?Ch=E9p=E9lov?= <cyrille@chepelov.org>
Subject: Re: full btrfs partition, became unmountable (+ a solution that
 thankfully worked for me)
Date: Thu, 27 Jan 2011 07:52:22 +0100
Message-ID: <1296111143.29117.38.camel@hestia>
References: <1295981200.29117.19.camel@hestia>
	 <BC28BE23-1017-456E-9EAA-74A840809085@me.com>
	 <1296027969.29117.26.camel@hestia>
	 <C6F9866B-F632-4A8A-BCA0-5BA44338FA21@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Shawn Stricker <kb1ibt@me.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C6F9866B-F632-4A8A-BCA0-5BA44338FA21@me.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Shawn,

it's now performing a sequential read of the volume, which will probabl=
y
take significantly more time for you than for me (where I was dealing
with an image of a 16GB SD card, stored on a recent mechanical SATA
disk).

I'm a bit confused by what happens while reading the "potential supers"=
=2E
At first the blocks appear valid, then they are all "misplaced" (meanin=
g
the bytenr field !=3D the bytenr from which the block has been read, IO=
W
the block is most probably not part of btrfs structures, from what I
understand).  From the output before the "will attempt to find useful
trees" messages, it seems btrfsck is now doing a sequential read not
just of /dev/sde, but also every single block device ?

disk-io.c: try_emergency_tree_fixup() is probably now a bit too silent
for your use case at the moment. You might want to uncomment the
commented out fprintf there; this will make it very verbose (an extra
line per structure block) but will provide clues as to where on disk is
it working.

	-- Cyrille

Le jeudi 27 janvier 2011 =C3=A0 01:18 -0500, Shawn Stricker a =C3=A9cri=
t :
> any chance of getting a little more informative output?
> I started the command at about 2250 Eastern and now at 0117 Eastern t=
he command is still running and all of the attached output happened in =
the first few minutes (under 5).
> On Jan 26, 2011, at 2:46 AM, Cyrille Ch=C3=A9p=C3=A9lov wrote:
>=20
> > Le mardi 25 janvier 2011 =C3=A0 23:38 -0500, Shawn Stricker a =C3=A9=
crit :
> >> Not sure where you pulled your source from but a fresh checkout of=
 either master or next of git.kernel.org/pub/scm/linux/kernel/git/mason=
/btrfs-progs-unstable.git does not compile properly.
> >> They both fail with=20
> >>=20
> >> cc1: warnings being treated as errors
> >> disk-io.c: In function =E2=80=98btrfs_read_dev_super=E2=80=99:
> >> disk-io.c:937: error: format =E2=80=98%lu=E2=80=99 expects type =E2=
=80=98long unsigned int=E2=80=99, but argument 4 has type =E2=80=98unsi=
gned int=E2=80=99
> >> disk-io.c:957: error: implicit declaration of function =E2=80=98uu=
id_unparse=E2=80=99
> >>=20
> >> am I patching/compiling from the wrong source or is there somethin=
g I am missing?
> >=20
> > uh, I had been compiling with CFLAGS=3D-g, where the makefile speci=
fies
> > "-O2 -Werror"
> >=20
> > -Werror causes warnings to be treated as errors, which is a good th=
ing
> > in a way (makes sure stuff as this gets caught :) )
> >=20
> > fixes are:
> > 	* line 937 (patched), should be %llu instead of %lu
> > 	* line 957, there should be a prototype for uuid_unparse(), most
> > certainly by including <uuid/uuid.h>
> >=20
> > please try this patch instead.
> >=20
> > Thanks for the feedback!
> >=20
> > 	-- Cyrille
> >=20
> >> On Jan 25, 2011, at 1:46 PM, Cyrille Ch=C3=A9p=C3=A9lov wrote:
> >>=20
> >>> Hello all,
> >>>=20
> >>> Last Friday, the /var and /home partition on one of my appliances=
 became
> >>> full. This should normally not be much of a problem, except that =
after
> >>> the incident, I had been unable to mount the partition back again=
=2E
> >>>=20
> >>> The appliance runs 2.6.32 as provided by Debian during the last t=
wo
> >>> months.=20
> >>> The rescue computer runs 2.6.37; both exhibited the same behaviou=
r at
> >>> mount: an infinite loop-and-abort cycle (I unfortunately did not =
write
> >>> down the exact messages, but in a nutshell, there was not enough =
free
> >>> space to replay the log, so it aborted).
> >>>=20
> >>> After pulling the SD card (yes) to break the loop, I ended up wit=
h a
> >>> corrupt file system. Any attempt to mount, debug or fsck (using
> >>> btrfs-tools 0.19+20100601 as shipped by Debian, or compiled from =
git
> >>> 1b444cd2e6ab8dcafdd) aborted with the following message:
> >>>   btrfs-debug-tree: disk-io.c:741: open_ctree_fd: Assertion `!(!
> >>> tree_root->node)' failed.
> >>>=20
> >>> After much scavenging on the disk image, I finally managed to rec=
over,
> >>> using the (dirty) patch attached here. Since apparently other peo=
ple had
> >>> similar issues, I'm posting it in the hope it might be useful.
> >>>=20
> >>>   -- Cyrille
> >>>=20
> >>> PS: Chris, if btrfs-images of "before" and "after" my butcher fix=
 would
> >>> be useful to you, just let me know.=20
> >>> <scavenge.patch>
> >>=20
> >=20
> > <scavenge-2.patch>
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
