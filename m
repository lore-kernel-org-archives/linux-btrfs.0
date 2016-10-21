Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:33828 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935413AbcJUQTb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 12:19:31 -0400
Received: by mail-yw0-f179.google.com with SMTP id w3so101285247ywg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Oct 2016 09:19:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6KGPRy4xisK_H2RZm-==xuBtsRyqdZ5O=8=UE_MF1434gDHQ@mail.gmail.com>
References: <CAG6KGPS8Gvy2zGCe22mMmk4uXrqVyRP8FHayhe0ph-8vC+kA4A@mail.gmail.com>
 <CAG6KGPSeR1zAuU0Xo9DrEpd-0QC9agB7p7z+Lb69hxS233_Cvg@mail.gmail.com>
 <20161010234227.69746d3f@natsu> <CAJCQCtQh2C95=ug3x7wT98CA-fRAVXxd5Ghz4suYkENFCf8jQg@mail.gmail.com>
 <CAG6KGPTU0U1=WCA9cZgXrYtm=yDJFZDH+x2v7RtS=6RzmGzRTA@mail.gmail.com> <CAG6KGPRy4xisK_H2RZm-==xuBtsRyqdZ5O=8=UE_MF1434gDHQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 21 Oct 2016 10:19:29 -0600
Message-ID: <CAJCQCtRC6iMw3cE3pX6UprE1AFvYSQ01vpSwuTBrA6XifhsCLQ@mail.gmail.com>
Subject: Re: csum failed during copy/compare
To: Martin Dev <mrturtledev@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 21, 2016 at 7:19 AM, Martin Dev <mrturtledev@gmail.com> wrote:
> SATA trace shows device behaving correctly.
> btrfs repair --ignore-errors /dev/sda2 /tmp/ will yield files that are
> not verifiable by FIO, and differ from the original files on the
> internal drive that they were copied from at the failing offset.

Did you try without discard mount option? And did you get different results?

I'm not following 'btrfs repair --ignore-errors /dev/sda2 /tmp/'  at
all. Is this actually restore?

I'm not an expert in this particular area of finding problems as
they're being written - but it sounds like that's what's going on in
your case - since kernel messages are currently not revealing at all,
all I can think of is to build a kernel.org kernel, I think for what
you're doing it's fine to use 4.4.26 but it might get more traction to
use 4.9.rc1 just because that's what's currently being worked on and
likely where any fix would have to go first before it got backported.
If it's a bug. And I'd build with these:

CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_DEBUG=y

The first does nothing unless you use one of two possible mount
options check_int and check_int_data.
https://btrfs.wiki.kernel.org/index.php/Mount_options

I don't have any advice on how to test. Maybe leave out the check
integrity mount options for the first round and see if you can still
trigger the problem, since there are already two major changes: a.)
it's a kernel.org kernel and b.) it has debug enabled. If you can
trigger the problem but it's still not revealing then test with
check_int which has less performance impact than check_int_data. It
looks like what you're getting is a metadata inconsistency but I'm not
certain.

-- 
Chris Murphy
