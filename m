From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: Questions regarding COW-related behaviors
Date: Mon, 8 Nov 2010 17:45:37 -0500
Message-ID: <20101108224537.GA8950@flcl.lan>
References: <71EA287F-BE05-4BD8-A474-58A68B0FC6A3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?iso-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <71EA287F-BE05-4BD8-A474-58A68B0FC6A3@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

(sorry for sending twice)

On Mon, Nov 08, 2010 at 02:23:13PM +0000, Jo=E3o Eduardo Lu=EDs wrote:

> Basically, I need to be aware how the COW works in BTRFS, and what it=
 may allow one to achieve. Questions follow.

=46rom your questions, you don't seem to understand CoW. CoW is basical=
ly
an alternative to the logging/journalling used by most filesystems.

When you change a data structure in a journalling filesystem, like ext4=
,
you actually write two copies--one into the journal, and one that
overwrites the old data structure. If a crash happens, at least one cop=
y
will still be valid, making recovery possible.

When you change a data structure in a CoW filesystem, like btrfs, you
only write one copy, but you DON'T write it over the old data structure=
=2E
You write it to a new, unallocated space. This means the location of th=
e
data structure changed, so you have to change the parent data structure=
;
you use CoW for that and so on up to the superblocks, which actually ar=
e
overwritten. Once that's finished, the old versions are no longer
needed, so they will be unallocated and eventually overwritten. If a
crash happens, the superblocks will still point to the old version of
the data structures.

This makes it relatively easy to add snapshot features--just add
reference counting, and don't free old versions of data structures if
they're still being used. However, this only happens if the user
explicitly requests a snapshot. Otherwise, the old data structures are
freed immediately once the new ones are completely written.

> 1) Is COW only used when creating or updating a file? While testing B=
TRFS, using 'btrfs subvolume find-new', I got the idea that neither cre=
ation of directories, nor any kind of deletion are covered by COW. Is t=
his right?

CoW is used anytime any structure is changed. find-new is not directly
related to CoW.

> 2) Each time a COW happens, is there any kind implicit 'snapshotting'=
 that may keep track of changes around the filesystem for each COW?=20
> By Rodeh's paper and some info on the wiki, I gather that a new root =
is created for each COW, due to shadowing, but will the previous tree b=
e kept? The wiki, at "BTRFS Design", states that "after the commit fini=
shes, the older subvolume root items may be removed". This would make i=
mpossible to track changes to files, but 'btrfs subvolume find-new' sti=
ll manages to output file generations, so there must be some info left =
behind.=20

The old tree is discarded unless the user requested a snapshot of it.

Every time btrfs updates the roots is a new generation. Some data
structures have "generation" fields, indicating the generation in which
they were most recently changed. This is mostly used to verify the
filesystem is correct, but it's also possible to scan the generation
fields and find out which files have changed.

> 3) Following (2), is there any way to access this informations and, l=
et's say, recover an older version of a given file? Or an entire previo=
us tree?

No, unless the user request a snapshot. I'm assuming you're not talking
about tools like PhotoRec, that try to reassemble files from whatever
disk data looks valid.

> 4) From Rodeh's paper I got the idea that BTRFS uses periodic checkpo=
inting, in order to assign generations to operations. Using 'btrfs subv=
olume find-new' I confirmed my suspicions. After copying two different =
directories into the same subvolume at the same time, all files got ass=
igned the same generation and it took a while until they all showed up.=
 This raises the question: what triggers a new checkpoint? Is it based =
on elapsed time since last checkpoint? Is it triggered by a COW and the=
n, all COWs happening at the same time will be put together and create =
a big new generation?

Again, periodic checkpointing is probably the wrong way to think about
it. It would be wasteful to overwrite the superblocks every time a
change is made; instead, btrfs may combine multiple changes into one
generation and only update the superblocks once. I'm not sure exactly
how btrfs decides when to write a new generation.

> 5) If we have multiple jobs updating the same file at the same time, =
I assume the system will shadow their updates; when the time for commit=
ting comes, will there be any kind of 'conflict' between concurrent upd=
ates, or will they be applied by order of commit, ignoring whether ther=
e were previous commits or not? Regarding checkpointing, will all the c=
hanges be shown as part of the generation, or will they be considered a=
s only one?

This is handled just like in any other filesystem. There are no
concurrent generations; if two threads both update a file, btrfs will
handle the updates sequentially, one at a time.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
