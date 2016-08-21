Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:35762 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbcHUC27 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Aug 2016 22:28:59 -0400
Received: by mail-ua0-f170.google.com with SMTP id n59so138267367uan.2
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Aug 2016 19:28:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$37954$2a2891c6$a583cdc5$350ef358@cox.net>
References: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
 <CAJCQCtTQAG+0M9AsNj5LNWXTAKd8V-6DL=5kS80dPt59S1uiAA@mail.gmail.com>
 <BLU437-SMTP168169D258F02597287B2E92170@phx.gbl> <CAJCQCtS1LPmYN2JY0cayWpCPVzaPq+KQSZZU4g9ifVGT9HCZCg@mail.gmail.com>
 <pan$37954$2a2891c6$a583cdc5$350ef358@cox.net>
From: =?UTF-8?B?QmVhcmNhdCDFnsOhbmRvcg==?= <bearcatsandor@gmail.com>
Date: Sat, 20 Aug 2016 20:28:18 -0600
Message-ID: <CAMPo9sq2v=-VrTfjqOe+fAuWGnOEKDX1UoeW9fJAb6KBzr_SMw@mail.gmail.com>
Subject: Re: Mixing partitioned and non-partitioned discs in a RAID?
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the responses all. I'm on Gentoo as well for what that
matters. I think what i'm going to do (if i don't abandon EFI
entirely) is just to get a small (16gb), $25 m.2 since my board
supports that, and use that as my boot drive. Then mkfs other all
discs to be partitionless and away i go.

Not sure what i'll use the extra 15g on that m.2 for.

I learned a lot from your long response Chris. Thank you.

On Sat, Aug 20, 2016 at 8:19 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Sat, 20 Aug 2016 18:36:21 -0600 as excerpted:
>
>> FAT leaves a lot to be desired but it's pretty universally supported and
>> almost trivial to repair *if* the volume is repairable in the first
>> place. The much bigger issue with ESP on Linux is this neurotic tendency
>> of distros to persistently mount shit that does not need to be mounted.
>> Like the ESP, and even the dedicated boot volume. They only need to be
>> mounted when being updated and then should be umounted. And worse the
>> convention is to do nested mount with /boot and then /boot/efi for the
>> ESP so it's twice as bad a practice. By virtue of mounting the ESP the
>> dirty bit is set, so any crash means it must be fsck'd and if that
>> doesn't work, it's game over for that volume. Fragile setup.
>
> Depends on the distro.  On gentoo, you set it up the way you want of
> course, but the recommendation has always been /boot, and now the ESP,
> not mounted by default.
>
> But that would be /expected/ on gentoo, since being able to configure it
> the way you want is the whole /point/ of running gentoo in the first
> place.  Sort of like arch, only much more so.
>
> Meanwhile, I'm kinda partial to booting in legacy mode in grub2, with
> grub2 installed to the legacy-BIOS partion on multiple gpt-partitioned
> devices, which each one having its own /boot as well, setup so the
> firmware boot device selector can choose which device and thus which
> grub2 installation on that device, I boot from.  That gives me as many
> backup grub2 installations on the legacy BIOS partitions, pointing at as
> many backup /boots on the same device by default, as I care to setup.  Of
> course what's extra nice about that is that you can switch to the /boot
> on another device direct from the grub2 prompt, emergency mode if it
> can't load the /boot off that device, if you like.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Bearcat M. Şándor
Feline Soul Systems LLC
Voice: 872.CAT.SOUL (872.228.7685)
Fax: 406.235.7070
