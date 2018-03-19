Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:33045 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755179AbeCSFFd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 01:05:33 -0400
Subject: Re: [PATCH 1/1] btrfs-progs: docs: annual typo, clarity, & grammar
 review & fixups
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <20171022000046.9000-1-nsteeves@gmail.com>
 <20171022000046.9000-2-nsteeves@gmail.com>
 <25ead4df-d964-ecac-4c48-5ec20b52ff45@gmx.com>
 <20180316004925.kxz3yplwkmuntadq@DigitalMercury.dynalias.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fedd6eb0-d18d-fe5c-630b-32a9c1e11fa1@gmx.com>
Date: Mon, 19 Mar 2018 13:05:25 +0800
MIME-Version: 1.0
In-Reply-To: <20180316004925.kxz3yplwkmuntadq@DigitalMercury.dynalias.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pOdHuuiwxielzmKd2bycl877MSqRcBU1r"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pOdHuuiwxielzmKd2bycl877MSqRcBU1r
Content-Type: multipart/mixed; boundary="0W2yOS9Sz6bbAUfwXC43z6dU3eaKrNkPo";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <fedd6eb0-d18d-fe5c-630b-32a9c1e11fa1@gmx.com>
Subject: Re: [PATCH 1/1] btrfs-progs: docs: annual typo, clarity, & grammar
 review & fixups
References: <20171022000046.9000-1-nsteeves@gmail.com>
 <20171022000046.9000-2-nsteeves@gmail.com>
 <25ead4df-d964-ecac-4c48-5ec20b52ff45@gmx.com>
 <20180316004925.kxz3yplwkmuntadq@DigitalMercury.dynalias.net>
In-Reply-To: <20180316004925.kxz3yplwkmuntadq@DigitalMercury.dynalias.net>

--0W2yOS9Sz6bbAUfwXC43z6dU3eaKrNkPo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8816=E6=97=A5 08:49, Nicholas D Steeves wrote:
> Hi Qu,
>=20
> So sorry for the incredibly delayed reply [it got lost in my drafts
> folder], I sincerely appreciate the time you took to respond.  There
> is a lot in your responses that I suspect would benefit readers of the
> btrfs wiki, so I've drawn attention to them by replying inline.  I've
> omitted the sections David resolved with his merge.
>=20
> P.S. Even graduate-level native speakers struggle with the
> multitude of special-cases in English!
>=20
> On Sun, Oct 22, 2017 at 06:54:16PM +0800, Qu Wenruo wrote:
>> Hi Nicholas,
>>
>> Thanks for the documentation update.
>> Since I'm not a native English speaker, I may not help much to organiz=
e
>> the sentence, but I can help to explain the question noted in the
>> modification.
>>
>> On 2017=E5=B9=B410=E6=9C=8822=E6=97=A5 08:00, Nicholas D Steeves wrote=
:
>>> In one big patch, as requested
> [...]
>>> --- a/Documentation/btrfs-balance.asciidoc
>>> +++ b/Documentation/btrfs-balance.asciidoc
>>> @@ -21,7 +21,7 @@ filesystem.
>>>  The balance operation is cancellable by the user. The on-disk state =
of the
>>>  filesystem is always consistent so an unexpected interruption (eg. s=
ystem crash,
>>>  reboot) does not corrupt the filesystem. The progress of the balance=
 operation
>>> -is temporarily stored and will be resumed upon mount, unless the mou=
nt option
>>> +****is temporarily stored**** (EDIT: where is it stored?) and will b=
e resumed upon mount, unless the mount option
>>
>> To be specific, they are stored in data reloc tree and tree reloc tree=
=2E
>>
>> Data reloc tree stores the data/metadata written to new location.
>>
>> And tree reloc tree is kind of special snapshot for each tree whose tr=
ee
>> block is get relocated during the relocation.
>=20
> Is there already a document on the btrfs allocation?  This seems like
> it might be a nice addition for the wiki.  I'm guessing it would fit
> under
> https://btrfs.wiki.kernel.org/index.php/Main_Page#Developer_documentati=
on

Yep, it's a good idea to document such things into btrfs wiki.

I would add such doc in my spare time.

>=20
>>> @@ -200,11 +200,11 @@ section 'PROFILES'.
>>>  ENOSPC
>>>  ------
>>> =20
>>> -The way balance operates, it usually needs to temporarily create a n=
ew block
>>> +****The way balance operates, it usually needs to temporarily create=
 a new block
>>>  group and move the old data there. For that it needs work space, oth=
erwise
>>>  it fails for ENOSPC reasons.
>>>  This is not the same ENOSPC as if the free space is exhausted. This =
refers to
>>> -the space on the level of block groups.
>>> +the space on the level of block groups.**** (EDIT: What is the relat=
ionship between the new block group and the work space?  Is the "old data=
" removed from the new block group?  Please say something about block gro=
ups to clarify)
>>
>> Here I think we're talking about allocating new block group, so it's
>> using unallocated space.
>>
>> While for normal space usage, we're allocating from *allocated* block
>> group space.
>>
>> So there are two levels of space allocation:
>>
>> 1) Extent level
>>    Always allocated from existing block group (or chunk).
>>    Data extent, tree block allocation are all happening at this level.=

