From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Default to read-only on snapshot creation and have a flag if
 snapshot should be writable (was: [PATCH 0/5] btrfs: Readonly snapshots)
Date: Mon, 29 Nov 2010 13:08:45 -0800
Message-ID: <AANLkTimfSTq4h0eq_hjY6aEdXgM7Gq382m1FMAXy-z=P@mail.gmail.com>
References: <AANLkTikbmUQA7JtkjV4177jmj9WDVe1V3NvbX3ts6TNd@mail.gmail.com>
	<4CF40FE4.2030801@prnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: David Arendt <admin@prnet.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF40FE4.2030801@prnet.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 29, 2010 at 12:41 PM, David Arendt <admin@prnet.org> wrote:
> On 11/29/10 21:02, Mike Fedyk wrote:
>>
>> On Mon, Nov 29, 2010 at 12:02 AM, Li Zefan<lizf@cn.fujitsu.com> =C2=A0=
wrote:
>>>
>>> (Cc: Sage Weil<sage@newdream.net> =C2=A0for changes in async snapsh=
ots)
>>>
>>> This patchset adds readonly-snapshots support. You can create a
>>> readonly snapshot, and you can also set a snapshot readonly/writabl=
e
>>> on the fly.
>>>
>>> A few readonly checks are added in setattr, permission, remove_xatt=
r
>>> and set_xattr callbacks, as well as in some ioctls.
>>>
>> Great work!
>>
>> I have a suggestion on defaults when snapshots are created. =C2=A0I =
think
>> they should default to being read-only and if they are meant to be
>> read-write a flag can be set at creation time (and changable at a
>> later time as well of course).
>>
>> This way user/admin preconceptions of a snapshot being read-only can
>> be enforced by default, and the exception when you want a read-write
>> snapshot can be available with a switch at the cli level (and probab=
ly
>> a flag at the ioctl level).
>>
>> It gives one more natural distinction between a snapshot and a
>> subvolume at the user conceptual level.
>>
>> What do you think?
>>
> I completely agree with you. I think lots of people use snapshots for=
 backup
> purposes and these ones shouldn't be writable.
>
=2E... by default.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
