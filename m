Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp0.eecs.utk.edu ([160.36.59.170]:49010 "EHLO
	smtp0.eecs.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3KTQYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 11:24:39 -0500
Subject: Re: Triple parity and beyond
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: James Plank <plank@cs.utk.edu>
In-Reply-To: <528BCA2D.5010500@redhat.com>
Date: Wed, 20 Nov 2013 11:16:04 -0500
Cc: Andrea Mazzoleni <amadvance@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Message-Id: <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all -- no real comments, except as I mentioned to Ric, my tutorial in FAST last February presents Reed-Solomon coding with Cauchy matrices, and then makes special note of the common pitfall of assuming that you can append a Vandermonde matrix to an identity matrix.  Please see http://web.eecs.utk.edu/~plank/plank/papers/2013-02-11-FAST-Tutorial.pdf, slides 48-52.

Andrea, does the matrix that you included in an earlier mail (the one that has Linux RAID-6 in the first two rows) have a general form, or did you develop it in an ad hoc manner so that it would include Linux RAID-6 in the first two rows?

Best wishes -- Jim
----------

On Nov 19, 2013, at 3:29 PM, Ric Wheeler wrote:

> On 11/19/2013 12:28 PM, Andrea Mazzoleni wrote:
>> Hi Peter,
>> 
>> Yes, 251 disks for 6 parity.
>> 
>> To build a NxM Cauchy matrix you need to pick N+M distinct values
>> in the GF(2^8) and we have only 2^8 == 256 available.
>> This means that for every row we add for an extra parity level, we
>> have to remove one of the disk columns.
>> 
>> Note that in true, I use an Extended Cauchy matrix that gives the
>> first row of 1 for "free". This results in N+M <= 256+1.
>> So, DISKS = 257 - PARITY -> 251 = 257 - 6
>> 
>> A brief introduction of Cauchy and Extended Cauchy matrix can be found in:
>> 
>> Vinocha, "On Generator Cauchy Matrices of GDRS/GTRS Codes", 2012
>> http://www.m-hikari.com/ijcms/ijcms-2012/45-48-2012/brarIJCMS45-48-2012.pdf
>> (just check the Introduction, the rest is not related)
>> 
>> More details can be found in:
>> 
>> Roth, "Introduction to Coding Theory", 2006
>> http://carlossicoli.free.fr/R/Roth_R.-Introduction_to_coding_theory-Cambridge_University_Press%282006%29.pdf
>> (search for "Extended Cauchy")
>> 
>> Ciao,
>> Andrea
> 
> Great work - we have waited a long time for this. Adding in Jim Plank who did some great talks and work in this area as well :)
> 
> Ric
> 
>> 
>> On Tue, Nov 19, 2013 at 12:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 11/18/2013 02:35 PM, Andrea Mazzoleni wrote:
>>>> Hi Peter,
>>>> 
>>>> The Cauchy matrix has the mathematical property to always have itself
>>>> and all submatrices not singular. So, we are sure that we can always
>>>> solve the equations to recover the data disks.
>>>> 
>>>> Besides the mathematical proof, I've also inverted all the
>>>> 377,342,351,231 possible submatrices for up to 6 parities and 251 data
>>>> disks, and got an experimental confirmation of this.
>>>> 
>>> Nice.
>>> 
>>>> The only limit is coming from the GF(2^8). You have a maximum number
>>>> of disk = 2^8 + 1 - number_of_parities. For example, with 6 parities,
>>>> you can have no more of 251 data disks. Over this limit it's not
>>>> possible to build a Cauchy matrix.
>>>> 
>>> 251?  Not 255?
>>> 
>>>> Note that instead with a Vandermonde matrix you don't have the
>>>> guarantee to always have all the submatrices not singular. This is the
>>>> reason because using power coefficients, before or late, it happens to
>>>> have unsolvable equations.
>>>> 
>>>> You can find the code that generate the Cauchy matrix with some
>>>> explanation in the comments at (see the set_cauchy() function) :
>>>> 
>>>> http://sourceforge.net/p/snapraid/code/ci/master/tree/mktables.c
>>> OK, need to read up on the theoretical aspects of this, but it sounds
>>> promising.
>>> 
>>>         -hpa
>>> 
>>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

