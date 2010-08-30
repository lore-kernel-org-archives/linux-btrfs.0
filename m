From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 15:56:14 -0700
Message-ID: <4C7C370E.1080901@noir.com>
References: <AANLkTinmSdHwXXq3s64sM39GjacafgwgTjPadZGHuway@mail.gmail.com>	<AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>	<4C7BF087.6060400@noir.com> <AANLkTimWJoYVf2nqoi7KkOKSFz2F7wp0gcV=XKvo5uzj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Fred van Zwieten <fvzwieten@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimWJoYVf2nqoi7KkOKSFz2F7wp0gcV=XKvo5uzj@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  If you can put the db into a consistent state, then rsync will do 
this.  Rsync does changed block transfers.

--rich

On 8/30/10 14:15 , Fred van Zwieten wrote:
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
>
> Fred
>
> On Mon, Aug 30, 2010 at 7:55 PM, K. Richard Pixley<rich@noir.com>  wrote:
>>   On 20100830 10:07, Fred van Zwieten wrote:
>>> Hi there,
>>>
>>> I would like to know if there is something functionally equivalent to
>>> NetApp's SnapMirror in the works or planning? It would require block
>>> level access to a snap and the ability to rebuild (subvolumes
>>> including it's) snap's on another machine.
>>>
>>> If not, what would be the best way to build something more or less
>>> equivalent using existing tools? rsync-ing a snap seems the same, but
>>> it isn't. First of all it 's file based, not very nice for DB's, and
>>> you don't get the snap's on "the other side" the same.
>>>
>>> Fred
>> I think drbd does precisely what you want.
>>
>> It's not useful for fault tolerance, nor for load balancing, but it will
>> produce a remote block copy that can be used as a sort of "hot backup".
>>
>> You can also do something very similar by combining LVM, (the logical volume
>> manager), with LVM snapshots and NBD, (the network block device) by
>> mirroring to an NBD device.
>>
>> Neither of these approaches can tolerate the remote file system being "live"
>> until and unless it takes over for the primary.  But either can maintain a
>> dynamic remote block device.
>>
>> --rich
>>
