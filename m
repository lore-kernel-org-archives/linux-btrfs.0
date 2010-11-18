From: Bart Noordervliet <bart@noordervliet.net>
Subject: Re: Update to Project_ideas wiki page
Date: Thu, 18 Nov 2010 15:31:51 +0100
Message-ID: <AANLkTinKX6uULbK88WdkXhH-XjUboUDf2FV8qopjZPcC@mail.gmail.com>
References: <m3hbfg3acu.fsf@pullcord.laptop.org> <20101117143103.GA2401@selene>
 <AANLkTi=YcVE44g9waRBHQPido4_xf1o5hE4zmTPqVBxN@mail.gmail.com>
 <20101117175657.GB2401@selene> <4CE419ED.3020209@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CE419ED.3020209@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 17, 2010 at 19:07, Gordan Bobic <gordan@bobich.net> wrote:
> Since BTRFS is already doing some relatively radical things, I would like to
> suggest that RAID5 and RAID6 be deemed obsolete. RAID5 isn't safely usable
> for arrays bigger than about 5TB with disks that have a specified error rate
> of 10^-14. RAID6 pushes that problem a little further away, but in the
> longer term, I would argue that RAID (n+m) would work best. We specify that
> of (n+m) disks in the array, we want n data disks and m redundancy disks. If
> this is implemented in a generic way, then there won't be a need to
> implement additional RAID modes later.

I presume you're talking about the uncaught read errors that makes
many people avoid RAID5. Btrfs actually enables us to use it with
confidence again, since using checksums it's able to detect these
errors and prevent corruption of the array. So to the contrary, I see
a lot of potential for parity-based redundancy in combination with
btrfs.

Regards,

Bart
