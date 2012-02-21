From: Tom Cameron <tomc603@gmail.com>
Subject: Re: Balance RAID10 with odd device count
Date: Mon, 20 Feb 2012 20:59:05 -0500
Message-ID: <CA+Huu1H3q-eztZ8W3BK=y4TR7ero1tc=QdzAkiFewQw8jA-7-g@mail.gmail.com>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
	<CAHH42iun+Qby5evPhwv0T6LH7BaOk=pcPrPbrKXe2BUEnNX5sA@mail.gmail.com>
	<CAHH42isod-cyEqG1rfq6m1ki2EV_FqU6TnX9WzH+BJ7s6OF1aQ@mail.gmail.com>
	<CA+Huu1FF9-wFXyG4NvvNLwJv5eqHUcVK_UHeENSY9A=9ssXSEQ@mail.gmail.com>
	<CA+WRLO9BgqE+CwCUNgjwjVFyjDDp94SBX_EbdVciHUd0jpUqWQ@mail.gmail.com>
Reply-To: tom@drdabbles.us
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Gareth Pye <gareth@cerberos.id.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+WRLO9BgqE+CwCUNgjwjVFyjDDp94SBX_EbdVciHUd0jpUqWQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Gareth,

I would completely agree. I only use the RAID vernacular here because,
well, it's the unfortunate defacto standard way to talk about data
protection.

I'd go a step beyond saying dupe or dupe + stripe, because future
modifications could conceivably see the addition of multiple
duplicated sets. The case of 4 disks in a BTRFS filesystem with dupe
running across all of them would be a clear extension I could see. So
that would be something like 4D. I'm not real sure what you'd use for
the terminology, but something completely different than RAID-like
terms is almost certainly best. Just look at the ZFS documentation to
see how carefully they have to spell out what RAID-Z, Z2, and Z3 do
because they used the RAID acronym.

On Mon, Feb 20, 2012 at 8:47 PM, Gareth Pye <gareth@cerberos.id.au> wro=
te:
> On Tue, Feb 21, 2012 at 12:07 PM, Tom Cameron <tomc603@gmail.com> wro=
te:
>>
>> It seems from the BTRFS documentation that the RAID1 profile is
>> actually "mirror", or store 2 copies of the object. Perhaps when
>> Oracle makes BTRFS a production option they should more clearly spel=
l
>> that out.
>
>
> I'd really like BTRFS to not use RAID level terminology anywhere (oth=
er than
> maybe in=A0parenthesis=A0along the lines of: "this is similar to RAID=
X") and use
> less ambigious options as the recommended way to talk about things. A=
s there
> is good reason to talk about Dup and RAID1 differently as they aren't=
 the
> same on more than 2 drives. Doing it that way will make people unders=
tand
> what is going on more often, which should be good.
>
> It also makes things much easier to remember. Like how much data can =
you fit
> on a 6 drive RAID10? I dunno, but I can more intuitively answer that =
same
> question when it is phrased as just simply 'dup', or maybe 'dup + str=
ipe'.
>
> Is there a difference in BTRFS between dup and raid10?
>
> --
> Gareth Pye
> Level 2 Judge, Melbourne, Australia
> Australian MTG Forum:=A0mtgau.com
> gareth@cerberos.id.au=A0-=A0www.rockpaperdynamite.wordpress.com
> "Dear God, I would like to file a bug report"
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
