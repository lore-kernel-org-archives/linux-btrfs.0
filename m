From: Christian Mikovits <gaelic@luchmhor.net>
Subject: Re: snapshot-removal - timeline ?
Date: Wed, 5 Aug 2009 20:46:24 +0200
Message-ID: <87c1d2600908051146n31f485f6qe51eb8509461ee75@mail.gmail.com>
References: <1552F85577A149D68B0BFF2A44E0FF0A@bui.materna.com>
	 <20090803130412.GB3570@think>
	 <10F3F7E4-276B-49C3-B944-61320D634C93@karlsbakk.net>
	 <20090803161800.GB5492@think>
	 <7EC11C2E-889E-42A4-80D8-EA7E80F4963D@karlsbakk.net>
	 <20090804183307.GG5693@think>
	 <5D3C1A84-7A56-48CC-9C78-EDC582ED6B54@karlsbakk.net>
	 <2a31deca0908051128r48cdfd62t2d0fe40c4a9b1a05@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2a31deca0908051128r48cdfd62t2d0fe40c4a9b1a05@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I guess whats really hard to program: snapshot removal when not
copying the data, but only pointing to that data and writing the
differences from that point on. Figure out how difficult it is to
remove snapshot 3 of 7; When snapshot 1 is the original data, snap2
the diff from 1 to 2, snap 3 the diff from 2 to 3, .... so you have to
merge the data of snap 3 and 4.

But the benefits are obvious: instant snapshots and very low space
consumption (in case you don't delete lots of your 'live' data).

On 8/5/09, Andrey Kuzmin <andrey.v.kuzmin@gmail.com> wrote:
> On Wed, Aug 5, 2009 at 3:18 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.n=
et>
> wrote:
>>
>> On 4. aug.. 2009, at 20.33, Chris Mason wrote:
>>
>>>> It's strange that such a small thing should be delayed so much. If
>>>> snapshot removal was working, I'm quite sure we might get more use=
rs
>>>> and thereby more stable code faster.
>>>
>>> It's a small feature but it gets deep into the difficult parts of t=
he
>>> dentry cache to do it right. =C2=A0So, it definitely isn't easy.
>>
>>
>> I'd say it's a pretty elemetary feature to be able to remove somethi=
ng you
>> have created.
>
> Snapshots are somewhat counter-intuitive in many respects: for
> instance, one snapshot-capable file-system performs writes to  a
> dataset with snapshots _faster_ than to the same dataset w/o
> snapshots. Snapshot removal is no exception - it's a bit more complex
> than one would think.
>
> Regards,
> Andrey
>
>> I know, you can remove the files and so on, but still, having a bunc=
h of
>> old and empty
>> snapshots lying around is no good.
>
>
>>
>> roy
>> --
>> Roy Sigurd Karlsbakk
>> (+47) 97542685
>> roy@karlsbakk.net
>> http://blogg.karlsbakk.net/
>> --
>> I all pedagogikk er det essensielt at pensum presenteres intelligibe=
lt.
>> Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=
=A5 eksessiv
>> anvendelse av idiomer med fremmed opprinnelse. I de fleste tilfeller
>> eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
