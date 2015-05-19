Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37557 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447AbbESMaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 08:30:20 -0400
Received: by igbsb11 with SMTP id sb11so12421060igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 05:30:19 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <pan.2015.05.19.11.32.06@googlemail.com>
References: <1431972715-16833-1-git-send-email-fdmanana@suse.com>
	<pan.2015.05.19.11.32.06@googlemail.com>
Date: Tue, 19 May 2015 13:30:19 +0100
Message-ID: <CAL3q7H6ay7T_-RK+ujf0KM4eLbMfAhOXHWV1Fr5G_Msd5Mxr1g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix racy system chunk allocation when setting
 block group ro
From: Filipe David Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 19, 2015 at 12:32 PM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> On Mon, 18 May 2015 19:11:40 +0100, Filipe Manana wrote:
>
>> If while setting a block group read-only we end up allocating a system
>> chunk, through check_system_chunk(), we were not doing it while holding
>> the chunk mutex which is a problem if a concurrent chunk allocation is
>> happening, through do_chunk_alloc(), as it means both block groups can
>> end up using the same logical addresses and physical regions in the
>> device(s). So make sure we hold the chunk mutex.
>>
>> Cc: stable@vger.kernel.org  # 4.0+
>> Fixes: 2f0810880f08 ("btrfs: delete chunk allocation attemp when
>>                       setting block group ro")
>
> Hello Filipe,
>
> good find, as usual. But from the description it's not clear to me whether
> this also fixes rebalance seemingly not having an effect (as reported many
> times now) or "just" the on-disk block data getting munched together on a
> racy day? Just thought I'd ask for clarification before I start patching.

No, it doesn't fix the balance/conversion issue. It's a completely
separate issue/regression. Chris is working on the balance/conversion
issue.

thanks

>
> Thanks!
>
> Holger
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
