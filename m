Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:40366 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbeAPDsk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 22:48:40 -0500
Received: by mail-lf0-f42.google.com with SMTP id h92so5320178lfi.7
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jan 2018 19:48:39 -0800 (PST)
Subject: Re: how to make a cache directory nodatacow while also excluded from
 snapshots?
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAH=dxU6A75wET7_bZZ3sVhCFpr8RRWhJJsd=L66YyuW_kiHCcg@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <de2e32dc-92c2-3f63-0de5-5d50469709ec@gmail.com>
Date: Tue, 16 Jan 2018 06:48:36 +0300
MIME-Version: 1.0
In-Reply-To: <CAH=dxU6A75wET7_bZZ3sVhCFpr8RRWhJJsd=L66YyuW_kiHCcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

16.01.2018 00:56, Dave пишет:
> I want to exclude my ~/.cache directory from snapshots. The obvious
> way to do this is to mount a btrfs subvolume at that location.
> 
> However, I also want the ~/.cache directory to be nodatacow. Since the
> parent volume is COW, I believe it isn't possible to mount the
> subvolume with different mount options.
> 
> What's the solution for achieving both of these goals?
> 
> I tried this without success:
> 
>     chattr +C ~/.cache
> 
> Since ~/.cache is a btrfs subvolume, apparently that doesn't work.
> 
>     lsattr ~/.cache
> 
> returns nothing.

Try creating file under ~/.cache and check its attributes.
