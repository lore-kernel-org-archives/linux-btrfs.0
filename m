Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:43623 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3EYIV6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 May 2013 04:21:58 -0400
Received: by mail-lb0-f180.google.com with SMTP id r10so5445497lbi.11
        for <linux-btrfs@vger.kernel.org>; Sat, 25 May 2013 01:21:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$1197$73f28aeb$cb95553f$36bb7307@cox.net>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
	<CAE5mzvj=rAmw9DgVL5HUx+Ue1stArhjV9UBM+6fsHUZMZK25Rg@mail.gmail.com>
	<CAAeznTo1uiZMgedoWfE-E0v=2vTWVkV0_k-9_+vVZ6YMFfjdRg@mail.gmail.com>
	<pan$1197$73f28aeb$cb95553f$36bb7307@cox.net>
Date: Sat, 25 May 2013 09:21:57 +0100
Message-ID: <CAAeznTr-sZhaMDMjQP-GFrkoH+JASDEP+ae1fyojxE4=Qoe1Jw@mail.gmail.com>
Subject: Re: Recommended settings for SSD
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 25, 2013 at 4:58 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>
> Without going back to check the wiki, IIRC it was there that the /sys
> paths it checks for that detection are listed.  Those paths are then
> based on what the drive itself claims.  If it claims to be rotating
> storage...
I remember reading something like that myself, maybe my SSD (Crucial
S4) is old enough to report rotating storage, don't know..
>
> It may also depend on the kernel version, etc, as I'm not sure when that
> auto-detection was added (tho for all I know it has been there awhile).
>
> I do know my new SSDs (Corsair Neutrons, 256GB) are detected here, and
> the ssd mount option is thus not needed.  However, I'm running current
> v3.10-rcX-git kernels, tho I'm a few days behind ATM as I'm still working
> on switching over to the SSDs ATM and am having to do some reconfiguring
> to get there.
>
> Btrfs still being marked for testing only and under heavy development, if
> people aren't at least running current Linus stable or better and don't
> have a specific bug as a reason not to, they're actually behind and are
> likely missing potentially critical patches.  That means most people
> trying to run btrfs on stock distro kernels will be behind...
>
I agree on that, it could be related, my kernel version is stock
3.8.0-22-generic (getting sources now to recompile latest)
>
> Meanwhile, what about the discard option?  As I'm still setting up on the
> SSDs as well as btrfs here, I haven't had a chance to decide whether I
> want that, or would rather setup fstrim as a cron job, or what.  But
> that's the other big question for SSD.
>
I decided not to add the discard option and run the daily script from
cron (fstrim) as I think there's a performance hit with the discard.
It mainly depends on your hardware I think.

> Here, I'm actually partitioning for near 100% over-provisioning, (120-ish
> GiB of partitions on the 238GiB/256GB drives, so I suspect actually
> running with discard as a mount option won't be such a big deal and will
> likely only cut write performance as I head toward stable-state, since
> the drive should have plenty of trimmed space to work with in any case
> due to the over-provisioning.  But I suspect it could be of benefit to
> those much closer to 0% over-provisioning than to my near 100%.
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

Since I am going to build the kernel and it's a good test on the SSD
does anyone recommend some ways to speed up the build related to SSD?

Thanks

--
Caution: breathing may be hazardous to your health.

#include <stdio.h>
int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}
