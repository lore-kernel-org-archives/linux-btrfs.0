Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:41957 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965759AbeE2T0P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 15:26:15 -0400
Received: by mail-ot0-f195.google.com with SMTP id t1-v6so18319944oth.8
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 12:26:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180529074527.7333-1-wqu@suse.com>
References: <20180529074527.7333-1-wqu@suse.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Tue, 29 May 2018 15:26:13 -0400
Message-ID: <CA+X5Wn6Ltx02naOh2BjZwzu2A2c74G47QAceMipt-XsoCS2k+A@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: check: Also compare data between mirrors to
 detect corruption for NODATASUM extents
To: Qu Wenruo <wqu@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 29, 2018 at 3:45 AM, Qu Wenruo <wqu@suse.com> wrote:
> As the lzo corruption reported by James Harvey, for data extents without
> checksum, neither btrfs check nor kernel scrub could detect anything
> wrong.
>
> However if our profile supports duplication, we still have a chance to
> detect such corruption, as in that case the mirrors will mismatch with
> each other.
>
> So enhance --check-data-csum option to do such check, and this could
> help us to detect such corruption in an autonomous test case.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

I think it's good to have check --check-data-csum do such check.

I also think there should be a check option that only checks the
mirrored copies, so it could be ran without taking the time to check
everything that scrub looks at.  (If the feature isn't also added to
scrub as I argue for below, one could run this option every time they
scrub.)

IMO, it is important to also add this to scrub.  First reason is to
allow online scanning, since check is recommended not to run with
--force on a quiescent/read-only fs.  Second, I think users expect
scrub to ensure mirrored data integrity, and this goes along with
that, of course without automatic correction.  I think without doing
so, users who periodically run scrub would be surprised if they had
data corruption, that it hadn't been being checked all along.

It's recommended many places that users setup scrub to run
automatically on a periodic basis, but I'm not sure if I've seen
anywhere recommend setting up check to do so as well, especially as
doing so on a mounted filesystem is discouraged and potentially will
crash.

I haven't looked at this specifically, but I'm thinking this would be
better in the btrfs-progs side of scrub after it runs the kernel side
real scrub.

I have to head out for a while.  I haven't looked over or tried the
code yet, but will later.
