From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: Default to read-only on snapshot creation and have a flag if
 snapshot should be writable (was: [PATCH 0/5] btrfs: Readonly snapshots)
Date: Tue, 30 Nov 2010 00:31:33 +0300
Message-ID: <AANLkTi=VP4jStt41sYAD=6g8FwRfGrhqZB2pGcZjNbiN@mail.gmail.com>
References: <AANLkTikbmUQA7JtkjV4177jmj9WDVe1V3NvbX3ts6TNd@mail.gmail.com>
 <4CF40FE4.2030801@prnet.org> <AANLkTimfSTq4h0eq_hjY6aEdXgM7Gq382m1FMAXy-z=P@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Arendt <admin@prnet.org>, linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimfSTq4h0eq_hjY6aEdXgM7Gq382m1FMAXy-z=P@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This may sound excessive as any new concept introduction that late in
development, but readonly/writable snapshots could be further
differentiated by naming the latter clones. This way end-user would
naturally perceive snapsot as read-only PIT fs image, while clone
would naturally refer to (writable) head fork.

Regards,
Andrey




On Tue, Nov 30, 2010 at 12:08 AM, Mike Fedyk <mfedyk@mikefedyk.com> wro=
te:
> On Mon, Nov 29, 2010 at 12:41 PM, David Arendt <admin@prnet.org> wrot=
e:
>> On 11/29/10 21:02, Mike Fedyk wrote:
>>>
>>> On Mon, Nov 29, 2010 at 12:02 AM, Li Zefan<lizf@cn.fujitsu.com> =C2=
=A0wrote:
>>>>
>>>> (Cc: Sage Weil<sage@newdream.net> =C2=A0for changes in async snaps=
hots)
>>>>
>>>> This patchset adds readonly-snapshots support. You can create a
>>>> readonly snapshot, and you can also set a snapshot readonly/writab=
le
>>>> on the fly.
>>>>
>>>> A few readonly checks are added in setattr, permission, remove_xat=
tr
>>>> and set_xattr callbacks, as well as in some ioctls.
>>>>
>>> Great work!
>>>
>>> I have a suggestion on defaults when snapshots are created. =C2=A0I=
 think
>>> they should default to being read-only and if they are meant to be
>>> read-write a flag can be set at creation time (and changable at a
>>> later time as well of course).
>>>
>>> This way user/admin preconceptions of a snapshot being read-only ca=
n
>>> be enforced by default, and the exception when you want a read-writ=
e
>>> snapshot can be available with a switch at the cli level (and proba=
bly
>>> a flag at the ioctl level).
>>>
>>> It gives one more natural distinction between a snapshot and a
>>> subvolume at the user conceptual level.
>>>
>>> What do you think?
>>>
>> I completely agree with you. I think lots of people use snapshots fo=
r backup
>> purposes and these ones shouldn't be writable.
>>
> .... by default.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
