Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:40022 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965176AbeALVib (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 16:38:31 -0500
Received: by mail-qk0-f179.google.com with SMTP id d18so10420482qke.7
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 13:38:31 -0800 (PST)
MIME-Version: 1.0
From: "Daniel E. Shub" <daniel.e.shub@gmail.com>
Date: Fri, 12 Jan 2018 16:38:30 -0500
Message-ID: <CA+-0u-Yp85JieqjcVk3UkPVtF2ppgpiD27wajEvR0Q3pbf2AUg@mail.gmail.com>
Subject: Limit on the number of btrfs snapshots?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A couple of years ago I asked a question on the Unix and Linux Stack
Exchange about the limit on the number of BTRFS snapshots:
https://unix.stackexchange.com/q/140360/22724

Basically, I want to use something like snapper to take time based
snapshots so that I can browse old versions of my data. This would be
in addition to my current off site backup since a drive failure would
wipe out the data and the snapshots. Is there a limit to the number of
snapshots I can take and store? If I have a million snapshots (e.g., a
snapshot every minute for two years) would that cause havoc, assuming
I have enough disk space for the data, the changed data, and the meta
data?

The answers there provided a link to the wiki:
https://btrfs.wiki.kernel.org/index.php/Btrfs_design#Snapshots_and_Subvolumes
that says: "snapshots are writable, and they can be snapshotted again
any number of times."

While I don't doubt that that is technically true, another user
suggested that the practical limit is around 100 snapshots.

While I am not convinced that having minute-by-minute versions of my
data for two years is helpful (how the hell is anyone going to find
the exact minute they are looking for), if there is no cost then I
figure why not.

I guess I am asking is what is the story and where is it documented.
