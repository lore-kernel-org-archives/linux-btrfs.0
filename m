From: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Subject: Re: Questions regarding COW-related behaviors
Date: Tue, 9 Nov 2010 14:18:01 +0000
Message-ID: <1FAB8D40-6A0E-4E90-A9D9-3FB2D1656377@gmail.com>
References: <71EA287F-BE05-4BD8-A474-58A68B0FC6A3@gmail.com> <20101108224537.GA8950@flcl.lan>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=iso-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101108224537.GA8950@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

=46irst of all, thanks for all replies; they've been quite insightful.


On Nov 8, 2010, at 10:45 PM, Sean Bartell wrote:

> From your questions, you don't seem to understand CoW. CoW is basical=
ly
> an alternative to the logging/journalling used by most filesystems.
>=20

Actually, I do understand how CoW works. Although, maybe due to naivet=E9=
, I do lack some understanding on how it is applied on a full-fledged f=
ilesystem.


>> 2) Each time a COW happens, is there any kind implicit 'snapshotting=
' that may keep track of changes around the filesystem for each COW?=20
>> By Rodeh's paper and some info on the wiki, I gather that a new root=
 is created for each COW, due to shadowing, but will the previous tree =
be kept? The wiki, at "BTRFS Design", states that "after the commit fin=
ishes, the older subvolume root items may be removed". This would make =
impossible to track changes to files, but 'btrfs subvolume find-new' st=
ill manages to output file generations, so there must be some info left=
 behind.=20
>=20
> The old tree is discarded unless the user requested a snapshot of it.
>=20
> Every time btrfs updates the roots is a new generation. Some data
> structures have "generation" fields, indicating the generation in whi=
ch
> they were most recently changed. This is mostly used to verify the
> filesystem is correct, but it's also possible to scan the generation
> fields and find out which files have changed.

As Goffredo Baroncelli explained in a previous reply to my questions, t=
he "find-new" command will search through keys with type BTRFS_EXTENT_D=
ATA_TYPE. This command does print several changes to the same files thr=
oughout history since a given generation. My new question to this is ra=
ther simple: does BTRFS actually keep the data from this generations to=
 which "find-new" has access, or is it only able to access information =
that records this changes?


>=20
>> 3) Following (2), is there any way to access this informations and, =
let's say, recover an older version of a given file? Or an entire previ=
ous tree?
>=20
> No, unless the user request a snapshot. I'm assuming you're not talki=
ng
> about tools like PhotoRec, that try to reassemble files from whatever
> disk data looks valid.

You're right. What I mean is for one to be able to actually recover an =
old, recently-modified version of a file -- somewhat like a versioning =
system. I believe to have read that both WAFL and ZFS have similar supp=
ort. I do understand now that this is only possible if one explicitly c=
reates a snapshot.

However, I thought that, by using shadowing of the changed blocks, it c=
ould be quite inexpensive (aside from a storage point-of-view) to impli=
citly keep multiple "versions" of the tree --- unchanged blocks would b=
e kept shared among "tree versions" until CoWed, if they were ever chan=
ged. With these versions one would be able to recover, or restore, a fi=
le or the entire filesystem, regardless of having created an explicit c=
heckpoint. Then again,  I understand this is not how it works with BTRF=
S, and neither do I have a clue if it is feasible such support.

=20
>=20
>> 4) From Rodeh's paper I got the idea that BTRFS uses periodic checkp=
ointing, in order to assign generations to operations. Using 'btrfs sub=
volume find-new' I confirmed my suspicions. After copying two different=
 directories into the same subvolume at the same time, all files got as=
signed the same generation and it took a while until they all showed up=
=2E This raises the question: what triggers a new checkpoint? Is it bas=
ed on elapsed time since last checkpoint? Is it triggered by a COW and =
then, all COWs happening at the same time will be put together and crea=
te a big new generation?
>=20
> Again, periodic checkpointing is probably the wrong way to think abou=
t
> it. It would be wasteful to overwrite the superblocks every time a
> change is made; instead, btrfs may combine multiple changes into one
> generation and only update the superblocks once. I'm not sure exactly
> how btrfs decides when to write a new generation.

As Chris Samuel stated in another reply, at some point I did made the l=
ink between BTRFS' checkpointing and NILFS'. Although I assumed BTRFS' =
checkpointing was hardcoded somewhere in the code. If this is not the c=
ase, I'm still wondering how such decision is made, for I have not yet =
found where this checkpointing is happening in the code.


Regards.

---
Jo=E3o Eduardo Lu=EDs--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
