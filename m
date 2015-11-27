Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35256 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbbK0Lxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 06:53:47 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <565843B8.1050205@googlemail.com>
References: <565834B3.4020602@gmx.de>
	<CAL3q7H4F4ohPo=LK_dhT+wom7KmP7PwSqm8GzkvknPpBqbR85Q@mail.gmail.com>
	<56583C7C.5080904@gmx.de>
	<565843B8.1050205@googlemail.com>
Date: Fri, 27 Nov 2015 11:53:47 +0000
Message-ID: <CAL3q7H6KJ=qbg5eZ8wbAqHyGfsjSNYCCoM-VN6SmfQ_zc=u6Zg@mail.gmail.com>
Subject: Re: PAX: size overflow detected in function try_merge_map fs/btrfs/extent_map.c:238
From: Filipe Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2015 at 11:51 AM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> On 11/27/15 12:20, Toralf Förster wrote:
>> On 11/27/2015 12:07 PM, Filipe Manana wrote:
>>> Try the following (also pasted at
>>> https://friendpaste.com/5O6o1cqWqJZDIKrH1YqG7y):
>>
>> Doesn't apply neither against the used 4.2.6 kernel nor aginst current git HEAD :
>>
>> t44 linux # patch -p1 --dry-run < /home/tfoerste/Downloads/5O6o1cqWqJZDIKrH1YqG7y.diff.patch
>> checking file fs/btrfs/extent_map.c
>> Hunk #1 FAILED at 235.
>> Hunk #2 FAILED at 252.
>> 2 out of 2 hunks FAILED
>>
>>
>> tfoerste@t44 ~/devel/linux $ patch -p1 --dry-run < ~/Downloads/5O6o1cqWqJZDIKrH1YqG7y.diff.patch
>> checking file fs/btrfs/extent_map.c
>> Hunk #1 FAILED at 235.
>> Hunk #2 FAILED at 252.
>> 2 out of 2 hunks FAILED
>>
>
> Toralf,
>
> try with --ignore-whitespace, that works for me. Seems the pastebin ate
> some formatting.

Indeed.
Try the following instead:  http://paste.opensuse.org/view/raw/58412382

thanks

>
> -h
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
