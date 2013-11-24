Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:64272 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab3KXJjy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 04:39:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131123221024.GA10555@lazy.lzy>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<20131120222903.GA3654@lazy.lzy>
	<CAGKKSfUejP=pb6HHF-48ciu5GSSd_ZCZMXHyL6iHLcQHvDs8yQ@mail.gmail.com>
	<20131123221024.GA10555@lazy.lzy>
Date: Sun, 24 Nov 2013 10:39:52 +0100
Message-ID: <CAGKKSfXCz_sF4jiM_c2zOvzaCUN6yyR9wL7e84_HqKH-EACKmw@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Piergiorgio,

Checking better I found that for PAR3 it was also evaluated a Cauchy
matrix, but they preferred to use a RS with FFT in GF(2^16 +1).

http://sourceforge.net/mailarchive/forum.php?forum_name=parchive-devel&max_rows=25&style=nested&viewmonth=201006

Note that using a Cauchy matrix for a MDS is something well known.
What I did is just to adapt a Cauchy matrix to be compatible with the
present Linux kernel implementation. I think it has a value only for
Linux or compatible implementations.

Ciao,
Andrea

On Sat, Nov 23, 2013 at 11:10 PM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi Andrea,
>
> On Sat, Nov 23, 2013 at 08:55:08AM +0100, Andrea Mazzoleni wrote:
>> Hi Piergiorgio,
>>
>> > How about par2? How does this work?
>> I checked the matrix they use, and sometimes it contains some singular
>> square submatrix.
>> It seems that in GF(2^16) these cases are just less common. Maybe they
>> were just unnoticed.
>>
>> Anyway, this seems to be an already known problem for PAR2, with an
>> hypothetical PAR3 fixing it:
>>
>> http://sourceforge.net/p/parchive/discussion/96282/thread/d3c6597b/
>
> you did a pretty damn good research work!
>
> Maybe you should consider to contact them too.
> I'm not sure if your approach can be extended
> to GF(2^16), I guess yes, in that case they
> might be interested too.
>
> bye,
>
> --
>
> piergiorgio
