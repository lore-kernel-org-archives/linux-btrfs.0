From: Ravi Pinjala <ravi@p-static.net>
Subject: Re: Raid1 with 3 drives
Date: Fri, 05 Mar 2010 19:02:35 -0600
Message-ID: <4B91A9AB.1020005@p-static.net>
References: <013A5A0F-6BB8-4CF0-855F-0A80BEA8B1CC@adtran.com> 	<20100305194047.GA15771@localhost.localdomain> <m3iq9av8uv.fsf@pullcord.laptop.org> 	<EC9156D0-7498-458A-AD9F-0197C933C5FC@adtran.com> <20100305203148.GB15771@localhost.localdomain> <b7130efa1003051349p63733275g6b98fab32d6f497c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Bart Noordervliet <bart@noordervliet.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <b7130efa1003051349p63733275g6b98fab32d6f497c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/05/10 15:49, Bart Noordervliet wrote:
> On Fri, Mar 5, 2010 at 21:31, Josef Bacik<josef@redhat.com>  wrote:
>>> Since I have three devices in a RAID1 pool, can it survive 2 drive failures?
>>
>> Yes, tho you won't be able to remove more than 1 at a time (since it wants you
>> to keep at least two disks around).  Thanks,
>>
>> Josef
>
> Hmm, I would expect the raid1 data mode to keep 2 copies of each file
> and thus yield 50% effective storage capacity, even with 3 disks. I
> see no real reason to stick with the full-disk mirroring mentality of
> previous raid systems since raid implemented in a filesystem works
> differently. Or would it be difficult to implement btrfs raid1 like
> this?
>
> Maybe it's worth to consider leaving the burdened raid* terminology
> behind and name the btrfs redundancy modes more clearly by what they
> do. For instance "-d double|triple" or "-d 2n|3n". And for raid5/6 "-d
> single-parity|double-parity" or "-d n+1|n+2".
>
> Regards,
>
> Bart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This would be pretty excellent - there's a real need for a storage 
system where you can just give it a bunch of disks and a policy, and let 
the system worry about the details. Current RAID implementations are 
pretty inflexible, for example when dealing with disks of varying size.

--Ravi
