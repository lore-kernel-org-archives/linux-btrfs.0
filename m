Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:38188 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752968AbdESJJy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 05:09:54 -0400
Date: Fri, 19 May 2017 14:09:46 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Pasi =?UTF-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: RAID 6 corrupted
Message-ID: <20170519140946.27d2d32f@natsu>
In-Reply-To: <20170519085527.GD24459@reaktio.net>
References: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
        <pan$3156f$ad60295$88e5604$e6cc7e68@cox.net>
        <20170517101523.ylmw4qo2wjsnibfh@angband.pl>
        <CA+M=Xp0o6uz6uBv41ygpFBiWyw1x6ucg38BtG3V-XdOJ9azvxA@mail.gmail.com>
        <20170518101719.6c9feabe@natsu>
        <pan$24de$e527cbb7$733b205c$f2415b2@cox.net>
        <20170519085527.GD24459@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 19 May 2017 11:55:27 +0300
Pasi Kärkkäinen <pasik@iki.fi> wrote:

> > > Try saving your data with "btrfs restore" first 
> > 
> > First post, he tried that.  No luck.  Tho that was with 4.4 userspace.  
> > It might be worth trying with the 4.11-rc or soon to be released 4.11 
> > userspace, tho...
> > 
> 
> Try with 4.12-rc, I assume :)

No, actually I missed that this was already tried, and a newer kernel will not
help at "btrfs restore", AFAIU it works entirely in userspace, not kernel.

Newer btrfs-progs could be something to try though, as the version used seems
pretty old -- btrfs-progs v4.4.1, while the current one is v4.11.

-- 
With respect,
Roman
