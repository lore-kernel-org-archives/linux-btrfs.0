From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: snapshot-removal - timeline ?
Date: Wed, 5 Aug 2009 22:28:31 +0400
Message-ID: <2a31deca0908051128r48cdfd62t2d0fe40c4a9b1a05@mail.gmail.com>
References: <1552F85577A149D68B0BFF2A44E0FF0A@bui.materna.com>
	<20090803130412.GB3570@think> <10F3F7E4-276B-49C3-B944-61320D634C93@karlsbakk.net>
	<20090803161800.GB5492@think> <7EC11C2E-889E-42A4-80D8-EA7E80F4963D@karlsbakk.net>
	<20090804183307.GG5693@think> <5D3C1A84-7A56-48CC-9C78-EDC582ED6B54@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <5D3C1A84-7A56-48CC-9C78-EDC582ED6B54@karlsbakk.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 5, 2009 at 3:18 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.net=
> wrote:
>
> On 4. aug.. 2009, at 20.33, Chris Mason wrote:
>
>>> It's strange that such a small thing should be delayed so much. If
>>> snapshot removal was working, I'm quite sure we might get more user=
s
>>> and thereby more stable code faster.
>>
>> It's a small feature but it gets deep into the difficult parts of th=
e
>> dentry cache to do it right. =A0So, it definitely isn't easy.
>
>
> I'd say it's a pretty elemetary feature to be able to remove somethin=
g you have created.

Snapshots are somewhat counter-intuitive in many respects: for
instance, one snapshot-capable file-system performs writes to  a
dataset with snapshots _faster_ than to the same dataset w/o
snapshots. Snapshot removal is no exception - it's a bit more complex
than one would think.

Regards,
Andrey

> I know, you can remove the files and so on, but still, having a bunch=
 of old and empty
> snapshots lying around is no good.


>
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 97542685
> roy@karlsbakk.net
> http://blogg.karlsbakk.net/
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibel=
t. Det er et element=E6rt imperativ for alle pedagoger =E5 unng=E5 ekse=
ssiv anvendelse av idiomer med fremmed opprinnelse. I de fleste tilfell=
er eksisterer adekvate og relevante synonymer p=E5 norsk.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
