From: Mathijs Kwik <mathijs@bluescreen303.nl>
Subject: Re: how stable are snapshots at the block level?
Date: Sun, 23 Oct 2011 18:41:20 +0200
Message-ID: <CAKvOHKACQNDweSsunRGDzs2UL4jdr0sNZ5E1_64bE2n7o9AZtw@mail.gmail.com>
References: <CAKvOHKABup6D2pwbiZpCfxoHt7Obv6sHAZqcPp=ce9ZcJ8-vuw@mail.gmail.com>
	<20111023160535.GA11547@shiny.Mikenopa.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Mathijs Kwik <mathijs@bluescreen303.nl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111023160535.GA11547@shiny.Mikenopa.local>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 23, 2011 at 6:05 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Sun, Oct 23, 2011 at 09:45:10AM +0200, Mathijs Kwik wrote:
>> Hi all,
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
>>
>> After finding some discussion about it here:
>> http://www.backupcentral.com/phpBB2/two-way-mirrors-of-external-mail=
ing-lists-3/backuppc-21/using-rsync-for-blockdevice-level-synchronisati=
on-of-backupp-100438
>>
>> I found that the official rsync-patches tarball includes the patch
>> that allows syncing full block devices.
>> After the initial backup, I found that this indeed speeds up my back=
ups a lot.
>> Ofcourse this is meant for syncing unmounted filesystems (or other
>> things that are "stable" at the block level, like LVM snapshot
>> volumes).
>>
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
>>
>> Can someone with knowledge about the on-disk structure please
>> confirm/reject that subvolumes (created before starting rsync on the
>> block device) should be safe and never move by themselves? Or was I
>> just lucky?
>> Are there any things that might break the backup when performed duri=
ng rsync?
>> Like creating/deleting other subvolumes, probably defrag isn't a goo=
d
>> idea either :)
>
> The short answer is that you were lucky ;)

That's why I only try this at home :)

>
> The big risk is the extent allocation tree is changing, and the tree =
of
> tree roots is changing and so the result of the rsync isn't going to =
be
> a fully consistent filesystem.

Nope, I understand it's not fully consistent, but I'm hoping for
consistency for all subvols that weren't in use during the sync/dd.

>
> With that said, as long as you can mount it the actual files in the
> snapshot are going to be valid. =C2=A0The only exceptions are if you'=
ve run a
> filesystem balance or removed a drive during the rsync.

Do I understand correctly that as long as I don't defrag/balance or
add/remove drives (my example is just about 1 drive though), there's a
chance the result isn't mountable, but if it _is_ mountable, all
subvolumes that weren't touched during the rsync/dd should be fine?
Or is there a chance that some files/dirs (in a snapshot volume) are
fine, but others are broken?

In other words: do I only need to check the destination to be
mountable afterwards or does that by itself mean not enough.

You mentioned 2 important trees
- tree of tree roots
- extent allocation tree

My root subvolume contains only subvolumes (no dirs/files), 1 of which
is mounted with -o subvol, the rest are snapshots.
Am I correct to assume the tree of tree roots doesn't change as long
as I don't create/remove subvols?

And for the extent allocation tree, can I assume that all changes to
extent allocation will be related to files/dirs changing on the
currently in-use subvolume? All extents that contain files in any of
the snapshots will still be there as changes to those files in
"current" will be COWed to new extents. So the risk is not that
extents are marked "free" when they aren't, but I might end up with
extents that are marked in-use while they are free.
As I expect "current" to become corrupt in the destination, I will
remove the subvolume there. Will that take care of the extent
allocation tree? Or will there still be extents marked "in use"
without any subvolume/dir/file pointing at it? If so, this is probably
something that the future fsck can deal with?


>
> -chris

Thanks,
Mathijs
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
