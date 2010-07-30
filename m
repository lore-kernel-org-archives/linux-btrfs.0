From: Wang Shaoyan <stufever@gmail.com>
Subject: Re: can subvolumes be specified as compressed?
Date: Fri, 30 Jul 2010 11:21:58 +0800
Message-ID: <AANLkTik-0PdjpjNgufGy6n+DawgAkGhv2uuY4BkVmAEV@mail.gmail.com>
References: <AANLkTi=_gp3hbXjqCnpzHJRAkBhRZqVZ1V5jhg1B0RAV@mail.gmail.com>
	<4C5139FB.8070504@cn.fujitsu.com>
	<AANLkTi=HwyeSxwMNXWTCDzpzDMqoza1DcTuEzS6oirXF@mail.gmail.com>
	<AANLkTinOWkZMDGkgEk0yrGBLDKX6a2ocNcq_b-dKVncN@mail.gmail.com>
	<m3pqy5ra9f.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3pqy5ra9f.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

I don't know whether this demand, which specified some subvolumes or
directories to be compressed, conflict with the design of btrfs's
compression feature, may be they want to do this thing well, and
everyone will enable the compression feature, rather than throw the
decision to user to determine which should compress.

But now, if we can mount a subvolume and specify some mount options,
we should make these options work, rather than ignore.

2010/7/30 Chris Ball <cjb@laptop.org>:
> Hi,
>
> =A0 > So, is there such a method: in a specified directory, the
> =A0 > compression feature is enabled, and the file in this directory
> =A0 > will be compressed automatically, while the others don't enable
> =A0 > compression.
>
> I don't think so, but it wouldn't be difficult -- you'd just set a
> per-inode flag on whether to compress, and if it's set on a directory
> then it's inherited by the files in that directory.
>
> I think the hold up has been that we've waited for a *generic*
> cross-filesystem flag to appear, and it hasn't (or it has and I didn'=
t
> notice). =A0Does anyone have suggestions on how to break the deadlock
> there?
>
> - Chris.
> --
> Chris Ball =A0 <cjb@laptop.org>
> One Laptop Per Child
>



--=20
Wang Shaoyan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
