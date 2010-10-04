From: Fabio <tux@ilbello.com>
Subject: Re: MySQL on BTRFS Experiences
Date: Tue, 05 Oct 2010 01:27:07 +0200
Message-ID: <4CAA62CB.9010307@ilbello.com>
References: <AANLkTi=7PDWuRb6J8cma-E7qGbFU=ounrzwZB681moZG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Jason J. W. Williams" <jasonjwwilliams@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=7PDWuRb6J8cma-E7qGbFU=ounrzwZB681moZG@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Jason J. W. Williams ha scritto:
> Hi,
>
> My shop is a long time (~2006) ZFS user, considering moving off OpenSolaris
> due to a number of non-technical issues. We use ZFS for all of our MySQL
> databases. It's cheap/fast snapshots are critical to our backup strategy,
> and we rely on the L2ARC and dedicated log device (i.e. NVRAM) features to
> accelerate our pools with SSDs.
>
> I've read through the archives for comments on stability, but they seem to
> be generic "is it stable" questions. Is there anyone who is running a
> critical MySQL operation on BTRFS that could comment on their experience
> with it? "critical" to me means a 24x7 operation with 3-4 nines uptime
> requirement.
>   
As already discussed, the main concern against BTRFS is not stability, 
but the lack of a functional fsck utility.

> Also, as BTRFS doesn't seem to have SSD acceleration features yet, is anyone
> using BTRFS in combination with flashcache?
>
> Anybody who's come to BTRFS from ZFS would be very helpful too.
>
> Thank you in advance.
>
> -J
>   


-- 
Fabio

