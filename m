Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36393 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752802AbcLHCTk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 21:19:40 -0500
Received: by mail-yw0-f194.google.com with SMTP id r204so33305182ywb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Dec 2016 18:19:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201612080952.kBilhr2z%fengguang.wu@intel.com>
References: <1481147110-20048-5-git-send-email-bo.li.liu@oracle.com> <201612080952.kBilhr2z%fengguang.wu@intel.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Thu, 8 Dec 2016 03:19:24 +0100
Message-ID: <CANznX5Fsgqe5o8ZSa+x=J5VXg_ftZ2hb=ZTBmOAeOUTp6=MuXg@mail.gmail.com>
Subject: Re: [PATCH 4/6] Btrfs: add DAX support for nocow btrfs
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I realize this is related very loosely (if at all) to this topic but
what about these two possible features:
- a mount option, or
- an attribute (which could be set on directories and/or sub-volumes
and applied to any new files created below these)
which effectively forces every read/write operations to behave like
the file was explicitly opened with DirectIO by the application (even
if the application has no DirectIO support)?

This could achieve something loosely similar to DAX while keeping more
of the "advanced" Btrfs features (I think only compression is ruled
out by DIO).
