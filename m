Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36437 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753462AbcIMPzx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 11:55:53 -0400
Received: by mail-oi0-f48.google.com with SMTP id q188so273232091oia.3
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 08:55:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160913002110.0c621dc2@jupiter.sol.kaishome.de>
References: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
 <CAJCQCtTQAG+0M9AsNj5LNWXTAKd8V-6DL=5kS80dPt59S1uiAA@mail.gmail.com>
 <BLU437-SMTP168169D258F02597287B2E92170@phx.gbl> <CAJCQCtS1LPmYN2JY0cayWpCPVzaPq+KQSZZU4g9ifVGT9HCZCg@mail.gmail.com>
 <pan$37954$2a2891c6$a583cdc5$350ef358@cox.net> <20160913002110.0c621dc2@jupiter.sol.kaishome.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 13 Sep 2016 09:55:50 -0600
Message-ID: <CAJCQCtSCQ=deq3BrEcMecSOuiLERV=aqV9U74dF7zngyZOyKOg@mail.gmail.com>
Subject: Re: Mixing partitioned and non-partitioned discs in a RAID?
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 12, 2016 at 4:21 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Sun, 21 Aug 2016 02:19:33 +0000 (UTC)
> schrieb Duncan <1i5t5.duncan@cox.net>:
>
>> Chris Murphy posted on Sat, 20 Aug 2016 18:36:21 -0600 as excerpted:
>>
>> > FAT leaves a lot to be desired but it's pretty universally
>> > supported and almost trivial to repair *if* the volume is
>> > repairable in the first place. The much bigger issue with ESP on
>> > Linux is this neurotic tendency of distros to persistently mount
>> > shit that does not need to be mounted. Like the ESP, and even the
>> > dedicated boot volume. They only need to be mounted when being
>> > updated and then should be umounted. And worse the convention is to
>> > do nested mount with /boot and then /boot/efi for the ESP so it's
>> > twice as bad a practice. By virtue of mounting the ESP the dirty
>> > bit is set, so any crash means it must be fsck'd and if that
>> > doesn't work, it's game over for that volume. Fragile setup.
>>
>> Depends on the distro.  On gentoo, you set it up the way you want of
>> course, but the recommendation has always been /boot, and now the
>> ESP, not mounted by default.
>>
>> But that would be /expected/ on gentoo, since being able to configure
>> it the way you want is the whole /point/ of running gentoo in the
>> first place.  Sort of like arch, only much more so.
>
> systemd systems (I'm booting Gentoo with systemd) should auto-mount ESP
> to /boot on access, and auto-unmount after a short timeout. So the
> solution to this problem is already wired into systemd if you use (a)
> proper GPT setup (with correct GUIDs) and (b) do not mention /boot in
> fstab.

What distro uses this layout by default? It's certainly incompatible
with multiboot where either Windows or macOS exist first. It also
necessitates an excessively large ESP to store all possible kernels
and initrds for every OS, making it all the harder to keep sync'd in
any case where even a simple raid1 setup is desired. The ESP is a file
system that doesn't support permissions, acls, or security labels
either. So I'm not really a fan of this, or even nested /boot/efi
either for that matter.  They should be mounted in /run only on demand
and only by the process that has permission to modify each.



-- 
Chris Murphy
