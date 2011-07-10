From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: TRIM support
Date: Sun, 10 Jul 2011 23:34:08 +0100
Message-ID: <CAAeznTp-XB2eGarkfyVRASyLTULYLz0myPE+GN6TggrxPjv_YA@mail.gmail.com>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com>
	<1309635918.3774.7.camel@nayuki>
	<201107101833.31450.chris@csamuel.org>
	<CAAeznTrXzt+jYByWz3fkSH41qStNfWupWNk8SZt75ousuJ3iYg@mail.gmail.com>
	<CAG1y0seg-TTgbdr5_xTjaA_rYoW44AF_pPAFC5_nCNG1qEmNHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0seg-TTgbdr5_xTjaA_rYoW44AF_pPAFC5_nCNG1qEmNHg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

So any clues for the intel 320 series? I think it doesn't use compressi=
on.

On Sun, Jul 10, 2011 at 10:59 PM, Fajar A. Nugraha <list@fajar.net> wro=
te:
> On Mon, Jul 11, 2011 at 3:58 AM, Leonidas Spyropoulos
> <artafinde@gmail.com> wrote:
>> On Sun, Jul 10, 2011 at 9:33 AM, Chris Samuel <chris@csamuel.org> wr=
ote:
>>> On Sun, 3 Jul 2011 05:45:17 AM Calvin Walton wrote:
>>> This LWN article from 2009 explains why it can be problematic
>>> (especially on SATA drives where TRIM is a non-queued command):
>>>
>>> https://lwn.net/Articles/347511/
>>>
>> So the current problem with TRIM in ATA (and SATA) is that it
>> introduce delays? As long as it keeps your SSD in a good shape it's
>> still better than not having TRIM at all, right?
>
> Not quite.
>
> Sandforce-based SSDs have their own way of reducing writes (e.g. by
> using internal compression), so you don't have to do anything special=
=2E
> Also, AFAIK currently TRIM is useless if the drives are behind a
> hardware raid controller anyway.
>
> My Corsair F60 (on a notebook) is actually MUCH SLOWER with -o discar=
d
> (i.e. writes capped at 100 iops)
>
> --
> Fajar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
