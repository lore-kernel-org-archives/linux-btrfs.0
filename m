Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:48426 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbdIRCbV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 22:31:21 -0400
Received: by mail-io0-f181.google.com with SMTP id n69so15436519ioi.5
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 19:31:21 -0700 (PDT)
MIME-Version: 1.0
From: Dave <davestechshop@gmail.com>
Date: Sun, 17 Sep 2017 22:31:00 -0400
Message-ID: <CAH=dxU7t=p8MVh1y2Tv7wPrP=1ntYcHCy7W6aBQGRtMp_gaaRA@mail.gmail.com>
Subject: ERROR: parent determination failed (btrfs send-receive)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sometimes when using btrfs send-receive, I get errors like this:

ERROR: parent determination failed for <subvolume name>

When this happens, btrfs send-receive backups fail. And all subsequent
backups fail too.

The issue seems to stem from the fact that an automated cleanup
process removes certain earlier subvolumes. (I'm using Snapper.)

I'd like to understand exactly what is happening so that my backups do
not unexpectedly fail.

In my scenario, no parent subvolumes have been deleted from the
target. Some subvolumes have been deleted from the source, but why
does that matter? I am able to take a valid snapshot at this time and
every snapshot ever taken continues to reside at the target backup
destination (seemingly meaning that a parent subvolume can be found at
the target).

This issue seems to make btrfs send-receive a very fragile backup
solution. I hope, instead, there is some knowledge I'm missing, that
when learned, will make this a robust backup solution.

Thanks
