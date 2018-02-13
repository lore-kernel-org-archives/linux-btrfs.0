Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:43311 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934086AbeBMLkf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 06:40:35 -0500
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <CAJ3TwYSTnQfj=qmBLtnmtXQKexMMD4x=9Gk3p3anf4uF+G26kw@mail.gmail.com>
 <CAJ3TwYTnMPVwkrZEU-=Q_Nq+9Bn0vM3z+EFC8RP=RTyaufSoqw@mail.gmail.com>
 <5cc93522-1bd2-bdc1-d5da-a11d5e4816a7@cn.fujitsu.com>
 <CAJ3TwYRpc_R-wVur0T6+Uy_aPVXTGpvp_ag1Ar9K2HoB0H1ySQ@mail.gmail.com>
 <799054c4-b4f5-2dc0-4f70-4345159d9078@cn.fujitsu.com>
 <CAJ3TwYRH8JVkuv2Hu7FYb+BSwKGrq1spx079zwOF_FO1y=9NFA@mail.gmail.com>
 <e51aaa6e-a4b9-c187-84fa-c57799865b0e@cn.fujitsu.com>
 <CAJ3TwYS6UTkWf=PNku3RG7hPrXMKz3yhk2WqCRLix4v_VwgrmA@mail.gmail.com>
 <36291cd0-64bc-8708-9e23-0aac30539785@cn.fujitsu.com>
 <CAJ3TwYQ47SVpbO1Pb-TWjhaTCCpMFFmijwTgmV8=7+1_a6_3Ww@mail.gmail.com>
 <e8d681cb-aa1b-6395-f968-38e8425ed8fb@cn.fujitsu.com>
 <CAJ3TwYRgHfCNxKwWnfWXr=w_mBo2B2AuSDeE+PgYEtn7kyAx7w@mail.gmail.com>
 <87975474-0cb9-13d7-f623-c0622b31f437@gmx.com>
 <CAJ3TwYQ-GgZCCoD07AgQ0EDtpOknt3Ta1=WNAH7sSvXO3R-u8w@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a27b619e-6e39-20e6-413e-c9d5c7a90b6f@gmx.com>
Date: Tue, 13 Feb 2018 19:40:25 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYQ-GgZCCoD07AgQ0EDtpOknt3Ta1=WNAH7sSvXO3R-u8w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mW8VbivtMywBR94wIannSjIFQMMolbWDF"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mW8VbivtMywBR94wIannSjIFQMMolbWDF
Content-Type: multipart/mixed; boundary="Xequb3OHXpEbT0oF1sfetWddmwtZc2hNW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: John Ettedgui <john.ettedgui@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
 Austin S Hemmelgarn <ahferroin7@gmail.com>,
 btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <a27b619e-6e39-20e6-413e-c9d5c7a90b6f@gmx.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <CAJ3TwYRXwDVVfT0TRRiM9dEw-7TvY8qG=WvMYKczZOv6wkFWAQ@mail.gmail.com>
 <fd718727-9b54-ba58-5f39-63066181d13e@cn.fujitsu.com>
 <CAJ3TwYSTnQfj=qmBLtnmtXQKexMMD4x=9Gk3p3anf4uF+G26kw@mail.gmail.com>
 <CAJ3TwYTnMPVwkrZEU-=Q_Nq+9Bn0vM3z+EFC8RP=RTyaufSoqw@mail.gmail.com>
 <5cc93522-1bd2-bdc1-d5da-a11d5e4816a7@cn.fujitsu.com>
 <CAJ3TwYRpc_R-wVur0T6+Uy_aPVXTGpvp_ag1Ar9K2HoB0H1ySQ@mail.gmail.com>
 <799054c4-b4f5-2dc0-4f70-4345159d9078@cn.fujitsu.com>
 <CAJ3TwYRH8JVkuv2Hu7FYb+BSwKGrq1spx079zwOF_FO1y=9NFA@mail.gmail.com>
 <e51aaa6e-a4b9-c187-84fa-c57799865b0e@cn.fujitsu.com>
 <CAJ3TwYS6UTkWf=PNku3RG7hPrXMKz3yhk2WqCRLix4v_VwgrmA@mail.gmail.com>
 <36291cd0-64bc-8708-9e23-0aac30539785@cn.fujitsu.com>
 <CAJ3TwYQ47SVpbO1Pb-TWjhaTCCpMFFmijwTgmV8=7+1_a6_3Ww@mail.gmail.com>
 <e8d681cb-aa1b-6395-f968-38e8425ed8fb@cn.fujitsu.com>
 <CAJ3TwYRgHfCNxKwWnfWXr=w_mBo2B2AuSDeE+PgYEtn7kyAx7w@mail.gmail.com>
 <87975474-0cb9-13d7-f623-c0622b31f437@gmx.com>
 <CAJ3TwYQ-GgZCCoD07AgQ0EDtpOknt3Ta1=WNAH7sSvXO3R-u8w@mail.gmail.com>
In-Reply-To: <CAJ3TwYQ-GgZCCoD07AgQ0EDtpOknt3Ta1=WNAH7sSvXO3R-u8w@mail.gmail.com>

--Xequb3OHXpEbT0oF1sfetWddmwtZc2hNW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 19:25, John Ettedgui wrote:
> On Tue, Feb 13, 2018 at 3:04 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>
>>
>> On 2018=E5=B9=B402=E6=9C=8813=E6=97=A5 18:21, John Ettedgui wrote:
>>> Hello there,
>>>
>>> have you found anything good since then?
>>
>> Unfortunately, not really much to speed it up.
> Oh :/
>>
>> This reminds me of the old (and crazy) idea to skip block group build
>> for RO mount.
>> But not really helpful for it.
>>
>>> With a default system, the behavior is pretty much still the same,
>>> though I have not recreated the partitions since.
>>>
>>> Defrag helps, but I think balance helps even more.
>>> clear_cache may help too, but I'm not really sure as I've not tried i=
t
>>> on its own.
>>> I was actually able to get a 4TB partition on a 5400rpm HDD to mount
>>> in around 500ms, quite faster that even some Gb partitions I have on
>>> SSDs! Alas I wrote some files to it and it's taking over a second
>>> again, so no more magic there.
>>
>> The problem is not about how much space it takes, but how many extents=

