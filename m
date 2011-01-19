From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: btrfs defrag: how does it work?
Date: Wed, 19 Jan 2011 16:49:33 -0600
Message-ID: <AANLkTik6-1DiqN7ktb5v-ybszJSWN3fb3p8+qY6t3JVL@mail.gmail.com>
References: <AANLkTintJmDE7VVa5eTiepew68gztjh1j8Li1Fgq2iS6@mail.gmail.com>
	<1295471646-sup-7764@think>
	<AANLkTikcNy1FdRjLu=bDpE=A7krUysmV2uLwN9jh4AF2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Paul Komkoff <i@stingr.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikcNy1FdRjLu=bDpE=A7krUysmV2uLwN9jh4AF2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 19, 2011 at 4:31 PM, Paul Komkoff <i@stingr.net> wrote:
> On Wed, Jan 19, 2011 at 9:25 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
>> The defrag code doesn't actually defrag. =A0It opens up the file and
>> recows all the extents and then the delayed allocation code jumps in=
 and
>> makes the biggest possible extent that it can.
>>
>> The reason why you're still seeing extents after running the defrag
>> command is because the file hasn't been written yet, so the delayed
>> allocation code hasn't kicked in.
>>
>> If you use btrfs fi defrag -f it'll trigger writeback on the file an=
d
>> you should see the results of the defrag sooner.
>
> I tried, and just tried it again, with the same file. I even tried
> doing btrfs fi sync in random order. No matter what I do, it's still
> 132 extents :)
> --

Is it possible that this patch is causing this behavior?:

http://www.spinics.net/lists/linux-btrfs/msg03110.html

It appears to me that when a relocation is performed (as is done with
defragmentation), that this patch limits the extent size with the
newly introduced "#define MAX_EXTENTS 128".
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
