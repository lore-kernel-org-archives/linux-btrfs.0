From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: TRIM support
Date: Mon, 11 Jul 2011 08:17:56 +0100
Message-ID: <4E1AA3A4.2050908@redhat.com>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com> <CAAeznTrXzt+jYByWz3fkSH41qStNfWupWNk8SZt75ousuJ3iYg@mail.gmail.com> <CAG1y0seg-TTgbdr5_xTjaA_rYoW44AF_pPAFC5_nCNG1qEmNHg@mail.gmail.com> <201107111553.17293.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201107111553.17293.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/11/2011 06:53 AM, Chris Samuel wrote:
> On Mon, 11 Jul 2011 07:59:54 AM Fajar A. Nugraha wrote:
>
>> Sandforce-based SSDs have their own way of reducing writes
>> (e.g. by using internal compression), so you don't have to
>> do anything special
> Not just compression, but also block level de-duplication too
> (i.e. potentially removing the redundancy of btrfs's duplication
> of metadata for safety).
>
> cheers,
> Chris

How vendors implement their internal firmware at any given point is not 
something that we can know (or should know).

As mentioned in this thread, you can and should always measure the performance 
of your application on your OS with and without discard being enabled. Note that 
you might have long term effects (i.e., trim enabled via discard might avoid the 
performance hit you see with some devices after extensive use, especially when 
full).

Keep in mind that discard support is built on an industry standard command and 
is used by other vendors (including windows) so manufacturers that do a bad job 
and suffer performance impacts will be *very* motivated to fix their firmware :)

Ric

