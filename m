From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: weird ENOSPC with defragment directory
Date: Mon, 16 Aug 2010 22:20:43 -0500
Message-ID: <AANLkTinpV9fT3GUuuKC--VpPABERBHx7Xf5fCJSrFRUL@mail.gmail.com>
References: <AANLkTikgGCOfZo1A-R6bX+XXcAfCz48SDwX_0yhvUeJx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikgGCOfZo1A-R6bX+XXcAfCz48SDwX_0yhvUeJx@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 16, 2010 at 10:15 PM, Jon Nelson <jnelson@jamponi.net> wrot=
e:
> Most other directories on /var/cache, *except* those created by squid=
,
> can be defragmented.
> The filesystem was converted from ext3/4.
>
> turnip:~ # uname -a
> Linux turnip 2.6.34-12-default #1 SMP 2010-06-29 02:39:08 +0200 x86_6=
4
> x86_64 x86_64 GNU/Linux
>
> (stock openSUSE 11.3 kernel)
>
> turnip:~ btrfsctl -d /var/cache/squid/01/93
> ioctl:: No space left on device
> turnip:~ # find !$
> find /var/cache/squid/01/93
> /var/cache/squid/01/93
> /var/cache/squid/01/93/00019321
> /var/cache/squid/01/93/00019378
> turnip:~ # ls -la !$
> ls -la /var/cache/squid/01/93
> total 2
> drwxr-x--- 1 squid nogroup =C2=A0 32 Aug 13 17:13 .
> drwxr-x--- 1 squid nogroup 1024 Jun =C2=A04 18:35 ..
> -rw-r----- 1 squid nogroup 1777 Jul 13 22:31 00019321
> -rw-r----- 1 squid nogroup =C2=A0537 Jul 13 22:31 00019378
> turnip:~ #
>
> That seems... strange.

It gets stranger. If I issue a 'sync' command, chances are the
defragment command will work. If I issue a bunch of them (in series,
however), then I get ENOSPC.

find /var/cache -xdev -type d -exec btrfsprogs -d {} \;

Seems to do it every time, with or without -depth. I get 100% success
and then 100% failure - no mixing.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
