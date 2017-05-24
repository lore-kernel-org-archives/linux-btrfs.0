Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:34741 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754542AbdEXS4x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 14:56:53 -0400
Received: by mail-qk0-f179.google.com with SMTP id k74so161634137qke.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2017 11:56:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZH3K+skMjROAUtRyhsRbah4Pbcx8JmNKc7bn+mLn2tUQ@mail.gmail.com>
References: <4b1b08de-9012-fb2a-eca1-a8adfdbf8e7b@o3-software.de>
 <2e30c414-3bb3-536e-2bab-1bbda9cba25d@cn.fujitsu.com> <CAPmG0jZH3K+skMjROAUtRyhsRbah4Pbcx8JmNKc7bn+mLn2tUQ@mail.gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Wed, 24 May 2017 20:56:52 +0200
Message-ID: <CAPmG0jZngVrU9PFbd0gE5_7raZMDb=ex7awO5Ct4nKJ+jL5QoQ@mail.gmail.com>
Subject: Re: btrfs check --check-data-csum malfunctioning?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Werner Braun <wb@o3-software.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 19, 2017 at 11:44 AM, Henk Slager <eye1tm@gmail.com> wrote:

> I also have a WD40EZRX and the fs on it is also almost exclusively a
> btrfs receive target and it has now for the second time csum (just 5 )
> errors. Extended selftest at 16K hours shows no problem and I am not
> fully sure if this is a magnetic media error case or something else.

I have now located the 20K (sequential) of bad csums in a 4G file and
physical chunk address. Then read that 1G chunk to a file and wrote it
back to the same disk location. No I/O errors in dmesg, so my
assumption is that the 20K bad spot is replaced by good spares. Or it
was a btrfs or luks fault or just a spurious random write somehow due
to SW/HW glitch.

As a sort of locking the bad area, I did cp --reflink the 4G file to
the root of the fs and read-writeback the 20K spot in the 4G file in
the send-source fs. So now after another differential receive, I
remove all but the latest snapshot. The 5 csum errors will then sit
there fixed if I don't balance. Then just before I do a btrfs-repflace
(if I decide to ), I delete the 4G file en make sure the cleaner has
finished so that replace will not fail on bad the 5 bad csums.

The fs on the WD40EZRX is just another clone/backup but with quite
some complex subvolume tree. The above actions + replace are more fun
and faster cloning again than recreating the tree with rsync etc. I
have done similar things in the past, when csum errors were clearly
due to btrfs bugs but with good HDDs.
