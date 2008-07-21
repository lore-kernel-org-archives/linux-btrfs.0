From: "Dongjun Shin" <djshin90@gmail.com>
Subject: Re: single disk reed solomon codes
Date: Tue, 22 Jul 2008 00:03:15 +0900
Message-ID: <7fe698080807210803h3a634eddw49be677e235c1c88@mail.gmail.com>
References: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com>
	 <0cb201c8e9b2$a4272b20$0a00a8c0@ALDI2>
	 <1216622923.6970.19.camel@s1.crocom.com.pl>
	 <3da3b5b40807210040s72fdf458g44a1fe968088586e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Tomasz Torcz" <tomek@crocom.com.pl>, linux-btrfs@vger.kernel.org
To: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40807210040s72fdf458g44a1fe968088586e@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 21, 2008 at 4:40 PM, Ahmed Kamal
<email.ahmedkamal@googlemail.com> wrote:
> I definitely hope btrfs has this per-object "copies" property too.
> However, simply replicating the whole contents of a directory, wastes
> too much disk space, as opposed to RS codes
>

Although adding redundancy mechanism will help increasing the integrity of data,
I'm not sure whether repeating the same kind of mechanism twice will help.
(AFAIK, RS is common in HDD and BCH is common in flash due to their own
physical characteristics)

I think it is better to have another redundancy mechanism (like RAID1)
which is independent of the algorithm used by the underlying storage.

-- 
Dongjun
