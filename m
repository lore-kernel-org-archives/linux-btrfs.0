Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36609 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdHCTSW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 15:18:22 -0400
Received: by mail-wm0-f42.google.com with SMTP id t201so3136464wmt.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Aug 2017 12:18:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP9B-QnJ_=jeA=3bgzzVtpsvwaVmK-=cxY7PBOWh660viWmVMA@mail.gmail.com>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za> <CAP9B-QnJ_=jeA=3bgzzVtpsvwaVmK-=cxY7PBOWh660viWmVMA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 3 Aug 2017 13:18:20 -0600
Message-ID: <CAJCQCtREAS53cG_eF8jfg-iqL15ErTqH7gryQ6yYO5sz1BpADw@mail.gmail.com>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 2, 2017 at 3:11 AM, Wang Shilong <wangshilong1991@gmail.com> wrote:
> I haven't seen active btrfs developers from some time, Redhat looks
> put most of their efforts on XFS, It is time to switch to SLES/opensuse!

I disagree. We need one or more Btrfs developers involved in Fedora.

Fedora runs fairly unmodified upstream kernels, which are kept up to
date. By default, Fedora 24, 25, 26 users today are on kernel 4.11.11
or 4.11.12. Fedora 25, 26 will soon be rebased to probably 4.12.5.
That's the stable repo. You can optionally get newer non-rc ones from
testing repo. And nightly Rawhide kernels are built as well with the
latest patchset in between rc's. Both Btrfs and Fedora are heavily
developing in containerize deployments, so it seems like a good fit
for both camps.

The problem is the Fedora kernel team has no one sufficiently familiar
with Btrfs, nor anyone at Red Hat to fall back on. But they do have
this with ext4, XFS, device-mapper, and LVM developers. So they're not
going to take on a burden like Btrfs by default without a
knowledgeable pair of eyes to triage issues as they come up. And
instead they're moving to XFS + overlayfs.

There's more opportunity for Btrfs than just as a default file system.
I like the idea of using Btrfs on install media to eliminate the
monolithic isomd5sum most users skip to test their USB install media;
eliminate device-mapper based persistent overlay for the install media
and use Btrfs seed/sprout instead (which would help the Sugar on a
Stick project as well); and at least for nightly composes eliminate
squashfs xz based images in favor of Btrfs compression (faster
compression and decompression, bigger file sizes but these are daily
throw aways so I think time is more important).

Anyway - point is that converging on SUSE doesn't help. If anything I
think it'll shrink the market for Btrfs as a general purpose file
system, rather than grow it.

-- 
Chris Murphy
