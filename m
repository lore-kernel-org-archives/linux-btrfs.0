From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: TRIM support
Date: Sun, 10 Jul 2011 21:58:16 +0100
Message-ID: <CAAeznTrXzt+jYByWz3fkSH41qStNfWupWNk8SZt75ousuJ3iYg@mail.gmail.com>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com>
	<1309635918.3774.7.camel@nayuki>
	<201107101833.31450.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201107101833.31450.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 10, 2011 at 9:33 AM, Chris Samuel <chris@csamuel.org> wrote=
:
> On Sun, 3 Jul 2011 05:45:17 AM Calvin Walton wrote:
>
>> The discard option is not currently automatically enabled; I think
>> there may have been some performance issues in certain cases with
>> drives that have slow trim implementations. But feel free to give
>> it a try.
>
> This LWN article from 2009 explains why it can be problematic
> (especially on SATA drives where TRIM is a non-queued command):
>
> https://lwn.net/Articles/347511/
>
So the current problem with TRIM in ATA (and SATA) is that it
introduce delays? As long as it keeps your SSD in a good shape it's
still better than not having TRIM at all, right?

Also the only viable option for now is fstrim? What is fstrim does
that kernel cannot?
I thought the TRIM was included as from kernel 2.6.29, no ?

Cheers
Leonidas

> cheers,
> Chris
> --
> =A0Chris Samuel =A0: =A0http://www.csamuel.org/ =A0: =A0Melbourne, VI=
C
>
> This email may come with a PGP signature as a file. Do not panic.
> For more info see: http://en.wikipedia.org/wiki/OpenPGP
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
