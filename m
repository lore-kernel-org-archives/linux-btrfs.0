Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:35582 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754636AbdAARYW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jan 2017 12:24:22 -0500
Received: by mail-yw0-f169.google.com with SMTP id v81so153855067ywb.2
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jan 2017 09:24:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRBeZGV1iyg=KCJMTxTgO1Z-xoV_Ph71hVZgCCMMGWM1A@mail.gmail.com>
References: <CAJCQCtRBeZGV1iyg=KCJMTxTgO1Z-xoV_Ph71hVZgCCMMGWM1A@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 1 Jan 2017 10:24:21 -0700
Message-ID: <CAJCQCtSmz3NQKWR925cehVsr69DC+AViG_gxYJjvSVi+jeXP9w@mail.gmail.com>
Subject: Re: regression 4.9.0 read-only fs fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 31, 2016 at 12:44 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Problem: The file system (root fs) goes read-only soon after login. It
> only happens with a particular subvolume, and only with kernel 4.9.0.
> If I use kernel 4.9.0 on a different subvolume the problem doesn't
> happen, if I use kernel 4.8.15 on the suspect subvolume, the problem
> doesn't happen.

The problem also happens on 4.10-rc1.



-- 
Chris Murphy
