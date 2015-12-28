Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34652 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbL1BXQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 20:23:16 -0500
Received: by mail-io0-f169.google.com with SMTP id e126so294030768ioa.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 17:23:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451264981.6320.15.camel@scientia.net>
References: <567FEEB6.3080701@online.no>
	<CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
	<1451263174.6320.5.camel@scientia.net>
	<CAJCQCtTmiKcapPpZ62Ko6mZK_MSDAFS2FAwU8CUJxkWwu-nYuw@mail.gmail.com>
	<1451264981.6320.15.camel@scientia.net>
Date: Sun, 27 Dec 2015 18:23:15 -0700
Message-ID: <CAJCQCtQ29Jwmywz+TrkYC6RuDpsk4v3gOkfmBGoxPahy5Nk--g@mail.gmail.com>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 27, 2015 at 6:09 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Sun, 2015-12-27 at 17:58 -0700, Chris Murphy wrote:
>> I don't see a good use case for scrubbing a degraded array. First
>> make
>> the array healthy, then scrub.
> As I've said, I agree basically... but *if* scrubbing a degraded fs
> leads to even more errors (apart from the fact that you may loose
> another device for hardware reasons while scrubbing), than either this
> needs to be fixed *or* scrub mustn't be started on a degraded array (in
> the sense that software prevents it).
>
> Consider you have a weekly cron job that scrubs, which runs while the
> array is degraded.

The scrub should fail gracefully (exit 1).


>
>
>>  But I've not tested this with mdadm or
>> lvm raid. I don't know how they behave.
> Don't know, but for them it makes not so much sense, as their scrub is
> different from ours... they have no checksums and can only tell whether
> the RAID itself is consistent, which it is of course not when degraded.
> It does perhaps make sense in any mirrored RAIDs (e.g. when you have a
> 4 disk RAID1, which is degraded and 1 disk is missing,... it may still
> be worth to scrub the remaining 3,...)
>
>
>>  But even if either of them
>> tolerate it, it's a legitimate design decision for Btrfs developers
>> to
>> refuse supporting the scrub of a degraded array. Same for balancing
>> for that matter.
> Sure... but still it needs to be handled gracefully... i.e. not more
> damage and reasonable userland output which people will understand.

Yes.

I'd want scrub to immediately fail in a degraded case, because the
higher workload added by the scrub itself could cause additional
device failures sooner. And that would negatively impact the ability
to get the array healthy again with a rebuild - during which time you
wouldn't want the scrub running anyway.


-- 
Chris Murphy
