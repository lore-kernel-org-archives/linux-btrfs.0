Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:57888 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752968AbdERFRW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 01:17:22 -0400
Date: Thu, 18 May 2017 10:17:19 +0500
From: Roman Mamedov <rm@romanrm.net>
To: =?UTF-8?B?xYF1a2FzeiBXcsOzYmxld3NraQ==?= <lw@nri.pl>
Cc: Adam Borowski <kilobyte@angband.pl>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: RAID 6 corrupted
Message-ID: <20170518101719.6c9feabe@natsu>
In-Reply-To: <CA+M=Xp0o6uz6uBv41ygpFBiWyw1x6ucg38BtG3V-XdOJ9azvxA@mail.gmail.com>
References: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
        <pan$3156f$ad60295$88e5604$e6cc7e68@cox.net>
        <20170517101523.ylmw4qo2wjsnibfh@angband.pl>
        <CA+M=Xp0o6uz6uBv41ygpFBiWyw1x6ucg38BtG3V-XdOJ9azvxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 18 May 2017 04:09:38 +0200
Łukasz Wróblewski <lw@nri.pl> wrote:

> I will try when stable 4.12 comes out.
> Unfortunately I do not have a backup.
> Fortunately, these data are not so critical.
> Some private photos and videos of youth.
> However, I would be very happy if I could get it back.

Try saving your data with "btrfs restore" first (i.e. you can do it right now,
as it doesn't depend on kernel versions), after you have your data recovered
and reliably backed up, then you can proceed with experiments on new kernel,
patches and whatnot.

-- 
With respect,
Roman
