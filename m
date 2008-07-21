From: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Subject: Re: single disk reed solomon codes
Date: Mon, 21 Jul 2008 10:40:06 +0300
Message-ID: <3da3b5b40807210040s72fdf458g44a1fe968088586e@mail.gmail.com>
References: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com>
	 <0cb201c8e9b2$a4272b20$0a00a8c0@ALDI2>
	 <1216622923.6970.19.camel@s1.crocom.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Tomasz Torcz" <tomek@crocom.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216622923.6970.19.camel@s1.crocom.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

I definitely hope btrfs has this per-object "copies" property too.
However, simply replicating the whole contents of a directory, wastes
too much disk space, as opposed to RS codes

On Mon, Jul 21, 2008 at 9:48 AM, Tomasz Torcz <tomek@crocom.com.pl> wrote:
> Dnia 2008-07-19, sob o godzinie 17:18 +0200, Gerald Nowitzky pisze:
>
>> In the end, you would add very little security by the price of -at least-
>> cutting half your write performance. Thus, I don't think there is any point
>> in adding redundancy to single disk systems.
>
>  ZFS can store multiple copies of data block within one disk. Using
> your words, it's like "Intra-Disk-RAID1". After reading data, when
> checksum shows it's corrupted, another copy (hopefully correct) is read
> from other disk location.
>  This is adding security by the price of half storage capacity. Which
> seems like a fair game, given todays 1,5TB HDDs.
>
> --
> Tomasz Torcz
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
