From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 14:23:37 -0700
Message-ID: <AANLkTikWFUQ14_a6k-UR7mtWHnNJVudZuxqxYu9Xme-p@mail.gmail.com>
References: <AANLkTinmSdHwXXq3s64sM39GjacafgwgTjPadZGHuway@mail.gmail.com>
	<AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>
	<4C7BF087.6060400@noir.com>
	<AANLkTimWJoYVf2nqoi7KkOKSFz2F7wp0gcV=XKvo5uzj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "K. Richard Pixley" <rich@noir.com>, linux-btrfs@vger.kernel.org
To: Fred van Zwieten <fvzwieten@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimWJoYVf2nqoi7KkOKSFz2F7wp0gcV=XKvo5uzj@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 30, 2010 at 2:15 PM, Fred van Zwieten <fvzwieten@gmail.com> wrote:
> I just glanced over the DRBD/LVM combi, but I don't see it being
> functionally equal to SnapMirror. Let me (try to) explain how
> snapmirror works:
>
> On system A there is a volume (vol1). We let this vol1(A) replicate
> thru SnapMirror to vol1(B). This is done by creating a snap vol1sx(A)
> and replicate all changed blocks between this snapshot (x) and the
> previous snapshot (x-1). The first time, there is no x-1 and the whole
> volume will be replicated, but after this initial "full copy", only
> the changed blocks between the two snapshot's are being replicated to
> system B. This is also called snap based replication. Why we want
> this? Easy. To support consistent DB snap's. The proces works by first
> putting the DB in a consistent mode (depends on DB implementation),
> create a snapshot, let the DB continue, replicate the changes. This
> way a DB consistent state will be replicated. The cool thing about the
> NetApp implementation is that on system B the snap's (x, x-1, x-2,
> etc) are also available. When there is trouble, you can choose to
> online the DB on system B on any of the snap's, or, even cooler, to
> replicate one of those snap's back to system A, doing a block based
> rollback at the filesystem level.

In the ZFS world, this would be the "zfs send" and "zfs recv"
functionality.  In case anyone wants to read up on how it works over
there, for ideas on how it could be implemented for btrfs in the
future.

-- 
Freddie Cash
fjwcash@gmail.com
