From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: TRIM support
Date: Mon, 11 Jul 2011 04:59:54 +0700
Message-ID: <CAG1y0seg-TTgbdr5_xTjaA_rYoW44AF_pPAFC5_nCNG1qEmNHg@mail.gmail.com>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com>
	<1309635918.3774.7.camel@nayuki>
	<201107101833.31450.chris@csamuel.org>
	<CAAeznTrXzt+jYByWz3fkSH41qStNfWupWNk8SZt75ousuJ3iYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTrXzt+jYByWz3fkSH41qStNfWupWNk8SZt75ousuJ3iYg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2011 at 3:58 AM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> On Sun, Jul 10, 2011 at 9:33 AM, Chris Samuel <chris@csamuel.org> wrote:
>> On Sun, 3 Jul 2011 05:45:17 AM Calvin Walton wrote:
>> This LWN article from 2009 explains why it can be problematic
>> (especially on SATA drives where TRIM is a non-queued command):
>>
>> https://lwn.net/Articles/347511/
>>
> So the current problem with TRIM in ATA (and SATA) is that it
> introduce delays? As long as it keeps your SSD in a good shape it's
> still better than not having TRIM at all, right?

Not quite.

Sandforce-based SSDs have their own way of reducing writes (e.g. by
using internal compression), so you don't have to do anything special.
Also, AFAIK currently TRIM is useless if the drives are behind a
hardware raid controller anyway.

My Corsair F60 (on a notebook) is actually MUCH SLOWER with -o discard
(i.e. writes capped at 100 iops)

-- 
Fajar
