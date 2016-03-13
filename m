Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36511 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbcCMWfQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 18:35:16 -0400
Received: by mail-ig0-f175.google.com with SMTP id nk17so26439998igb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 15:35:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR-=YiBCiO9++gPxYFgE=3_z_qVzma=2HvLugEdP=0Lvg@mail.gmail.com>
References: <CAJCQCtQt8J697-mABAr+4Wdaf7Kw-sX6yLHwwyLGJ9kJFFG7xw@mail.gmail.com>
	<CAJCQCtQ_LaxZp1fkxZ+_gpSBcdRY-bhNLar0b2zYGK8AAY1DUg@mail.gmail.com>
	<CAJCQCtR-=YiBCiO9++gPxYFgE=3_z_qVzma=2HvLugEdP=0Lvg@mail.gmail.com>
Date: Sun, 13 Mar 2016 16:35:15 -0600
Message-ID: <CAJCQCtTkF13x7TEhGxS7EUOnmwGGsT0-UAvC-gwhuOmj5Co3ow@mail.gmail.com>
Subject: Re: 4.5.0 rc7 balance btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0x417/0x500
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2016 at 4:14 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Reproducible with Not tainted 4.4.5-300.fc23.x86_64. Attached new
> dmesg to bug report, direct link is:
> https://bugzilla.kernel.org/attachment.cgi?id=208951

The warning doesn't happen if enospc_debug mount option is not set. If
set, it always happens. However,

# CONFIG_BTRFS_DEBUG is not set



-- 
Chris Murphy
