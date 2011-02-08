From: C Anthony Risinger <anthony@extof.me>
Subject: Re: no space left on device
Date: Mon, 7 Feb 2011 18:09:42 -0600
Message-ID: <AANLkTi=LUqY6FfH52Lv7+d+8doGvi0yj0dUB5fW252__@mail.gmail.com>
References: <AANLkTi=KNt1JVq82FR-u9CGA1TcXiknz0c3bbD186U43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=KNt1JVq82FR-u9CGA1TcXiknz0c3bbD186U43@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 7, 2011 at 3:21 PM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> Hey all,
>
> I run into no space left on device on a virtualbox
>
> After installing Debian 6 on a virtual machine
> I tried installing the KDE desktop
>
> The system HDD is 8Gb
> Both root (/) and /home are btrfs
> over LVM.
>
> While installing the packages I run into:
>
> no space left, need 4096, 4096 dealloc bytes, 1776283648 bytes_used, 0
> bytes_reserved,
> 0 bytes_pinned, 0 bytes_readonly, 0 may use 1776287744 total
>
> df shows only 74% used space on /
>
> kernel used: stock debian 6 2.6.32-5-686
>
> At the moment I cannot access it with normal boot, only recovery mode.
>
> I can provide whatever info you would like as long as you think of a
> way to load the normal system and not the recovery mode.

IIRC .32 has all sorts of ENOSPC problems; I think this was seriously
tackled in kernels > .32... this kernel was only declared ready for
"early adopters", with an "expect issues" disclaimer.

The btrfs-tools in squeeze is probably so old you may not even have
the `btrfs` binary, but I don't run debian so I'm not sure there...
not really a solution probably for you, but I wouldn't run that kernel
if using btrfs.

C Anthony
