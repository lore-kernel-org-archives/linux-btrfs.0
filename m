From: Fred van Zwieten <fvzwieten@gmail.com>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 23:15:31 +0200
Message-ID: <AANLkTimWJoYVf2nqoi7KkOKSFz2F7wp0gcV=XKvo5uzj@mail.gmail.com>
References: <AANLkTinmSdHwXXq3s64sM39GjacafgwgTjPadZGHuway@mail.gmail.com>
	<AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>
	<4C7BF087.6060400@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C7BF087.6060400@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

I just glanced over the DRBD/LVM combi, but I don't see it being
functionally equal to SnapMirror. Let me (try to) explain how
snapmirror works:

On system A there is a volume (vol1). We let this vol1(A) replicate
thru SnapMirror to vol1(B). This is done by creating a snap vol1sx(A)
and replicate all changed blocks between this snapshot (x) and the
previous snapshot (x-1). The first time, there is no x-1 and the whole
volume will be replicated, but after this initial "full copy", only
the changed blocks between the two snapshot's are being replicated to
system B. This is also called snap based replication. Why we want
this? Easy. To support consistent DB snap's. The proces works by first
putting the DB in a consistent mode (depends on DB implementation),
create a snapshot, let the DB continue, replicate the changes. This
way a DB consistent state will be replicated. The cool thing about the
NetApp implementation is that on system B the snap's (x, x-1, x-2,
etc) are also available. When there is trouble, you can choose to
online the DB on system B on any of the snap's, or, even cooler, to
replicate one of those snap's back to system A, doing a block based
rollback at the filesystem level.

=46red

On Mon, Aug 30, 2010 at 7:55 PM, K. Richard Pixley <rich@noir.com> wrot=
e:
> =C2=A0On 20100830 10:07, Fred van Zwieten wrote:
>>
>> Hi there,
>>
>> I would like to know if there is something functionally equivalent t=
o
>> NetApp's SnapMirror in the works or planning? It would require block
>> level access to a snap and the ability to rebuild (subvolumes
>> including it's) snap's on another machine.
>>
>> If not, what would be the best way to build something more or less
>> equivalent using existing tools? rsync-ing a snap seems the same, bu=
t
>> it isn't. First of all it 's file based, not very nice for DB's, and
>> you don't get the snap's on "the other side" the same.
>>
>> Fred
>
> I think drbd does precisely what you want.
>
> It's not useful for fault tolerance, nor for load balancing, but it w=
ill
> produce a remote block copy that can be used as a sort of "hot backup=
".
>
> You can also do something very similar by combining LVM, (the logical=
 volume
> manager), with LVM snapshots and NBD, (the network block device) by
> mirroring to an NBD device.
>
> Neither of these approaches can tolerate the remote file system being=
 "live"
> until and unless it takes over for the primary. =C2=A0But either can =
maintain a
> dynamic remote block device.
>
> --rich
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
