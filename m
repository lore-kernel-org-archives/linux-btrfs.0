From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: replacing failed disks in RAID-1 (kernel BUG)?
Date: Tue, 14 Jul 2009 10:36:10 +0200
Message-ID: <4A5C437A.2010206@wpkg.org>
References: <4A5B0C39.5030905@wpkg.org> <235a4bf70907132054j402af6b8o9405300062bb07d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Roger Bumgarner <roger.bumgarner@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <235a4bf70907132054j402af6b8o9405300062bb07d1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Roger Bumgarner wrote:
> I have no idea if this would work with btrfs, but the first thing I
> would do is use 'dd' to clone one drive over to the new drive. I've
> done that to repair real failed RAID1 arrays.

I don't think it's a good idea.
Well, it could be a temporary workaround (_if_ it works) for btrfs until 
it stabilizes.

But certainly not for md RAID-1. _If_ it did work for you, you would 
have to take the whole array down as dd works, which is not good. md 
provides its own tools (mdadm) to replace/rebuild the RAID.


-- 
Tomasz Chmielewski
http://wpkg.org
