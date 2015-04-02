Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36242 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbDBSD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Apr 2015 14:03:27 -0400
Received: by iedm5 with SMTP id m5so75315628ied.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Apr 2015 11:03:27 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <pan.2015.04.02.17.31.42@googlemail.com>
References: <1427810206-23103-1-git-send-email-fdmanana@suse.com>
	<1427995511-13028-1-git-send-email-fdmanana@suse.com>
	<pan.2015.04.02.17.31.42@googlemail.com>
Date: Thu, 2 Apr 2015 19:03:27 +0100
Message-ID: <CAL3q7H6p4S7f72krzV6dTUYxKzOvx8AYOkhdx76_PSLKq-VfKQ@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix range cloning when same inode used as
 source and destination
From: Filipe David Manana <fdmanana@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 2, 2015 at 6:31 PM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
>
> On Thu, 02 Apr 2015 18:25:11 +0100, Filipe Manana wrote:
>
>> V2: Fixed a warning about potentially uninitialized variable. David
>>     got this warning on a 4.5.1 gcc, but I didn't on a 4.9.2 gcc
>>     however.
>
> I was *just* about to post this warning, since I saw it only a minute ago!
>
> I assume you mean:
>
> fs/btrfs/ioctl.c: In function 'btrfs_clone':
> fs/btrfs/ioctl.c:3531:14: warning: 'next_key_min_offset' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    key.offset = next_key_min_offset;
>               ^
>
> ..and this is with 4.9.2 here.
>
> Anyway..thanks for being faster :)

Yes, that was it.
Thanks.

>
> Holger
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
