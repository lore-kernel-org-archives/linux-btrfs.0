Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35018 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbcCANlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 08:41:50 -0500
Received: by mail-lf0-f49.google.com with SMTP id j186so39027081lfg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Mar 2016 05:41:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56D58E93.9000705@googlemail.com>
References: <56D58E93.9000705@googlemail.com>
Date: Tue, 1 Mar 2016 14:41:48 +0100
Message-ID: <CAGGqMYRKppf3vxjLCHrgwCp5-E6jf8kc6Mdj-NVmhoux6W-eVQ@mail.gmail.com>
Subject: Re: btrfs-progs: initial scan-build results
From: Alexander Fougner <fougner89@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-03-01 13:44 GMT+01:00 Holger Hoffstätte
<holger.hoffstaette@googlemail.com>:
> Hi,
>
> With btrfs-progs needing & getting some more love I decided to run today's
> master through clang's very awesome static analyzer [1] to see what a more
> complete data flow analysis than gcc's -Wall yields. The results can be
> found at [2] and are somewhat reason for concern. =:)
>
> Please note that even though all messages are typically "real" in the sense
> that they _could_ happen, it does not mean that they do during normal
> operation, since some codepaths might just be dynamic/rare. That being said,
> quite a few warnings seemed sufficiently serious to me that I decided to post
> this. For example there's IMHO no sane way zero-sized allocations make any
> sense.
>

All zero-sized allocations are false positives, except the
btrfs-image.c. This can be fixed by placing the num_threads at the top
instead of after calloc().

> IMHO most dead stores are seemingly the easiest to fix (just remove the
> statement?), but some of them might actually be missing upstream error
> handling - indicative of something more serious.

I checked a few, those were false positives.

> Dave, any suggestions on how best to proceed? Any preferences or would
> another branch be more interesting? I tried to track devel but that
> gets rebased frequently (or I'm doing something wrong).
>
> Btw running scan-build is easy: get clang, './configure' as usual and
> 'scan-build make -jX' will create the report in /tmp/scan-build-<time>.
>
> Let me know if this is helpful.
>
> cheers,
> Holger
>
> [1] http://clang-analyzer.llvm.org/scan-build.html
> [2] http://hoho.duckdns.org/~holger/btrfs-progs/scan-build-2016-03-01-130244-29106-1/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
