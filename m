Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:32870 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbbK0LWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 06:22:34 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <56583C7C.5080904@gmx.de>
References: <565834B3.4020602@gmx.de>
	<CAL3q7H4F4ohPo=LK_dhT+wom7KmP7PwSqm8GzkvknPpBqbR85Q@mail.gmail.com>
	<56583C7C.5080904@gmx.de>
Date: Fri, 27 Nov 2015 11:22:33 +0000
Message-ID: <CAL3q7H7zmkb5mnSdEJ456wnM91+g=PgjVqvziAUdjf9PsotZ2A@mail.gmail.com>
Subject: Re: PAX: size overflow detected in function try_merge_map fs/btrfs/extent_map.c:238
From: Filipe Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2015 at 11:20 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> On 11/27/2015 12:07 PM, Filipe Manana wrote:
>> Try the following (also pasted at
>> https://friendpaste.com/5O6o1cqWqJZDIKrH1YqG7y):
>
> Doesn't apply neither against the used 4.2.6 kernel nor aginst current git HEAD :

Quite probable, this was against the integration branch for btrfs.
You should be able to apply it manually, it's a trivial change and
extent_map.c did not change in any significant way.

>
> t44 linux # patch -p1 --dry-run < /home/tfoerste/Downloads/5O6o1cqWqJZDIKrH1YqG7y.diff.patch
> checking file fs/btrfs/extent_map.c
> Hunk #1 FAILED at 235.
> Hunk #2 FAILED at 252.
> 2 out of 2 hunks FAILED
>
>
> tfoerste@t44 ~/devel/linux $ patch -p1 --dry-run < ~/Downloads/5O6o1cqWqJZDIKrH1YqG7y.diff.patch
> checking file fs/btrfs/extent_map.c
> Hunk #1 FAILED at 235.
> Hunk #2 FAILED at 252.
> 2 out of 2 hunks FAILED
>
> --
> Toralf, pgp: C4EACDDE 0076E94E



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
