Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37005 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeAOV5T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 16:57:19 -0500
Received: by mail-wm0-f51.google.com with SMTP id v71so4732841wmv.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jan 2018 13:57:18 -0800 (PST)
MIME-Version: 1.0
From: Dave <davestechshop@gmail.com>
Date: Mon, 15 Jan 2018 16:56:57 -0500
Message-ID: <CAH=dxU6A75wET7_bZZ3sVhCFpr8RRWhJJsd=L66YyuW_kiHCcg@mail.gmail.com>
Subject: how to make a cache directory nodatacow while also excluded from snapshots?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I want to exclude my ~/.cache directory from snapshots. The obvious
way to do this is to mount a btrfs subvolume at that location.

However, I also want the ~/.cache directory to be nodatacow. Since the
parent volume is COW, I believe it isn't possible to mount the
subvolume with different mount options.

What's the solution for achieving both of these goals?

I tried this without success:

    chattr +C ~/.cache

Since ~/.cache is a btrfs subvolume, apparently that doesn't work.

    lsattr ~/.cache

returns nothing.
