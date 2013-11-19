Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64738 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab3KSR2o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 12:28:44 -0500
MIME-Version: 1.0
In-Reply-To: <528AA1EB.3010909@zytor.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
Date: Tue, 19 Nov 2013 18:28:43 +0100
Message-ID: <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Peter,

Yes, 251 disks for 6 parity.

To build a NxM Cauchy matrix you need to pick N+M distinct values
in the GF(2^8) and we have only 2^8 == 256 available.
This means that for every row we add for an extra parity level, we
have to remove one of the disk columns.

Note that in true, I use an Extended Cauchy matrix that gives the
first row of 1 for "free". This results in N+M <= 256+1.
So, DISKS = 257 - PARITY -> 251 = 257 - 6

A brief introduction of Cauchy and Extended Cauchy matrix can be found in:

Vinocha, "On Generator Cauchy Matrices of GDRS/GTRS Codes", 2012
http://www.m-hikari.com/ijcms/ijcms-2012/45-48-2012/brarIJCMS45-48-2012.pdf
(just check the Introduction, the rest is not related)

More details can be found in:

Roth, "Introduction to Coding Theory", 2006
http://carlossicoli.free.fr/R/Roth_R.-Introduction_to_coding_theory-Cambridge_University_Press%282006%29.pdf
(search for "Extended Cauchy")

Ciao,
Andrea

On Tue, Nov 19, 2013 at 12:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/18/2013 02:35 PM, Andrea Mazzoleni wrote:
>> Hi Peter,
>>
>> The Cauchy matrix has the mathematical property to always have itself
>> and all submatrices not singular. So, we are sure that we can always
>> solve the equations to recover the data disks.
>>
>> Besides the mathematical proof, I've also inverted all the
>> 377,342,351,231 possible submatrices for up to 6 parities and 251 data
>> disks, and got an experimental confirmation of this.
>>
>
> Nice.
>
>>
>> The only limit is coming from the GF(2^8). You have a maximum number
>> of disk = 2^8 + 1 - number_of_parities. For example, with 6 parities,
>> you can have no more of 251 data disks. Over this limit it's not
>> possible to build a Cauchy matrix.
>>
>
> 251?  Not 255?
>
>> Note that instead with a Vandermonde matrix you don't have the
>> guarantee to always have all the submatrices not singular. This is the
>> reason because using power coefficients, before or late, it happens to
>> have unsolvable equations.
>>
>> You can find the code that generate the Cauchy matrix with some
>> explanation in the comments at (see the set_cauchy() function) :
>>
>> http://sourceforge.net/p/snapraid/code/ci/master/tree/mktables.c
>
> OK, need to read up on the theoretical aspects of this, but it sounds
> promising.
>
>         -hpa
>
>
