From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Atomic replacement of subvolumes is not possible
Date: Sat, 3 Jul 2010 10:19:45 -0500
Message-ID: <AANLkTimcHKzYwefMpTdYA__OHENAMeedBGx2EnL3rMQE@mail.gmail.com>
References: <4C263826.1060702@debian.org>
	<AANLkTilcAfaH4KmSzKGp8M-xj511IlowGgIZnhHopdNx@mail.gmail.com>
	<20100702013054.GC15319@think>
	<201007022138.47323.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, daniel@debian.org,
	linux-btrfs@vger.kernel.org, Roger Leigh <rleigh@debian.org>
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201007022138.47323.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 2, 2010 at 2:38 PM, Goffredo Baroncelli <kreijack@gmail.com=
> wrote:
> On Friday, July 02, 2010, Chris Mason wrote:
>> On Wed, Jun 30, 2010 at 09:26:11AM -0500, C Anthony Risinger wrote:
> [...]
>> > what about this: =A0would it be possible to have TWO subvolumes by
>> > "default"? =A0the regular one (current directory, "."):
>> >
>> > mount -o subvol=3D. <btrfs_dev> /mnt
>> >
>> > would behave as it does now. =A0BUT... there would then be a speci=
al,
>> > permanent (like "." is right now) subvol, say "parent directory"
>> > (".."):
>> >
>> > mount -o subvol=3D.. <btrfs_dev> /mnt
>> >
>> > TWO dots would mount the parent of ".", where i could then swap ou=
t
>> > the real default (".").
>> >
>> > would that work?
>>
>> We do provide a set-default ioctl that can be used to change the def=
ault
>> for the next mount. =A0 This is pretty close to what you want, let m=
e
>> think about ways to make it easier to use.
>>
>> -chris
>
> Hello Chris,
>
> to me it seems that the Anthony request make sense. And it not so dif=
ficult to
> have. We have all the pieces, we need only a "policy" regarding the s=
ubvolume
> use and a bit of glue
> It should be sufficent to "replace" the standard mkfs.btrfs command w=
ith the
> following commands sequence
>
> # mkfs.btrfs <device>
> # mount <device> /mnt/<tmp>
> # btrfs subvol create /mnt/<tmp>/__root__
> # btrfs subvol set-default __root__ /mnt/<tmp>/
> # umount <device>
>
> So if an user don't want to care about a subvolume, he simply mount a=
 btrfs
> filesystem without any option. This user will work inside the __root_=
_
> subvolume, where he can create snapshot, subvolume...
>
> Instead if an user want to play with different root in different subv=
olumes,
> he have to mount the ".", where he can manage the root-subvolume(s) (=
renaming,
> moving, snapshotting/branching ... ).
>
> The key is to think the "." subvolume only to handling the subvolumes=
 and not
> to storing files. If you don't want to use it, you can simply ignore =
it,
> because the default is to mount the __root__ subvolume.

i don't want to comment anymore on this thread, as i feel i kind of
hijacked it :-), but what Goffredo has suggested above is a great idea
and would solve my default subvol problems completely.

the real problem is that users are installing into the "." subvol not
knowing they cannot easily manipulate the system after that.  as
Goffredo hinted:

"The key is to think the "." subvolume only to handling the subvolumes
and not to storing files."

if a empty subvol is created, then marked as the new mount default,
users would never know the difference, and integrators like me could
still get "underneath" to prepare the system for all the cool
distribution-specific btrfs features.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
