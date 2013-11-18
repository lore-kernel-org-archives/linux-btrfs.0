Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53105 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3KRWfr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 17:35:47 -0500
MIME-Version: 1.0
In-Reply-To: <528A90B7.5010905@zytor.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
Date: Mon, 18 Nov 2013 23:35:45 +0100
Message-ID: <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        david.brown@hesbynett.no, creamyfish@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Peter,

The Cauchy matrix has the mathematical property to always have itself
and all submatrices not singular. So, we are sure that we can always
solve the equations to recover the data disks.

Besides the mathematical proof, I've also inverted all the
377,342,351,231 possible submatrices for up to 6 parities and 251 data
disks, and got an experimental confirmation of this.

The only limit is coming from the GF(2^8). You have a maximum number
of disk = 2^8 + 1 - number_of_parities. For example, with 6 parities,
you can have no more of 251 data disks. Over this limit it's not
possible to build a Cauchy matrix.

Note that instead with a Vandermonde matrix you don't have the
guarantee to always have all the submatrices not singular. This is the
reason because using power coefficients, before or late, it happens to
have unsolvable equations.

You can find the code that generate the Cauchy matrix with some
explanation in the comments at (see the set_cauchy() function) :

http://sourceforge.net/p/snapraid/code/ci/master/tree/mktables.c

Ciao,
Andrea

On Mon, Nov 18, 2013 at 11:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/18/2013 02:08 PM, Andrea Mazzoleni wrote:
>> Hi,
>>
>> I want to report that I recently implemented a support for
>> arbitrary number of parities that could be useful also for Linux
>> RAID and Btrfs, both currently limited to double parity.
>>
>> In short, to generate the parity I use a Cauchy matrix specifically
>> built to be compatible with the existing Linux parity computation,
>> and extensible to an arbitrary number of parities. This without
>> limitations on the number of data disks.
>>
>> The Cauchy matrix for six parities is:
>>
>> 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01...
>> 01 02 04 08 10 20 40 80 1d 3a 74 e8 cd 87 13 26 4c 98 2d 5a b4 75...
>> 01 f5 d2 c4 9a 71 f1 7f fc 87 c1 c6 19 2f 40 55 3d ba 53 04 9c 61...
>> 01 bb a6 d7 c7 07 ce 82 4a 2f a5 9b b6 60 f1 ad e7 f4 06 d2 df 2e...
>> 01 97 7f 9c 7c 18 bd a2 58 1a da 74 70 a3 e5 47 29 07 f5 80 23 e9...
>> 01 2b 3f cf 73 2c d6 ed cb 74 15 78 8a c1 17 c9 89 68 21 ab 76 3b...
>>
>> You can easily recognize the first row as RAID5 based on a simple
>> XOR, and the second row as RAID6 based on multiplications by powers
>> of 2. The other rows are for additional parity levels and they
>> require multiplications by arbitrary values that can be implemented
>> using the PSHUFB instruction.
>>
>
> Hello,
>
> This looks very interesting indeed.  Could you perhaps describe how the
> Cauchy matrix is derived, and under what conditions it would become
> singular?
>
>         -hpa
>
>
