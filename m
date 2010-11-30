From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: Default to read-only on snapshot creation and have a flag if
 snapshot should be writable (was: [PATCH 0/5] btrfs: Readonly snapshots)
Date: Tue, 30 Nov 2010 15:44:00 +0300
Message-ID: <AANLkTikocW7V8V2Q_pBpXmVKEyZ4Fyfb=YDf4HY=mzas@mail.gmail.com>
References: <AANLkTikbmUQA7JtkjV4177jmj9WDVe1V3NvbX3ts6TNd@mail.gmail.com>
	<4CF40FE4.2030801@prnet.org>
	<AANLkTimfSTq4h0eq_hjY6aEdXgM7Gq382m1FMAXy-z=P@mail.gmail.com>
	<AANLkTi=VP4jStt41sYAD=6g8FwRfGrhqZB2pGcZjNbiN@mail.gmail.com>
	<AANLkTikK0OEJneHWqABnOA+c9e1-QirctS34mV0bOFCv@mail.gmail.com>
	<AANLkTimb=-v4b-fHqRpW-7Q2gyzHp=8e3Ouff3ShoQJr@mail.gmail.com>
	<6742321336526268697@unknownmsgid>
	<4CF45EC9.5080902@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: C Anthony Risinger <anthony@extof.me>,
	Mike Fedyk <mfedyk@mikefedyk.com>,
	David Arendt <admin@prnet.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF45EC9.5080902@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

In my opinion, the point is not the default snapshot creation mode but
rather default usage, equals user's expectation.

On 11/30/10, Li Zefan <lizf@cn.fujitsu.com> wrote:
> C Anthony Risinger wrote:
>> On Nov 29, 2010, at 3:48 PM, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
>> wrote:
>>
>>> I'm not sure why zfs came up, they don't own the term :). As to
>>> zfs/overhead topic, I doubt there's any difference between clone and
>>> writable shapshot (there should be none, of course, it's just two
>>> different names for the same concept).
>>>
>>> Regards,
>>> Andrey
>>>
>>>
>>>
>>>
>>> On Tue, Nov 30, 2010 at 12:43 AM, Mike Fedyk <mfedyk@mikefedyk.com>
>>> wrote:
>>>> On Mon, Nov 29, 2010 at 1:31 PM, Andrey Kuzmin
>>>> <andrey.v.kuzmin@gmail.com> wrote:
>>>>> This may sound excessive as any new concept introduction that late
>>>>> in
>>>>> development, but readonly/writable snapshots could be further
>>>>> differentiated by naming the latter clones. This way end-user would
>>>>> naturally perceive snapsot as read-only PIT fs image, while clone
>>>>> would naturally refer to (writable) head fork.
>>>>>
>>>> I'm not sure we want to take all of the terminology that zfs uses as
>>>> it may also bring the percieved drawbacks as well.  Isn't there some
>>>> additional overhead for a zfs clone compared to a snapshot?  I'm not
>>>> very familiar with zfs so that's why I ask.
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-
>>> btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> I don't like the idea of readonly by default, or further changes to
>> terminology, for several reasons:
>>
>
> I quite agree with you. LVM2 also defaults to read/write for snapshots.
>
>> ) readonly by default offers no real enhancement whatsoever other than
>> breaking _anything_ that's written right now
>
> This was the first thing that came to my mind.
>
>> ) btrfs readonly is not even really readonly; as superuser could
>> simply flip a flag to enable writes, readonly merely prevents
>> accidental writes or misbehaving apps... ie. protecting you from
>> yourself
>> ) backups are the simple/obvious use case; I personally use btrfs
>> heavily for LXC containers, in which case nearly every single snapshot
>> is intended to be writable -- usually cloning a template into a new
>> domain
>> ) I also use an initramfs hook to provide system rollbacks, also
>> writable; the hook also provides multiple versions of the "branch"...
>> all writable
>> ) adding new terms is not a good idea imo; I've already spewed out
>> many sentences explaining the difference between subvolumes and
>> snapshots, ie. that there is none... adding another term only adds to
>> this problem; they each describe the same thing, but differentiate
>> based on origin or current state, neither of which actually describe
>> what it _is_-- a new named pointer to a tree, like a git branch -- a
>> subvolume.
>>
>> I think a better solution/compromise would be to leave snapshots
>> writeable by default, since that's more true to what's happening
>> internally anyway, but maybe introduce a mount option controlling the
>> default action for that mount point.
>>
>> C Anthony [mobile]
>


-- 
Regards,
Andrey
