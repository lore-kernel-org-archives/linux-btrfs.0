From: cwillu <cwillu@cwillu.com>
Subject: Re: btrfs-raid10 <-> btrfs-raid1 confusion
Date: Sun, 6 May 2012 14:02:57 -0600
Message-ID: <CAE5mzvhR1j95tdx5-=w+JcF8aM0q7FfPFUgnMp-RVk3+7Unkjg@mail.gmail.com>
References: <4FA68F50.60505@gmail.com>
	<20120506152343.GL9860@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>,
	Alexander Koch <lynix47@googlemail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120506152343.GL9860@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 6, 2012 at 9:23 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sun, May 06, 2012 at 04:48:48PM +0200, Alexander Koch wrote:
>> So I added the two new disks to my existing filesystem
>>
>> =C2=A0 =C2=A0 $ btrfs device add /dev/sde1 /dev/sdf1 /mnt/archive
>>
>> and as the capacity reported by 'btrfs filesystem df' did not increa=
se,
>
> =C2=A0 It won't -- "btrfs fi df" reports what's been allocated out of=
 the
> raw pool. To check that the disks have been added, you need "btrfs fi
> show" (no parameters).

Worth pointing out that plain old /bin/df will report the added space
(I believe), but without taking into account raid level for space that
isn't allocated to a block group yet.

>> I got two questions now:
>>
>> 1.) Is there really no difference between btrfs-raid1 and btrfs-raid=
10
>> =C2=A0 =C2=A0 in my case (2 x 2TiB, 2 x 1TiB disks)? Same degree of =
fault
>> =C2=A0 =C2=A0 tolerance?
>
> =C2=A0 There's the same degree of fault tolerance -- you're guarantee=
d to
> be able to lose one disk from the array and still have all your data.
>
> =C2=A0 The data will be laid out in a different way on the disks, tho=
ugh.
> In your case, with four unevenly-sized disks, you will get the best
> usage out of the filesystem with RAID-1. With only 4 disks, RAID-10
> will run out of space when the smallest disk is full. (So, in your
> configuration, you'd still have only 2TB of space usable, rather
> defeating the point of having the new disks in the first place).

Well, compared to the 1TB he had before, but yes, still short of the
3TB of capacity he'd have with RAID-1.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