>> are here in the filesystem.
>>
>> For new fs filled with normal data, I'm pretty sure data extents will =
be
>> as large as its maximum size (256M), causing very little or even no
>> pressure to block group search.
>>
> What do you mean by "new fs",

I mean the 4TB partition on that 5400rpm HDD.

> was there any change that would improve
> the behavior if I were to recreate the FS?

If you backed up your fs, and recreate a new, empty btrfs on your
original SSD, then copying all data back, I believe it would be much
faster to mount.

> Last time we talked I believe max extent was 128M for non-compressed
> files, so maybe there's been some good change.

My fault, 128M is correct.

>>>
>>> The workarounds do work, so it's still not a major issue, but they're=

>>> slow and sometimes I have to workaround the "no space left on device"=

>>> which then takes even more time.
>>
>> And since I went to SUSE, some mail/info is lost during the procedure.=

> I still have all mails, if you want it. No dump left though.
>>
>> Despite that, I have several more assumption to this problem:
>>
>> 1) Metadata usage bumped by inline files
> What are inline files? Should I view this as inline in C, in that the
> small files are stored in the tree directly?

Exactly.

>>    If there are a lot of small files (<2K as default),
> Of the slow to mount partitions:
> 2 partitions have less than a dozen files smaller than 2K.
> 1 has about 5 thousand and the last one 15 thousand.
> Are the latter considered a lot?

If using default 16K nodesize, 8 small files takes one leaf.
And 15K small failes means about 2K tree extents.

Not that much in my opinion, can't even fill half of a metadata chunk.

>> and your metadata
>>    usage is quite high (generally speaking, it meta:data ratio should =
be
>>    way below 1:8), that may be the cause.
>>
> The ratio is about 1:900 on average so that should be ok I guess.

Yep, that should be fine.
So not metadata to blame.

Then purely fragmented data extents.

>>    If so, try mount the fs with "max_inline=3D0" mount option and then=

>>    try to rewrite such small files.
>>
> Should I try that?

No need, it won't cause much difference.

>> 2) SSD write amplification along with dynamic remapping
>>    To be honest, I'm not really buying this idea, since mount doesn't
>>    have anything related to write.
>>    But running fstrim won't harm anyway.
>>
> Oh I am not complaining about slow SSDs mounting. I was just amazed
> that a partition on a slow HDD mounted faster.
> Without any specific work, my SSDs partitions tend to mount around 1 se=
c or so.
> Of course I'd be happy to worry about them once all the partitions on
> HDDs mount in a handful of ms :)
>=20
>> 3) Rewrite the existing files (extreme defrag)
>>    In fact, defrag doesn't work well if there are subvolumes/snapshots=

> I have no subvolume or snapshot so that's not a problem.
>>    /reflink involved.
>>    The most stupid and mindless way, is to write a small script and fi=
nd
>>    all regular files, read them out and rewrite it back.
>>
> That's fairly straightforward to do, though it should be quite slow so
> I'd hope not to have to do that too often.

Then it could be tried on the most frequently updated files then.

And since you don't use snapshot, locate such files and then "chattr +C"
would make them nodatacow, reducing later fragments.

>>    This should acts much better than traditional defrag, although it's=

>>    time-consuming and makes snapshot completely meaningless.
>>    (and since you're already hitting ENOSPC, I don't think the idea is=

>>     really working for you)
>>
>> And since you're already hitting ENOSPC, either it's caused by
>> unbalanced meta/data usage, or it's really going hit the limit, I woul=
d
>> recommend to enlarge the fs or delete some files to see if it helps.
>>
> Yup, I usually either slowly ramp up the {d,m}usage to pass it, or
> when that does not work I free some space, then balance will finish.
> Or did you mean to free some space to see about mount speed?

Kind of, just do such freeing in advance, and try to make btrfs always
have unallocated space in case.

And finally, use latest kernel if possible.
IIRC old kernel doesn't have empty block group auto remove, which makes
user need to manually balance to free some space.

Thanks,
Qu

>> Thanks,
>> Qu
>>
>=20
> Thank you for the quick reply!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Xequb3OHXpEbT0oF1sfetWddmwtZc2hNW--

--mW8VbivtMywBR94wIannSjIFQMMolbWDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqCzqkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg1nQf+ONpZfwWnaTz3LZeFiSjJH32y
Y+nwD3qsmYHHxYzGDTcntEu7yQrghxaYoOO+K5Efy/mGo8lc4HDn5WbGU2nCETpD
eEr4SRjF5KhUCa50zWPQsCtYLZsWI6st1CdjHmpJXgVykZC4azsyREU5nROIcX+j
h49AqZTWkwoUYm90Ke/6uxhe9ajim2Okm13+VxNoP1eJ8Zfu9DFrl+ml6Wl1OhbT
PFn03nonF16MXtHjCsK/nI4u81mNQyh9k1vhMCK8okeBx7bF9gFUFqlZi1jFDDjS
/pmt0lQCe1HWGiAWlUIOHxiCb5ZWh6EwkNrrE3ZShND978gYylAWBC/+RCHQKw==
=c1Ha
-----END PGP SIGNATURE-----

--mW8VbivtMywBR94wIannSjIFQMMolbWDF--
