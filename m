From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: Default to read-only on snapshot creation and have a flag if
 snapshot should be writable (was: [PATCH 0/5] btrfs: Readonly snapshots)
Date: Tue, 30 Nov 2010 00:48:06 +0300
Message-ID: <AANLkTimb=-v4b-fHqRpW-7Q2gyzHp=8e3Ouff3ShoQJr@mail.gmail.com>
References: <AANLkTikbmUQA7JtkjV4177jmj9WDVe1V3NvbX3ts6TNd@mail.gmail.com>
 <4CF40FE4.2030801@prnet.org> <AANLkTimfSTq4h0eq_hjY6aEdXgM7Gq382m1FMAXy-z=P@mail.gmail.com>
 <AANLkTi=VP4jStt41sYAD=6g8FwRfGrhqZB2pGcZjNbiN@mail.gmail.com> <AANLkTikK0OEJneHWqABnOA+c9e1-QirctS34mV0bOFCv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Arendt <admin@prnet.org>, linux-btrfs@vger.kernel.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikK0OEJneHWqABnOA+c9e1-QirctS34mV0bOFCv@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I'm not sure why zfs came up, they don't own the term :). As to
zfs/overhead topic, I doubt there's any difference between clone and
writable shapshot (there should be none, of course, it's just two
different names for the same concept).

Regards,
Andrey




On Tue, Nov 30, 2010 at 12:43 AM, Mike Fedyk <mfedyk@mikefedyk.com> wro=
te:
> On Mon, Nov 29, 2010 at 1:31 PM, Andrey Kuzmin
> <andrey.v.kuzmin@gmail.com> wrote:
>> This may sound excessive as any new concept introduction that late i=
n
>> development, but readonly/writable snapshots could be further
>> differentiated by naming the latter clones. This way end-user would
>> naturally perceive snapsot as read-only PIT fs image, while clone
>> would naturally refer to (writable) head fork.
>>
>
> I'm not sure we want to take all of the terminology that zfs uses as
> it may also bring the percieved drawbacks as well. =C2=A0Isn't there =
some
> additional overhead for a zfs clone compared to a snapshot? =C2=A0I'm=
 not
> very familiar with zfs so that's why I ask.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
