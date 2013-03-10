Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:54456 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3CJPl5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 11:41:57 -0400
Received: by mail-we0-f169.google.com with SMTP id t11so2816242wey.28
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 08:41:56 -0700 (PDT)
Message-ID: <513CAA25.2010803@gmail.com>
Date: Sun, 10 Mar 2013 16:43:33 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

On 03/09/2013 09:31 PM, Hugo Mills wrote:
>    Some time ago, and occasionally since, we've discussed altering the
> "RAID-n" terminology to change it to an "nCmSpP" format, where n is the
> number of copies, m is the number of (data) devices in a stripe per copy,
> and p is the number of parity devices in a stripe.
> 
>    The current kernel implementation uses as many devices as it can in the
> striped modes (RAID-0, -10, -5, -6), and in this implementation, that is
> written as "mS" (with a literal "m"). The mS and pP sections are omitted
> if the value is 1S or 0P.
> 
>    The magic look-up table for old-style / new-style is:
> 
> single 		 1C (or omitted, in btrfs fi df output)
> RAID-0		 1CmS
> RAID-1		 2C
> DUP			 2CD
> RAID-10		 2CmS
> RAID-5		 1CmS1P
> RAID-6		 1CmS2P


Even I found a bit more rational the "nCmSpP" format, I think that this
is a bit too complex.

As you told:
>    Chris is definitely planning fixed values for mS (so you can ask
> for, say, exactly 4 stripes and one parity), and values for nC greater
> than 2. As far as I know, there aren't any plans for nC > 1 and pP > 0
> together. I haven't got far enough into the kernel code to work out
> whether that's simple or not to implement.

On the basis of that we should handle few cases than the full "nCDmSpP"
format allow. So I suggest to allow the following "shorts forms":

- DUP			-> dD		(to allow more that 2 copy per
					 disk)

- RAID1			-> nC or *C	

- RAID0 		-> mS or *S

- RAID10		-> nCmS or *CmS or nC*s

- RAID with parity	-> mSpP or *SpP or mS*p (it is possible ?)

- single		-> 1C or 1D or 1S or "single"


where d,n,m,p are integers; '*' is the literal '*' and means "how many
possible".

For example if I have 6 disks:
*C2S	-> means: 3 copies, 2 stripes ( m*n = 3*2 == num disk == 6)
2C*S	-> means: 2 copies, 3 stripes ( m*n = 3*2 == num disk == 6)
*S2P	-> means: 2 parity, 4 stripes ( p+m = 4+2 == num disk == 6)

We could also have some defaults, like: d=2, n=2, m=*, p=1, so some
common forms become:
D	-> means DUP (d==2)
S	-> means RAID0 (s=*)
C	-> means RAID1 (n=2)
CS	-> means RAID10 (n=2, m=*)
SP	-> means RAID5 (m=*, p=1)
SP2	-> means RAID6 (m=*, p=2)

It would allowable also more complex form like
	5C3D4S2P
but I don't think it will be supported ever.

I have a request: could we consider to swap letters with the numbers ?
For example 3S2P could become S3P2. For my *subjective* point of view,
this seems more clear. What do you think ?

However I am open also to the following forms

dD -> DUP(d), as backward compatibility DUP means d==2
nC -> RAID1(n), as backward compatibility RAID1 means n==2
mS -> RAID0(n), as backward compatibility RAID0 means m==*
nCmS -> RAID10(n,m), as backward compatibility RAID10 means n=2, m=*
mSpP -> RAIDP(n,m), as backward compatibility RAID6 means p=2, m=*
			RAID5 means p=1, m=*

more verbose but also more familiar to the administrator.

What do you think ?

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
