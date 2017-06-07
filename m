Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35690 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdFGP6k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 11:58:40 -0400
Received: by mail-wm0-f49.google.com with SMTP id x70so60971639wme.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Jun 2017 08:58:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ad923a84-bd2c-a8fd-8532-c7dc73d1870f@xunil.at>
References: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
 <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com>
 <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at> <CAGqmi77URH-XTW7fCB+NqzcSb-Y+LvwuvQep+CRJ6_ENgRtWRQ@mail.gmail.com>
 <20170607130902.q3stj6wj52duvmr2@angband.pl> <20170607184848.6218c92f@natsu>
 <20170607135219.blgoomc4mwt5ebvj@angband.pl> <ad923a84-bd2c-a8fd-8532-c7dc73d1870f@xunil.at>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 7 Jun 2017 09:58:38 -0600
Message-ID: <CAJCQCtSGxC-UxkB7NuXuUvWYg-kC4sRdteiiVYQbPZpx9AUfsw@mail.gmail.com>
Subject: Re: getting rid of "csum failed" on a hw raid
To: "Stefan G. Weichinger" <lists@xunil.at>
Cc: Adam Borowski <kilobyte@angband.pl>, Roman Mamedov <rm@romanrm.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm confused about a few items in this thread:

1. On normal read, if there's a csum mismatch, there should be a path
to file and EIO, because Btrfs won't propagate bad data up to user
space. I'd expect if there's metadata corruption, there'd be no path
to file, and no EIO. The original email does include an inode, but
that's ambiguous since each fs tree has its own set of inodes, so we
can't always easily infer a file from an inode.

2. Why does ddrescue work around this problem on a mounted file
system? It's just reading the file, through the file system, the exact
same errors should have happened.

3. My take on this would have been to use btrfs restore and go after
the file path if I absolutely needed a copy of this file (no backup),
and then copied that back to the file system.


Chris Murphy