>>
>> 2) Block group (or chunk, which are the same) level
>>    Always allocated from free device space.
>>
>> I think the original sentence just wants to address this.
>=20
> Also seems like a good fit for a btrfs allocation document.
>=20
>>> =20
>>>  The free work space can be calculated from the output of the *btrfs =
filesystem show*
>>>  command:
>>> @@ -227,7 +227,7 @@ space. After that it might be possible to run oth=
er filters.
>>> =20
>>>  Conversion to profiles based on striping (RAID0, RAID5/6) require th=
e work
>>>  space on each device. An interrupted balance may leave partially fil=
led block
>>> -groups that might consume the work space.
>>> +groups that ****might**** (EDIT: is this 2nd level of uncertainty ne=
cessary?) consume the work space.
>>> =20
> [...]
>>> @@ -3,7 +3,7 @@ btrfs-filesystem(8)
> [...]
>>>  SYNOPSIS
>>>  --------
>>> @@ -53,8 +53,8 @@ not total size of filesystem.
>>>  when the filesystem is full. Its 'total' size is dynamic based on th=
e
>>>  filesystem size, usually not larger than 512MiB, 'used' may fluctuat=
e.
>>>  +
>>> -The global block reserve is accounted within Metadata. In case the f=
ilesystem
>>> -metadata are exhausted, 'GlobalReserve/total + Metadata/used =3D Met=
adata/total'.
>>> +The global block reserve is accounted within Metadata. ****In case t=
he filesystem
>>> +metadata are exhausted, 'GlobalReserve/total + Metadata/used =3D Met=
adata/total'.**** (EDIT: s/are/is/? And please write more for clarity. Is=
 "global block reserve" part of GlobalReserve that is accounted within Me=
tadata?  Isn't all of GlobalReserve's metadata accounted within Metadata?=
  eg: "global block reserve" is the data portion of GlobalReserve, but al=
l metadata is accounted for in Metadata.)
>>
>> GlobalReserve is accounted as Metadata, but most of time it's just as =
a
>> buffer until we really run out of metadata space.
>>
>> It's like metadata headroom reserved for really important time.
>>
>> So under most situation, the GlobalReserve usage should be 0.
>> And it's not accounted as Meta/used. (so, if there is Meta/free, then =
it
>> belongs to Meta/free)
>>
>> But when GlobalReserve/used is not 0, the used part is accounted to
>> Meta/Used, and the unused part (GlobalReserve/free if exists) belongs =
to
>> Meta/free.
>>
>> Not sure how to explain it better.
>=20
> Thank you, you've explained it wonderfully.  (This also seems like a
> good fit for a btrfs allocation document)
>=20
>>>  +
>>>  `Options`
>>>  +
>>> @@ -93,10 +93,10 @@ You can also turn on compression in defragment op=
erations.
>>>  +
>>>  WARNING: Defragmenting with Linux kernel versions < 3.9 or =E2=89=A5=
 3.14-rc2 as well as
>>>  with Linux stable kernel versions =E2=89=A5 3.10.31, =E2=89=A5 3.12.=
12 or =E2=89=A5 3.13.4 will break up
>>> -the ref-links of COW data (for example files copied with `cp --refli=
nk`,
>>> +the reflinks of COW data (for example files copied with `cp --reflin=
k`,
>>>  snapshots or de-duplicated data).
>>>  This may cause considerable increase of space usage depending on the=
 broken up
>>> -ref-links.
>>> +reflinks.
>>>  +
>> [snip]
>>> +broken up reflinks.
>>> =20
>>>  *barrier*::
>>>  *nobarrier*::
>>>  (default: on)
>>>  +
>>>  Ensure that all IO write operations make it through the device cache=
 and are stored
>>> -permanently when the filesystem is at it's consistency checkpoint. T=
his
>>> +permanently when the filesystem is at ****(EDIT: "its" or "one of it=
s" consistency checkpoint[s])****. This
>>
>> I think it is "one of its", as there are in fact 2 checkpoints for btr=
fs:
>> 1) Normal transaction commitment
>> 2) Log tree commitment
>>    Which only commits the log trees and log tree root.
>>
>> But I'm not really sure if log tree commitment is also under the contr=
ol
>> of barrier.
>=20
> Is there a document on the topic of "Things btrfs does to keep your
> data safe, and things it does to maintain a consistent state"?  This
> can to there, with a subsection for "differences during a balance
> operation" if necessary.  David merged "its consistency checkpoint",
> which I think is fine for general-user-facing documentation, but
> because you mentioned log tree commitment I'm also wondering if 2) is
> not under the control of a barrier.  Without this barrier, aren't the
> log trees more likely to be corrupted and/or out-of-date in the event
> of sudden loss of power or crash?

