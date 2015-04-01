Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38396 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbbDAQP1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 12:15:27 -0400
Received: by wibgn9 with SMTP id gn9so72990282wib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 09:15:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
 <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
 <CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
 <CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com> <CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com>
From: Martin Langhoff <martin.langhoff@gmail.com>
Date: Wed, 1 Apr 2015 12:15:05 -0400
Message-ID: <CACPiFCKtEHdnMjKC_rCuHfAHO0CFiHN9YaY5jRfKdmu+dOYh+g@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 11:42 AM, Martin Langhoff
<martin.langhoff@gmail.com> wrote:
> See below. Perhaps the newer kernel (in latest F21) has regressed in
> handling some kinds of errors during mount, or the dracut/systemd
> mounting process is less resilient than mounting under a fully booted
> system?

This is getting even more interesting.

Under 3.17.4-301.fc21.x86 from LiveUSB, I could mount, even repair the disk.

Since the repair, the on-disk latest kernel (3.18.9-200.fc21) tries to
boot, but dracut/systemd time out on mounting sysroot after waiting
for quite a while. I don't get a dracut shell anymore so the failure
mode has changed. I may try to set a breakpoint to force a shell.

I do have an earlier F21 kernel on disk-- 3.18.7-200.fc21 -- and this
boots the system without a glitch. After a complete boot with
3.18.7.200, clean shutdown and booting into 3.18.9-200 is still
broken, same failure mode.

Will try to capture some info from a dracut breakpoint  (I'll try
mount). At this point this really looks like a regression.

cheers,



martin
-- 
 martin.langhoff@gmail.com
 -  ask interesting questions
 - don't get distracted with shiny stuff  - working code first
 ~ http://docs.moodle.org/en/User:Martin_Langhoff
