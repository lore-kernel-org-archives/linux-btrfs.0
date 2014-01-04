Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:40178 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaADBEy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jan 2014 20:04:54 -0500
Received: by mail-vb0-f43.google.com with SMTP id p6so8093268vbe.30
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 17:04:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAVQaYAx8yxtvM1Mg759FJpEx6rjHQo3_2F84LNMA_f0kP81Sg@mail.gmail.com>
References: <CAAVQaYAx8yxtvM1Mg759FJpEx6rjHQo3_2F84LNMA_f0kP81Sg@mail.gmail.com>
Date: Sat, 4 Jan 2014 02:04:53 +0100
Message-ID: <CAD_cGvFpaOB4mfo8nDeVFcu+ANuNZKha7xzJHPeLU_eSHt2gDA@mail.gmail.com>
Subject: Re: Status of raid5/6 in 2014?
From: Hans-Kristian Bakke <hkbakke@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I personally consider proper RAID6 support with gracious non-intrusive
handling of failing drives and a proper warning mechanism the most
important missing feature of btrfs, and I know this view is shared by
many others with software RAID based storage systems, currently
limited by the existing choises on Linux.
But having been a (naughty) user of btrfs the last few months I fully
understand that there are important bugs, performance fixes and issues
in the existing state of btrfs that need more immediate attention as
they affect the currently installed base.

I will however stress that the faster the functionality gets
implemented the sooner users like myself can begin using it and
reporting issues, and hence btrfs gets ready for enterprise usage and
general deployment sooner.

Regards,
Hans-Kristian Bakke
Mvh

Hans-Kristian Bakke


On 3 January 2014 17:45, Dave <dave@thekilempire.com> wrote:
> Back in Feb 2013 there was quite a bit of press about the preliminary
> raid5/6 implementation in Btrfs.  At the time it wasn't useful for
> anything other then testing and it's my understanding that this is
> still the case.
>
> I've seen a few git commits and some chatter on this list but it would
> appear the developers are largely silent.  Parity based raid would be
> a powerful addition the the Btrfs feature stack and it's the feature I
> most anxiously await.  Are there any milestones planned for 2014?
>
> Keep up the good work...
> --
> -=[dave]=-
>
> Entropy isn't what it used to be.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
