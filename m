From: Fred van Zwieten <fvzwieten@gmail.com>
Subject: Re: remote mirroring in the works?
Date: Tue, 31 Aug 2010 07:07:29 +0200
Message-ID: <AANLkTimNOqfQHwPmJk4mQUsFOwORHtZvyZ_8QZ5om=wT@mail.gmail.com>
References: <AANLkTinmSdHwXXq3s64sM39GjacafgwgTjPadZGHuway@mail.gmail.com>
	<AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>
	<4C7BF087.6060400@noir.com>
	<AANLkTimWJoYVf2nqoi7KkOKSFz2F7wp0gcV=XKvo5uzj@mail.gmail.com>
	<4C7C370E.1080901@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C7C370E.1080901@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hmmm, maybe, but rsync would take a lot of time to find the changes.
the actual blocks of a snap _are_ the changes, that's why SnapMirror
is very efficient. And, I don't see how rsync will retain the snap's
between both sites. It would be great if a tool like rsync could have
access to the changed blocks in a snap. Don't know if btrfs exposes
these somehow.

=46red

On Tue, Aug 31, 2010 at 12:56 AM, K. Richard Pixley <rich@noir.com> wro=
te:
> =C2=A0If you can put the db into a consistent state, then rsync will =
do this.
> =C2=A0Rsync does changed block transfers.
>
> --rich
>
> On 8/30/10 14:15 , Fred van Zwieten wrote:
>>
>> I just glanced over the DRBD/LVM combi, but I don't see it being
>> functionally equal to SnapMirror. Let me (try to) explain how
>> snapmirror works:
>>
>> On system A there is a volume (vol1). We let this vol1(A) replicate
>> thru SnapMirror to vol1(B). This is done by creating a snap vol1sx(A=
)
>> and replicate all changed blocks between this snapshot (x) and the
>> previous snapshot (x-1). The first time, there is no x-1 and the who=
le
>> volume will be replicated, but after this initial "full copy", only
>> the changed blocks between the two snapshot's are being replicated t=
o
>> system B. This is also called snap based replication. Why we want
>> this? Easy. To support consistent DB snap's. The proces works by fir=
st
>> putting the DB in a consistent mode (depends on DB implementation),
>> create a snapshot, let the DB continue, replicate the changes. This
>> way a DB consistent state will be replicated. The cool thing about t=
he
>> NetApp implementation is that on system B the snap's (x, x-1, x-2,
>> etc) are also available. When there is trouble, you can choose to
>> online the DB on system B on any of the snap's, or, even cooler, to
>> replicate one of those snap's back to system A, doing a block based
>> rollback at the filesystem level.
>>
>> Fred
>>
>> On Mon, Aug 30, 2010 at 7:55 PM, K. Richard Pixley<rich@noir.com> =C2=
=A0wrote:
>>>
>>> =C2=A0On 20100830 10:07, Fred van Zwieten wrote:
>>>>
>>>> Hi there,
>>>>
>>>> I would like to know if there is something functionally equivalent=
 to
>>>> NetApp's SnapMirror in the works or planning? It would require blo=
ck
>>>> level access to a snap and the ability to rebuild (subvolumes
>>>> including it's) snap's on another machine.
>>>>
>>>> If not, what would be the best way to build something more or less
>>>> equivalent using existing tools? rsync-ing a snap seems the same, =
but
>>>> it isn't. First of all it 's file based, not very nice for DB's, a=
nd
>>>> you don't get the snap's on "the other side" the same.
>>>>
>>>> Fred
>>>
>>> I think drbd does precisely what you want.
>>>
>>> It's not useful for fault tolerance, nor for load balancing, but it=
 will
>>> produce a remote block copy that can be used as a sort of "hot back=
up".
>>>
>>> You can also do something very similar by combining LVM, (the logic=
al
>>> volume
>>> manager), with LVM snapshots and NBD, (the network block device) by
>>> mirroring to an NBD device.
>>>
>>> Neither of these approaches can tolerate the remote file system bei=
ng
>>> "live"
>>> until and unless it takes over for the primary. =C2=A0But either ca=
n maintain
>>> a
>>> dynamic remote block device.
>>>
>>> --rich
>>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
