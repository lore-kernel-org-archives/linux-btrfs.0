Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33535 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032345AbdDTURF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 16:17:05 -0400
Received: by mail-oi0-f54.google.com with SMTP id y11so34261324oie.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Apr 2017 13:17:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$9c654$fc7a9a58$350415c4$8a82638f@cox.net>
References: <20170419210745.15263-1-kilobyte@angband.pl> <pan$9c654$fc7a9a58$350415c4$8a82638f@cox.net>
From: Sargun Dhillon <sargun@sargun.me>
Date: Thu, 20 Apr 2017 15:16:23 -0500
Message-ID: <CAMp4zn8_qq32mcj0rcRvh=yBa6-1YR2tcYUkELN_ZW5yqqUQBg@mail.gmail.com>
Subject: Re: [PATCH ping] btrfs: warn about RAID5/6 being experimental at
 mount time
To: Duncan <1i5t5.duncan@cox.net>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 20, 2017 at 3:13 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Adam Borowski posted on Wed, 19 Apr 2017 23:07:45 +0200 as excerpted:
>
>> Too many people come complaining about losing their data -- and indeed,
>> there's no warning outside a wiki and the mailing list tribal knowledge.
>> Message severity chosen for consistency with XFS -- "alert" makes dmesg
>> produce nice red background which should get the point across.
>
> Commenting on the idea and comment, because as a non-coder list regular,
> that's what I can evaluate fairly. =:^)
>
> A kernel dmesg warning like this makes more sense to me than trying to
> put it in, for instance, mkfs.btrfs, because the instability is primarily
> kernel code and at least the message can stay synced with it, being
> removed when considered appropriate, unlike userspace code which can't,
> because people often run userspace and kernelspace versions well out of
> sync with each other.
>
Seconded. As someone who's been trying to get BtrFS adopted, the
biggest hurdle has been around perception. Rarely do people use the
userspace tools directly, but rather through multiple layers of
abstraction where they don't see any warnings coming from it. I think
adding these warnings to kernel logs is an excellent suggestion.

>> I intend to ask for inclusion of this one (or an equivalent) in 4.9,
>> either in Debian or via GregKH -- while for us kernels "that old" are
>> history, regular users expect stable releases to be free of known
>> serious data loss bugs.
>
> Arguably it should go in the LTS-4.4 series as well, because we at least
> try to support the last two LTS series on-list, more or less giving up
> beyond that, and that's the relatively new 4.9 and the now going stale
> but we really should be still trying to support it 4.4.  Older than that,
> 4.1 was the only LTS after initial code completion, but since it should
> be simple enough even before that and certainly would be true, queuing
> the patch for any still being updated LTS back to initial partial support
> (3.9 IIRC) is arguably worthwhile.
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
