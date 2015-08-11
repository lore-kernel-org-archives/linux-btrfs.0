Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35869 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbbHKUnf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 16:43:35 -0400
Received: by wicja10 with SMTP id ja10so89505059wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 13:43:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMUoZtY7Or1+4-XmxWQjrmkAk-x62e13XMoTbWApRAn_zhd2DQ@mail.gmail.com>
References: <CAMUoZtY7Or1+4-XmxWQjrmkAk-x62e13XMoTbWApRAn_zhd2DQ@mail.gmail.com>
Date: Tue, 11 Aug 2015 20:43:34 +0000
Message-ID: <CABRuA+gXqmE1vVWFpHFtS=rx3Tm6+o2n8Pn_G1uQmkcv6SYBpA@mail.gmail.com>
Subject: Re: Scaling to 100k+ snapshots/subvolumes
From: Michael Darling <darlingm@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If someone can answer Tristan's question, can they also add in if
large volumes of frequently created and destroyed snapshots/subvolumes
will cause issues?  Or, if they're deleted quickly after being made,
is it just the number that exists at any given time that matters?
(Building source in chroot subvolumes with its "own" o/s install, as
in Arch's devtools scripts, if used to create *separate* subvolumes
under each source build, rather than a global shared one.)

On Tue, Aug 11, 2015 at 6:33 PM, Tristan Zajonc <tristan@sense.io> wrote:
>
> Hi,
>
> In an early thread Duncan mentioned that btrfs does not scale well in
> the number of subvolumes (including snapshots).  He recommended
> keeping the total number under 1000.  I just wanted to understand this
> limitation further.  Is this something that has been resolved or will
> be resolved in the future or is it something inherent to the design of
> btrfs?
>
> We have an application that could easily generate 100k-1M snapshots
> and 10s of thousands of subvolumes.  We use snapshots to track very
> fine-grained filesystem histories and subvolumes to enforce quotas
> across a large number of distinct projects.
>
> Thanks,
> Tristan
>
> Duncan >
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/43910
>
> The question of number of subvolumes normally occurs in the context of
> snapshots, since snapshots are a special kind of subvolume.  Ideally,
> you'll want to keep the total number of subvolumes (including snapshots)
> to under 1000, with the number of snapshots of any single subvolume
> limited to 250-ish (say under 300).  However, even just four subvolumes
> being snapshotted to this level will reach the thousand, and 2000-3000
> total isn't /too/ bad as long as it's no more than 250-300 snapshots per
> subvolume.  But DEFINITELY try to keep it under 3000, and preferably
> under 2000, as the scaling really does start to go badly as the number of
> subvolumes increases beyond that.  If you're dealing with 10k subvolumes/
> snapshots, that's too many and you ARE likely to find yourself with
> problems.
>
> (With something like snapper, configuring it for say half-hour or hourly
> snapshots at the shortest time, with twice-daily or daily being more
> reasonable in many circumstances, and then thinning it down to say daily
> after a few days and weekly after four weeks, goes quite a long way
> toward reducing the number of snapshots per subvolume.  Keeping it near
> 250-ish per subvolume is WELL within reason, and considering that a month
> or a year out, you're not likely to /care/ whether it's this hour or
> that, just pick a day or a week and if it's not what you want, go back or
> forward a day or a week, is actually likely to be more practical than
> having hundreds of half-hourly snapshots a year old to choose from.  And
> 250-ish snapshots per subvolume really does turn out to be VERY
> reasonable, provided you're doing reasonable thinning.)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
