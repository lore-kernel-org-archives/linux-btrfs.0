From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Atomic replacement of subvolumes is not possible
Date: Wed, 30 Jun 2010 09:26:11 -0500
Message-ID: <AANLkTilcAfaH4KmSzKGp8M-xj511IlowGgIZnhHopdNx@mail.gmail.com>
References: <4C263826.1060702@debian.org>
	<AANLkTinQmObagOuslcRzuuLZe3ViamIs8e-Jgt-bjRvD@mail.gmail.com>
	<20100630133142.GU1993@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	C Anthony Risinger <anthony@extof.me>, daniel@debian.org,
	linux-btrfs@vger.kernel.org, Roger Leigh <rleigh@debian.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100630133142.GU1993@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 30, 2010 at 8:31 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Sun, Jun 27, 2010 at 07:44:12PM -0500, C Anthony Risinger wrote:
>> On Sat, Jun 26, 2010 at 12:25 PM, Daniel Baumann <daniel@debian.org>=
 wrote:
>> > Hi,
>> >
>> > this is basically a forward from
>> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D587253
>> >
>> > "rename(2) allows for the atomic replacement of files. =A0Being ab=
le to
>> > atomically replace subvolume snapshots would be equally invaluable=
,
>> > since it would permit lock-free replacement of subvolumes.
>> >
>> > =A0% btrfs subvolume snapshot <src> <dest>
>> >
>> > creates dest as a snapshot of src. However, if I want to do the
>> > converse,
>> >
>> > =A0% btrfs subvolume snapshot <dest> <src>
>> >
>> > then <dest> is snapshotted as <src>/<dest>, i.e. not replacing the
>> > original subvolume, but going inside the original subvolume.
>> >
>> > Use case 1:
>> > =A0I have a subvolume of data under active use, which I want to
>> > =A0periodically update. =A0I'd like to do this by atomically
>> > =A0replacing its contents. =A0I can replace the content right now
>> > =A0by deleting the old subvolume and then snapshotting the new
>> > =A0on in its place, but it's racy. =A0It really needs to be
>> > =A0replaced in a single operation, or else there's a small window
>> > =A0where there is no data, and I'd need to resort to some external
>> > =A0locking to protect myself.
>
> I'm not sure I understand use case #1. =A0The problem is that you'll =
have
> files open in the subvolume and you can't just pull the rug out from
> under them. =A0Could you tell me a little more about what you're tryi=
ng to
> do?
>
>> >
>> > Use case 2:
>> > =A0In schroot, we create btrfs subvolume snapshots to get copy-on-
>> > =A0write chroots. =A0This works just fine. =A0We also provide dire=
ct
>> > =A0access to the "source" subvolume, but since it could be
>> > =A0snapshotted in an inconsistent state while being updated, we
>> > =A0want to do the following:
>> >
>> > =A0=B7 snapshot source subvolume
>> > =A0=B7 update snapshot
>> > =A0=B7 replace source volume with updated snapshot"
>> >
>> > Please keep roger in the cc for any replies, thanks.
>>
>> i am also looking for functionality similar to this, except i would
>> like to be able to replace the DEFAULT subvolume, with an empty or
>> existing subvolume, and put the original default subvolume INSIDE th=
e
>> new root (or drop it completely), outlined by this post and the thre=
ad
>> it's in:
>>
>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg05278.htm=
l
>>
>> is there any feedback on these actions? =A0no one seems to even resp=
ond :-(
>>
>> it would seem we need ways to swap subvolumes around, _including_ th=
e
>> default, providing the on-disk format supports such operations.
>
> Moving 'default' generally involves a reboot for the same reasons. =A0=
We
> have to worry about open files and their view of the filesystem. =A0m=
v on
> a directory won't affect file handles that are open, and renaming
> subvolumes needs to follow a similar model.

could we fail if the user tries to replace a subvolume while it's
being used?  what if the root device is _not_ the default (".")
subvolume, then can it be swapped?

in my use case, i am running in initramfs, so the root device has not
even been mounted or pivoted to; it should be safe to do whatever i
want to the filesystem.  i want to move the user's installation to a
dedicated subvolume.

what about this:  would it be possible to have TWO subvolumes by
"default"?  the regular one (current directory, "."):

mount -o subvol=3D. <btrfs_dev> /mnt

would behave as it does now.  BUT... there would then be a special,
permanent (like "." is right now) subvol, say "parent directory"
(".."):

mount -o subvol=3D.. <btrfs_dev> /mnt

TWO dots would mount the parent of ".", where i could then swap out
the real default (".").

would that work?

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