For log tree I investigated it a little further so I'm pretty confident
to say that, all super block update is using FUA unless nobarrier mount
option is specified.

So it's as safe as normal transaction commit.

>=20
> [...]
>>> =20
>>>  *sync* <path> [subvolid...]::
>>> -Wait until given subvolume(s) are completely removed from the filesy=
stem
>>> -after deletion. If no subvolume id is given, wait until all current =
 deletion
>>> -requests are completed, but do not wait for subvolumes deleted meanw=
hile.
>>> -The status of subvolume ids is checked periodically.
>>> +Wait until given subvolume[s] are completely removed from the filesy=
stem after
>>> +deletion. If no subvolume id is given, wait until all current deleti=
on requests
>>> +are completed, but do not wait for subvolumes deleted in the meantim=
e.  ****The
>>> +status of subvolume ids is checked periodically.**** (EDIT: How is t=
he relevant to sync?  Should it read "the status of all subvolume ids are=
 periodically synced as a normal background operation"?)
>>
>> The background is, subvolume deletion is expensive for btrfs, so
>> subvolume deletion is split into 2 stages:
>> 1) Unlike the subvolume
>>    So no one can access the deleted subvolume
>>
>> 2) Delete the subvolume tree blocks and its data in background
>>    And for tree blocks, we skip the normal tree balance, to speed up t=
he
>>    deletion.
>>
>> I think the original sentence means we won't wait for the 2nd stage.
>=20
> When I started using btrfs with linux-3.16 I regularly ran into issues
> when I omitted a btrfs sub sync step when deleting, creating, and then
> deleting snapshots, so I started syncing subvolumes religiously after
> each operation.  If the btrfs sub sync step is still a recommended
> practice, I wonder if this is the place to say so.  Maybe it's no
> longer necessary?

This may need extra test so I'm not 100% confident yet.

>=20
> [...]
>>>  *-d|--data <profile>*::
>>> @@ -79,7 +79,7 @@ default value is 16KiB (16384) or the page size, wh=
ichever is bigger. Must be a
>>>  multiple of the sectorsize and a power of 2, but not larger than 64K=
iB (65536).
>>>  Leafsize always equals nodesize and the options are aliases.
>>>  +
>>> -Smaller node size increases fragmentation but lead to higher b-trees=
 which in
>>> +Smaller node size increases fragmentation ****but lead to higher b-t=
rees**** (EDIT: "but leads to taller/deeper/more/increased-usage-of b-tre=
es"?) which in
>>
>> What's the difference between "higher" and "taller"?
>> Seems quite similar to me though.
>=20
> I could be wrong, but I think one of
> "taller/deeper/more/increased-usage-of b-trees" is closer to what you
> want to say,

Yep.

> because "smaller node size...leads to higher b-trees"
> sounds like a smaller node size leads to the emergence of something
> like a higher-order of b-trees that operate or function differently
> than b-trees usually do in btrfs.

Makes sense.

Thanks,
Qu
>=20
> [I've deleted my pedantic explanation, because I think googling for
> "taller vs higher" will provide the resources you need]
>=20
>>> @@ -166,7 +166,7 @@ root partition created with RAID1/10/5/6 profiles=
=2E The mount action can happen
>>>  before all block devices are discovered. The waiting is usually done=
 on the
>>>  initramfs/initrd systems.
>>> =20
>>> -As of kernel 4.9, RAID5/6 is still considered experimental and shoul=
dn't be
>>> +As of kernel ****4.9**** (EDIT: 4.14 status?), RAID5/6 is still cons=
idered experimental and shouldn't be
>>
>> Well, this changed a lot in v4.14. So definitely need to be modified.
>>
>> At least Oracle is considring RAID5/6 stable. Maybe we'd better to wai=
t
>> for several other releases to see if this is true.
>=20
> Wow!  If so, congratulations!
>=20
> Sincerely,
> Nicholas
>=20


--0W2yOS9Sz6bbAUfwXC43z6dU3eaKrNkPo--

--pOdHuuiwxielzmKd2bycl877MSqRcBU1r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqvRRYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiMQggAm4AvlJd4w0WypUAKxC/2jAXZ
g2AAEB3x+fUnu2PvtK4IhKU6okcMuHZro+S4+cFjK62beFhzLaeTZ3uJkbwkH2qv
LRptz1PiQcMrF9cRKmqL5E2QHwrE0jQd888wpbRiDXPRGcOQLGXNs9vzZf4vOQW0
KKGFh6AEWl6D+HHFrykI2SEYGwHkCo10CPS8exE/VGrKt/nQkq52CHO+2vXtOfwZ
FtWH5sgHZA5kBYChAa25HX/6J6lut6p7CkBaH+VsMNsZTChdRtUwAzwlJlstuOES
bDndcxSpwcvNpjrPLz7xCbVzZlDdyp3c47f/BBxOng/XAcbe/YGmlVh5XVc3+A==
=ha6B
-----END PGP SIGNATURE-----

--pOdHuuiwxielzmKd2bycl877MSqRcBU1r--
