From: Mathijs Kwik <mathijs@bluescreen303.nl>
Subject: Re: how stable are snapshots at the block level?
Date: Sun, 23 Oct 2011 17:19:42 +0200
Message-ID: <CAKvOHKCjxxKTahivOuRBPBB89JBrTwndQ6cCEuFaPbJr8PYtpA@mail.gmail.com>
References: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com>
	<000101cc918d$3ffb45b0$bff1d110$@nedharvey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Edward Ned Harvey <kernel@nedharvey.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <000101cc918d$3ffb45b0$bff1d110$@nedharvey.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 23, 2011 at 4:08 PM, Edward Ned Harvey <kernel@nedharvey.co=
m> wrote:
>> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
>> owner@vger.kernel.org] On Behalf Of Mathijs Kwik
>>
>> I'm currently doing backups by doing a btrfs snapshot, then rsync th=
e
>> snapshot to my backup location.
>> As I have a lot of small files and quite some changes between
>> snapshots, this process is taking more and more time.
>> I looked at "btrfs find-new", which is promissing, but I need
>> something to track deletes and modifications too.
>> Also, while this will help the initial comparison phase, most time i=
s
>> still spent on the syncing itself, as a lot of overhead is caused by
>> the tiny files.
>
> No word on when this will be available, but "btrfs send" or whatever =
it's going to be called, is currently in the works. =C2=A0This is reall=
y what you want.
>
>
>> After finding some discussion about it here:
>> http://www.backupcentral.com/phpBB2/two-way-mirrors-of-external-
>> mailing-lists-3/backuppc-21/using-rsync-for-blockdevice-level-
>> synchronisation-of-backupp-100438
>
> When you rsync at the file level, it needs to walk the directory stru=
cture, which is essentially a bunch of random IO. =C2=A0When you rsync =
at the block level, it needs to read the entire storage device sequenti=
ally. =C2=A0The latter is only a possible benefit, when the amount of t=
ime to walk the tree is significantly greater than the time to read the=
 entire block device.

My test was just a 10G block device filled with random files between 51=
2b and 8k
While this is a contrived example, in this case a block level rsync is
way way way faster. It's not just the tree-walking that's slow, I
guess there's some per-file overhead too.When not using rsync but
plain dd, it's even faster (at the expense of more writes, even when
unneeded), since it can almost transfer data at the maximum write
speed for the receiver.


>
> Even if you rsync the blocklevel device, the local rsync will have to=
 read the entire block device to search for binary differences before s=
ending. =C2=A0This will probably have the opposite effect from what you=
 want - Because every time you created and deleted a file, every time y=
ou overwrote an existing block (copy on write) it still represents bina=
ry differences on disk, so even though that file was deleted, or severa=
l modifications all yielded a single modification in the end, all the b=
ytes of all the deleted files and all the file deltas that were formerl=
y occupied will be sent anyway. =C2=A0Unless you always zero them out, =
or something.

I understand. A block copy is not advantageous in every situation. I'm
just trying to find out if it's possible for the situations where it
is beneficial.

>
> Given that you're talking about rsync'ing a block level device that c=
ontains btrfs, I'm assuming you have no raid/redundancy. =C2=A0And the =
receiving end is the same.

Yup, in my example I synced my laptop ssd to an external disk (usb3).

>
> Also if you're rsyncing the block level device, you're running undern=
eath btrfs and losing any checksumming benefit that btrfs was giving yo=
u, so you're possibly introducing risk for silent data corruption. =C2=A0=
(Or more accurately, failing to allow btrfs to detect/correct it.)

Not sure... I'm sure that's the case for in-use subvolumes, but
shouldn't snapshots (and their metadata/checksums) just be safe?

>
>
>> I found that the official rsync-patches tarball includes the patch
>> that allows syncing full block devices.
>> After the initial backup, I found that this indeed speeds up my back=
ups a lot.
>> Ofcourse this is meant for syncing unmounted filesystems (or other
>> things that are "stable" at the block level, like LVM snapshot
>> volumes).
>
> Just guessing you did a minimal test. =C2=A0Send initial image, then =
make some changes, then send again. =C2=A0I don't expect this to be typ=
ical after a day or a week of usage, for the reasons previously describ=
ed.
>
>
>> I tested backing up a live btrfs filesystem by making a btrfs
>> snapshot, and this (very simple, non-thorough) turned out to work ok=
=2E
>> My root subvolume contains the "current" subvolume (which I mount) a=
nd
>> several backup subvolumes.
>> Ofcourse I understand that the "current" subvolume on the backup
>> destination is broken/inconsistent, as I change it during the rsync
>> run. But when I mounted the backup disk and compared the subvolumes
>> using normal file-by-file rsync, they were identical.
>
> I may be wrong, but this sounds dangerous to me. =C2=A0As you've demo=
nstrated, it will probably work a lot of the time - because the subvols=
 and everything necessary to reference them are static on disk most of =
the time. =C2=A0But as soon as you write to any of the subvols - and th=
at includes a scan, fsck, rebalance, defrag, etc. =C2=A0Anything that w=
rites transparently behind the scenes as far as user processes are conc=
erned... =C2=A0Those could break things.

I understand there are harmful operations, that's why I'm asking if it
is known exactly what those actions are. I'm not writing to the
snapshots (only to my "current" subvol) during rsync/dd and I make
sure not to rebalance or defrag (basically don't use any btrfs progs).
I understand that "current" will be corrupt on the backup destination,
but it would be great to know that all other subvolumes should be
safe.

=46or this case (my laptop) I can stick to file-based rsync, but I thin=
k
some guarantees should exist at the block level. Many virtual machines
and cloud hosting services (like ec2) provide block-level snapshots.
With xfs, I can freeze the filesystem for a short amount of time
(<100ms), snapshot, unfreeze. I don't think such a lock/freeze feature
exists for btrfs, but if btrfs guarantees all snapshots are stable as
long as you don't use any btrfs tools while snapping, it's not needed
either. Ofcourse I understand there's a difference between an instant
block snapshot and a dd/rsync session that takes a few minutes, but if
the dont-use-dangerous-operations conditions are met, it shouldn't
matter for snapshots that aren't used.

Also, I can see how future applications might want to use btrfs for
providing history, or other special purposes that they now write their
own b-tree code for. If the above holds true, block backups would have
no issues backing up this data, while file backups might lead to
enormous redundancy as files/blocks shared between multiple subvolumes
get unCOWed on the destination.


>
>
>> Thanks for any comments on this.
>
> I suggest one of a few options:
> (a) Stick with rsync at the file level. =C2=A0It's stable.
> (b) Wait for btrfs send (or whatever) to become available
> (c) Use ZFS. =C2=A0Both ZFS and BTRFS have advantages over one anothe=
r. =C2=A0This an area where zfs has the advantage for now.

Thanks for your advice,
Like I said, for me, right now, sticking to tried-and-tested
file-based rsync is just ok. But I hope to get some insights into
other possibilities. btrfs send sounds cool, but I sure hope this is
not the only solution, as I described a few scenarios where
block-level copies have advantages.

Mathijs


>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
