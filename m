From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Atomic replacement of subvolumes is not possible
Date: Sun, 27 Jun 2010 19:44:12 -0500
Message-ID: <AANLkTinQmObagOuslcRzuuLZe3ViamIs8e-Jgt-bjRvD@mail.gmail.com>
References: <4C263826.1060702@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Roger Leigh <rleigh@debian.org>
To: daniel@debian.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C263826.1060702@debian.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 26, 2010 at 12:25 PM, Daniel Baumann <daniel@debian.org> wr=
ote:
> Hi,
>
> this is basically a forward from
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D587253
>
> "rename(2) allows for the atomic replacement of files. =A0Being able =
to
> atomically replace subvolume snapshots would be equally invaluable,
> since it would permit lock-free replacement of subvolumes.
>
> =A0% btrfs subvolume snapshot <src> <dest>
>
> creates dest as a snapshot of src. However, if I want to do the
> converse,
>
> =A0% btrfs subvolume snapshot <dest> <src>
>
> then <dest> is snapshotted as <src>/<dest>, i.e. not replacing the
> original subvolume, but going inside the original subvolume.
>
> Use case 1:
> =A0I have a subvolume of data under active use, which I want to
> =A0periodically update. =A0I'd like to do this by atomically
> =A0replacing its contents. =A0I can replace the content right now
> =A0by deleting the old subvolume and then snapshotting the new
> =A0on in its place, but it's racy. =A0It really needs to be
> =A0replaced in a single operation, or else there's a small window
> =A0where there is no data, and I'd need to resort to some external
> =A0locking to protect myself.
>
> Use case 2:
> =A0In schroot, we create btrfs subvolume snapshots to get copy-on-
> =A0write chroots. =A0This works just fine. =A0We also provide direct
> =A0access to the "source" subvolume, but since it could be
> =A0snapshotted in an inconsistent state while being updated, we
> =A0want to do the following:
>
> =A0=B7 snapshot source subvolume
> =A0=B7 update snapshot
> =A0=B7 replace source volume with updated snapshot"
>
> Please keep roger in the cc for any replies, thanks.

i am also looking for functionality similar to this, except i would
like to be able to replace the DEFAULT subvolume, with an empty or
existing subvolume, and put the original default subvolume INSIDE the
new root (or drop it completely), outlined by this post and the thread
it's in:

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg05278.html

is there any feedback on these actions?  no one seems to even respond :=
-(

it would seem we need ways to swap subvolumes around, _including_ the
default, providing the on-disk format supports such operations.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
